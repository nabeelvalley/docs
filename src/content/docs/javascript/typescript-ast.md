---
published: true
title: Using the TypeScript AST
---

## Generating Typescript using AST's

> Some parsers other that the Typescript one is [Esprima](https://esprima.org/demo/parse.html), [Acorn](https://github.com/acornjs/acorn), these are Javascript Parsers> Other languages also have parsers as well as tools called `Parser Generators` that enable you to generate a parser for a given language or usecase

Before getting started, you should first install the `typescript` package into your project with:

```sh
yarn add typescript
```

Using the typescript compiler you are able to parse TS into an AST as well as build code using the TS AST

> You can also generate the `ts.` code using the [Typescript to AST Converter](https://ts-ast-viewer.com/)

### Generate Types

```ts
export type User = {
  name: string
  age: number
}
```

To generate a type like above using the TS compiler you can use the following:

```ts
import ts, { factory } from 'typescript'
import { writeFileSync } from 'fs'

// create name property
const nameProp = factory.createPropertySignature(
  undefined,
  factory.createIdentifier('name'),
  undefined,
  factory.createKeywordTypeNode(ts.SyntaxKind.StringKeyword)
)

// create age property
const ageProp = factory.createPropertySignature(
  undefined,
  factory.createIdentifier('age'),
  undefined,
  factory.createKeywordTypeNode(ts.SyntaxKind.NumberKeyword)
)

// create User type
const userType = factory.createTypeAliasDeclaration(
  undefined,
  [factory.createModifier(ts.SyntaxKind.ExportKeyword)],
  factory.createIdentifier('User'),
  undefined,
  factory.createTypeLiteralNode([nameProp, ageProp])
)
```

We can then use the generated type to build a more complex type:

```ts
export type Admin = {
  user: User
}
```

```ts
const userProp = factory.createPropertySignature(
  undefined,
  factory.createIdentifier('user'),
  undefined,
  factory.createTypeReferenceNode(factory.createIdentifier('User'), undefined)
)

const adminType = factory.createTypeAliasDeclaration(
  undefined,
  [factory.createModifier(ts.SyntaxKind.ExportKeyword)],
  factory.createIdentifier('Admin'),
  undefined,
  factory.createTypeLiteralNode([userProp])
)
```

Next, we'll creata a `NodeArray` our of the two type declarations we want in our file like so:

```ts
const nodes = factory.createNodeArray([userType, adminType])
```

### Printing to Code

We can then print the two types out as Typescript code with the following:

```ts
const sourceFile = ts.createSourceFile(
  'placeholder.ts',
  '',
  ts.ScriptTarget.ESNext,
  true,
  ts.ScriptKind.TS
)
```

The above sourcefile is a way for us to store some basic settings for the file we're going to be saving our file content into, we've got the name `placeholder.ts` in the above case but this doesn't really output the file we're going to be outputing

Next, we can create a `Printer` instance and use it to generate our output file:

```ts
const printer = ts.createPrinter()

const outputFile = printer.printList(ts.ListFormat.MultiLine, nodes, sourceFile)
```

Lastly, we can print the `outputFile` using `fs`:

```ts
import { writeFileSync } from 'fs'

//... other code from above

writeFileSync('./output.ts', outputFile)
```

Which will output the following:

```ts
export type User = {
  name: string
  age: number
}
export type Admin = {
  user: User
}
```

## Update 24 June 2026

Here's a small implementation of a generic type visitor that can be used to scrape files for information using `ts-morph`

`describe.js`

```ts
/**
 * Basic pattern for visiting nodes and scraping metadata from them
 */
import {
  Project,
  SyntaxKind,
  Node,
  type ImplementedKindToNodeMappings,
} from 'ts-morph';

// this is the data that the visitor needs to return
interface Visited {
  kind: string;
  name?: string;
  children?: Visited[];
}

// some helpers to make the tree traversal statically typed
type SyntaxKindNames = keyof typeof SyntaxKind;
type SyntaxKindFromName<N extends SyntaxKindNames> = (typeof SyntaxKind)[N] &
  keyof ImplementedKindToNodeMappings;

type Visitors<T = unknown> = {
  [K in SyntaxKindNames]: (
    node: ImplementedKindToNodeMappings[SyntaxKindFromName<K>],
  ) => T | undefined;
};

// add any visitors here as needed
const visitors: Partial<Visitors<Visited>> = {
  Identifier: (node) => {
    return { kind: node.getKindName(), name: node.getText() };
  },
  SyntaxList: (node) => {
    return {
      kind: node.getKindName(),
      name: node.getKindName(),
      children: visitChildren(node),
    };
  },
  ImportDeclaration: (node) => {
    return {
      kind: node.getKindName(),
      name: node.getModuleSpecifier().getLiteralText(),
      children: [
        visitNode(node.getDefaultImport()),
        ...node.getNamedImports().map(visitNode),
      ].filter(exits),
    };
  },
  ImportSpecifier: (node) => {
    return {
      kind: node.getKindName(),
      name: node.getName(),
      isTypeOnly: node.isTypeOnly(),
    };
  },
  ClassDeclaration: (node) => {
    return {
      kind: node.getKindName(),
      name: node.getName(),
      children: [
        ...node.getProperties().map(visitNode),
        ...node.getMembers().map(visitNode),
      ],
    };
  },
  ObjectLiteralExpression: (node) => {
    return {
      kind: node.getKindName(),
      children: node.getProperties().map(visitNode),
    };
  },
  PropertyAssignment: (node) => {
    return {
      kind: node.getKindName(),
      name: node.getName(),
      type: node.getType().getText(),
    };
  },
  PropertyDeclaration: (node) => {
    return {
      kind: node.getKindName(),
      name: node.getName(),
      isReadonly: node.isReadonly,
      type: node.getType().getText(),
    };
  },
  MethodDeclaration: (node) => {
    return {
      kind: node.getKindName(),
      name: node.getName(),
      isReadonly: node.isReadonly,
      type: node.getType().getText(),
    };
  },
  StringLiteral: (node) => {
    return {
      kind: node.getKindName(),
      value: node.getLiteralValue(),
    };
  },
};

function exits<T>(v?: T): v is Exclude<T, undefined> {
  return typeof v !== 'undefined';
}

function visitNode(c?: Node) {
  if (!c) {
    return undefined;
  }

  const handle = visitors[c.getKindName() as keyof Visitors];

  if (!handle) {
    console.warn('No handler for', c.getKindName());
  }

  const typedHandle = handle as (c: Node) => Visited | undefined;

  return typedHandle?.(c);
}

function visitChildren(node: Node) {
  return node
    .getChildren()
    .map(visitNode)
    .filter((c) => !!c);
}

const path = process.argv[process.argv.length - 1];
const project = new Project();

const sourceFile = project.addSourceFileAtPath(path);

const result = visitChildren(sourceFile);

// just print the result as JSON, but this can of course be whatever
console.log(JSON.stringify(result));
```

This can be used by running it directly with `node`. Piping to `jq` can also provide some nice highlighting:

```sh
node describe.ts path/to/file/to/describe/example.ts | jq
```

## References

In addition to using the AST Direcly, some libraries that are also handy for working with the Typescript AST are:

- [@phenomnomnominal/tsquery](https://github.com/phenomnomnominal/tsquery)
- [ts-morph](https://github.com/dsherret/ts-morph)
- [@microsoft/api-extractor](https://api-extractor.com)
- [jscodeshift](https://jscodeshift.com/build/api-reference/)
- [recast](https://github.com/benjamn/recast)
- [TS Parsec](https://github.com/microsoft/ts-parsec)

And some more general AST related tools:

- [Tree-sitter](https://tree-sitter.github.io/tree-sitter/)
- [ast-grep](https://ast-grep.github.io/)
