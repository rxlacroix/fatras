library(sf)
library(leaflet)
library(tidyverse)
library(openrouteservice)
library(geojsonsf)


ors_api_key() #clé api perso tu peux avoir la tienne sur https://openrouteservice.org/sign-up


coordinates <- list(c(4.605415, 44.305024), c(4.883257, 44.082031),c(4.940453,43.920740))

options <- list(
  maximum_speed = 90,
  avoid_features = "highways|tracks"
)

x <- ors_isochrones(coordinates, range = 60*60, interval = 6*60, 
                    profile = "driving-car",
                    options = options,parse_output = FALSE)

iso <- geojson_sf(x)


leaflet() %>% addProviderTiles(providers$OpenStreetMap) %>%
  addPolygons(data = iso$geometry[10], color = '#440154') %>% ## 60 min
  addPolygons(data = iso$geometry[9], color = '#472878') %>%
  addPolygons(data = iso$geometry[8], color = '#3e4a89') %>%
  addPolygons(data = iso$geometry[7], color = '#31688e') %>%
  addPolygons(data = iso$geometry[6], color = '#25838e') %>%
  addPolygons(data = iso$geometry[5], color = '#1e9e89') %>%
  addPolygons(data = iso$geometry[4], color = '#35b779') %>%
  addPolygons(data = iso$geometry[3], color = '#6cce59') %>%
  addPolygons(data = iso$geometry[2], color = '#b5de2c') %>%
  addPolygons(data = iso$geometry[1], color = '#fde725')     ## 6 min


zone_max <- st_union(iso$geometry[10], iso$geometry[20])
zone_max <- st_union(zone_max, iso$geometry[30])

leaflet() %>% addProviderTiles(providers$OpenStreetMap) %>%
  addPolygons(data = zone_max, color = '#440154') 


for (i in c(10,9,8,7,6,5,4,3,2)) {
  iso$geometry[i] <- st_difference(iso$geometry[i], iso$geometry[i-1])
}

for (i in c(20,19,18,17,16,15,14,13,12)) {
  iso$geometry[i] <- st_difference(iso$geometry[i], iso$geometry[i-1])
}

for (i in c(30,29,28,27,26,25,24,23,22)) {
  iso$geometry[i] <- st_difference(iso$geometry[i], iso$geometry[i-1])
}

leaflet() %>% addProviderTiles(providers$OpenStreetMap) %>%
  addPolygons(data = iso$geometry[10], color = '#440154', weight = 0.5) %>%
  addPolygons(data = iso$geometry[9], color = '#472878',weight = 0.5) %>%
  addPolygons(data = iso$geometry[8], color = '#3e4a89',weight = 0.5) %>%
  addPolygons(data = iso$geometry[7], color = '#31688e',weight = 0.5) %>%
  addPolygons(data = iso$geometry[6], color = '#25838e',weight = 0.5) %>%
  addPolygons(data = iso$geometry[5], color = '#1e9e89',weight = 0.5) %>%
  addPolygons(data = iso$geometry[4], color = '#35b779',weight = 0.5) %>%
  addPolygons(data = iso$geometry[3], color = '#6cce59',weight = 0.5) %>%
  addPolygons(data = iso$geometry[2], color = '#b5de2c',weight = 0.5) %>%
  addPolygons(data = iso$geometry[1], color = '#fde725',weight = 0.5)     ## 6 min



iso_opti1 <- iso

leaflet() %>% addProviderTiles(providers$OpenStreetMap) %>%
  addPolygons(data = iso$geometry[10], color = 'blue', weight = 0.5) %>%
  addPolygons(data = iso$geometry[19], color = 'red',weight = 0.5) 
  

