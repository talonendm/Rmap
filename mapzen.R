# mapzen.R
# https://tarakc02.github.io/rmapzen/
install.packages("rmapzen")
# load rmapzen and run provider set-up functions

# You’ll also need to set up options specific to the API provider you end up using. rmapzen works with API providers who implement the Mapzen API. In order to specify provider information (such as URL and API key), use mz_set_host. There are custom set-up functions for the following providers:
#   
#   geocode.earth, for search services. Use the function mz_set_search_host_geocode.earth
# Nextzen, for vector tiles. Use the function mz_set_tile_host_nextzen.
# NYC GeoSearch, for search services using New York City’s Property Address Directory. Use mz_set_search_host_nyc_geosearch.


library(rmapzen)
# mz_set_tile_host_nextzen()
# mz_set_search_host_geocode.earth()
mz_set_search_host_nyc_geosearch()  # cool this works!!! 18.9.2020

?mz_set_host

oakland_public <- mz_search("Oakland Public Library Branch", 
                            size = 20, focus.point = mz_geocode("Oakland, CA"))
oakland_public


mz_geocode("UC Berkeley, Berkeley, CA")



library(tidyverse)
library(sf)

# mz_bbox is a generic that returns the bounding box of an object
oakland_tiles <- mz_vector_tiles(mz_bbox(oakland_public))

# vector tiles return all layers (roads, water, buildings, etc) in a list
roads <- as_sf(oakland_tiles$roads) %>% 
  filter(kind != "ferry")
water <- as_sf(oakland_tiles$water)

labels <- as.data.frame(oakland_public) %>% 
  mutate(name = str_replace_all(
    name, 
    "(Oakland Public Library)|(Branch)", ""))

# make a quick static map that includes roads and oceans as reference
ggplot() +
  geom_sf(data = water, 
          fill = "lightblue", colour = NA) + 
  geom_sf(data = roads, 
          size = .2, colour = "gray30") + 
  geom_sf(data = as_sf(oakland_public), 
          colour = "black", size = 1) + 
  ggrepel::geom_label_repel(
    data = labels,
    aes(x = lon, y = lat, label = name), size = 3,
    family = "Roboto Condensed", label.padding = unit(.1, "lines"),
    alpha = .7) +
  theme_void() + 
  theme(panel.grid.major = element_line(size = 0))

