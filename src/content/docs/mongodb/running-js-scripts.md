---
published: true
title: JS Scripts
subtitle: Running JS Scripts on MongoDB
---

> More information [here](https://kb.objectrocket.com/mongo-db/use-mongodb-to-run-javascript-957)

JavaScript can be used to manipulate a MongoDB Database from within the `mongo` shell. To do this you can make use of the `mongo` shell

# Create a Script

To create a script, you simply need to create a `.js` file, the `db` object will be the current database (set when running the script) and pretty much holds the database reference

> Note that `print` is used instead of `console.log`

`MyDbScript.js`

```js
print(db)
```

# Run a Script

To run the script, you will do the following from the terminal:

```
mongo DBName MyDbScript.js
```

// To update with more detailed examples
