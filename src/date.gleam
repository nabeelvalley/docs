import gleam/int
import parz
import parz/combinators
import parz/parsers

pub type IsoDate {
  IsoDate(year: Int, month: Int, day: Int)
}

fn parser() {
  let sep = parsers.str("-")
  let i = parsers.digits() |> combinators.map(int.parse)

  combinators.separator(sep:, parser: i)
  |> combinators.try_map(fn(parts) {
    case parts {
      [Ok(year), Ok(month), Ok(day)] -> Ok(IsoDate(year:, month:, day:))
      _ -> Error("Invalid date format")
    }
  })
}

pub fn parse(str: String) {
  let result = parz.run(str, parser())
  case result {
    Error(err) -> Error(err)
    Ok(state) ->
      case state.remaining {
        "" -> Ok(state.matched)
        _ ->
          Error("Found more extra after date was parsed: " <> state.remaining)
      }
  }
}
