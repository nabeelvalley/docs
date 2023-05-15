```ts
const bobs = ["bob", "Bob", "BOB", "boB"] as const;

type Bob = typeof bobs[number];

const isBobKindOf = (thing: string): boolean => bobs.includes(thing as Bob);

const isBob = (thing: string): thing is Bob => bobs.includes(thing as Bob);

const people = ["bob", "smith", "boB", "smITH"];

const bobPeople = people.filter(isBobKindOf);
const bobPeople2 = people.filter(isBob);

const isKindOfFirstBob = people.find(isBobKindOf);
const firstBob = people.find(isBob);


const first = people[0];

if (isBob(first)) {
  console.log(first)
} else {
  console.log(first, 'not bob')
}
```