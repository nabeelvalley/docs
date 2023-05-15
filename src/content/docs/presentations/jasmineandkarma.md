---
published: true
title: Jasmine and Karma
subtitle: Unit testing JS Apps using Jasmine and Karma
---

[[toc]]

# Jasmine

## What and Why

### What

- Javascript testing framework

  - Can be used with different languages and frameworks

    - Javascript, Node
    - Typescript, Angular
    - Ruby
    - Python

      **Why**

- Fast
- Independent
- Runs via Node or in Browser
- Behaviour Driven Development
  - Attempts to describe tests in a human readable format

## Setting up a test environment

### For JS

```html
<!-- Order of tags is important -->
<link rel="stylesheet" href="jasmine.css" />
<script src="jasmine.js"></script>
<script src="jasmine-html.js"></script>
<script src="boot.js"></script>

<!-- Sctipts to be tested -->
<script src="main.js"></script>

<!-- Test Script -->
<script src="test.js"></script>
```

### For Node

Add Jasmine as a dev dependency

```text
npm install --save-dev jasmine
```

Add test command to `package.json`

```javascript
"scripts": { "test": "jasmine" }
```

Run the test command

```text
npm test
```

## Writing a test suite and spec

We want to test the following `helloWorld` function.

`main.js`

```javascript
function helloWorld() {
  return "Hello world!"
}
```

This function, when called should return `'Hello World'`

`test.js`

```javascript
describe("suiteName", () => {
  it("specName", () => {
    expect(helloWorld()).matcher("Hello world!")
  })
})
```

### 4 functions

- Define the **Test Suite**

  ```javascript
  describe(string, function)
  ```

- Define a **Test Spec**

  ```javascript
  it(string, function)
  ```

- Define the **Actual Value**

  ```javascript
  expect(actual)
  ```

- Define the Comparison

  ```javascript
  matcher(expected)
  ```

### Setup and Teardown

```javascript
let expected = "Hello World!"
```

- Initialize variable that are needed for testing

```javascript
beforeAll(function)
```

- Called before all tests in a Suite are run

```javascript
afterAll(function)
```

- Called after all tests in a Suite are run

```javascript
beforeEach(function)
```

- Called before each test Spec is run

```javascript
afterEach
```

- Called after each test Spec is run

### Matchers

- The means of comparing the `actual` and `expected` values
- Return a `boolean` indicating if a test passed or failed
- Jasmine has some pre-built Matchers

  ```javascript
  expect(array).toContain(member)
  expect(fn).toThrow(string)
  expect(fn).toThrowError(string)
  expect(instance).toBe(instance)
  expect(mixed).toBeDefined()
  expect(mixed).toBeFalsy()
  expect(mixed).toBeNull()
  expect(mixed).toBeTruthy()
  expect(mixed).toBeUndefined()
  expect(mixed).toEqual(mixed)
  expect(mixed).toMatch(pattern)
  expect(number).toBeCloseTo(number, decimalPlaces)
  expect(number).toBeGreaterThan(number)
  expect(number).toBeLessThan(number)
  expect(number).toBeNaN()
  expect(spy).toHaveBeenCalled()
  expect(spy).toHaveBeenCalledTimes(number)
  expect(spy).toHaveBeenCalledWith(...arguments)
  ```

- Custom matchers can also be defined

  **Running tests**

- For JS we have 2 options
- Open `index.html` in a browser
- Run `npm test`

# Jasmine Demo

## The following 3 files

`index.html`

```html
<!DOCTYPE html>
<html>
  <head>
    <title>Jasmine Running</title>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/jasmine/2.4.1/jasmine.css"
    />
  </head>
  <body>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jasmine/2.4.1/jasmine.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jasmine/2.4.1/jasmine-html.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jasmine/2.4.1/boot.js"></script>
    <script src="main.js"></script>
    <script src="test.js"></script>
  </body>
</html>
```

`main.js`

```javascript
function helloWorld() {
  return "Hello world!"
}

function byeWorld() {
  return "Bye world!"
}

function bigNumber(num) {
  return num + 1
}
```

`test.js`

