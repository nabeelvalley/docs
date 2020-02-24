# Generating Typescript using AST's

Using the typescript compiler you are able to parse TS into an AST as well as build code using the TS AST

> You can also generate the `ts.` code using the [Typescript to AST Converter](https://ts-ast-viewer.com/)

## Generate Types

```ts
export type User = {
    name: string;
    age: number;
};
```

To generate a type like above using the TS compiler you can use the following:

```js
// create name property
const nameProp = ts.createPropertySignature(
    undefined,
    name = ts.createIdentifier("name"),
    undefined, 
    type = ts.createKeywordTypeNode(ts.SyntaxKind.StringKeyword),
    undefined
)

// create age property
const ageProp = ts.createPropertySignature(
    undefined,
    ts.createIdentifier("age"),
    undefined,
    ts.createKeywordTypeNode(ts.SyntaxKind.NumberKeyword),
    undefined
)

// create User type
const usersType = ts.createTypeAliasDeclaration(
    undefined,
    [ts.createModifier(ts.SyntaxKind.ExportKeyword)],
    ts.createIdentifier("User"),
    undefined,
    ts.createTypeLiteralNode([nameProp, ageProp])
)
```

We can then use the generated type to build a more complex type:

```ts
export type Admin = {
    user: User;
};
```

```js
const userProp = ts.createPropertySignature(
    undefined,
    ts.createIdentifier("user"),
    undefined,
    usersType.name,
    undefined
)

const adminType = ts.createTypeAliasDeclaration(
    undefined,
    [ts.createModifier(ts.SyntaxKind.ExportKeyword)],
    ts.createIdentifier("Admin"),
    undefined,
    ts.createTypeLiteralNode([userProp])
)
```

## Printing to Code

We can then print the two types out as Typescript code with the following:

```js
const sourceFile = ts.createSourceFile('./test.ts', '', ts.ScriptTarget.ES3, true, ts.ScriptKind);

const printer = ts.createPrinter()

const file = printer.printList(ts.EmitHint.Expression, [usersType, adminType], sourceFile)

fs.writeFileSync('./output.ts', file)
```

Which will output the following:

```ts
export type User = {
    name: string;
    age: number;
};
export type Admin = {
    user: User;
};
``