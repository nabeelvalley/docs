---
published: true
title: Using the TypeScript AST
---

---
published: true
title: Using the TypeScript AST
---

# Generating Typescript using AST's

> Some parsers other that the Typescript ones is [Esprima](https://esprima.org/demo/parse.html), [Acorn](https://github.com/acornjs/acorn), these are Javascript Parsers> Other languages also have parsers as well as tools called `Parser Generators` that enable you to generate a parser for a given language or usecase

Before getting started, you should first install the `typescript` package into your project with:

```sh
yarn add typescript
```

Using the typescript compiler you are able to parse TS into an AST as well as build code using the TS AST

> You can also generate the `ts.` code using the [Typescript to AST Converter](https://ts-ast-viewer.com/)

## Generate Types

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

## Printing to Code

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
