import consts
import content/fs
import gleam/dict
import gleam/list
import gleam/result
import js/dom
import js/sharp
import lustre/attribute
import lustre/element
import lustre/element/html

type Image {
  Image(path: String)
}

pub fn render_all(html: String) -> String {
  use _, raw_attrs <- dom.update(html:, tag: "gallery")
  let attrs = dict.from_list(raw_attrs)

  {
    use path <- result.try(dict.get(attrs, "path"))

    let gallery_path = fs.join([consts.gallery_dir, path])

    use files <- result.try(
      fs.ls_dir(gallery_path) |> result.replace_error(Nil),
    )

    let images =
      files
      |> list.map(fn(f) {
        // use created <- sharp.optimize_image(f.path)
        let slug = fs.replace(full: f.path, rel: consts.gallery_dir)
        Image(slug)
      })

    Ok(render(images))
  }
  |> result.unwrap(element.none())
  |> element.to_document_string
}

fn render(paths: List(Image)) {
  paths
  |> list.map(fn(p) { html.img([attribute.src(p.path)]) })
  |> html.div([], _)
}
