import consts
import content/fs
import gleam/io
import gleam/javascript/promise.{type Promise}
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/order
import gleam/regexp
import gleam/result
import js/sharp
import shoki/internal/date
import util

pub type Paths {
  Paths(input_file: String, output_file: String, site_path: String)
}

pub type Asset {
  OptimizeImageAsset(input_file: String)
}

pub type Meta {
  Meta(
    title: String,
    description: Option(String),
    date: Option(date.IsoDate),
    tags: List(String),
  )
}

pub type Page {
  Page(
    path: String,
    /// Should always start with "/"
    slug: String,
    meta: Meta,
    html: String,
    assets: List(Asset),
  )
}

pub type DynamicPage {
  DynamicPage(slug: String, meta: Meta, html: String, assets: List(Asset))
}

pub type RSSFeed {
  XMLFeed(slug: String, content: String)
}

pub type RenderedPage {
  Content(Page)
  Dynamic(DynamicPage)
  Feed(RSSFeed)
}

fn replace_non_words(in: String) {
  let assert Ok(re) = regexp.from_string("[\\W_]+")

  regexp.replace(re, in: in, with: "_")
}

pub fn resolve(asset: Asset) {
  case asset {
    OptimizeImageAsset(input_file:) -> {
      let site_dir = "optimized"
      use out_dir <- result.try(fs.join([consts.out_dir, site_dir]))

      let out_name = replace_non_words(input_file) <> ".webp"
      use site_path <- result.try(fs.join(["", site_dir, out_name]))

      use output_file <- result.try(fs.join([out_dir, out_name]))

      Ok(Paths(input_file:, output_file:, site_path:))
    }
  }
}

pub fn write_pages(pages: List(RenderedPage)) -> Promise(Result(Nil, String)) {
  let page_result =
    pages
    |> list.try_each(write_page)

  use _ <- util.try_resolve(page_result)

  let assets =
    pages
    |> list.flat_map(assets_of)

  write_assets(assets)
}

fn write_page(page: RenderedPage) {
  let slug = slug_of(page)

  let html = content_of(page)

  let path = consts.out_dir <> page |> path_of

  io.println("wrote page: " <> slug <> " to " <> path)
  fs.write(path, html)
}

pub fn content_of(page: RenderedPage) -> String {
  case page {
    Content(page) -> page.html
    Dynamic(page) -> page.html
    Feed(feed) -> feed.content
  }
}

fn path_of(page: RenderedPage) -> String {
  case page {
    Content(page) -> page.slug <> ".html"
    Dynamic(page) -> page.slug <> ".html"
    Feed(feed) -> feed.slug <> ".xml"
  }
}

pub fn slug_of(page: RenderedPage) -> String {
  case page {
    Content(page) -> page.slug
    Dynamic(page) -> page.slug
    Feed(feed) -> feed.slug
  }
}

pub fn assets_of(page: RenderedPage) -> List(Asset) {
  case page {
    Content(page) -> page.assets
    Dynamic(page) -> page.assets
    Feed(_) -> []
  }
}

fn write_assets(assets: List(Asset)) {
  assets
  |> list.map(write_asset)
  |> promise.await_list
  |> promise.map(result.all)
  |> promise.map(result.replace(_, Nil))
}

fn write_asset(asset: Asset) {
  use resolved <- util.try_resolve(resolve(asset))
  case asset {
    OptimizeImageAsset(_) -> {
      sharp.optimize_image(resolved.input_file, resolved.output_file)
      |> promise.tap(fn(_) {
        io.println(
          "wrote asset: "
          <> resolved.input_file
          <> " -> "
          <> resolved.output_file,
        )
      })
    }
  }
}

pub fn sort_by_date(pages: List(Page)) {
  pages
  |> list.sort(fn(a, b) {
    case a.meta.date, b.meta.date {
      Some(a), Some(b) -> date.compare(a, b)
      Some(_), _ -> order.Gt
      None, _ -> order.Lt
    }
  })
}
