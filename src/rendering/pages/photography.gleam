import charge
import charge/date
import charge/error
import charge/fs
import consts
import content/metadata
import gleam/dict
import gleam/list
import gleam/option.{None}
import gleam/pair
import gleam/result
import gleam/string
import gleam/uri
import mellie/attr as attribute
import mellie/html
import rendering/dict as dict_util
import rendering/ssr/custom_el
import rendering/templates/base

fn gallery_path() {
  let assert Ok(path) = fs.from_cwd(consts.gallery_dir)
  path
}

fn photography_path() {
  let assert Ok(path) = fs.site_path_from_string("/photography")
  path
}

fn photography_photo_path() {
  let assert Ok(path) = fs.site_path_from_string("/photography/photo")
  path
}

pub fn render(pages: List(metadata.Frontmatter)) {
  let meta = base.Meta("Photography", None, None, [])
  let photography_items =
    pages
    |> list.filter(fn(p) {
      fs.site_path_starts_with(p.path, photography_path())
    })
    |> list.group(fn(a) {
      case fs.site_path_parts(a.path) {
        [_photography, section, ..] -> section
        _ -> "other"
      }
    })

  let tag_items =
    pages
    |> list.filter(fn(p) { p.tags |> list.contains("photography") })
    |> list.group(fn(a) {
      case fs.site_path_parts(a.path) {
        [section, ..] -> section
        _ -> "other"
      }
    })

  let all_items = dict.combine(photography_items, tag_items, list.append)

  let rendered =
    all_items
    |> dict_util.to_sorted_entries
    |> list.map(fn(entry) {
      let #(section, ps) = entry
      let title = section |> html.text

      let subitems =
        ps
        |> list.map(fn(p) {
          html.li([], [
            html.a([fs.site_path_to_href(p.path)], [
              html.text(p.title),
            ]),
          ])
        })
        |> html.ul([], _)

      html.section([], [
        html.h2([], [title]),
        subitems,
      ])
    })

  let html =
    // temp until we figure out how this layout should look
    html.article([attribute.class("site-article")], rendered)
    |> base.render(meta)

  fs.site_path_from_string("/photography.html")
  |> result.map(charge.generated_html_file(_, html))
}

pub fn render_photo_page(photo: metadata.Photo) {
  use page_path <- result.map(photo_to_site_page_path(photo.path))
  let src_path = to_site_src_path(photo.path)

  let content =
    html.article([attribute.class("site-photo-detail")], [
      html.h1([], [html.text(photo.description)]),

      custom_el.site_photo_info([
        html.dl([], [
          custom_el.site_photo_info_item([
            html.dt([], [html.text("Taken")]),
            html.dd([], [html.text(photo.date |> date.to_string("-"))]),
          ]),

          custom_el.site_photo_info_item([
            html.dt([], [html.text("Country")]),
            html.dd([], [html.text(photo.country)]),
          ]),
        ]),
      ]),

      custom_el.site_photo_full([
        html.img([fs.site_path_to_src(src_path), attribute.alt("")]),
      ]),
    ])
    |> base.render(
      base.Meta(
        "Photo: " <> photo.date |> date.to_string("-"),
        photo.description |> option.Some,
        date: photo.date |> option.Some,
        tags: ["photo"],
      ),
    )

  charge.derived_html_file(photo.path, page_path, content)
}

pub fn photo_to_site_page_path(path) {
  fs.to_site_path(
    gallery_path(),
    path,
    [
      fs.JPG,
      fs.PNG,
      fs.JPEG,
      fs.WEBP,
    ]
      |> list.map(pair.new(_, fs.HTML))
      |> dict.from_list,
  )
  |> fs.concat_site_path(photography_photo_path(), _)
  |> fs.site_path_to_string
  |> uri.percent_decode
  |> result.replace_error(error.Custom("error replacing image path"))
  |> result.map(string.replace(_, " ", "-"))
  |> result.try(fs.site_path_from_string)
}

fn to_site_src_path(path) {
  fs.to_site_path(fs.cwd(), path, dict.new())
}
