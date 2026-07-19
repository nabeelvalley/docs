import birdie
import gleam/dict
import shoki/element

const example_html = "
<h2>Welcome!</h2>
<p>This is some content in Markdown that can be rendered to your site</p>
<p>Here&#39;s a code block and some other <em>fancy</em> formatting</p>
<my-custom-tag data='hello world'>
  <blockquote>
    <h2>Nested Heading</h2>
    <pre><code class='language-gleam'>code |&gt; print_me |&gt; echo
      </code></pre>
  </blockquote>
</my-custom-tag>
<script type='module' src='my/script/src'></script>
<script>
  console.log('some stuff')
</script>
<style>
  .some-class {
    background-color: green;
  }
</style>
"

pub fn parse_html_test() {
  example_html
  |> element.parse_doc(dict.new())
  |> element.to_document_string
  |> birdie.snap("html to string")
}
