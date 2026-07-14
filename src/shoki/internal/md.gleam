import gleam/dict
import gleam/list
import gleam/option.{None, Some}
import gleam/string
import lustre/attribute
import lustre/element
import lustre/element/html
import maud
import maud/components
import mork
import smalto
import smalto/languages/bash
import smalto/languages/c
import smalto/languages/cpp
import smalto/languages/csharp
import smalto/languages/css
import smalto/languages/dart
import smalto/languages/dockerfile
import smalto/languages/elixir
import smalto/languages/erlang
import smalto/languages/fsharp
import smalto/languages/gleam
import smalto/languages/go
import smalto/languages/haskell
import smalto/languages/html as smalto_html
import smalto/languages/java
import smalto/languages/javascript
import smalto/languages/json
import smalto/languages/kotlin
import smalto/languages/lua
import smalto/languages/markdown
import smalto/languages/nginx
import smalto/languages/php
import smalto/languages/python
import smalto/languages/razor
import smalto/languages/reactjsx
import smalto/languages/reacttsx
import smalto/languages/ruby
import smalto/languages/rust
import smalto/languages/scala
import smalto/languages/sql
import smalto/languages/swift
import smalto/languages/toml
import smalto/languages/typescript
import smalto/languages/xml
import smalto/languages/yaml
import smalto/languages/zig
import smalto/lustre as smalto_lustre

fn components() {
  components.default()
  |> components.code(fn(attrs, lang, children) {
    let attrs =
      attrs
      |> dict.map_values(fn(k, v) { attribute.attribute(k, v) })
      |> dict.values

    case lang {
      Some(l) -> {
        html.code(attrs, highlight(l, children))
      }
      None -> html.code(attrs, children)
    }
  })
}

pub fn parse_default(markdown: String) {
  markdown
  |> string.trim
  |> maud.render_markdown(mork.configure(), components())
}

/// Highlighting code adapted https://github.com/veeso/blogatto
fn highlight(lang, children) {
  let code = children |> list.map(element.to_string) |> string.join("")
  let grammar = languages() |> dict.get(lang)

  case grammar {
    Ok(g) -> {
      let tokens = smalto.to_tokens(code, g())
      smalto_lustre.to_lustre(tokens, smalto_lustre.default_config())
    }
    _ -> children
  }
}

fn languages() {
  dict.from_list([
    #("bash", bash.grammar),
    #("c", c.grammar),
    #("cpp", cpp.grammar),
    #("csharp", csharp.grammar),
    #("cs", csharp.grammar),
    #("cshtml", razor.grammar),
    #("css", css.grammar),
    #("dart", dart.grammar),
    #("dockerfile", dockerfile.grammar),
    #("elixir", elixir.grammar),
    #("erlang", erlang.grammar),
    #("fsharp", fsharp.grammar),
    #("fs", fsharp.grammar),
    #("fsx", fsharp.grammar),
    #("gleam", gleam.grammar),
    #("go", go.grammar),
    #("golang", go.grammar),
    #("haskell", haskell.grammar),
    #("hs", haskell.grammar),
    #("html", smalto_html.grammar),
    #("java", java.grammar),
    #("javascript", javascript.grammar),
    #("js", javascript.grammar),
    #("jsx", reactjsx.grammar),
    #("json", json.grammar),
    #("kotlin", kotlin.grammar),
    #("kt", kotlin.grammar),
    #("lua", lua.grammar),
    #("markdown", markdown.grammar),
    #("md", markdown.grammar),
    #("nginx", nginx.grammar),
    #("php", php.grammar),
    #("python", python.grammar),
    #("py", python.grammar),
    #("razor", razor.grammar),
    #("rb", ruby.grammar),
    #("ruby", ruby.grammar),
    #("rs", rust.grammar),
    #("rust", rust.grammar),
    #("scala", scala.grammar),
    #("sh", bash.grammar),
    #("shell", bash.grammar),
    #("sql", sql.grammar),
    #("swift", swift.grammar),
    #("toml", toml.grammar),
    #("ts", typescript.grammar),
    #("tsx", reacttsx.grammar),
    #("typescript", typescript.grammar),
    #("xml", xml.grammar),
    #("yaml", yaml.grammar),
    #("yml", yaml.grammar),
    #("zig", zig.grammar),
  ])
}
