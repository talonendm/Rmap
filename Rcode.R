library(leaflet)
map <- leaflet() %>% addTiles()



coordinates <- data.frame(lat = c(70, 30), lng = c(40,20) )

map <- map %>% addCircles(lat = coordinates$lat, lng = coordinates$lng)

map



# access token not to used

p <- list()

p$mapboxkey <- mapboxrestricted

library(mapdeck)
options(mapbox.accessToken = p$mapboxkey)
library(mapdeck)
library(widgetframe)
library(dplyr)

# restricted not working:
# https://stackoverflow.com/questions/57764179/mapbox-access-token-restrict-to-url-does-not-work-with-github-pages

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





map <- leaflet() %>% addTiles()
map %>%
  add_heatmap(
    data = df[1:30000, ]
    , lat = "lat"
    , lon = "lng"
    , weight = "weight",
    , colour_range = colourvalues::colour_values(1:6, palette = "inferno")
  )


# https://www.r-bloggers.com/exploring-london-crime-with-r-heat-maps/

install.packages('leaflet.extras')

library(httr)
library(rvest)
library(purrr)
library(dplyr)
library(ggplot2)
library(jsonlite)
library(lubridate)
library(stringr)
library(viridis)
library(leaflet)
library(leaflet.extras)
library(htmltools)


df %>% 
  leaflet() %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  addHeatmap(lng=~as.numeric(lng),
             lat=~as.numeric(lat),
             radius = 8)


df %>% 
  leaflet() %>% addProviderTiles(providers$CartoDB.Positron) %>%
  addProviderTiles(providers$OpenRailwayMap) %>% addProviderTiles(providers$OpenFireMap) %>% addProviderTiles(providers$OpenSeaMap) %>%
  addHeatmap(lng=~as.numeric(lng),
             lat=~as.numeric(lat),
             radius = 8)




#quite good combination

df %>% 
  leaflet() %>% # addProviderTiles(providers$CartoDB.Positron) %>%
  addProviderTiles(providers$OpenTopoMap) %>%  
  addProviderTiles(providers$Stamen.TerrainLabels) %>% addProviderTiles(providers$OpenSeaMap) %>%
  addHeatmap(lng=~as.numeric(lng),
             lat=~as.numeric(lat),
             radius = 8)



df %>% 
  leaflet() %>%  addProviderTiles(providers$HikeBike) %>%
  # addProviderTiles(providers$OpenTopoMap) %>%  
  # addProviderTiles(providers$Stamen.TerrainLabels) %>% 
  addProviderTiles(providers$OpenSeaMap) %>%
  addHeatmap(lng=~as.numeric(lng),
             lat=~as.numeric(lat),
             radius = 8)

print(names(providers))



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


# install.packages('plotKML')
library(plotKML)

if (FALSE) {
gpx.file <- 'C:\\data\\sportstracker\\9_14_20 16_09.gpx'

boat1 <- readGPX(gpx.file, metadata = TRUE, bounds = TRUE, waypoints = TRUE, tracks = TRUE, routes = TRUE)
boat1$tracks
boat1$routes


gpx.file <- 'C:\\data\\sportstracker\\21.8.2020 6.20.gpx'

boat2 <- readGPX(gpx.file, metadata = TRUE, bounds = TRUE, waypoints = TRUE, tracks = TRUE, routes = TRUE)
boat2$tracks
boat2$routes
boat2$bounds
boat2$waypoints

da1 <- data.frame(boat1$tracks)
da2 <- data.frame(boat2$tracks)
da3 <- rbind(da1, da2)
da4 <- da3 %>% dplyr::select(lat = NA.lat, lon = NA.lon)

da4 %>% 
  leaflet() %>%  addProviderTiles(providers$HikeBike) %>%
  # addProviderTiles(providers$OpenTopoMap) %>%  
  # addProviderTiles(providers$Stamen.TerrainLabels) %>% 
  addProviderTiles(providers$OpenSeaMap) %>%
  addHeatmap(lng=~as.numeric(lon),
             lat=~as.numeric(lat),
             radius = 2, blur = 2, minOpacity = 0.2, max = 0.25, cellSize = 1)



}

