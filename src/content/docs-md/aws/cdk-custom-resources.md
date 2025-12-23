## Run a Database Migration on RDS with CDK Custom Resources

> Refer to [Custom cloud infrastructure as code with AWS CDK - CloudFormation Custom Resources Lambda Backend](https://www.youtube.com/watch?v=u7FdDFta2XI)

Cloud Formation Custom Resources are the method by which we can provision resources that cloud formation doesn't have an existing resource definition for but we still need to create.

They provide us with a way to provision or modify resources by way of a function

This enables us to run pretty much any code or before or after a particular resource lifecycle event so we can do things like provision 3rd party or on-prem services or even run something like a database migration when the database is created - the latter of which is what we're going to do in this post

> Note that there are other types of custom resources, but we'll be specifically using one that uses a Lambda as its basis

## Setup the CDK App

To create a CDK app, you will need to use the `cdk` CLI, init a new app like this:

```sh
mkdircustom-resources
cd custom-resources

cdk init --language typescript
```

The created app will have all the usual CDK files, for our purposes you can delete the default `Stack` in the `lib` directory. If you're using the same name as I am this will be the `lib/custom-resources-stack.ts` file

Next, since we'll need to create Custom Resources as the packages needed to configure an RDS instance as well as work with it using postgres we need to install the following packages using our package manager:

```json
"@aws-cdk/aws-ec2": "1.109.0",
"@aws-cdk/aws-iam": "1.109.0",
"@aws-cdk/aws-lambda": "1.109.0",
"@aws-cdk/aws-lambda-nodejs": "1.109.0",
"@aws-cdk/aws-logs": "1.109.0",
"@aws-cdk/aws-rds": "1.109.0",
"@aws-cdk/aws-secretsmanager": "1.109.0",
"@aws-cdk/core": "1.109.0",
"@aws-cdk/custom-resources": "1.109.0",
"@types/pg": "^8.6.0",
"pg": "^8.6.0",
```

> Replace the version in the above with the version used by your CDK app, you can see what this is in your `pacakge.json` file in the `@aws-cdk/core` dependency

Now that we've got all the dependencies in place, we can move on to actually building our the functionality

## Define the Stacks

Our app will make use of two stack, one to setup the database and one to handle the migration by way of a Custom Resource, the stacks will need the following respectively:

1. A `DatabaseStack` with a `vpc`, `secret`, `instance`, and connection clearances as well as Exporting the above resources
2. A `MigrateStack` which will define our custom resource which requires the `Exports` from the `DatabaseStack` and contains a `NodejsFunction` for our Lambda, a `Provider` and a `CustomResource` definition

Once that's all done, we can actually create the Lambda which will carry our our migration

### `DatabaseStack`

1. Definition of a `secret` for our DB Credentials, we will want to export this for use by our `MigrateStack` by way of a `public` property on our class

```ts
const dbSecret = new sm.Secret(this, 'DBCredentials', {
  generateSecretString: {
    secretStringTemplate: JSON.stringify({
      username: 'dbAdmin',
    }),
    excludePunctuation: true,
    excludeCharacters: '/@"\' ',
    generateStringKey: 'password',
  },
})
```

2. Creation of a `vpc` for the RDS instance

```ts
const vpc = new ec2.Vpc(this, 'AppVPC', {
  maxAzs: 2,
})
```

3. The `instance` for our database:

```ts
const dbInstance = new rds.DatabaseInstance(this, 'Instance', {
  vpc,
  engine: rds.DatabaseInstanceEngine.postgres({
    version: rds.PostgresEngineVersion.VER_12_6,
  }),
  databaseName: this.dbName,
  // optional, defaults to m5.large
  instanceType: ec2.InstanceType.of(
    ec2.InstanceClass.BURSTABLE3,
    ec2.InstanceSize.SMALL
  ),
  credentials: rds.Credentials.fromSecret(dbSecret),
  publiclyAccessible: true,
})
```

4. Some network clearences to allow traffic to our database (We're keeping this simple and allowing all connections, but in practice you would want to use a more secure connection strategy)

```ts
dbInstance.connections.allowFromAnyIpv4(ec2.Port.allTraffic())

dbInstance.connections.allowInternally(ec2.Port.allTraffic())
```

And lastly, we'll export these to public properties with:

```ts
// top of the `DatabaseStack` class
public readonly dbInstance: rds.DatabaseInstance;
public readonly dbSecret: sm.Secret;
public readonly vpc: ec2.Vpc;
public readonly dbName: string = "appdb";


// after we have done all the setup above
this.vpc = vpc;
this.dbInstance = dbInstance;
this.dbSecret = dbSecret;
```

Putting all this together into a `lib/database-stack.ts` file to define the `DatabaseStack` we have:

`lib/database-stack.ts`

```ts
import * as cdk from '@aws-cdk/core'
import * as ec2 from '@aws-cdk/aws-ec2'
import * as sm from '@aws-cdk/aws-secretsmanager'
import * as rds from '@aws-cdk/aws-rds'
import * as cr from '@aws-cdk/custom-resources'
import * as lambda from '@aws-cdk/aws-lambda'
import * as iam from '@aws-cdk/aws-iam'
import * as logs from '@aws-cdk/aws-logs'
import { NodejsFunction } from '@aws-cdk/aws-lambda-nodejs'
import { CfnOutput } from '@aws-cdk/core'

export class DatabaseStack extends cdk.Stack {
  public readonly dbInstance: rds.DatabaseInstance
  public readonly dbSecret: sm.Secret
  public readonly vpc: ec2.Vpc
  public readonly dbName: string = 'appdb'

  constructor(scope: cdk.Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props)

    const dbSecret = new sm.Secret(this, 'DBCredentials', {
      generateSecretString: {
        secretStringTemplate: JSON.stringify({
          username: 'dbAdmin',
        }),
        excludePunctuation: true,
        excludeCharacters: '/@"\' ',
        generateStringKey: 'password',
      },
    })

    const vpc = new ec2.Vpc(this, 'AppVPC', {
      maxAzs: 2,
    })

    const dbInstance = new rds.DatabaseInstance(this, 'Instance', {
      vpc,
      engine: rds.DatabaseInstanceEngine.postgres({
        version: rds.PostgresEngineVersion.VER_12_6,
      }),
      databaseName: this.dbName,
      // optional, defaults to m5.large
      instanceType: ec2.InstanceType.of(
        ec2.InstanceClass.BURSTABLE3,
        ec2.InstanceSize.SMALL
      ),
      credentials: rds.Credentials.fromSecret(dbSecret),
      publiclyAccessible: true,
    })

    dbInstance.connections.allowFromAnyIpv4(ec2.Port.allTraffic())

    dbInstance.connections.allowInternally(ec2.Port.allTraffic())

    this.vpc = vpc
    this.dbInstance = dbInstance
    this.dbSecret = dbSecret
  }
}
```

### MigrateStack

1. `Props` defintion so the `DatabaseStack` Exports can be provided:

```ts
interface StackProps extends cdk.StackProps {
  dbInstance: rds.DatabaseInstance
  dbSecret: sm.Secret
  vpc: ec2.Vpc
  dbName: string
}

// which can be destructured later with:
const { dbInstance, dbName, dbSecret, vpc } = props
```

2. NodeJS Lambda to run our migration:

```ts
const onEventHandler = new NodejsFunction(this, 'DatabaseMigrate', {
  vpc,
  runtime: lambda.Runtime.NODEJS_14_X,
  entry: 'lib/database-migrate-lambda.ts',
  handler: 'handler',
  environment: {
    DB_HOST: dbInstance.dbInstanceEndpointAddress,
    DB_PORT: dbInstance.dbInstanceEndpointPort,
    DB_USERNAME: dbSecret.secretValueFromJson('username').toString(),
    DB_PASSWORD: dbSecret.secretValueFromJson('password').toString(),
    DB_NAME: dbName,
  },
  logRetention: logs.RetentionDays.ONE_DAY,
  timeout: Duration.minutes(2),
})
```

3. The `Provider` to be used in the `CustomResource` Creation:

```ts
const databaseMigrationProvider = new cr.Provider(
  this,
  'DatabaseMigrateProvider',
  {
    onEventHandler,
    logRetention: logs.RetentionDays.ONE_DAY,
  }
)
```

4. Lastly, the `CustomResource` itself:

```ts
const databaseMigrationResource = new cdk.CustomResource(
  this,
  'DatabaseMigrateResource',
  {
    serviceToken: databaseMigrationProvider.serviceToken,
  }
)
```

The overall `lib/migrate-stack.ts` file will look like this:

`lib/migrate-stack.ts`

```ts
import * as cdk from '@aws-cdk/core'
import * as ec2 from '@aws-cdk/aws-ec2'
import * as sm from '@aws-cdk/aws-secretsmanager'
import * as rds from '@aws-cdk/aws-rds'
import * as cr from '@aws-cdk/custom-resources'
import * as lambda from '@aws-cdk/aws-lambda'
import * as iam from '@aws-cdk/aws-iam'
import * as logs from '@aws-cdk/aws-logs'
import { NodejsFunction } from '@aws-cdk/aws-lambda-nodejs'
import { Duration } from '@aws-cdk/core'

interface StackProps extends cdk.StackProps {
  dbInstance: rds.DatabaseInstance
  dbSecret: sm.Secret
  vpc: ec2.Vpc
  dbName: string
}

export class MigrateStack extends cdk.Stack {
  constructor(scope: cdk.Construct, id: string, props: StackProps) {
    super(scope, id, props)

    const { dbInstance, dbName, dbSecret, vpc } = props

    const onEventHandler = new NodejsFunction(this, 'DatabaseMigrate', {
      vpc,
      runtime: lambda.Runtime.NODEJS_14_X,
      entry: 'lib/database-migrate-lambda.ts',
      handler: 'handler',
      environment: {
        DB_HOST: dbInstance.dbInstanceEndpointAddress,
        DB_PORT: dbInstance.dbInstanceEndpointPort,
        DB_USERNAME: dbSecret.secretValueFromJson('username').toString(),
        DB_PASSWORD: dbSecret.secretValueFromJson('password').toString(),
        DB_NAME: dbName,
      },
      logRetention: logs.RetentionDays.ONE_DAY,
      timeout: Duration.minutes(2),
    })

    const databaseMigrationProvider = new cr.Provider(
      this,
      'DatabaseMigrateProvider',
      {
        onEventHandler,
        logRetention: logs.RetentionDays.ONE_DAY,
      }
    )

    const databaseMigrationResource = new cdk.CustomResource(
      this,
      'DatabaseMigrateResource',
      {
        serviceToken: databaseMigrationProvider.serviceToken,
      }
    )
  }
}
```

## The Migration Lambda

The Migration Lambda itself is pretty much just a function that will use the Postgres Client for Node.js to run some SQL queries against the database - you can implement this however you want, and I would suggest using some kind of ORM if needed, but again, to keep it simple we're going to just run some regular SQL, we can do this in a file called `lib/database-migrate-lambda.ts` which is what we actually referenced above when creating the `NodeJS` Lambda

`lib/database-migrate-lambda.ts`

```ts
import { Client } from 'pg'

interface EventType {
  RequestType: 'Create' | string
}

export const handler = async (event: EventType): Promise<any> => {
  const { DB_HOST, DB_PORT, DB_USERNAME, DB_PASSWORD, DB_NAME } = process.env

  // the RequestType that will be sent to us from CloudFormation when the lambda is executed
  if (event.RequestType == 'Create') {
    const port = +(DB_PORT || 5432)

    const rootClient = new Client({
      port,
      host: DB_HOST,
      user: DB_USERNAME,
      password: DB_PASSWORD,
      database: 'postgres',
    })

    try {
      await rootClient.connect()

      console.log(
        await rootClient.query(`
        CREATE DATABASE ${DB_NAME};
      `)
      )
    } catch (error) {
      console.warn(
        `Error creating db ${DB_NAME}, check if due to db existing, move on anyway`
      )
      console.warn(error)
    } finally {
      rootClient.end()
    }

    const appClient = new Client({
      port,
      host: DB_HOST,
      user: DB_USERNAME,
      password: DB_PASSWORD,
      database: DB_NAME,
    })

    await appClient.connect()

    console.log(
      await appClient.query(`
      CREATE TABLE users (
        id serial PRIMARY KEY,
        username VARCHAR ( 50 ) UNIQUE NOT NULL,
        password VARCHAR ( 50 ) NOT NULL
      );
      `)
    )

    console.log(
      await appClient.query(`
      INSERT INTO users 
        (id, username, password)
      VALUES (1, 'helloworld', 'securepassword');
    `)
    )

    console.log(
      await appClient.query(`
      SELECT * FROM users;
      `)
    )

    appClient.end()
  }
}
```

## Deploy the App Stacks

So, we've defined two stacks for our application, but we're not yet ready to deploy since we need to actually get CDK to recognize and deploy these stacks.

To configure the deployment, we need to edit the `bin/custom-resources.ts` file to create the stack instance and pass the Exports from the `DatabaseStack` to the `MigrateStack`:

`lib/custom-resources.ts`

```ts
#!/usr/bin/env node
import 'source-map-support/register'
import * as cdk from '@aws-cdk/core'
import { DatabaseStack } from '../lib/database-stack'
import { MigrateStack } from '../lib/migrate-stack'

const app = new cdk.App()

const dbStack = new DatabaseStack(app, 'CRDatabaseStack')

const migrateStack = new MigrateStack(app, 'CRMigrateStack', {
  dbInstance: dbStack.dbInstance,
  dbName: dbStack.dbName,
  dbSecret: dbStack.dbSecret,
  vpc: dbStack.vpc,
})
```

Then, use `yarn cdk deploy --all` to build and deploy your application:

```
yarn cdk deploy --all
```

This will take a while to deploy, and the `cdk` CLI will ask you for some confirmations while it runs, once done you can look for the Lambda in CloudWatch to view the results of the deploy, however if there are any errors while running you will see it in the terminal or CloudFormation output

## Final Notes

The above setup is just intended to be a starting point for using Lambdas to run custom logic on application deploys. This isn't a database setup I'd recommend but it should allow you
