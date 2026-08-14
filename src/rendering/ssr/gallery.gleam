import charge/component
import charge/error
import charge/fs as sfs
import consts
import content/metadata
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/result
import gleam/string
import mellie
import mellie/attr as attribute
import mellie/element.{type ElementTree}
import mellie/html
import rendering/pages/photography
import rendering/ssr/custom_el

fn gallery_dir() {
  let assert Ok(dir) = sfs.from_cwd(consts.gallery_dir)
  dir
}

fn iif(cond, cb) {
  case cond {
    False -> False
    True -> cb()
  }
}

fn create_filter(
  path: Option(sfs.Path),
  country: Option(String),
  tags: List(String),
) {
  let dir = path |> option.unwrap(gallery_dir()) |> sfs.path_to_string

  fn(img: metadata.Photo) {
    use <- iif(img.path |> sfs.path_to_string |> string.starts_with(dir))
    use <- iif(case country {
      None -> True
      Some(c) -> img.country == c
    })

    case tags {
      [] -> True
      _ -> list.any(img.tags, list.contains(tags, _))
    }
  }
}

fn get_files(data: metadata.SiteData, el: ElementTree, page: sfs.Path) {
  use parent <- result.try(sfs.parent(page))

  let base_path =
    mellie.attr(el, "path")
    |> result.replace_error(error.ComponentError(
      "site-gallery could not find path on given element",
    ))

  let relative_path =
    base_path
    |> result.try(sfs.resolve(parent, _))
    |> option.from_result

  let gallery_path =
    base_path
    |> result.try(sfs.resolve(gallery_dir(), _))
    |> option.from_result

  // use parent <- result.try(sfs.parent(page))
  // use gallery_path <- result.try(sfs.resolve(gallery_dir(), path))              
  // use relative_path <- result.try(sfs.resolve(parent, path))

  let country = mellie.attr(el, "country") |> option.from_result
  let tags =
    mellie.attr(el, "tags")
    |> option.from_result
    |> option.map(string.split(_, " "))
    |> option.unwrap([])

  let sort = case mellie.attr(el, "sort") {
    Ok("reverse") -> fn(photos) {
      photos |> metadata.sort_photos |> list.reverse
    }
    _ -> metadata.sort_photos
  }

  let relative_photos =
    data.photos |> list.filter(create_filter(relative_path, country, tags))
  let gallery_photos =
    data.photos |> list.filter(create_filter(gallery_path, country, tags))

  [relative_photos, gallery_photos]
  |> list.flatten
  |> list.unique
  |> sort
  |> Ok
}

pub fn component() {
  component.new(tag: "gallery", visit: fn(data, el) {
    case data.source_path {
      None -> el |> Ok
      Some(path) ->
        get_files(data.data, el, path)
        |> result.try(render)
    }
  })
}

fn render(imgs) {
  imgs
  |> list.map(render_image)
  |> error.collate_errors
  |> result.map(custom_el.site_gallery)
}

fn render_image(img: metadata.Photo) {
  use link_path <- result.map(
    img
    |> photography.photo_to_site_page_path,
  )

  custom_el.site_gallery_image(
    html.a([link_path |> sfs.site_path_to_href], [
      html.img([
        photography.to_site_src_path(img),
        attribute.alt(img.description),
      ]),
    ]),
  )
}
