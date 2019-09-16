import "../css/app.scss"

import "phoenix_html"
import { Socket } from "phoenix"
import LiveSocket from "phoenix_live_view"
import hooks from './hooks'

const liveSocket = new LiveSocket("/live", Socket, { hooks })
liveSocket.connect()
