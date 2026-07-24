import birdie
import jot
import js/marked
import lustre/element
import lustre/element/html
import maud
import maud/components
import mork
import mork/to_lustre

const content = "
## Welcome!

This is some content in Markdown that can be rendered to your site

Here's a code block and some other _fancy_ formatting

<my-custom-tag data='hello world'>

<blockquote>

## Nested Heading

```gleam
code |> print_me |> echo
```

</blockquote>


</my-custom-tag>
"

pub fn mork_test() {
  content
  |> mork.parse
  |> to_lustre.to_lustre
  |> html.main([], _)
  |> element.to_readable_string
  |> birdie.snap("mork to lustre")
}

pub fn maud_test() {
  content
  |> maud.render_markdown(mork.configure(), components.default())
  |> html.main([], _)
  |> element.to_readable_string
  |> birdie.snap("maud to lustre")
}

pub fn jot_test() {
  content
  |> jot.to_html
  |> birdie.snap("jot to html")
}

pub fn marked_test() {
  content
  |> marked.parse
  |> birdie.snap("marked to html")
}