```javascript
describe("Test Suite", () => {
  let hello = ""
  let bye = "Bye World :("
  let num = 0

  beforeAll(() => {
    num = 5
  })

  beforeEach(() => {
    hello = "Hello world!"
  })

  afterEach(() => {
    hello = ""
    console.log("Test Completed")
  })

  it("Says hello", () => {
    expect(helloWorld()).toEqual(hello)
  })

  it("Says bye", () => {
    expect(byeWorld()).toEqual(bye)
  })

  it("Returns a bigger number", () => {
    expect(bigNumber(num)).toBeGreaterThan(num)
  })
})
```

# Karma

## What and Why

### What

- Test Runner for Jasmine in Angular
- Automated running of tests
- Does not require us to modify our code
- Can test on multiple browser instances at once

  **Testing Angular Components**

  -`ng generate component <component>` will output:

  - `component.html`
  - `component.css`
  - `component.ts`
  - `component.spec.ts`

- Test against an instance of a component
- Using the Angular Test Bed

## Angular Test Bed

- Test behaviour that depends on Angular framework
- Test Change and Property Binding
- Import the `TestBed`, `ComponentFixture` and Component to be tested

```typescript
import { TestBed, async } from "@angular/core/testing"
import { AppComponent } from "./app.component"
```

- Configure the Test Bed's Testing Module with the necerssary components and imports in the beforeEach
- Reinstantiate the component before each test

  ```typescript
  describe('AppComponent', () => {
  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [
        AppComponent
      ],
    }).compileComponents();
  }));
  ...
  });
  ```

- Create a fixture and Component Instance

  - wrapper for a Component and Template

    ```typescript
    const fixture = TestBed.createComponent(AppComponent)
    const app = fixture.debugElement.componentInstance
    ```

- If a component has injected dependencies we can get these instances by:

  ```typescript
  const service = TestBed.get(ServiceName)
  ```

## Looking at the App Component

`app.component.html`

```html
<div style="text-align:center">
  <h1>
    Welcome to {{ title }}!
  </h1>
</div>
<h2>Here are some links to help you start:</h2>
<ul>
  <li>
    <h2><a target="_blank" rel="noopener" href="...">Tour of Heroes</a></h2>
  </li>
  <li>
    <h2><a target="_blank" rel="noopener" href="...">CLI Documentation</a></h2>
  </li>
  <li>
    <h2><a target="_blank" rel="noopener" href="...">Angular blog</a></h2>
  </li>
</ul>
```

`app.component.ts`

```typescript
import { Component } from "@angular/core"

@Component({
  selector: "app-root",
  templateUrl: "./app.component.html",
  styleUrls: ["./app.component.css"],
})
export class AppComponent {
  title = "app"
}
```

`app.component.spec.ts`

```typescript
import { TestBed, async } from "@angular/core/testing"
import { AppComponent } from "./app.component"
describe("AppComponent", () => {
  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [AppComponent],
    }).compileComponents()
  }))
  it("should create the app", async(() => {
    const fixture = TestBed.createComponent(AppComponent)
    const app = fixture.debugElement.componentInstance
    expect(app).toBeTruthy()
  }))
  it(`should have as title 'app'`, async(() => {
    const fixture = TestBed.createComponent(AppComponent)
    const app = fixture.debugElement.componentInstance
    expect(app.title).toEqual("app")
  }))
  it("should render title in a h1 tag", async(() => {
    const fixture = TestBed.createComponent(AppComponent)
    fixture.detectChanges()
    const compiled = fixture.debugElement.nativeElement
    expect(compiled.querySelector("h1").textContent).toContain(
      "Welcome to app!"
    )
  }))
})
```

## Running tests with the AngularCLI

- `ng test`
- Other Angular features can also be tested
  - Services
  - Components
  - Classes
  - Forms
  - Routing
  - Dependency Injection
  - etc.

# Karma Demo

# Conclusion

- Jasmine is a relatively simple testing tool
  - Easy to implement on a variety of projects
- Karma Automates testing
  - Test on multiple places simultaneously
  - Well incorporated into Angular
