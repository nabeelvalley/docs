import consts
import gleam/dict
import gleam/list
import gleam/option.{None, Some}
import gleam/result
import mellie
import mellie/attr as attribute
import mellie/element.{type ElementTree}
import mellie/html
import rendering/ssr/custom_el
import charge/component
import charge/error
import charge/internal/fs as sfs

fn gallery_dir() {
  let assert Ok(dir) = sfs.from_cwd(consts.gallery_dir)
  dir
}

fn get_files(el: ElementTree, page: sfs.Path) {
  use path <- result.try(
    mellie.attr(el, "path")
    |> result.replace_error(
      error.ComponentError("site-gallery could not find path on given element")
      |> error.error_context(page |> sfs.path_to_string),
    ),
  )

  use parent <- result.try(sfs.parent(page))
  use gallery_path <- result.try(sfs.resolve(gallery_dir(), path))
  use relative_path <- result.try(sfs.resolve(parent, path))

  let gallery_files = sfs.ls_dir(gallery_path)
  let relative_files = sfs.ls_dir(relative_path)

  use files <- result.try(result.or(gallery_files, relative_files))

  files |> Ok
}

pub fn component() {
  component.new(tag: "gallery", visit: fn(data, el) {
    case data.source_path {
      None -> el |> Ok
      Some(path) ->
        get_files(el, path)
        |> result.map(render)
    }
  })
}

fn render(paths: List(sfs.Path)) {
  paths
  |> list.map(render_image)
  |> custom_el.site_gallery
}

fn render_image(img: sfs.Path) {
  let site_path = sfs.to_site_path(sfs.cwd(), img, dict.new())

  custom_el.site_gallery_image(
    html.img([
      site_path
        |> sfs.site_path_to_src,
      attribute.alt(img |> sfs.file_name_only),
    ]),
  )
}
