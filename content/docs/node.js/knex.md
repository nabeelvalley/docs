Knex is a library for Node.js which supports for a variety of SQL databases and allows us to generate and run queries against them

# Knex as a Query Builder

We can use Knex to generate SQL queries for a database using something like the following structure:

```ts
const knex = require('knex')({
  client: 'pg',
})

const query = knex('users').where({'username': 'bob'}).toQuery();

console.log(query) // select * from "users" where "username" = 'bob'
```

We can use Knex using TS in a more practical sense like such:

```ts
const createUser = (username: string) => {
  return knex('users').insert({ username }).returning('*').toQuery();
};

const getUser = (username: string) => {
  return knex('users').where({ username }).toQuery();
};
```