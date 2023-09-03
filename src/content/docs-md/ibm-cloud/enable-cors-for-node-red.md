# Enale Cors for Node-RED

In order to enable Cross Origin for Node-RED we need to add the `httpNodeCors` option into the `bluemix-settings.js` file in the settings object

```javascript
var settings = module.exports = {
    ...
    httpNodeCors: { origin: "*", methods: ["GET","PUT","POST","DELETE"] },
    ...
    }
```

We can access our application by either pulling it and re-pushing, or alternatively by creating a DevOps toolchain around that
