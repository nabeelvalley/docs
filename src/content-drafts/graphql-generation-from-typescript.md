---
published: true
title: Generate GraphQL Schemmas from typescript type definitions
---

---
title: Generate GraphQL Schemmas from typescript type definitions
---

Below is a very in-progress implementation of reading typescript types to define a graphql schema


Some TSConfig

```ts
import {Project, SyntaxKind, TypeFormatFlags} from 'ts-morph';

const project = new Project({
  tsConfigFilePath: "./tsconfig.json",
})

const languageServer = project.getLanguageService()

// TODO: we can maybe use this to "inline" schema defs
type Expand<T> = T extends {} ? { [K in keyof T]: Expand<T[K]> } & {} : T;

const schemas : string[]=  []

const models = project.addDirectoryAtPath("./models")
const modelsFiles = models.getSourceFiles().map(file => {

  const statements = file.getStatements()
  statements.map(statement => {
    const isInterface = statement.isKind(SyntaxKind.InterfaceDeclaration)

    if (isInterface) {
      const typeName = statement.getName()
      const declaration = [`type ${typeName} {`]

      const members = statement.getMembers()
    

       members.forEach(member => {
        const name = member.compilerNode.name?.getText()
        const type = member.compilerNode.name?.getText()

        if (!(name && type)) {
          return undefined
        }

        declaration.push(`  ${name}: ${type}`)

        return {name,type}
       })
      
      declaration.push(`}`)

      schemas.push(declaration.join('\n'))
    }
  })
})

console.log(schemas.join('\n'))
```

Some input files:


```ts
type Expand<T> = T extends {} ? { [K in keyof T]: Expand<T[K]> } & {} : T;

export interface Jack {
  name: 'jack'
}

export interface Person {
  name: string,
  age: number,
  jack: Jack
}

export type PersonExpand = Expand<Person>

export type DoThing = () => void
```