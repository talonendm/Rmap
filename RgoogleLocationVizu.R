# RgoogleLocationVizu.R

p <- list()
p$path_semantic <- 'C:\\data\\googleExport200918\\takeout-20200917T160945Z-001\\Takeout\\Location History\\Semantic Location History\\2020\\'
p$file_semantic <- '2020_SEPTEMBER.json'
p$file_semantic <- '2020_AUGUST.json'

p$path_location_history <- 'C:\\data\\googleExport200918\\takeout-20200917T160945Z-001\\Takeout\\Location History\\'
p$file_history <- 'Location History.json'
  
library(jsonlite)

d0 <- jsonlite::fromJSON(readLines(paste0(p$path_semantic, p$file_semantic)))

d1 <- d0$timelineObjects
d1.place.location <- d1$placeVisit$duration


d0a <- jsonlite::fromJSON((paste0(p$path_semantic, p$file_semantic)))
d0a$timelineObjects$activitySegment$activities
length(d0a$timelineObjects$activitySegment$activities)


# probabilities of the activity ------------------
activities <- list()
for (i in c(1:length(d0a$timelineObjects$activitySegment$activities))) {
  if (!is.null(d0a$timelineObjects$activitySegment$activities[[i]])) {
  activities[[i]] <- d0a$timelineObjects$activitySegment$activities[[i]]
  activities[[i]]$probability <- round(activities[[i]]$probability,3)
  activities[[i]]$dataset <- i
  }
}
activities2 <- rbind_list(activities)


d0a$timelineObjects$activitySegment$activityType
d0a$timelineObjects$placeVisit$location
d0a$timelineObjects$activitySegment$waypointPath$waypoints
loc = d0$locations
loc
d0$timelineObjects$placeVisit$location

# https://econsultsolutions.com/google-takeout-data/
# https://gist.github.com/cxbonilla/7e520c2a660be90abe433f2ad7dc6362

## VARIABLES
google.location.data <- fromJSON(readLines(paste0(p$path_location_history, p$file_history)), flatten = TRUE)
google.locations <- google.location.data$locations
rm(google.location.data)  # freeing up memory
Sys.getlocale()
# Sys.setlocale("LC_TIME", "C")
head(google.locations)

google.locations$timekeeping <- as.POSIXct(as.numeric(google.locations$timestampMs)/1000, origin="1970-01-01")
google.locations$weekdays <- factor(format(google.locations$timekeeping, "%a"), 
                                    levels = c("Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"))
date.diff <- max(google.locations$timekeeping) - min(google.locations$timekeeping)
measurements.per.hour <- (nrow(google.locations)/as.numeric(date.diff))/24  # number of measurements per hour
measurements.per.minute <- measurements.per.hour/60  # number of measurements per minute
measurement.interval <- 60/measurements.per.hour  # number of minutes per measurement


#oma 
google.locations$timediff <- lag(google.locations$timekeeping)
google.locations$timediff <- difftime(google.locations$timekeeping, google.locations$timediff, units = "secs")

head(google.locations)

summary(google.locations$accuracy)
summary(google.locations$altitude)

glo <- google.locations
glo <- google.locations %>% dplyr::filter(altitude < 800)
glo <- glo %>% dplyr::filter(accuracy < 60)

summary(glo$accuracy)
summary(glo$altitude)

summary(as.numeric(google.locations$timediff))
plot(sample_n(as.numeric(google.locations$timediff), 1000)) # slow if whole data.

## HEATMAP
ldf <- data.frame(t=rep(0,nrow(glo)))
ldf$t <- as.numeric(glo$timestampMs)/1000
class(ldf$t) <- 'POSIXct'
ldf$lat <- as.numeric(glo$latitudeE7/1E7)
ldf$lon <- as.numeric(glo$longitudeE7/1E7)

head(ldf)

# .............................................................
# https://martijnvanvreeden.nl/analysing-google-location-data/


data <- ldf[1:100000,]


data2 <- ldf
head(ldf)
data2$rlat <- round(data2$lat, 3)
data2$rlon <- round(data2$lon, 3)

data2 <- data2[!duplicated(data2[c("rlat","rlon")]),]

data <- ldf # data2
data <- ldf %>% dplyr::filter(t >= as.POSIXct('2020-01-01'))
class(data$t)

map <- leaflet() %>% # leaflet(datameta, width = '100%', height = '100%') %>%  
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
             radius = 2, blur = 1, minOpacity = 0.2, max = 0.25, cellSize = 1, group = "boat")



map

