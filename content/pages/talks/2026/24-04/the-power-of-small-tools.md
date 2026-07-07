---
title: '* > +'
description: the multiplicative power of small tools
---

> Run this presentation using:

```sh
http get https://raw.githubusercontent.com/nabeelvalley/docs/refs/heads/master/src/content/talks/2026/24-04/the-power-of-small-tools.md
  | sed '1,/^--- presenterm-start/d'
  | str trim
  | save presentation.md --force

cat presentation.md
  | split row "---"
  | str trim | parse --regex '`(?<path>.+)`\n\n```(?<lang>\w+)\n(?<content>(.|\n)+)```'
  | each {|i| echo $i.content | save $i.path --force}

presenterm presentation.md
```

--- presenterm-start

---
options:
  end_slide_shorthand: true
---


# * > +, Or, the Multiplicative Power of Small Tools

> A mindset for working more efficiently

---

# Agenda

- [Ideas First](#ideas-first)
- [A (less-technical) Unix Philosophy](#a-less-technical-unix-philosophy)
- [Identify Accidental Complexity](#identify-accidental-complexity)
- [How Do We Get Faster?](#how-do-we-get-faster)
- [Let's Write Some Code](#let-s-write-some-code)
- [More Ideas](#more-ideas)

---

## Ideas First

The first bit of this is all a bit abstract

> Try to be open to the ideas without thinking too much about application right now, we'll get to that later

---

## A (less-technical) Unix Philosophy

> An emergent set of principles within the Unix ecosystem[^1] with a personal spin

Technology should:

1. Do one thing. Do it well.
2. Work well together
3. Fail early and allow for iteratation
4. Allow for disposability

--- 

## Identify Accidental Complexity

> Opportunities to work more effectively

1. The work around your work
2. Things that you do frequently
3. Things that are slow
4. Things that don't play well together

---

### It's a Numbers Game

- A little faster each day adds up pretty quick
- Composition helps small solutions solve big problems really quickly

---

## How Do We Get Faster?

> The terminal, unfortunately

Shell commands are:

- Fast
- Repeatable
- Composable

UI's are generally none of these things

---

## Let's Write Some Code

> We have a weekly team presentation we want to assign a section to each team member

---

### Some Scripts to Do the Things

> We'll make small generalized tools instead of one big one

---

### Composing the Tools

> Do the entire workflow at once

```sh
cat presentation.md
| node extract-headings.js
| node assign-team.js
| node create-tasks.js "My Task Prefix"
```

---

### Greater than the Sum of Their Parts

> Small tools can be composed in more complex ways

Can you assign these tasks on the fly?

1. Buy bread
2. Go to the farmer's market
3. Reply to emails
4. Drop PROD database

> Tip: If you're using [helix](https://github.com/helix-editor/helix), this is `:| node assign-team.js`

---

## More Ideas

---

### Composition with Nushell

> Create all the files listed in this presentation

```sh
 cat presentation.md
  | split row "---"
  | str trim | parse --regex '`(?<path>.+)`\n\n```(?<lang>\w+)\n(?<content>(.|\n)+)```'
  | each {|i| echo $i.content | save $i.path --force}
```

---

### JS Implementations

---

`extract-headings.js`

```js
import { readFileSync } from 'fs';

readFileSync(0, 'utf-8').split('\n')
  .filter(l => l.startsWith('## '))
  .forEach(l => console.log(l.slice(3)))
```

---

`assign-team.js`

```js
import { execSync } from 'child_process';
import { readFileSync } from 'fs';

const members = [
  'Alice',
  'Bob',
  'Charles'
]

readFileSync(0, 'utf-8')
  .trim()
  .split('\n')
  .forEach((t, i) => console.log(`${t}:${members[i%members.length]}`))
```

---

`create-tasks.js`

```js
import { execSync } from 'child_process';
import { readFileSync } from 'fs';

if (process.argv.length < 3) {
  throw new Error("Prefix must be provided")
}

const prefix = process.argv[process.argv.length - 1]

// this could be the Azure Devops CLI or GitHub CLI or anything really
const createTask = (task, assignee) => console.log(
  execSync(`gh issue create --body "${prefix}" --title "${prefix}: ${task}" --label "${assignee}" --label Presentation`).toString().trim()
)

readFileSync(0, 'utf-8')
  .trim()
  .split('\n')
  .forEach(t => createTask(...t.split(':')))
```

---

### Alternative Implementations

---

`tools.nu`

```nu
let members = [Alice, Bob, Charles];

let prefix = "My task title"

def "extract-headings" [] {
  $in | grep -e '^## ' | cut -c 4- | lines
}

def "assign-tasks" [] {
  $in | enumerate | each {|i|
    let assignee = $members | get ($i.index mod 3)

    ({
      title: $i.item,
      assignee: $assignee, 
    })
  }
}

def "create-task" [] {
  print "Enter task prefix:"
  let prefix = (input)

  $in
  | par-each { gh issue create --title $"($prefix) - ($in.title)" --body $prefix --label $in.assignee --label Presentation }

}
```

---

`assign-team.cs`

```js
string[] team = {"Alice", "Bob", "Charles"};

string? line = null;
int count = 0;

while((line = Console.In.ReadLine()) != null) 
{
	var assigned = team[count % team.Length];
	Console.WriteLine($"{line}:{assigned}");
	count ++;
}
```

---

`extract-headings.cs`

```js
string? line = null;
while((line = Console.In.ReadLine()) != null) 
{
	if (line.StartsWith("## ")) {
		Console.WriteLine(line.Substring(3));
	}
}
```

---

## Additional Resources

- [My uses page](/uses) 
- [Nushell](https://www.nushell.sh/)

---

## Footnotes

[^1]: [Wikipedia - Unix Philosophy](https://en.wikipedia.org/wiki/Unix_philosophy)
[^2]: [Steph Ango - File over app](https://stephango.com/file-over-app)