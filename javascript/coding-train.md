> Notes from [The Coding Train YouTube Channel](https://www.youtube.com/channel/UCvjgXvBlbQiydffZU7m1_aw)

# Intelligence and Learning

> From the [Intelligence and Learning Series](https://www.youtube.com/watch?v=Vc5fIuYk3Bw&list=PLRqwX-V7Uu6bePNiZLnglXUp2LXIjlCdb)

## Algorithms and Graphs

A Graph system is made up of two systems:

- Nodes
- Edges

### Binary Search Tree

A Binary Tree is a data structure that makes use of a node-based structure in which each node has only two connections in which the data is sorted in some way

When visiting nodes we do the following:

1. Go to the left as far as possible
2. Take node
3. Go up one
4. Go to the right node, if can't go to anohter new node take node
5. Start from 1 again

Doing this will result in us retrieving a sorted node list

Searching through a structure like this is much faster than searching a single linear array for an element due to the rules by which the tree is sorted

### Define Tree and Nodes

We can program a Binary Tree structure which makes use of the `add` function on a `Node` or the `Tree` to add a new node to the tree, while recursively finding the correct place in the tree to add the node:

```js
let tree

function setup() {
  noCanvas()

  tree = new Tree()

  tree.add(5)
  tree.add(12)
  tree.add(4)
  tree.add(1)

  console.log(tree)
}

class Tree {
  constructor() {
    this.root = null
  }

  add(val) {
    const node = new Node(val)

    // if tree is null assign current node as root
    if (this.root === null) {
      this.root = node
    } else {
      // otherwise append node to existing node
      this.root.add(node)
    }
  }
}

class Node {
  constructor(val) {
    this.value = val
    this.left = null
    this.right = null
  }

  add(node) {
    // check the value is less than the current node
    if (node.value < this.value) {
      // if the left node is null then assign
      if (this.left === null) this.left = node
      // otherwise we call the add function on the existing node
      else this.left.add(node)
    } else if (node.value > this.value) {
      // do the same for he right as we did for the left
      if (this.right === null) this.right = node
      else this.right.add(node)
    }
  }
}
```

### Traverse Tree

We can also create a function that allows us to retrieve all the values from the different nodes defined on the `Node` which will again recursively visit all children on the Node:

```js
visit() {
  if (this.left !== null) {
    this.left.visit()
  }

  console.log(this.value)

  if (this.right !== null) {
    this.right.visit()
  }
}
```

We can then add a function called `traverse` on the tree which will just call the `visit` function on the root node:

```js
traverse(){
  if (this.root !== null) {
    this.root.visit()
  }
}
```

### Search Tree

Next, we can define a function `search` on the node which allows us to search a node as well as its children for a specific value as well as print out the current node when found:

```js
search(val) {
  // if the current node is the one we're looking for then return
  if (this.value === val){
    return this

  // else check the left node if smaller than current
  } else if (this.left !== null && this.value > val) {
    return this.left.search(val)

  // else check the right node
  } else if (this.right !== null && this.value < val) {
    return this.right.search(val)
  } else {
    return null
  }
}
```

And then the search function on the tree as a proxy:

```js
search(val) {
  if (this.root !== null) {
    return this.root.search(val)        
  }
}
```

### Visualize Tree

We can visualize the tree (poorly) using something like the following:

```js
let tree

function setup() {
  createCanvas(700, 450)
  background(50)

  tree = new Tree()

  for (let i = 0; i < 20; i++) {
    tree.add(Math.floor(random(-100, 100)))
  }

  tree.traverse()
}

class Tree {
  constructor() {
    this.root = null
  }

  add(val) {
    const node = new Node(val)

    // if tree is null assign current node as root
    if (this.root === null) {
      this.root = node
      this.root.x = width / 2
      this.root.y = 24
    } else {
      // otherwise append node to existing node
      this.root.add(node)
    }
  }

  traverse() {
    if (this.root !== null) {
      this.root.visit(this.root)
    }
  }

  search(val) {
    if (this.root !== null) {
      return this.root.search(val)
    }
  }
}

class Node {
  constructor(val) {
    this.value = val
    this.left = null
    this.right = null
  }

  add(node) {
    // check the value is less than the current node
    if (node.value < this.value) {
      // if the left node is null then assign
      if (this.left === null) {
        this.left = node
        this.left.x = this.x - 35 + random(1, 20)
        this.left.y = this.y + 35 + random(1, 20)
      }
      // otherwise we call the add function on the existing node
      else this.left.add(node)
    } else if (node.value > this.value) {
      // do the same for the right as we did for the left
      if (this.right === null) {
        this.right = node
        this.right.x = this.x + 35 + random(1, 20)
        this.right.y = this.y + 35 + random(1, 20)
      } else this.right.add(node)
    }
  }

  visit(parent) {
    stroke("red")
    strokeWeight(1)
    line(parent.x, parent.y, this.x, this.y)

    strokeWeight(0)
    
    ellipse(this.x, this.y, 25)
    
    textAlign("CENTER")
    text(this.value, this.x -6 , this.y + 5)

    if (this.left !== null) {
      this.left.visit(this)
    }

    console.log(this.value)

    if (this.right !== null) {
      this.right.visit(this)
    }
  }

  search(val) {
    // if the current node is the one we're looking for then return
    if (this.value === val) {
      return this

      // else check the left node if smaller than current
    } else if (this.left !== null && this.value > val) {
      return this.left.search(val)

      // else check the right node
    } else if (this.right !== null && this.value < val) {
      return this.right.search(val)
    } else {
      return null
    }
  }
}
```

## Breadth-First Search

This is a search algorithm for looking at the nearest node from the start node first and helps us traverse a tree in order to find the shortest number of steps to a specific node