# list of files
# https://sports-tracker.helpshift.com/a/sports-tracker/?s=account&f=how-to-export-import-workouts&p=android

gpxlist <- c(
  '9_14_20 16_09.gpx',
  '21.8.2020 6.20.gpx',
  '16.8.2020 18.11.gpx',
  '15.7.2020 16.26.gpx',
  '10.7.2020 20.02.gpx',
  '4.7.2020 4.14.gpx',
  '25.6.2020 19.42.gpx',
  '24.6.2020 21.22.gpx',
  '22.6.2020 19.42.gpx',
  '24.5.2020 8.19.gpx',
  '23.5.2020 13.31.gpx',
  '8.5.2020 6.40.gpx',
  '5.5.2020 19.00.gpx',
  '26.9.2019 15.09.gpx',
  '3.10.2014 17.11.gpx',
  '12.9.2014 17.17.gpx',
  '9.8.2014 10.31.gpx',
  '05.11.2010 13_56.gpx',
  '01.10.2010 17_16.gpx',
  '31.08.2008 12_17.gpx'
  )

gpxfiles <- paste0('C:\\data\\sportstracker\\',gpxlist)
gpxfiles

boat <- list()
i <- 0
for (file_i in gpxfiles) {
  i <- i + 1
  da <- readGPX(file_i, metadata = FALSE, bounds = FALSE, waypoints = FALSE, tracks = TRUE, routes = FALSE)
  boat[[i]] <- data.frame(da$tracks)
}

data <- rbind_list(boat) %>% dplyr::select(lat = NA.lat, lon = NA.lon, datetime = NA.time)
head(data)



data <- data %>% dplyr::filter(datetime < '2020-05-05T17:59:00Z' | datetime > '2020-05-05T20:08:52Z')
data <- data %>% dplyr::filter(datetime < '2014-09-12T15:30:56Z' | datetime > '2014-09-12T15:55:05Z')
data <- data %>% dplyr::filter(datetime < '2020-08-21T05:40:02Z' | datetime > '2020-08-21T07:12:07Z') # island
data <- data %>% dplyr::filter(datetime < '2008-08-31T11:36:08Z' | datetime > '2008-08-31T11:47:08Z')




data2 <- data

data2$rlat <- round(data2$lat, 3)
data2$rlon <- round(data2$lon, 3)

data2 <- data2[!duplicated(data2[c("rlat","rlon")]),]

datameta <- data2

kivilist <- c(60.048515, 24.298250, 
              60.054724, 24.298569, 
              60.025065, 24.286881,
              60.066400, 24.322405,
              60.083415, 24.337604,
              60.074224,24.335792,
              60.063131,24.322026,
              60.058776,24.319663,
              60.058881, 24.318476,
              60.083250, 24.337491,
              60.083473, 24.363921,
              60.081290, 24.359344,
              60.082903,24.384490,
              60.032686, 24.323791,
              60.036634, 24.315508,
              60.041459, 24.320798,
              60.045691, 24.325726,
              60.039726, 24.200881,
              60.027809, 24.219435,
              60.027678, 24.237490,
              60.029342, 24.261719,
              60.025065, 24.286881,
              60.024361, 24.291887
              
              
              
              )


placelist <- c(60.056564, 24.290942,
               60.055644,24.289828,
               60.039796, 24.272322,
               60.041891, 24.270921,
               60.032493, 24.271208,
               60.028414, 24.278200,
               60.019014, 24.425212,
               0.0420453,24.6003561,
               60.086700, 24.743100
               
               )


# seq(1,10,2)

kivet <- data.frame(lat = kivilist[seq(1,length(kivilist),2)], lon = kivilist[seq(2,length(kivilist),2)])
satamat <- data.frame(lat = placelist[seq(1,length(placelist),2)], lon = placelist[seq(2,length(placelist),2)])



library(sf)
library(dplyr)
library(leaflet)
library(crosstalk)
library(lubridate)
library(htmltools)

