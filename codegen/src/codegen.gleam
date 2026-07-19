import gleam/http/request
import gleam/httpc
import gleam/list
import gleam/regexp
import gleam/result
import gleam/set
import gleam/string
import presentable_soup as soup
import simplifile

const elements_out_file = "../src/shoki/html.gleam"

const elements_header = "// This file is generated. Do not edit by hand

//// Element creation functions scraped from https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements
//// This list automatically excludes any elements or attributes that are deprecated

import shoki/element
"

const attribute_out_file = "../src/shoki/attr.gleam"

const attributes_header = "// This file is generated. Do not edit by hand

//// Element creation functions scraped from https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes
//// This list automatically excludes any elements or attributes that are deprecated

import shoki/element
"

type Scraped {
  Scraped(name: String, doc: String)
}

fn func(el: Scraped, args: fn(String) -> String, impl: fn(String) -> String) {
  let assert Ok(re) = regexp.from_string("\\s+")

  let name =
    el.name
    |> string.remove_prefix("<")
    |> string.remove_suffix(">")

  // santize function names
  let func_name =
    case name {
      "type" -> "type_"
      "as" -> "as_"
      _ -> name
    }
    |> string.replace(each: "-", with: "_")

  // ignore generic tags
  case string.contains(name, "*") {
    True -> ""
    False -> {
      let doc = el.doc |> regexp.replace(re, _, " ") |> string.trim
      let doc = case doc {
        "" -> ""
        _ -> "/// " <> doc <> "\n"
      }

      doc
      <> "pub fn "
      <> func_name
      <> "("
      <> args(name)
      <> ") { "
      <> impl(name)
      <> " }"
    }
  }
}

/// List of void elements: https://developer.mozilla.org/en-US/docs/Glossary/Void_element
fn void_tags() {
  [
    "area",
    "base",
    "br",
    "col",
    "embed",
    "hr",
    "img",
    "input",
    "link",
    "meta",
    "param ",
    "source",
    "track",
    "wbr",
  ]
  |> set.from_list
}

fn scrape_els() {
  let assert Ok(req) =
    request.to(
      "https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements",
    )

  let assert Ok(resp) = httpc.send(req)

  // It would be nice to extract the docs from this content as well
  let row =
    soup.elements([soup.with_tag("table")])
    |> soup.descendants([soup.with_tag("tr")])

  let deprecated_rows =
    soup.elements([
      soup.with_aria("labelledby", "obsolete_and_deprecated_elements"),
    ])
    |> soup.descendants([soup.with_tag("tr")])

  let desc =
    soup.elements([soup.with_tag("td")])
    |> soup.return(soup.text_content())

  let doc = {
    use matched <- soup.map(desc)

    case matched {
      [els, desc] ->
        els
        |> list.filter(string.contains(_, "<"))
        |> list.map(Scraped(_, desc |> string.join(" ")))
        |> Ok
      [els] -> els |> list.map(Scraped(_, "")) |> Ok
      _ -> Error(matched |> list.map(string.join(_, ";")) |> string.join(";"))
    }
  }

  let assert Ok(all) =
    row
    |> soup.return(doc)
    |> soup.scrape(resp.body)
    |> result.map(list.flatten)

  let assert Ok(deprecated) =
    deprecated_rows
    |> soup.return(doc)
    |> soup.scrape(resp.body)
    |> result.map(list.flatten)

  let deprecated_els =
    deprecated |> result.values |> list.flatten |> set.from_list

  all
  |> result.values
  |> list.flatten
  |> set.from_list
  |> set.difference(deprecated_els)
  |> set.to_list
  |> list.map(
    func(
      _,
      fn(name) {
        let is_void = void_tags() |> set.contains(name)
        case is_void {
          True -> "attrs"
          False -> "attrs, children"
        }
      },
      fn(name) {
        let is_void = void_tags() |> set.contains(name)

        case is_void {
          True -> "element.element(\"" <> name <> "\", attrs, [])"
          False -> "element.element(\"" <> name <> "\", attrs, children)"
        }
      },
    ),
  )
  |> string.join("\n\n")
  |> string.append(elements_header, _)
}

fn scrape_attrs() {
  let assert Ok(req) =
    request.to(
      "https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes",
    )

  let assert Ok(resp) = httpc.send(req)

  // It would be nice to extract the docs from this content as well
  let row =
    soup.elements([soup.with_tag("table")])
    |> soup.descendants([soup.with_tag("tr")])

  let desc =
    soup.elements([soup.with_tag("td")])
    |> soup.return(soup.text_content())

  let doc = {
    use matched <- soup.map(desc)

    case matched {
      [el, _, desc] -> {
        let name = el |> string.join("") |> string.trim
        Scraped(name, desc |> string.join(" "))
        |> Ok
      }
      _ -> Error(matched |> list.map(string.join(_, " ")) |> string.join(" "))
    }
  }

  let assert Ok(all) =
    row
    |> soup.return(doc)
    |> soup.scrape(resp.body)
    |> result.map(list.flatten)

  all
  |> result.values
  |> list.map(
    func(_, fn(_) { "value" }, fn(name) {
      "element.attribute(\"" <> name <> "\", value" <> ")"
    }),
  )
  |> string.join("\n\n")
  |> string.append(attributes_header, _)
}

pub fn main() {
  let elements = scrape_els()

  let attributes = scrape_attrs()

  let assert Ok(_) = simplifile.write(elements_out_file, elements)
  let assert Ok(_) = simplifile.write(attribute_out_file, attributes)

  Nil
}
