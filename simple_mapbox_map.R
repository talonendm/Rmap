# simple_mapbox_map.R

# apikey: ------------
# https://www.r-bloggers.com/2020/09/running-an-r-script-on-a-schedule-gh-actions/
# How do you add them to your local environment?
#   
#   Create a .Renviron file in your local project
# add a new line to your .gitignore file: .Renviron
# Now this file with secrets will be ignored by git and you
# can never accidentely add it to a repo.
# the .Renviron file is a simple text file where you can add ‘secrets’ like: apikey="aVerY5eCretKEy" on a new line.


# at github: https://github.com/talonendm/Rmap/settings/secrets
p <- list()
p$mapboxkey <- Sys.getenv("MAPBOX_TOKEN") # note restart session if not working at first time


library(plotKML)
library(dplyr)
gpxlist <- c('9_21_20 16_53.gpx')
gpxfiles <- paste0('C:\\data\\sportstracker_ebike\\',gpxlist)
gpxfiles
gpxfiles <- 'https://github.com/talonendm/Rmap/blob/master/data/ebike/9_21_20%2016_53.gpx'


df <- readLines(gpxfiles)

fells_loop <- readGPX("http://www.topografix.com/fells_loop.gpx")
str(fells_loop)


# .....................................
loca <- list()
i <- 0
for (file_i in gpxfiles) {
  i <- i + 1
  da <- readGPX(file_i, metadata = FALSE, bounds = FALSE, waypoints = FALSE, tracks = TRUE, routes = FALSE)
  loca[[i]] <- data.frame(da$tracks)
}

data <- rbind_list(loca) %>% dplyr::select(lat = NA.lat, lon = NA.lon, datetime = NA.time)
head(data)





library(mapdeck)
options(mapbox.accessToken = p$mapboxkey)
library(mapdeck)
library(widgetframe)
library(dplyr)

# restricted not working:
# https://stackoverflow.com/questions/57764179/mapbox-access-token-restrict-to-url-does-not-work-with-github-pages

df <- data
df <- df[!is.na(df$lon), ]

location = as.vector(c(df$lon[1], df$lat[1]))


# do not use in html and export file: token = p$mapboxkey / MAPBOX_TOKEN
mapdeck(location = location, style = mapdeck_style("outdoors") , pitch = 40, zoom = 11, show_view_state = FALSE ) %>%
  add_heatmap(
    data = df
    , lat = "lat"
    , lon = "lon"
    , weight = "weight"
    , colour_range = colourvalues::colour_values(1:6, palette = "inferno")
    , update_view = FALSE
  )

# update field:  https://stackoverflow.com/questions/56171231/add-polygon-in-mapdeck-zooms-out-the-map 

# Access Tokens
# If the token argument is not used, the map will search for the token, firstly by checking if set_token() was used, then it will search environment variables using Sys.getenv() and the following values, in this order
# c("MAPBOX_TOKEN","MAPBOX_KEY","MAPBOX_API_TOKEN", "MAPBOX_API_KEY", "MAPBOX", "MAPDECK")
# If multiple tokens are found, the first one is used