if (FALSE) {


# https://mrjoh3.github.io/2018/07/25/filtering-spatial-data/
# https://rstudio.github.io/crosstalk/index.html
class(datameta$datetime)
datameta$date <- as.Date(datameta$datetime)
sd <- SharedData$new(data.frame(datameta))

# FILTERING SPATIAL DATA WITH CROSSTALK

# rm(map)
filter_slider("date", "", sd, column=~date, step=10, width=800)
date_filter <- filter_slider("date", "", sd, column = ~date,      step = NULL, width = '100%', dragRange = TRUE)


if (FALSE) {
map <- leaflet(sd, width = '100%') %>%  
  #addProviderTiles(providers$HikeBike) %>%
  #addProviderTiles(providers$OpenStreetMap, group = "OpenStreet", options = list(opacity = 0.6, minZoom = 8, maxZoom = 15)) %>%  
  #addProviderTiles(providers$HikeBike.HikeBike, group = "HikeBike", options = list(opacity = 0.6, minZoom = 8, maxZoom = 15)) %>% 
  #addProviderTiles(providers$Stamen.Terrain, group = "Stamen.Terrain", options = list(opacity = 0.6, minZoom = 8, maxZoom = 15)) %>% 
  #addProviderTiles(providers$OpenTopoMap, group = "OpenTopoMap", options = list(opacity = 0.6, minZoom = 8, maxZoom = 15)) %>%
  addProviderTiles(providers$OpenStreetMap, group = "OpenStreet", options = list(opacity = 0.6)) %>%  
  addProviderTiles(providers$HikeBike.HikeBike, group = "HikeBike", options = list(opacity = 0.6)) %>% 
  addProviderTiles(providers$Stamen.Terrain, group = "Stamen.Terrain", options = list(opacity = 0.6)) %>% 
  addProviderTiles(providers$OpenTopoMap, group = "OpenTopoMap", options = list(opacity = 0.6)) %>%
  addProviderTiles(providers$OpenSeaMap, group = "seamap") %>% 
  addLayersControl(position = "bottomright", baseGroups = c("OpenTopoMap", "HikeBike", "Stamen.Terrain"),
                                                          options = layersControlOptions(collapsed = TRUE), 
                                                          overlayGroups = c("OpenStreet",   "boat", "satamat", "seamap", "data2","rock","datetime")) %>% hideGroup(c("data2","datetime")) %>%
  addEasyButton(easyButton(
    icon="fa-globe", title="Zoom to Level 8",
    onClick=JS("function(btn, map){ map.setZoom(8); }"))) %>%
  addEasyButton(easyButton(
    icon="fa-crosshairs", title="Locate Me",
    onClick=JS("function(btn, map){ map.locate({setView: true});            map.setZoom(14); }"))) %>%
  addMeasure(
    position = "bottomright",
    primaryLengthUnit = "meters",
    activeColor = "#3D535D",
    completedColor = "#7D4479") %>%
  addHeatmap(lng=as.numeric(data$lon),
             lat=as.numeric(data$lat),
             radius = 2, blur = 2, minOpacity = 0.2, max = 0.25, cellSize = 1, group = "boat") %>%
  addHeatmap(lng=as.numeric(data2$lon),
             lat=as.numeric(data2$lat), radius = 10, blur = 20, minOpacity = 0.1, max = 0.25, cellSize = 5, group = "data2") %>% 
  
  addCircles(lng = ~lon, lat = ~lat, radius = 20, color = "blue", stroke = FALSE, fillOpacity = 0.4, group = "datetime", popup = ~datetime) %>% 
  
  addCircles(lng = kivet$lon, lat = kivet$lat, radius = 50, color = "gray", stroke = FALSE, group = "rock") %>% 
  addCircles(lng = kivet$lon, lat = kivet$lat, radius = 10, color = "black", stroke = TRUE, group = "rock") %>% 
  addCircles(lng = satamat$lon, lat = satamat$lat, radius = 20, color = "green", stroke = TRUE, group = "satamat")   %>% addScaleBar('bottomleft')


# https://mrjoh3.github.io/2018/07/25/filtering-spatial-data/ !!!!!!!!
}

library(leaflet.extras)
# map <- leaflet() %>% addTiles()
map <- addControlGPS(map, options = gpsOptions(position = "topleft", activate = TRUE, 
                                               autoCenter = TRUE, maxZoom = 15, 
                                               setView = TRUE))
map <- map %>% activateGPS() # activateGPS(map)


sivu <- tags$div(class="well well-lg",
         tagList(
           tags$h2('Boat near Helsinki 2009 - 2020'),
           date_filter,
           map
         )
)  


save_html(sivu, "C:\\github\\Rmap\\index.html")


}


