library(osmdata)
library(sf)
library(leaflet)
library(magrittr)

getbb('district de Lausanne') %>% opq () %>% add_osm_feature("amenity", "pub") %>% osmdata_sf() %$% osm_points %>% leaflet() %>% addTiles() %>% addMarkers()

v <- getbb('Chateauneuf-du-Pape, France') %>% opq () %>% add_osm_feature("landuse", "vineyard") %>% osmdata_sf() %$% osm_polygons
names(v$geometry) <- NULL #ne pas oublier !!
leaflet() %>% addProviderTiles(providers$Hydda.Base) %>% addPolygons(data = v, color = "purple", weight = 1)



lieu <- 'Montreux, Suisse'

gir <- getbb(lieu) %>% opq () %>% add_osm_feature("junction", "roundabout") %>% 
  osmdata_sf() %$% 
  osm_polygons

names(gir$geometry) <- NULL

girprim <- subset(gir, gir$highway == 'primary')
girsecond <- subset(gir, gir$highway == 'secondary')
girter <- subset(gir, gir$highway == 'tertiary')


p <- getbb(lieu) %>% opq () %>% add_osm_feature("highway") %>% 
  osmdata_sf() %$%
  osm_lines 
  
names(p$geometry) <- NULL

summary(p$highway)

mw <- subset(p, p$highway %in% c('motorway','motorway_link'))
pm <- subset(p, p$highway == 'primary')
sec <- subset(p, p$highway == 'secondary')



leaflet() %>%    addProviderTiles(providers$Hydda.Base) %>% 
  addPolylines(data=p, color = "black", weight = 1)%>%
  addPolylines(data = mw, color = 'red', weight = 5) %>%
  addPolylines(data = pm, color = 'orange', weight = 3) %>%
  addPolylines(data = sec, color = 'yellow', weight = 3) %>%
  addPolygons(data = girprim, color = 'orange') %>%
  addPolygons(data = girsecond, color = 'yellow') %>%
  addPolygons(data = girter, color = 'black') 
  
