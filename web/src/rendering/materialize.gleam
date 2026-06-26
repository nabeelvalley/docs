import gleam/option.{type Option}

pub type Asset {
  OptimizeImageAsset(path: String)
}

pub type Meta {
  Meta(title: Option(String), description: Option(String), date: Option(String))
}

pub type Page {
  Page(slug: String, meta: Meta, html: String, assets: List(Asset))
}

pub type SsrResult =
  #(String, List(Asset))

pub type SsrRenderer =
  fn(String) -> SsrResult
