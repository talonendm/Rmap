# Rcode_clean.R

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

library(plotKML)

library(sf)
library(dplyr)
library(leaflet)
library(crosstalk)
library(lubridate)
library(htmltools)

library(widgetframe)


# install.packages('mapview')
library(leaflet.providers)
library(mapview)
library(leafpop)

# install.packages('leafem')
library(leafem)


# .....................................
# Local sports tracker files ---------------
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

gpxlist <- c('9_21_20 16_53.gpx')


gpxfiles <- paste0('C:\\data\\sportstracker\\',gpxlist)
gpxfiles <- paste0('C:\\data\\sportstracker_ebike\\',gpxlist)
gpxfiles
# .....................................
boat <- list()
i <- 0
for (file_i in gpxfiles) {
  i <- i + 1
  da <- readGPX(file_i, metadata = FALSE, bounds = FALSE, waypoints = FALSE, tracks = TRUE, routes = FALSE)
  boat[[i]] <- data.frame(da$tracks)
}

data <- rbind_list(boat) %>% dplyr::select(lat = NA.lat, lon = NA.lon, datetime = NA.time)
head(data)
# .....................................
# exclude some data: land etc.
# .....................................
data <- data %>% dplyr::filter(datetime < '2020-05-05T17:59:00Z' | datetime > '2020-05-05T20:08:52Z')
data <- data %>% dplyr::filter(datetime < '2014-09-12T15:30:56Z' | datetime > '2014-09-12T15:55:05Z')
data <- data %>% dplyr::filter(datetime < '2020-08-21T05:40:02Z' | datetime > '2020-08-21T07:12:07Z') # island
data <- data %>% dplyr::filter(datetime < '2008-08-31T11:36:08Z' | datetime > '2008-08-31T11:47:08Z')

# .....................................
# drop data --------------
# .....................................
data2 <- data

data2$rlat <- round(data2$lat, 3)
data2$rlon <- round(data2$lon, 3)

data2 <- data2[!duplicated(data2[c("rlat","rlon")]),]

datameta <- data2

# https://stackoverflow.com/questions/44700868/way-to-add-hyperlink-to-leaflet-popup-in-shiny
datameta$info <- paste0(datameta$datetime, 
                        '<br><a href = "https://merella.0100100.fi/#map=14/0',datameta$lon,'/',datameta$lat,'">merella.0100100.fi</a><br>',
                        '<br><br><a href = "https://kirkkonummi.karttatiimi.fi/link/2kHsTT"> kirkkonummi.karttatiimi.fi </a><br>') # also zoom could be selected from map.. in shiny

# https://kirkkonummi.karttatiimi.fi/link/2kHsTT


# .....................................



# .....................................
# rocks, shoals, shallow water -------------- 
# .....................................


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


#
# harbours, ports ------------
#

placelist <- c(60.056564, 24.290942,
               60.055644,24.289828,
               60.039796, 24.272322,
               60.041891, 24.270921,
               60.032493, 24.271208,
               60.028414, 24.278200,
               60.019014, 24.425212,
               60.0420453,24.6003561,
               60.086700, 24.743100
               
)

# .....................................
# point data as data frames ------------
# .....................................
kivet <- data.frame(lat = kivilist[seq(1,length(kivilist),2)], lon = kivilist[seq(2,length(kivilist),2)])
satamat <- data.frame(lat = placelist[seq(1,length(placelist),2)], lon = placelist[seq(2,length(placelist),2)])
# .....................................


# .....................................
# leaflet map -----------
# .....................................


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
  
  addCircles(lng = ~lon, lat = ~lat, radius = 20, color = "blue", stroke = FALSE, fillOpacity = 0.4, group = "datetime", popup = ~info) %>% 
  addCircles(lng = satamat$lon, lat = satamat$lat, radius = 20, color = "green", stroke = TRUE, group = "satamat") %>% 
  addCircles(lng = kivet$lon, lat = kivet$lat, radius = 50, color = "gray", stroke = FALSE, group = "rock") %>% 
  addCircles(lng = kivet$lon, lat = kivet$lat, radius = 10, color = "black", stroke = TRUE, group = "rock") %>% addScaleBar('bottomleft') 




# .....................................
# logo
# .....................................
# add logo gif https://r-spatial.github.io/mapview/articles/articles/mapview_06-add.html
map <- map %>% leafem::addLogo("https://jeroenooms.github.io/images/banana.gif",
                               position = "bottomleft",
                               offset.x = 5,
                               offset.y = 40,
                               width = 50,
                               height = 50, alpha = 0.6)


# library(raster)
map <- map %>% leafem::addHomeButton(group = "rock" )#  %>% leafem::addHomeButton(group = "satamat" ) # https://r-spatial.github.io/mapview/articles/articles/mapview_06-add.html

# map


img <- "https://www.r-project.org/logo/Rlogo.svg"

# img <- "https://cdn.fmi.fi/apps/sea-level-observation-graphs/plot.php?station=12"

library(leaflet.extras)
# map <- leaflet() %>% addTiles()
map <- addControlGPS(map, options = gpsOptions(position = "topleft", activate = TRUE, 
                                               autoCenter = TRUE, maxZoom = 15, 
                                               setView = TRUE))
map <- map %>% deactivateGPS()
map <- map %>% activateGPS() 

# map %>%  addMouseCoordinates() %>% addLogo(img, url = "https://cdn.fmi.fi/apps/sea-level-observation-graphs/", alpha = 0.5, width = 250, height = 200) # %>% frameWidget()   # activateGPS(map)

# https://peerchristensen.netlify.app/post/mapping-street-art-with-leaflet-and-r/


# # https://stackoverflow.com/questions/61058110/r-code-to-save-shiny-tag-list-to-html-as-the-viewer-export-save-as-web-page-bu
# saveWidget(map,"C:\\github\\Rmap\\index.html", selfcontained = TRUE) # Fails with error
# # C:\data\temp
# saveWidget(map,"C:\\data\\temp\\index.html", selfcontained = TRUE) # Fails with error
# mapshot(map,"C:\\github\\Rmap\\index.html") # Fails with same error
# save_html(map,"C:\\github\\Rmap\\index.html") # Produces HTML with external dependencies

# 
# providers.details$OpenTopoMap$u
# providers.details$OpenTopoMap$options$attribution
# providers$details

# Images on popup ---------------------
# https://peerchristensen.netlify.app/post/mapping-street-art-with-leaflet-and-r/



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



library(leafem)
map %>%  addMouseCoordinates() %>% addLogo(img, url = "https://www.r-project.org/logo/", alpha = 0.5, width = 30, height = 30) # %>% frameWidget()   # activateGPS(map)




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
# Crosstalk - disabled: https://mrjoh3.github.io/2018/07/25/filtering-spatial-data/ !!!!!!!!

# more:
# https://www.marinetraffic.com/fr/ais/home/centerx:24.343/centery:60.043/zoom:13
# turva: https://www.marinetraffic.com/fr/ais/home/shipid:3772/zoom:14
# syvyys: https://merella.0100100.fi/#map=12.99/60.07693/24.35356
# merikartat: https://merella.0100100.fi/#map=13.82/60.07818/24.35088

# linkit kiviin ja satamiin:
# https://www.marinetraffic.com/fr/ais/home/centerx:24.289/centery:60.025/zoom:17
# automaattisesti...
# valmiit linkit suoraan. tarkka satelliittikuva.
# https://kirkkonummi.karttatiimi.fi/link/2kCR5m



