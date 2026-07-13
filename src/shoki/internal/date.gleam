import gleam/dynamic/decode
import gleam/int
import gleam/list
import gleam/option.{type Option}
import gleam/order
import gleam/string
import parz
import parz/combinators
import parz/parsers
import shoki/shoki.{DateParseError}

pub type IsoDate {
  IsoDate(year: Int, month: Int, day: Int)
}

/// parses a date in the format of yyyy-mm-dd
fn parser() {
  let digits =
    parsers.digits()
    |> combinators.try_map(int.parse)
    |> combinators.label_error(DateParseError("Expected digits"))

  let dash =
    parsers.str("-")
    |> combinators.label_error(DateParseError("Expected -"))

  combinators.left(digits, dash)
  |> combinators.then(combinators.left(digits, dash))
  |> combinators.then(digits)
  |> combinators.map(fn(parts) {
    let #(#(year, day), month) = parts

    IsoDate(year:, month:, day:)
  })
}

pub fn parse(str: String) {
  let result = parz.run(str, parser())
  case result {
    Ok(state) -> Ok(state.matched)
    Error(err) -> Error(err)
  }
}

pub fn to_string(date: IsoDate, sep) {
  [date.year, date.month, date.day]
  |> list.map(int.to_string)
  |> string.join(sep)
}

pub fn compare(a: IsoDate, b: IsoDate) -> order.Order {
  case a.year, b.year {
    a_year, b_year if a_year > b_year -> order.Gt
    a_year, b_year if a_year < b_year -> order.Lt
    _, _ ->
      case a.month, b.month {
        a_month, b_month if a_month > b_month -> order.Gt
        a_month, b_month if a_month < b_month -> order.Lt
        _, _ ->
          case a.day, b.day {
            a_day, b_day if a_day > b_day -> order.Gt
            a_day, b_day if a_day < b_day -> order.Lt
            _, _ -> order.Eq
          }
      }
  }
}

pub fn date_decoder() -> decode.Decoder(Option(IsoDate)) {
  decode.string
  |> decode.map(fn(field) { field |> parse |> option.from_result })
}