library(widgetframe)

# https://rpubs.com/ials2un/gpx1   # gpx and layers

map <- leaflet(datameta) %>% # leaflet(datameta, width = '100%', height = '100%') %>%  
  #addProviderTiles(providers$HikeBike) %>%
  #addProviderTiles(providers$OpenStreetMap, group = "OpenStreet", options = list(opacity = 0.6, minZoom = 8, maxZoom = 15)) %>%  
  #addProviderTiles(providers$HikeBike.HikeBike, group = "HikeBike", options = list(opacity = 0.6, minZoom = 8, maxZoom = 15)) %>% 
  #addProviderTiles(providers$Stamen.Terrain, group = "Stamen.Terrain", options = list(opacity = 0.6, minZoom = 8, maxZoom = 15)) %>% 
  #addProviderTiles(providers$OpenTopoMap, group = "OpenTopoMap", options = list(opacity = 0.6, minZoom = 8, maxZoom = 15)) %>%
  addProviderTiles(providers$OpenStreetMap, group = "OpenStreet", options = list(opacity = 0.6)) %>%  
  addProviderTiles(providers$HikeBike.HikeBike, group = "HikeBike", options = list(opacity = 0.6)) %>% 
  addProviderTiles(providers$Stamen.Terrain, group = "Stamen.Terrain", options = list(opacity = 0.6)) %>% 
  addProviderTiles(providers$Esri.WorldImagery, group = "Esri.WorldImagery", options = list(opacity = 0.4)) %>%
  addProviderTiles(providers$Esri.WorldTerrain, group = "Esri.WorldTerrain", options = list(opacity = 0.3)) %>%
  addProviderTiles(providers$OpenTopoMap, group = "OpenTopoMap", options = list(opacity = 0.6)) %>%
  addProviderTiles(providers$OpenSeaMap, group = "seamap") %>% 
  addLayersControl(position = "bottomright", baseGroups = c("seamap", "HikeBike"),
                   options = layersControlOptions(collapsed = TRUE), 
                   overlayGroups = c("OpenStreet", "Esri.WorldImagery", "Esri.WorldTerrain", "boat", "Stamen.Terrain", "data2","rock","satamat",  "datetime")) %>% hideGroup(c("Esri.WorldImagery","data2","datetime")) %>%
  addEasyButton(easyButton(
    icon="fa-globe", title="Zoom to Level 8", onClick=JS("function(btn, map){ map.setZoom(8); }"))) %>%
  addEasyButton(easyButton(
    icon="fa-crosshairs", title="Locate Me",onClick=JS("function(btn, map){ map.locate({setView: true}); map.setZoom(14); }"))) %>%
  addMeasure(
    position = "bottomright",
    primaryLengthUnit = "meters",
    activeColor = "#3D535D",
    completedColor = "#7D4479") %>%
  addHeatmap(lng=as.numeric(data$lon),
             lat=as.numeric(data$lat),
             radius = 2, blur = 2, minOpacity = 0.2, max = 0.25, cellSize = 1, group = "boat") %>%
  addHeatmap(lng=as.numeric(data2$lon),
             lat=as.numeric(data2$lat), radius = 10, blur = 20, minOpacity = 0.1, max = 0.25, cellSize = 5, group = "data2") %>% 
  
  addCircles(lng = ~lon, lat = ~lat, radius = 20, color = "blue", stroke = FALSE, fillOpacity = 0.4, group = "datetime", popup = ~datetime) %>% 
  addCircles(lng = satamat$lon, lat = satamat$lat, radius = 20, color = "green", stroke = TRUE, group = "satamat") %>% 
  addCircles(lng = kivet$lon, lat = kivet$lat, radius = 50, color = "gray", stroke = FALSE, group = "rock") %>% 
  addCircles(lng = kivet$lon, lat = kivet$lat, radius = 10, color = "black", stroke = TRUE, group = "rock") %>% addScaleBar('bottomleft') 