for (i in c(10,9,8,7,6,5,4,3,2)) {
  if(i+9 >10 ) {
    iso_opti1$geometry[i] <- st_difference(iso_opti1$geometry[i],iso_opti1$geometry[i+9])
    iso_opti1$geometry[i] <- st_difference(iso_opti1$geometry[i],iso_opti1$geometry[i+8])
    iso_opti1$geometry[i] <- st_difference(iso_opti1$geometry[i],iso_opti1$geometry[i+7])
    iso_opti1$geometry[i] <- st_difference(iso_opti1$geometry[i],iso_opti1$geometry[i+6])
    iso_opti1$geometry[i] <- st_difference(iso_opti1$geometry[i],iso_opti1$geometry[i+5])
    iso_opti1$geometry[i] <- st_difference(iso_opti1$geometry[i],iso_opti1$geometry[i+4])
    iso_opti1$geometry[i] <- st_difference(iso_opti1$geometry[i],iso_opti1$geometry[i+3])
    iso_opti1$geometry[i] <- st_difference(iso_opti1$geometry[i],iso_opti1$geometry[i+2])
    iso_opti1$geometry[i] <- st_difference(iso_opti1$geometry[i],iso_opti1$geometry[i+1])
  }
}

leaflet() %>% addProviderTiles(providers$OpenStreetMap) %>%
  addPolygons(data = iso_opti1$geometry[10], color = '#440154', weight = 0.5) %>%
  addPolygons(data = iso_opti1$geometry[9], color = '#472878',weight = 0.5) %>%
  addPolygons(data = iso_opti1$geometry[8], color = '#3e4a89',weight = 0.5) %>%
  addPolygons(data = iso_opti1$geometry[7], color = '#31688e',weight = 0.5) %>%
  addPolygons(data = iso_opti1$geometry[6], color = '#25838e',weight = 0.5) %>%
  addPolygons(data = iso_opti1$geometry[5], color = '#1e9e89',weight = 0.5) %>%
  addPolygons(data = iso_opti1$geometry[4], color = '#35b779',weight = 0.5) %>%
  addPolygons(data = iso_opti1$geometry[3], color = '#6cce59',weight = 0.5) %>%
  addPolygons(data = iso_opti1$geometry[2], color = '#b5de2c',weight = 0.5) %>%
  addPolygons(data = iso_opti1$geometry[1], color = '#fde725',weight = 0.5)     ## 6 min


## equidistance


iso_equi <- iso

for (i in c(10,9,8,7,6,5,4,3,2,1)) {
  iso_equi$geometry[i] <- st_intersection(iso_equi$geometry[i],iso_equi$geometry[i+10])
}

for (i in c(10,9,8,7,6,5,4,3,2,1)) {
  if(length(st_intersection(iso_equi$geometry[i],iso_equi$geometry[i+10])) < 1) {
    iso_equi$geometry[i] <- NULL
  }
}
for (i in 10:1) {
  iso_equi$geometry[i] <- st_cast(iso_equi$geometry[i], "MULTIPOLYGON")
}

plot(iso_equi$geometry[10], col = '#25838e')
plot(iso_equi$geometry[9], col = '#1e9e89', add=TRUE)
plot(iso_equi$geometry[8], col = '#35b779', add=TRUE)
plot(iso_equi$geometry[7], col = '#1e9e89', add=TRUE)
plot(iso_equi$geometry[6], col = '#b5de2c', add=TRUE)
plot(iso_equi$geometry[5], col = '#fde725', add=TRUE)



leaflet() %>% addProviderTiles(providers$OpenStreetMap) %>% #marche pas sfc collection
  addPolygons(data = iso_equi$geometry[10], color = '#440154', weight = 0.5)
  addPolygons(data = iso_equi$geometry[9], color = '#472878',weight = 0.5) %>%
  addPolygons(data = iso_equi$geometry[8], color = '#3e4a89',weight = 0.5) %>%
  addPolygons(data = iso_equi$geometry[7], color = '#31688e',weight = 0.5) %>%
  addPolygons(data = iso_equi$geometry[6], color = '#25838e',weight = 0.5) %>%
  addPolygons(data = iso_equi$geometry[5], color = '#1e9e89',weight = 0.5) %>%
  addPolygons(data = iso_equi$geometry[4], color = '#35b779',weight = 0.5) %>%
  addPolygons(data = iso_equi$geometry[3], color = '#1e9e89',weight = 0.5) %>%
  addPolygons(data = iso_equi$geometry[2], color = '#b5de2c',weight = 0.5) %>%
  addPolygons(data = iso_equi$geometry[1], color = '#fde725',weight = 0.5)     ## 6 min
