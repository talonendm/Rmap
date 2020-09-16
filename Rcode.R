library(leaflet)
map <- leaflet() %>% addTiles()



coordinates <- data.frame(lat = c(70, 30), lng = c(40,20) )

map <- map %>% addCircles(lat = coordinates$lat, lng = coordinates$lng)

map


library(mapdeck)
options(mapbox.accessToken = p$mapboxkey)
library(mapdeck)
library(widgetframe)
library(dplyr)



df <- read.csv(paste0(
  'https://raw.githubusercontent.com/uber-common/deck.gl-data/master/',
  'examples/3d-heatmap/heatmap-data.csv'
))

df <- df[!is.na(df$lng), ]
# just set of coordinates 140 000 points
mapdeck( token = p$mapboxkey, style = mapdeck_style("outdoors") , pitch = 0 ) %>%
  add_heatmap(
    data = df[1:30000, ]
    , lat = "lat"
    , lon = "lng"
    , weight = "weight",
    , colour_range = colourvalues::colour_values(1:6, palette = "inferno")
  )



mapdeck( token = p$mapboxkey, style = mapdeck_style("outdoors"), pitch = 0, show_view_state = FALSE ) %>%
  add_line(
    data = d2.line
    , layer_id = "line_layer"
    , origin = c("lon", "lat")
    , destination = c("lon.end", "lat.end")
    , stroke_colour = "line.depth"
    , stroke_width = 6
    , highlight_colour = "#AAFFFFFF"
    , auto_highlight = TRUE
    , legend = TRUE
    , tooltip = "line.depth"
  )

