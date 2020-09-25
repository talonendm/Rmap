# https://gist.github.com/jcheng5/c084a59717f18e947a17955007dc5f92#file-leaflet-heat-r

library(leaflet)
library(htmltools)
library(htmlwidgets)

# This tells htmlwidgets about our plugin name, version, and
# where to find the script. (There's also a stylesheet argument
# if the plugin comes with CSS files.)
esriPlugin <- htmlDependency("leaflet.esri", "1.0.3",
                             src = c(href = "https://cdn.jsdelivr.net/leaflet.esri/1.0.3/"),
                             script = "esri-leaflet.js"
)

# A function that takes a plugin htmlDependency object and adds
# it to the map. This ensures that however or whenever the map
# gets rendered, the plugin will be loaded into the browser.
registerPlugin <- function(map, plugin) {
  map$dependencies <- c(map$dependencies, list(plugin))
  map
}


leaflet() %>% setView(-122.23, 37.75, zoom = 10) %>%
  # Register ESRI plugin on this map instance
  registerPlugin(esriPlugin) %>%
  # Add your custom JS logic here. The `this` keyword
  # refers to the Leaflet (JS) map object.
  onRender("function(el, x) {
    L.esri.basemapLayer('Topographic').addTo(this);
  }")


# .............

library(leaflet)
library(htmltools)
library(htmlwidgets)


# https://kartat.kapsi.fi/leaflet.html
L.tileLayer.mml('Ortokuva');
