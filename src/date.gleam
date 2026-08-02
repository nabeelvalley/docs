import gleam/int
import gleam/list
import gleam/order
import gleam/string
import parz
import parz/combinators
import parz/parsers
import shoki/date.{type IsoDate, IsoDate}

/// parses a path of the format /myfolder/2026/31-01/some-other-stuff
fn parser_from_path() {
  let digit =
    parsers.digits()
    |> combinators.try_map(int.parse)
    |> combinators.label_error("Expected digits")
  let sep = fn(sep) {
    parsers.str(sep) |> combinators.label_error("Expected " <> sep)
  }
  let slash = sep("/")
  let dash = sep("-")

  let word =
    parsers.letters() |> combinators.label_error("Expected alphanumeric part")

  let prefix = combinators.between(slash, word, slash)

  combinators.right(prefix, digit)
  |> combinators.then(combinators.right(slash, digit))
  |> combinators.then(combinators.right(dash, digit))
  |> combinators.map(fn(parts) {
    let #(#(year, day), month) = parts

    IsoDate(year:, month:, day:)
  })
}

pub fn parse_from_path(str: String) {
  let result = parz.run(str, parser_from_path())
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
