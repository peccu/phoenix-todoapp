import {Socket} from "phoenix"
import LiveSocket from "phoenix_live_view"

// this route is defined in lib/todoapp_web/endpoint.ex
let liveSocket = new LiveSocket("/live", Socket)
liveSocket.connect()

// Do I need this exports?
export default liveSocket
