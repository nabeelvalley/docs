import charge
import charge/date as sdate
import charge/error
import charge/fs as sfs
import consts
import date
import gleam/dict
import gleam/dynamic/decode
import gleam/int
import gleam/io
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/order
import gleam/result
import gleam/string
import gleave
import parz
import parz/combinators
import parz/parsers
import simplifile
import yamleam

pub type Layout {
  NoLayout
  ArticleLayout
  GalleryLayout
}

pub type Frontmatter {
  Frontmatter(
    title: String,
    description: Option(String),
    published: Bool,
    feature: Bool,
    layout: Layout,
    tags: List(String),
    date: Option(sdate.IsoDate),
    path: sfs.SitePath,
  )
}

pub type SiteData {
  SiteData(frontmatters: List(Frontmatter), photos: List(Photo))
}

pub fn decoder(path: sfs.SitePath) -> decode.Decoder(Frontmatter) {
  let decode_bool = fn(field, default, a) {
    decode.optional_field(field, default, decode.bool, a)
  }

  let decode_str = fn(field, a) {
    decode.optional_field(field, None, decode.optional(decode.string), a)
  }

  use title <- decode.field("title", decode.string)
  use description <- decode_str("description")
  use layout_str <- decode_str("layout")

  use published <- decode_bool("published", True)
  use feature <- decode_bool("feature", False)

  use tags <- decode.optional_field("tags", [], decode.list(decode.string))

  let layout = case layout_str {
    Some("gallery") -> GalleryLayout
    Some("none") -> NoLayout
    _ -> ArticleLayout
  }

  let date =
    path
    |> sfs.site_path_to_string
    |> date.parse_from_path
    |> option.from_result

  decode.success(Frontmatter(
    title:,
    description:,
    published:,
    feature:,
    layout:,
    tags:,
    date:,
    path:,
  ))
}

pub fn sort_by_date(pages: List(Frontmatter)) {
  pages
  |> list.sort(fn(a, b) {
    case a.date, b.date {
      Some(a), Some(b) -> date.compare(a, b)
      Some(_), _ -> order.Gt
      None, _ -> order.Lt
    }
  })
}

pub fn is_published(fm: Frontmatter) {
  fm.published
}

pub type CamLens {
  CamLens(camera: String, lens: Option(String))
}

fn cam_lens_decoder() -> decode.Decoder(CamLens) {
  use camera <- decode.field("camera", decode.string)
  use lens <- decode.optional_field(
    "lens",
    option.None,
    decode.optional(decode.string),
  )
  decode.success(CamLens(camera:, lens:))
}

pub type PhotographyMeta {
  PhotographyMeta(cam_lens: dict.Dict(String, CamLens))
}

fn photography_meta_decoder() -> decode.Decoder(PhotographyMeta) {
  use cam_lens <- decode.field(
    "cam_lens",
    decode.dict(decode.string, cam_lens_decoder()),
  )
  decode.success(PhotographyMeta(cam_lens:))
}

pub type Photo {
  Photo(
    path: sfs.Path,
    date: sdate.IsoDate,
    cam_lens: CamLens,
    country: String,
    location: Option(String),
    tags: List(String),
    description: String,
  )
}

