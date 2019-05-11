// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import '../css/app.scss'

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import 'phoenix_html'

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"
// import '@webcomponents/webcomponentsjs/webcomponents-loader.js'
import './components/search-box.js'
import './components/with-dropdown.js'
import './components/location-input.js'
import './components/artists-input.js'
import './components/picture-input.js'
import './components/datetime-input.js'