# https://mrjoh3.github.io/2018/07/25/filtering-spatial-data/ !!!!!!!!

# add logo gif https://r-spatial.github.io/mapview/articles/articles/mapview_06-add.html
map <- map %>% leafem::addLogo("https://jeroenooms.github.io/images/banana.gif",
                               position = "bottomleft",
                               offset.x = 5,
                               offset.y = 40,
                               width = 100,
                               height = 100)


# library(raster)
map <- map %>% leafem::addHomeButton(group = "rock") # https://r-spatial.github.io/mapview/articles/articles/mapview_06-add.html

map

# install.packages('leafem')
library(leafem)
img <- "https://www.r-project.org/logo/Rlogo.svg"

# img <- "https://cdn.fmi.fi/apps/sea-level-observation-graphs/plot.php?station=12"

library(leaflet.extras)
# map <- leaflet() %>% addTiles()
map <- addControlGPS(map, options = gpsOptions(position = "topleft", activate = TRUE, 
                                               autoCenter = TRUE, maxZoom = 15, 
                                               setView = TRUE))
map <- map %>% activateGPS() 

# map %>%  addMouseCoordinates() %>% addLogo(img, url = "https://cdn.fmi.fi/apps/sea-level-observation-graphs/", alpha = 0.5, width = 250, height = 200) # %>% frameWidget()   # activateGPS(map)

  # https://peerchristensen.netlify.app/post/mapping-street-art-with-leaflet-and-r/
 
 
# https://stackoverflow.com/questions/61058110/r-code-to-save-shiny-tag-list-to-html-as-the-viewer-export-save-as-web-page-bu
saveWidget(map,"C:\\github\\Rmap\\index.html", selfcontained = TRUE) # Fails with error
# C:\data\temp
saveWidget(map,"C:\\data\\temp\\index.html", selfcontained = TRUE) # Fails with error
mapshot(map,"C:\\github\\Rmap\\index.html") # Fails with same error
save_html(map,"C:\\github\\Rmap\\index.html") # Produces HTML with external dependencies


library(leaflet.providers)

providers.details$OpenTopoMap$u
providers.details$OpenTopoMap$options$attribution
providers$details

# Images on popup ---------------------
# https://peerchristensen.netlify.app/post/mapping-street-art-with-leaflet-and-r/

# install.packages('mapview')
library(mapview)
library(leafpop)
saa.lat <- 60.08
saa.lon <- 24.39
saa.remotepath <- "https://cdn.fmi.fi/apps/sea-level-observation-graphs/plot.php?station=12"
saa.aallonkorkeus.path <- "https://cdn.fmi.fi/apps/wave-height-graphs/wave-plot.php?station=5"
saa.title <- 'Veden korkeus ja tuuli'
saa.creator <- "https://cdn.fmi.fi/apps/sea-level-observation-graphs/"

saa.ilmatieteen <- "https://www.ilmatieteenlaitos.fi/merisaa-ja-itameri"



icon.glyphicon <- makeAwesomeIcon(icon = "flag", markerColor = "blue",
                                  iconColor = "black", library = "glyphicon",
                                  squareMarker =  TRUE)
icon.fa <- makeAwesomeIcon(icon = "flag", markerColor = "red", library = "fa",
                           iconColor = "black")
icon.ion <- makeAwesomeIcon(icon = "home", markerColor = "green",
                            library = "ion")

map <- map %>% addAwesomeMarkers(lng=saa.lon, lat=saa.lat,  icon = icon.ion,
                             # add popup with images and variables as text
                             popup=paste(popupImage(saa.remotepath, src = c("remote")),"<br>",
                                 popupImage(saa.aallonkorkeus.path, src = c("remote")),"<br>",
                                         "Title: ",paste("<a href=",saa.remotepath,">",saa.title,"</a>"),"<br>",
                                         "Creator: ",saa.creator,"<br>",
                                         "Merisää:", paste("<a href =", saa.ilmatieteen,">",saa.title,"</a>"), "<br>" 
                                         ),
                           
                             label = saa.title)




