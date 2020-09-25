# https://cran.r-project.org/web/packages/geoviz/vignettes/hawaii_mapzen_dem.html

# install.packages('geoviz')

library(geoviz)

# install.packages('rayshader')

library(rayshader)

# Coordinates for Hawaii
lat = 19.593335
lon = -155.4880287
square_km = 50

# coordinates madagascar mauritius
lat = -20.2683077
lon = 57.4398897
square_km = 40

# Set max tiles to request from 'mapzen' and 'stamen'.
# Increase this for a higher resolution image.
max_tiles = 10 # 10

# Get elevation data. Increase max_tiles for a higher resolution image.
# Set max_tiles = 40 to reproduce the example above.
dem <- mapzen_dem(lat, lon, square_km, max_tiles = max_tiles)

# Get a stamen overlay (or a satellite overlay etc. by changing image_source)
overlay_image <-
  slippy_overlay(dem,
                 image_source = "stamen",
                 image_type = "watercolor",
                 png_opacity = 0.3,
                 max_tiles = max_tiles)

# Render the 'rayshader' scene.

elmat = matrix(
  raster::extract(dem, raster::extent(dem), method = 'bilinear'),
  nrow = ncol(dem),
  ncol = nrow(dem)
)

scene <- elmat %>%
  sphere_shade(sunangle = 270, texture = "bw") %>% 
  add_overlay(overlay_image)  # %>% 

#  For a slower but higher quality render with more realistic shadows (see 'rayshader' documentation)
#  add_shadow(
#    ray_shade(
#      elmat,
#      anglebreaks = seq(30, 60),
#      sunangle = 270,
#      multicore = TRUE,
#      lambert = FALSE,
#      remove_edges = FALSE
#    )
#  ) %>%
#  add_shadow(ambient_shade(elmat, multicore = TRUE, remove_edges = FALSE))


rayshader::plot_3d(
  scene,
  elmat,
  zscale = raster_zscale(dem) / 3,  #exaggerate elevation by 3x 
  solid = TRUE,
  shadow = FALSE,
  soliddepth = -raster_zscale(dem),
  water=TRUE,
  waterdepth = -40,
  wateralpha = 0.3,
  watercolor = "lightblue",
  waterlinecolor = "white",
  waterlinealpha = 0.3
)

rayshader::render_depth(
  focus = 0.3,
  fstop = 18,
  filename = "C:\\data\\temp\\LIDAR2.png")



rgl::view3d(theta =180, phi = 18, zoom = 1.3, fov = 5)
rgl::view3d(theta = 20, phi = 18, zoom = 0.3, fov = 3)


render_camera(fov = 0, theta = 60, zoom = 2.75, phi = 45)
render_scalebar(limits=c(0, 5, 10),label_unit = "km",position = "W", y=50,
                scale_length = c(0.33,1))
render_compass(position = "E")
render_snapshot(clear=TRUE)



rayshader::render_depth(
  focus = 0.3,
  fstop = 18,
  filename = "C:\\data\\temp\\LIDAR.png")




# https://www.rayshader.com/




-20.2683077,57.4598897


montereybay %>% 
  sphere_shade(zscale = 10, texture = "imhof1") %>% 
  add_shadow(montshadow, 0.5) %>%
  add_shadow(montamb,0) %>%
  plot_3d(montereybay, zscale = 50, fov = 0, theta = -100, phi = 30, windowsize = c(1000, 800), zoom = 0.6,
          water = TRUE, waterdepth = 0, waterlinecolor = "white", waterlinealpha = 0.5,
          wateralpha = 0.5, watercolor = "lightblue")
render_label(montereybay, x = 350, y = 160, z = 1000, zscale = 50,
             text = "Moss Landing", textsize = 2, linewidth = 5)
render_label(montereybay, x = 220, y = 70, z = 7000, zscale = 50,
             text = "Santa Cruz", textcolor = "darkred", linecolor = "darkred",
             textsize = 2, linewidth = 5)
render_label(montereybay, x = 300, y = 270, z = 4000, zscale = 50,
             text = "Monterey", dashed = TRUE, textsize = 2, linewidth = 5)
render_label(montereybay, x = 50, y = 270, z = 1000, zscale = 50,  textcolor = "white", linecolor = "white",
             text = "Monterey Canyon", relativez = FALSE, textsize = 2, linewidth = 5) 
Sys.sleep(0.2)
render_snapshot(clear=TRUE)