fn photo_parser(cam_lenses) {
  let sep = fn(at) {
    parsers.str(" - ")
    |> combinators.label_error("expected - at " <> at)
  }

  let text =
    parsers.regex(".+")
    |> combinators.label_error("expected some description text")

  let desc =
    text
    |> combinators.map(fn(d) { #(None, d) })

  let text =
    parsers.regex(".+")
    |> combinators.label_error("expected some description text")

  let text_before_sep =
    parsers.regex(".+(?= - )")
    |> combinators.label_error("expected some text followed by a dash")

  let desc_with_location =
    combinators.left(text_before_sep, sep("afer location"))
    |> combinators.then(text)
    |> combinators.map2(fn(l, d) { #(Some(l), d) })
    |> combinators.label_error("expected location and description")

  let country =
    parsers.regex("\\w\\w")
    |> combinators.label_error("expected two-letter country code")

  let date =
    sdate.parser()
    |> combinators.label_error("error parsing date")

  let tags =
    combinators.separator1(
      parsers.letters() |> combinators.label_error("expected word"),
      parsers.str(" ") |> combinators.label_error("expected space between tags"),
    )
    |> combinators.label_error("error reading photo tags")

  let cam_lens =
    cam_lenses
    |> dict.keys
    |> list.map(parsers.str)
    |> combinators.choice
    |> combinators.label_error("expected cam_lens value")

  date
  |> combinators.then(combinators.right(sep("before cam_lens"), cam_lens))
  |> combinators.then(combinators.right(sep("before tags"), tags))
  |> combinators.then(combinators.right(sep("before country"), country))
  |> combinators.then(combinators.right(
    sep("before desc"),
    combinators.or(desc_with_location, desc),
  ))
  |> combinators.try_map(fn(parsed) {
    let #(#(#(#(date, cam_lens), tags), country), #(location, description)) =
      parsed

    use cam_lens <- result.map(
      dict.get(cam_lenses, cam_lens)
      |> result.replace_error("cam_lens combination not found: " <> cam_lens),
    )

    fn(path) {
      Photo(path:, date:, cam_lens:, country:, location:, tags:, description:)
    }
  })
}

fn parse_photo(cam_lens, path: sfs.Path) {
  let name = path |> sfs.file_name_only

  let parsed =
    name
    |> parz.run(photo_parser(cam_lens))

  case parsed {
    Ok(state) -> state.matched(path) |> Ok
    Error(err) ->
      Error(
        err |> error.Custom |> error.error_context(path |> sfs.path_to_string),
      )
  }
}

pub fn load_photos() {
  let assert Ok(gallery_dir) = sfs.from_cwd(consts.gallery_dir)

  use file <- result.try(
    simplifile.read(consts.photogaphy_metadata)
    |> result.replace_error(error.ErrorReadingTextFile(
      "Error reading photography metadata file",
    )),
  )

  use metadata <- result.try(
    yamleam.parse(file, photography_meta_decoder())
    |> result.replace_error(error.Custom("Error parsing photography metadata")),
  )

  use files <- result.try(sfs.ls_dir(gallery_dir))

  let photos =
    files
    |> list.filter(sfs.has_ext(_, [sfs.JPG, sfs.JPEG, sfs.PNG, sfs.WEBP]))

  list.filter(files, fn(p) { !list.contains(photos, p) })
  use photos <- result.map(
    list.map(photos, parse_photo(metadata.cam_lens, _)) |> error.collate_errors,
  )

  photos
}

fn photo_to_string(photo: Photo) {
  "\npath: "
  <> photo.path |> sfs.path_to_string
  <> "\ndate: "
  <> photo.date |> date.to_string("-")
  <> "\ncam_lens: "
  <> photo.cam_lens.camera
  <> " "
  <> photo.cam_lens.lens |> option.unwrap("[no lens]")
  <> "\ncountry: "
  <> photo.country
  <> "\nlocation: "
  <> photo.location |> option.unwrap("[no location]")
  <> "\ntags: "
  <> photo.tags |> string.join(", ")
  <> "\ndescription: "
  <> photo.description
}

pub fn main() {
  case load_photos() {
    Ok(photos) -> {
      io.println("parsed photos")
      photos |> list.map(photo_to_string) |> string.join("\n\n") |> io.println

      io.println("\ntotal photos: " <> int.to_string(photos |> list.length))
      gleave.exit(0)
    }
    Error(e) -> {
      io.print_error("error parsing the following files\n\n")
      io.println_error(e |> error.error_to_string)
      gleave.exit(1)
    }
  }
}

pub fn with_photos() {
  charge.with_static_dir
}