kartta.lat <- 60.12
kartta.lon <- 24.45
kartta.karttapaikka <- "https://asiointi.maanmittauslaitos.fi/karttapaikka/"
kartta.retkikartta <- "https://www.retkikartta.fi/" # syvyyskäyrät ym.
kartta.title <- "Kartat"

map <- map %>% addAwesomeMarkers(lng=kartta.lon, lat=kartta.lat,  icon = icon.fa,
                                 # add popup with images and variables as text
                                 popup=paste(
                                  #           popupImage(saa.aallonkorkeus.path, src = c("remote")),"<br>",
                                            # "Title: ",paste("<a href=",saa.remotepath,">",saa.title,"</a>"),"<br>",
                                            # "Creator: ",saa.creator,"<br>",
                                             "karttapaikka:", paste("<a href =", kartta.karttapaikka,">",kartta.title,"</a>"), "<br>", 
                                               "retkikartta:", paste("<a href =", kartta.retkikartta,">",kartta.title,"</a>"), "<br>",
                                             "aaltopoiju:", paste("<a href =", "https://aaltopoiju.fi/",">",kartta.title,"</a>"), "<br>",
                                             "Kapsi:", paste("<a href =", "https://kartat.kapsi.fi/leaflet.html",">",kartta.title,"</a>"), "<br>",
                                             "Oskari:", paste("<a href =", "https://julkinen.vayla.fi/oskari/",">",kartta.title,"</a>"), "<br>"
                                             
                                                                  
                                                                           
                                 ) ,
                                 
                                 label = kartta.title,
                                 labelOptions = labelOptions(noHide = TRUE, direction = "right", opacity = 0.4,
                                                             style = list(
                                                               "color" = "red",
                                                               "font-family" = "serif",
                                                               "font-style" = "italic",
                                                               "box-shadow" = "3px 3px rgba(0,0,0,0.25)",
                                                               "font-size" = "12px",
                                                               "border-color" = "rgba(0,0,0,0.5)"          ))
                                 )


map %>%  addMouseCoordinates() %>% addLogo(img, url = "https://www.r-project.org/logo/", alpha = 0.5, width = 25, height = 20) # %>% frameWidget()   # activateGPS(map)




# add logo: https://www.rdocumentation.org/packages/leafem/versions/0.0.1/topics/addLogo
# add image to popup: https://peerchristensen.netlify.app/post/mapping-street-art-with-leaflet-and-r/
# popups and labels: https://rstudio.github.io/leaflet/popups.html
# google places: export: https://www.joshkasuboski.com/posts/export-google-saved-places/
# ilmatieteenlaitos: https://www.ilmatieteenlaitos.fi/vedenkorkeus?6tTXW2UE9vY53MYkuE3x9d_q=length%253D1%2526station%253D12%2526lang%253Dfi
# vedenkorkeusennätykset: https://www.ilmatieteenlaitos.fi/vedenkorkeusennatykset-suomen-rannikolla
# add mouse coordinates: https://github.com/r-spatial/leafem
# heatmap: https://gis.stackexchange.com/questions/168886/r-how-to-build-heatmap-with-the-leaflet-package
# export sports tracker: https://ivanderevianko.com/2016/04/export-all-workouts-from-sports-tracker
# export sport one file: https://sports-tracker.helpshift.com/a/sports-tracker/?s=account&f=how-to-export-import-workouts&p=android
# sports diary: https://www.sports-tracker.com/diary
# open nautical chart: http://opennauticalchart.org/
# kartat kapsi, kiinteistörajat ja ilmakuva: https://kartat.kapsi.fi/leaflet.html
# kartat export pdf tiedostona: http://pikakartta.fi/

# HYVÄ! : https://julkinen.vayla.fi/oskari/
# ks. merikarttasarjat jne...





