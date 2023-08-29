---
published: true
title: A Simple JSON Backed Database in Typescript
subtitle: 07 July 2022
description: Create a simple database that's backed to a JSON file using Typescript and Node.js
---

# Define the database

The database is defined as a class which has an in-memory store `data` and a `persist` method that allows for persisting the database to a file as well as content when an instance is created from an existing JSON file

The code for the database can be seen below:

```ts
import { existsSync, readFileSync, writeFileSync } from 'fs'

export class Database<TData> {
  public data: TData

  constructor(private readonly dbPath: string, initial: TData) {
    this.data = this.load(initial)
  }

  public update = (data: Partial<TData>) =>
    (this.data = { ...this.data, ...data })

  public commit = () => this.persist(this.data)

  private persist = (data: TData) =>
    writeFileSync(this.dbPath, JSON.stringify(data))

  private read = (): TData =>
    JSON.parse(readFileSync(this.dbPath).toString()) as TData

  private load = (initial: TData): TData => {
    if (!existsSync(this.dbPath)) {
      this.persist(initial)
    }

    const current = this.read()

    return {
      ...initial,
      ...current,
    }
  }
}
```

## Usage

The database can be used by creating an instance and modifying the data in it by using the `update` method, and can be written to a file using the `commit` method:

```ts
import { Database } from './db'

interface User {
  name: string
  age: number
}

interface DB {
  users: User[]
}

const initial: DB = {
  users: [],
}

const db = new Database<DB>('./data.json', initial)

db.update({
  users: [
    {
      name: 'Test',
      age: 20,
    },
  ],
})

db.commit()
```

## Functional Example

The above code is found in the below REPL as a runnable example:

<iframe height="700px" width="100%" src="https://replit.com/@nabeelvalley/SimpleJSONDB?lite=true" scrolling="no" frameborder="no" allowtransparency="true" allowfullscreen="true" sandbox="allow-forms allow-pointer-lock allow-popups allow-same-origin allow-scripts allow-modals"></iframe>
