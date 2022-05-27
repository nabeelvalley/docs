[[toc]]

When working with the `FSharp.Data.JsonProvider` type provider you may encounter a need to serialize a `JsonValue array`

Let's take a look at an example where this may be necessary:

First, we'll define the type of our data using a type provider, in this case it's connected to the following:

`data/api-response.json`

```json
{
  "data": [
      {
          "id": "id",
          "caption": "caption",
          "media_type": "IMAGE",
          "media_url": "url_to_image"
      }
  ],
  "paging": {
      "cursors": {
          "before": "hash",
          "after": "hash"
      },
      "next": "full_request_url"
  }
}
```

And the F# file that's using this as the basis for the type definition is as follows:

```fs
open FSharp.Data

type ApiResponse = JsonProvider<"./data/api-response.json", SampleIsList=true>
```

We can also create some sample data using the `ApiResponse.Parse` method that's now defined on our type thanks to the JsonProvider


```fs
// get some sample data
let sampleData = ApiResponse.Parse("""{
  "data": [
      {
          "id": "id",
          "caption": "caption",
          "media_type": "IMAGE",
          "media_url": "url_to_image"
      }
  ],
  "paging": {
      "cursors": {
          "before": "hash",
          "after": "hash"
      },
      "next": "full_request_url"
  }
}""")
```

If you were to use the `sampleData` object and try to parse it to JSON you could directly call the `sampleData.JsonValue.ToString()` method. As designed, this immediately returns the JSON representation of the object

However, when we take a look at the `sampleData.Data` property, we will notice this is a `Datum array`, the problem here is that the `array` type doesn't have `JsonValue` property 

However, if we look at how `JsonValue` is defined we will see the following:

```fs
union JsonValue =
  | String of string
  | Number of decimal
  | Float of float
  | Record of properties : (string * JsonValue) array
  | Array of elements : JsonValue array
  | Boolean of bool
  | Null
```

Based on this, we can see that an `Array of elements` can be seen as a `JsonValue array`, using this information, we can make use of the `JsonValue.Array` constructor and the `JsonValue` property of each of the elements of the `Data` property to convert the `JsonValue array` to a `JsonValue`

```fs
let jsonValue =
    // get the property we want
    sampleData.Data 
    // extract the JsonValue property from each element
    |> Array.map (fun p -> p.JsonValue)
    // pass into the JsonValue.Array constructor
    |> JsonValue.Array

let json = jsonValue.ToString()
```