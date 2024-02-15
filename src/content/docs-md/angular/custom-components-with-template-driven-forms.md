---
published: true
title: Custom form controls in Template Driven Forms
description: Using template driven forms to more easily manage state and validation of form data
---

# Problem

Given the below form I am able to manage the data and validation state of my component automatically as driven by the underlying Angular and HTML implementation

```ts
import { CommonModule } from '@angular/common';
import { Component } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { SampleInput } from './sample-input';

@Component({
  standalone: true,
  selector: 'example-form',
  imports: [CommonModule, FormsModule, SampleInput],
  template: `
    <form #form="ngForm">
      <h1>Example form</h1>

      <sample-form-input
        [required]="true"
        [(ngModel)]="data['isActive']"
        name="Name"
        label="This is a name input"
      />

      <div>
        <button type="submit" [disabled]="!form.form.valid">
          Is Form Valid: {{ form.form.valid }}
        </button>
      </div>
    </form>
    <pre>{{
      {
        data: data,
        value: form.form.value,
        status: form.status
      } | json
    }}</pre>
  `,
})
export class ExampleFormComponent {
  data: Record<string, any> = {};
}
```

However, as soon as I move my `input` into a different component I am usually forced to do lots of weird things that steer me further away from a more simplified HTML-directed form. For the sake of simplicity and maintainability however I would like to be able to define a component that is able to take advantage of the Angular/HTML form integration while also providing me with the benefits of a component-based form input

# Implementing a ControlValueAccessor

In order to do this, I can move the input into a new component provided that the component implements the `ControlValueAccessor` interface and the `Validation` interface if I would also like to use Angular Validation with my component

The basic implementation of a component that meets this requirement can be seen below:

```ts
import { Component, forwardRef } from '@angular/core';
import {
  AbstractControl,
  ControlValueAccessor,
  FormsModule,
  NG_VALIDATORS,
  NG_VALUE_ACCESSOR,
  ValidationErrors,
  Validator,
  Validators,
} from '@angular/forms';

@Component({
  standalone: true,
  selector: 'sample-form-input',
  imports: [FormsModule],
  providers: [
    {
        // Tell Angular that we can handle the value management by way of NgModel
      provide: NG_VALUE_ACCESSOR,
      useExisting: forwardRef(() => SampleInput),
      multi: true,
    },
    {
        // Tell angular that we also want to enable validation on our component
      provide: NG_VALIDATORS,
      useExisting: forwardRef(() => SampleInput),
      multi: true,
    },
  ],
  template: `
    <!-- Below is an example implementation that meets the UI requirements for
         the form to be template-driven -->

    <input
      class="block"
      type="text"
      [ngModel]="value"
      (ngModelChange)="onChange($event)"
      [disabled]="disabled"
    />
  `,
})
export class SampleInput implements ControlValueAccessor, Validator {
  value?: any;
  disabled: boolean = false;
  focused: boolean = false;

  onChange: any = () => {};
  onTouched: any = () => {};

  writeValue(value: any): void {
    this.value = value;
  }

  registerOnChange(fn: any): void {
    this.onChange = fn;
  }

  registerOnTouched(fn: any): void {
    this.onTouched = fn;
  }

  setDisabledState(isDisabled: boolean): void {
    this.disabled = isDisabled;
  }

  onBlur(): void {
    this.focused = false;
  }

  onFocus(): void {
    this.focused = true;
  }

  getValidator() {
    return Validators.maxLength(10);
  }

  validate(control: AbstractControl<any, any>): ValidationErrors | null {
    const validator = this.getValidator?.();
    if (!validator) {
      return null;
    }

    return validator(control);
  }
}
```

Now that we have this component, we can simply swap out the use of `input` to use our new component in our example form:

```ts
// rest of component
template: `
    <form #form="ngForm">
      <h1>Example form</h1>

      <sample-form-input
        [required]="true"
        [(ngModel)]="data['isActive']"
        name="Name"
        label="This is a name input"
      />

<-- rest of template -->
`
// rest of component
```

The above provides a basis for any input component we want. It is also possible to define the above as a base class that can then be extended by other components to provide a more specific implementation such as working with a generic `value` to be a bit more type safe or to allow more specific variations or any additional styling to be contained to a specific component
