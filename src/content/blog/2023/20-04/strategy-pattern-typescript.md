```ts
interface Todo {
  id: number;
  name: string;
  done: boolean;
}

const todo: Todo = {
  done: false,
  id: 0,
  name: "task",
};

interface StorageStrategy {
  get(id: number): Todo;
  getAll(): Todo[];
  delete(id: number): void;
  save(todo: Todo): void;
}

type InitializerStrategy = (todo: Todo) => Todo;

class TodoDB {
  constructor(
    private readonly storage: StorageStrategy,
    private readonly intializer: InitializerStrategy
  ) {}

  getItems(): Todo[] {
    return this.storage.getAll();
  }

  getItem(id: number): Todo {
    return this.storage.get(id);
  }

  addItem(todo: Todo): void {
    const item = this.intializer(todo);
    this.storage.save(item);
  }

  removeItem(id: number): void {
    this.storage.delete(id);
  }

  updateItem(todo: Todo): Todo {
    this.storage.save(todo);
    return todo;
  }

  completeItem(id: number): Todo {
    const todo = this.storage.get(id);
    const updated = {
      ...todo,
      done: true,
    };
    this.storage.save(updated);
    return updated;
  }

  resetItem(id: number): Todo {
    const todo = this.storage.get(id);
    const updated = {
      ...todo,
      done: false,
    };
    this.storage.save(updated);
    return updated;
  }
}

class ListStorageStrategy implements StorageStrategy {
  private todos: Todo[] = [];

  getAll(): Todo[] {
    return this.todos;
  }

  get(id: number): Todo {
    const item = this.todos[id];
    if (!item) {
      throw new Error("Item not found");
    }

    return item;
  }
  save(todo: Todo): void {
    this.todos[todo.id] = todo;
  }

  delete(id: number): void {
    delete this.todos[id];
  }
}

class MapStorageStrategy implements StorageStrategy {
  private todos: Map<number, Todo> = new Map();

  getAll(): Todo[] {
    return Array.from(this.todos.entries()).map((el) => el[1]);
  }

  get(id: number): Todo {
    const item = this.todos.get(id);
    if (!item) {
      throw new Error("Item not found");
    }

    return item;
  }

  save(todo: Todo): void {
    this.todos.set(todo.id, todo);
  }

  delete(id: number): void {
    this.todos.delete(id);
  }
}

const alwaysIncompleteInitializer: InitializerStrategy = (todo) => ({
  ...todo,
  done: false,
});

const randomIdInitializer: InitializerStrategy = (todo) => ({
  ...todo,
  id: Math.random(),
});

const listTodos = new TodoDB(
  new ListStorageStrategy(),
  alwaysIncompleteInitializer
);

const mapTodos = new TodoDB(new MapStorageStrategy(), randomIdInitializer);

const item1: Todo = {
  done: false,
  id: 1,
  name: "thing",
};

const item2: Todo = {
  done: true,
  id: 2,
  name: "thing",
};

listTodos.addItem(item1);
mapTodos.addItem(item1);

listTodos.addItem(item2);
mapTodos.addItem(item2);

console.log(listTodos.getItems());
console.log(mapTodos.getItems());

console.log(listTodos);
console.log(mapTodos);

console.log(listTodos.getItem(1));
console.log(mapTodos.getItem(1));
```