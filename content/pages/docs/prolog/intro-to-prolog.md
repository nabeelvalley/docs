# Introduction to Prolog

[Notes from Derek Banas' Youtube](https://www.youtube.com/watch?v=SykxWpFwMGs)

[Cheatsheet](http://www.newthinktank.com/2015/08/learn-prolog-one-video/)

Prolog consists of a collection of facts and rules that can be queried

These rules are stored in a Database or Knowledgebase file

## Installation

You can install Prolog using Chocolatey with

```
choco install swi-prolog
```

You can then open Prolog terminal which will be in your Start Menu, or you can look for the installation directory and add that to your path (preferred)

In my case the installation is here:

```
C:\Program Files\swipl\bin
```

You should then be able to run the `swipl` command from your terminal to start that up

You can close it with the `halt.` command

## Hello Worlding

You can hello-world with the following in the swipl terminal

```pl
write('Hello World').
```

Or multiple lines with:

```pl
write('Hello World'), nl,
write('Bye World').
```

Note that statements end with a `.`

## Creating a Knowledgebase

Facts and rules are stored in a `.pl` file, in our case we use `db.pl`

You can define a fact which consists of a `predicate` and `atoms`/`arguments`, these start with lowercase letters

A fact can be defined with something like:

```pl
loves(romeo, juliet).
```

A rule can be defined, for example `juliet loves romeo` if `romeo loves juliet`

```pl
loves(juliet, romeo) :- loves(romeo, juliet).
```

A database file can be loaded with the name of the file in `[]` as follows:

```
[db].
```

A variable is something that allows us to answer questions, these start with capital letters

```pl
loves(romeo, X).
```

Will return:

```
X = juliet
```

We can define some additional facts with the following code:

```pl
male(john).
male(jeff).
male(bob).

female(sally).
female(jenny).
female(amy).
```

You can view a listing of facts with the following command

```pl
listing.
```

Or all facts of a specific kind such as

```pl
listing(male).
```

You can view all the combinations of facts with

```pl
male(X), female(Y).
```

You can type `;` to move to the next element

Rules are used to state that a fact depends on another fact, the `:-` is like saying `if`

Example, albert runs if happy

```pl
runs(albert) :-
    happy(albert).
```

We can also have multiple conditions separated by a `,` (and)

```pl
dances(alice) :-
    happy(alice),
    with_albert(alice).
```

We can define `or` with making use of diffeent rules, such as:

```pl
dances(alice) :-
    happy(alice).

dances(alice) :-
    with_albert(alice).
```
