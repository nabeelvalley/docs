---
title: Update or Append to DynamoDB Attributes
description: Use UpdateExpressions to modify DynamoDB items without reading them from the database
subtitle: 28 February 2023
---

# DynamoDB Overview

DynamoDB is AWS's No SQL Database Service. Dynamo uses partition keys and sort keys to uniquely identify and partion item in the database which allows for high scalability and throughput

When working with traditional SQL databases a common operation is to update the value of a specific column without having to first fetch the entire row. DynamoDB offers us similar functionality using the AWS SDK

# The Update Command

DynamoDB commands are simple objects that consist of a few different parts. When looking to update an item the following are relavant:

1. `Key` - which is an object that uniquely identifies an item in the database
2. `UpdateExpression` - which is an expression that describes the upadate operation to be done using placeholders for attribute names and values ([AWS Documentation - Update Expressions](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Expressions.UpdateExpressions.html))
3. `ExpressionAttributeNames` - generic placehodlders for attribute names
4. `ExpresssionAtributeValues` - generic placeholders for values

When defining `UpdateExpression` we use placeholders for the attribute names and values to prevent any escaping/unsupported character related issues. A common convention for this is to use `#` at the start of attribute names and `:` at the start of attribute values to make expressions a bit easier to negotiate, for example, if I wanted to set `name` to `bob` I would do `'#name': 'name'` in the `ExpressionAttributeNames` and `'#name': 'bob'` in the `ExpressionAttributeValues`

DynamoDB uses an object representation that is a bit inconvenient to work with, we can use the `marshall` and `unmarshall` functions from `@aws-sdk/util-dynamodb` to simplify things a bit but if you'd like to know more about the data format used you can look towards the end of this post

# Our Example

For our example, imagine we have a table of user check-ins with data structured as follows:

```ts
type Item = {
  // partition key
  group: number
  // sort key
  username: string

  status: string
  checkIns: {
    place: string
    time: number
  }[]
}
```

# Update an Attribute

We can use a bit of a generic structure to outline our data that we plan to update a single attribute. To do this, we can use the `SET` command

The update expression for setting a value will look like so:

```
SET #attr = :value
```

Yup, that's pretty much it as far as the expression goes, the actual names of the fields we want to update aren't relevant here, instead they're mentioned in the `ExpressionAtrributeNames` and `ExpressionAttributeValues`

The overall command with all of that is as follows:


```ts
import { DynamoDBClient } from '@aws-sdk/client-dynamodb';
import { marshall, unmarshall } from '@aws-sdk/util-dynamodb';

const client = new DynamoDBClient({})

const pk = 'bob'
const sk = 12
const updateValue = 'available'

const command = new UpdateItemCommand({
  TableName: 'my-table-name',
  Key: marshall({
    username: pk,
    group: sk,
  }),
  UpdateExpression: 'SET #attr = :value',
  ExpressionAttributeNames: {
    '#attr': 'status'
  },
  ExpressionAtrributeValues: marshall({
    ':value': updateValue
  })
})

await client.send()
```

And that's pretty much the process for updating an attribute witha  specific value


# Append to a List Attribute That Exists

In the above data structure we have the `checkIns` field which is a list of objects

We can use the same method as above to define the `UpdateExpression`, however this time we can use the `list_append` function in our expression to state that we would like to append a value to

The `list_append` function appends one list to another - this means that it needs two lists to operate on. To update a list we can just use itself as the first input and the new list as the second. The `UpdateExpression` looks like this:

```
SET #attr = list_append(#attr, :value)
```

For our sake we only want to append a single item, so we can just wrap it in an array when we pass it on in the command. The command for the above update looks like so:

```ts
import { DynamoDBClient } from '@aws-sdk/client-dynamodb';
import { marshall, unmarshall } from '@aws-sdk/util-dynamodb';

const client = new DynamoDBClient({})

const pk = 'bob'
const sk = 12
const updateValue = {
  place: 'home',
  time: Date.now()
}

const command = new UpdateItemCommand({
  TableName: 'my-table-name',
  Key: marshall({
    username: pk,
    group: sk,
  }),
  UpdateExpression: 'SET #attr = list_append(#attr, :value)',
  ExpressionAttributeNames: {
    '#attr': 'checkIns'
  },
  ExpressionAtrributeValues: marshall({
    // array since the update expression works on two lists
    ':value': [updateValue]
  })
})

await client.send()
```

# Append to a List Attribute That May Not Exist

In some cases, we can end up trying to append to an attribute that may not exist, under these circumstances we can use the `is_not_exists` function that takes an attribute name and a fallback value and will return the fallback if the attribute does not exist in the item

We can change the `UpdateExpression` to make use of this as follows:

```
SET #attr = list_append(if_not_exists(#attr, :fallback), :value)
```

And the full command looks like so:

```ts
import { DynamoDBClient } from '@aws-sdk/client-dynamodb';
import { marshall, unmarshall } from '@aws-sdk/util-dynamodb';

const client = new DynamoDBClient({})

const pk = 'bob'
const sk = 12
const updateValue = {
  place: 'home',
  time: Date.now()
}

const command = new UpdateItemCommand({
  TableName: 'my-table-name',
  Key: marshall({
    username: pk,
    group: sk,
  }),
  UpdateExpression: 'SET #attr = list_append(if_not_exists(#attr, :fallback), :value)',
  ExpressionAttributeNames: {
    '#attr': 'checkIns'
  },
  ExpressionAtrributeValues: marshall({
    ':value': [updateValue],
    // fallback to an empty array if the value does not exist before appending
    ':fallback': []
  })
})

await client.send()
```

The above expresson helps us append an item to the list while also providing a fallback for the case where the list item may not exist

# A Note on Marshalled/Unmarshalled data


DynamoDB works with data in the "marshalled" form, which is an object representation for primitive data types ([AWS Documentation - Attribute Value](https://docs.aws.amazon.com/amazondynamodb/latest/APIReference/API_AttributeValue.html)). Some examples of marshalled and unmarshalled data can be seen below:

```ts
// STRING
// Unmarshalled
"hello"

// Marshalled
{
  "S": "Hello"
}

// NUMBER
// Unmarshalled
25

// Marshalled
{
  "N": "25"
}


// MAP
// Unmarshalled
{
  name: "bob"
}

/// Marshalled
{
  "M":{
    "name":{
      "S":"hello"
    }
  }
}
```

# Additional Resources

Speaking of DynamoDB updates, it looks like there's a library for building queries which seems promising and may bwe worth taking a look at called [ElectroDB](https://electrodb.dev/en/core-concepts/introduction/)