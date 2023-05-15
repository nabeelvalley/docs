---
published: true
title: Simple Lambda Custom Authorizer
subtitle: Using a Lambda for Authorization and Authentication on AWS API Gateway
---

[[toc]]

# Custom Authorizers

API Gateway allows us to handle auth by way of a lambda. AWS has two types of authorization lambdas we can use, namely:

- `SIMPLE` - returns a message stating whether a user is authorized along with a context object
- `IAM` - returns an IAM Policy Document stating user/resource access

We'll be discussing at the former since it's significantly simpler (hence the name) and is fairly poorly documented on the interwebs

Also note that I'm using SST for the definition of the `Function` and `Api` but the general concept still applies at a broader API Gateway and CDK Stack

# The Authorizer Lambda

> Note that the `@types/aws-lambda` package does not have a type def for the `SIMPLE` authorizer, and so I've provided the authorizer in JavaScript in order to keep things to the point, but in practice you should probably write more concrete types for the lambda

The expected return value for the Authorizer in `SIMPLE` mode looks like this:

```ts
interface AuthResult {
  isAuthorized: boolean,
  context?: any
}
```

If we want to create an Authorizer Lambda that checks for a `username` in the `Authorization` header for example, we can do something Like the below:

`src/lambda/auth.js`

```js
export const handler = async (event) => {
  const allowedUser = process.env.ALLOWED_USER

  if (!allowedUser) {
    return {
      isAuthorized: false
    }
  }

  // get the `username` from the `headers`
  const username = event.headers.Authorization

  // return unauthorized if the `username` does not match the `allowedUser`
  if (username !== allowedUser) {
    return {
      isAuthorized: false
    }
  }

  // return authorized if the `username` matches, along with some data in the `context`. the
  // `context` will be passed on to any lambda that's guarded by this authorizer so it's a good way
  // to populate what we know about the user so downstream lambdas don't need to check this manually
  return {
    isAuthorized: true,
    context: {
      username
    }
  }
}
```

Lastly, if you're hooking things up manually you can find the Authorizer Settings in API Gateway for your specific API and Lambda, but if you're using CDK/SST look to the next section for how to integrate this into your stack

# The Stack

If, like me, you're using SST for creating your API and would like to configure your Authorizer using that, you can simply add the following to your stack and attaching it to your API

```js
// Authorizer Lambda Definition
const authHandler = new sst.Function(this, 'AuthHandler', {
  handler: 'src/lambda/auth.handler',
  environment: {
     ALLOWED_USER: 'nabeel'
  },
});

const authorizer = new HttpLambdaAuthorizer({
  authorizerName: 'LambdaAuthorizer',
  handler: authHandler,
  responseTypes: [HttpLambdaResponseType.SIMPLE],
});

// Existing API Definition
const api = new sst.Api(this, 'Api', {
  defaultAuthorizationType: sst.ApiAuthorizationType.CUSTOM,
  defaultAuthorizer: authorizer,
  defaultPayloadFormatVersion: ApiPayloadFormatVersion.V2,
  /// rest of props
```

# PolicyDocument Based Authorizers

In the context of Authorizers we can also have the PolicyDocument based authorizers which is the typical implementation. Without any explanation this is what one of those would look like:

> This example is straight from the [AWS Documentation](https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-use-lambda-authorizer.html)

```ts

// A simple token-based authorizer example to demonstrate how to use an authorization token 
// to allow or deny a request. In this example, the caller named 'user' is allowed to invoke 
// a request if the client-supplied token value is 'allow'. The caller is not allowed to invoke 
// the request if the token value is 'deny'. If the token value is 'unauthorized' or an empty
// string, the authorizer function returns an HTTP 401 status code. For any other token value, 
// the authorizer returns an HTTP 500 status code. 
// Note that token values are case-sensitive.

exports.handler =  function(event, context, callback) {
    var token = event.authorizationToken;
    switch (token) {
        case 'allow':
            callback(null, generatePolicy('user', 'Allow', event.methodArn));
            break;
        case 'deny':
            callback(null, generatePolicy('user', 'Deny', event.methodArn));
            break;
        case 'unauthorized':
            callback("Unauthorized");   // Return a 401 Unauthorized response
            break;
        default:
            callback("Error: Invalid token"); // Return a 500 Invalid token response
    }
};

// Help function to generate an IAM policy
var generatePolicy = function(principalId, effect, resource) {
    var authResponse = {};
    
    authResponse.principalId = principalId;
    if (effect && resource) {
        var policyDocument = {};
        policyDocument.Version = '2012-10-17'; 
        policyDocument.Statement = [];
        var statementOne = {};
        statementOne.Action = 'execute-api:Invoke';


        statementOne.Effect = effect;
        statementOne.Resource = resource;
        policyDocument.Statement[0] = statementOne;
        authResponse.policyDocument = policyDocument;
    }
    
    // Optional output with custom properties of the String, Number or Boolean type.
    authResponse.context = {
        "stringKey": "stringval",
        "numberKey": 123,
        "booleanKey": true
    };
    return authResponse;
}
```