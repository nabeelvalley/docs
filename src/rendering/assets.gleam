import consts
import content/fs
import date
import gleam/javascript/promise.{type Promise}
import gleam/list
import gleam/option.{type Option}
import gleam/regexp
import gleam/result
import js/sharp
import util

pub type Paths {
  Paths(input_file: String, output_file: String, site_path: String)
}

pub type Asset {
  OptimizeImageAsset(input_file: String)
}

pub type Meta {
  Meta(
    title: Option(String),
    description: Option(String),
    date: Option(date.IsoDate),
  )
}

pub type Page {
  Page(slug: String, meta: Meta, html: String, assets: List(Asset))
}

fn replace_non_words(in: String) {
  let assert Ok(re) = regexp.from_string("[\\W_]+")

  regexp.replace(re, in: in, with: "_")
}

pub fn resolve(asset: Asset) {
  case asset {
    OptimizeImageAsset(input_file:) -> {
      let site_dir = "optimized"
      let out_dir = fs.join([consts.out_dir, site_dir])

      let out_name = replace_non_words(input_file) <> ".webp"
      let site_path = fs.join(["", site_dir, out_name])

      let output_file = fs.join([out_dir, out_name])

      Paths(input_file:, output_file:, site_path:)
    }
  }
}

pub fn write_pages(pages: List(Page)) -> Promise(Result(Nil, String)) {
  let page_result =
    pages
    |> list.try_each(write_page)

  use _ <- util.try_resolve(page_result)

  let assets = pages |> list.flat_map(fn(p) { p.assets })
  write_assets(assets)
}

fn write_page(page: Page) {
  let path = consts.out_dir <> "/" <> page.slug <> ".html"
  fs.write(path, page.html)
}

fn write_assets(assets: List(Asset)) {
  assets
  |> list.map(write_asset)
  |> promise.await_list
  |> promise.map(result.all)
  |> promise.map(result.replace(_, Nil))
}

fn write_asset(asset: Asset) {
  let resolved = resolve(asset)
  case asset {
    OptimizeImageAsset(_) -> {
      sharp.optimize_image(resolved.input_file, resolved.output_file)
    }
  }
}
