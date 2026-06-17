---
title: Quick and Dirty Object Access in Go
subtitle: 27 March 2026
published: true
---

> Assumed audience: Developers/technical people who use Go as a programming language

This probably isn't too difficult to write but it's recursive and I had fun putting it together so here it is

Basically, I was trying to access a deeply nested object that was parsed from [BurntSushi/toml](https://pkg.go.dev/github.com/BurntSushi/toml) in some generic fashion and it was getting annoying to constantly cast things and do the necessary checks at every level so I made two utilities that can access nested data a bit more conveniently

First off, here's a helper type to sprinkle around:

```go
type dynamic = map[string]any
```

Then, here's the version that will panic if it hits something it's not expecting:

```go
func unsafeIndex(data dynamic, path ...string) any {
	if len(path) == 0 {
		return data
	}

	inner := data[path[0]]
	if len(path) == 1 {
		return inner
	}

	return unsafeIndex(inner.(dynamic), path[1:]...)
}
```

And the version that returns the appropriate errors along the way:

```go
func safeIndex(data dynamic, path ...string) (any, error) {
	if len(path) == 0 {
		return data, nil
	}

	inner, ok := data[path[0]]
	if !ok {
		return data, fmt.Errorf("Error indexing path %v for %v", path, data)
	}

	if len(path) == 1 {
		return inner, nil
	}

	dyn, ok := inner.(dynamic)
	if !ok {
		return dyn, fmt.Errorf("Error indexing into inner struct %v for %v", path, inner)
	}

	return safeIndex(dyn, path[1:]...)
}
```

Using them is also fairly normal, as seen below:

```go
// whatever you're doing to decode the data. e.g. JSON/TOML parser
var output dynamic
decodeData(FILE_CONTENT, &output)

dynamicSources, err := safeIndex(output, "some", "deeply", "nested", "property")
if err != nil {
    panic(err)
}
```