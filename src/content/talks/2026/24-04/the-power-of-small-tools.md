---
title: "* > +"
subtitle: 24 April 2026
description: the multiplicative power of small tools
published: false
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
- [Practically Speaking](#practically-speaking)
- [Identify Accidental Complexity](#identify-accidental-complexity)
- [The Terminal](#the-terminal)
- [Let's Write Some Code](#let-s-write-code)
- [More Ideas](#more-ideas)

---

## Ideas First

The first bit of this is all a bit abstract

> Try to be open and onto the ideas without questioning them too right now, we'll get to that later

---

## A (less-technical) Unix Philosophy

An emergent set of principles within the Unix ecosystem[^1]

According to it, programs should:

1. Do one thing. Do it well
2. Work well together
3. Fail early and allow for iteration
4. Be small, disposable, and substitute unskilled labor

---

### 1. Do One Thing. Do It Well.

> They do something without using the word "and"

- Small tools
- Something that's good at one thing is better than something that's terrible at many things
- We should be able to write them quickly
- Pragmatically, there is a concept of "complete"

---

### 2. Work Well Together

> Composition unlocks productivity

- Open standards
- Shared input and output
- "File over app"[^2]

---

### 3. Fail Early and Iterate

- Design solutions to be used quickly
- Learn from your mistakes
- Don't over-engineer solutions
- It's okay to throw things away

---

### 4. Disposable Software

- Avoid repetitive work at all costs
- Write code, throw it away when you're done
- You will save more time in the long terms

--- 

## Practically Speaking

> How can I make my work more efficient?

---

## Identify Accidental Complexity

- Things that aren't the work you're trying to do
- Things that you do often that can be automated
- Things that are slow
- Things that aren't compatible with other things

---

### The Work Around Your Work

- Finding documentation
- Managing your task board

---

### Things That You Do Frequently

- Writing documentation
- Keeping dependencies up to date
- Creating git branches with a specific format

---

### Things That Are Slow

- Code reviews?
- Email responses?
- Azure DevOps probably?
- Your IDE probably lol
- Like this really gets so specific to you

---

### Things That Don't Play Well Together

- Proprietary applications
- Proprietary formats
- User interfaces in general

---

### It's a Numbers Game

- Small solutions can be stitched together to solve big problems

---

## The Terminal

> It is a means, not an end

Shell commands are:

- Fast
- Repeatable
- Composable

UI's are generally none of these things

---

### 1. Fast

> If your problems are small enough, the solutions become trivial

- You can probably write some code to solve this quickly
- Someone else has probably written some code to solve this quickly
- They're straight up faster than a UI based equivalent

---

### 2. Repeatable

- You only pay the cost of doing it the first time
- If you've done it once, it's a few up-arrow-clicks to do it again
- Code makes fewer mistakes

---

### 3. Composable

> In your shell, this is just a pipe (`|`)

- Small tools are greater than the sum of their parts
- Big tools can't anticipate every possible use case

---

## Let's Write Some Code

---

### Example

> We have a weekly team presentation we want to assign a section to each team member

---

#### Some Scripts to Do the Things

> We'll make small generalized tools instead of one big one

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

1. By bread
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
