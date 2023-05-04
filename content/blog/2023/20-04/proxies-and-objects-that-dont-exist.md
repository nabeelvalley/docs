```ts
interface Person {
  name: string;
}

type DB = Record<string, Person>;

const db: DB = {
  bob: {
    name: "Bob",
  },
  jeff: {
    name: "Jeff",
  },
};

const alwaysDefinedHandler: ProxyHandler<DB> = {
  get(target, prop, receiver) {
    const user = db[prop as string];

    if (!user) {
      db[prop as string] = {
        name: prop as string,
      };

      return db[prop as string];
    }

    return user;
  },
};

const insertIfNotFoundDb = new Proxy<DB>(db, alwaysDefinedHandler);

console.log(insertIfNotFoundDb.bob);

console.log(db);

// smith is not in the database, but the act of accessing it through a proxy will create the person
// based on the logic we have defined in the proxy
console.log(insertIfNotFoundDb.smith);

console.log(db);

// @ts-expect-error
console.log(insertIfNotFoundDb[new Date()]);

console.log(db);
```