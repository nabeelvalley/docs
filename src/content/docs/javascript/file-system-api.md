The `FileSystemApi` is a browser API that allows us to read and write to files and folders using JavaScript

A simple example of listing the files in a folder can be seen below:

```js
let dir
let entries = []

document.getElementById('open').addEventListener('click', async () => {
  dir = await window.showDirectoryPicker()

  for await (const entry of dir.values()) {
    entries.push(entry)
  }
})
```

Once you've got the directory entries in the `entries` array, you can do a bunch of other stuff, like read the file contents

Values from the `dir.values()` method will have either a `kind` of `file` or `directory`. Each of which will evaluate to a `FileSystemFileHandle` or a `FileSystemDirectoryHandle` respectively

We can read the contents of a file in the directory like so:

```js
const fileHandle = entries[5]

const file = await fileHandle.getFile()

const text = await file.text()
```
