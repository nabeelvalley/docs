import gleam/erlang/process
import mist
import router
import wisp
import wisp/wisp_mist

pub type Context {
  Context(static_directory: String)
}

// TODO: this should be moved to the env. Used for signing/encryption
const encryption_key = ""

pub fn main() {
  wisp.configure_logger()

  let ctx = Context("./static")

  let assert Ok(_) =
    wisp_mist.handler(router.handle_request, encryption_key)
    |> mist.new
    |> mist.port(8000)
    |> mist.start

  process.sleep_forever()
}
