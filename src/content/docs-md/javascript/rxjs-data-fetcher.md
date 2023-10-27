---
published: true
title: useSWR-esque data fetching with RxJS
description: A class that can be used for dynamic data fetching and status tracking using RxJS
---

# Coming from React

In the react-world something I've really enjoyed using is the [SWR](https://swr.vercel.app/) library for fetching data which allows consolidation of data into a hook that can be used to track error and loading states as well as keep the data accessible at all times for consuming components

# Implementing this with RxJS

In RxJS we work with data as a stream, when fetching data we often have a resulting stream that will emit a value once the data has been fetched. The problem with this methodology is that we only have the resultant data but errors and loading states are not easily surfaced to consumers of this data unless they hook into the entire lifecycle for the momment the stream is created

Below is an implementation of a class that enables the definition and management of multiple streams that consumers can access for resolving the respective states for a given request. Furthermore, requests are triggered by params observable such that each emission of the observable will trigger the fetcher. Hence, this can be used for loading data but also for working with forms where each submission is a `.next` to the `params` stream

```ts
import { BehaviorSubject, Observable, throwError } from "rxjs";
import { catchError, debounceTime, filter, map } from "rxjs/operators";

/**
 * Creates a data fetcher class that can maintain state for managing loading and error states
 */
export class Fetcher<TParams, TData> {
  public readonly state$ = new BehaviorSubject<LoaderState<TData>>(initial);

  /**
   * Data will remember previously resolved values while loading and in the event of an error
   */
  public readonly data$ = this.state$.pipe(
    filter(isDataState),
    map((state) => state.data)
  );

  public readonly error$ = this.state$.pipe(
    map((state) => state.state === "error")
  );

  public readonly loading$ = this.state$.pipe(
    map((state) => state.state === "loading")
  );

  /**
   * @param dependencies depednencies that will trigger the data to be loaded
   * @param fetcher function for loading data that should return a stream that
   * @param debounce time used to debounce requests from the dependency observable
   */
  constructor(
    private readonly params: Observable<TParams>,
    private readonly fetcher: (params: TParams) => Observable<TData>,
    debounce = 0
  ) {
    this.dependencies.pipe(debounceTime(debounce)).subscribe(this.fetchData);
  }

  private fetchData = (deps: TParams): void => {
    this.state$.next(loading);

    this.fetcher(deps)
      .pipe(
        catchError(() => {
          this.state$.next(error);
          return throwError(() => new Error("Error loading data"));
        })
      )
      .subscribe((data) =>
        this.state$.next({
          state: "data",
          data,
        })
      );
  };
}
```

Additionally, we can define some utilities for the above class to use:

```ts
// Implementation of a simple state machine for the different staes available in the data fetcher
type Status<TState extends string, TData = undefined> = {
  state: TState;
  data: TData;
};

type LoadingState = Status<"loading">;
type ErrorState = Status<"error">;
type InitialState = Status<"initial">;

type DataState<TData> = Status<"data", TData>;

type LoaderState<TData> =
  | DataState<TData>
  | InitialState
  | LoadingState
  | ErrorState;

// some constatns for working with the states more easily
const loading: LoadingState = {
  state: "loading",
  data: undefined,
};

const error: ErrorState = {
  state: "error",
  data: undefined,
};

const initial: InitialState = {
  state: "initial",
  data: undefined,
};

const isDataState = <TData>(
  state: LoaderState<TData>
): state is DataState<TData> => state.state === "data";

const getData = <TData>(state: LoaderState<TData>): TData | undefined =>
  isDataState(state) ? state.data : undefined;
```

# Using the Class

We can use the class we defined by creating an instance of it

```ts
import { from } from "rxjs";

const search$ = new BehaviourSubject<string>("");

const usersFetcher = new Fetcher(
  search$,
  (search: string) => from(fetch(`https://api.com?search=${search}`)),
  200
);

const users$ = usersFetcher.data$;
const isLoading$ = usersFetcher.loading$;
const hasError$ = usersFetcher.error$;
```

The `users$`, `isLoading$` and `hasError$` values above are streams that we can use with our normal RxJS code

Interacting with the data is also pretty neat now, for example we can trigger the data to be refreshed whenever someone updates the search in our UI by doing something like:

```ts
onSearchChange(event) {
  this.search$.next(event.target.value || '')
}
```

Which will then trigger the data to be refreshed and all the loading and error states to be updated accordingly