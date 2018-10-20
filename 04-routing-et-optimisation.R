library(sf)
library(leaflet)
library(tidyverse)
library(RColorBrewer)
library(openrouteservice)

# test de l'api (les options marchent pas)

ors_api_key() #clé api perso tu peux avoir la tienne sur https://openrouteservice.org/sign-up


coordinates <- list(c(4.605415, 44.305024), c(4.883257, 44.082031))

x <- ors_isochrones(coordinates, range = 60*60, interval = 6*60, 
                    profile = "driving-car")



# set isochrones color
ranges <- x$info$query$ranges
pal <- brewer.pal(length(ranges), name = "Spectral")


x$features <- lapply(1:length(x$features), function(i) {
  feature <- x$features[[i]]
  range <- feature$properties$value
  
  ## set style
  col <- pal[which(ranges == range)]
  feature$properties$style <- list(color = col, fillColor = col, fillOpacity=0.5)
  
  ## restrict polygon to current level only
  if (range > ranges[1])
    feature$geometry$coordinates <-
    c(feature$geometry$coordinates, x$features[[i-1]]$geometry$coordinates)
  
  feature
})

leaflet() %>%
  addTiles() %>%
  addGeoJSON(x) %>%
  fitBBox(x$bbox)



## https://maps.openrouteservice.org

## isochrones 0-60 min toutes les 6 min, évite les autoroutes et ferry, exporter en geojson


celi <- read_sf("ors-export-polygon_cel.geojson")

lys <- read_sf("ors-export-polygon_lys.geojson")

lau <- read_sf("ors-export-polygon_lau.geojson")

zone_max <- st_union(celi$geometry[10], lys$geometry[10])
zone_max <- st_union(zone_max, lau$geometry[10])

leaflet() %>% addProviderTiles(providers$OpenStreetMap) %>%
  addPolygons(data = zone_max, color = '#440154') 

celi_zone_10 <- st_difference(celi$geometry[10],celi$geometry[9])
celi_zone_9 <- st_difference(celi$geometry[9],celi$geometry[8])
celi_zone_8 <- st_difference(celi$geometry[8],celi$geometry[7])
celi_zone_7 <- st_difference(celi$geometry[7],celi$geometry[6])
celi_zone_6 <- st_difference(celi$geometry[6],celi$geometry[5])
celi_zone_5 <- st_difference(celi$geometry[5],celi$geometry[4])
celi_zone_4 <- st_difference(celi$geometry[4],celi$geometry[3])
celi_zone_3 <- st_difference(celi$geometry[3],celi$geometry[2])
celi_zone_2 <- st_difference(celi$geometry[2],celi$geometry[1])
celi_zone_1 <- celi$geometry[1]


leaflet() %>% addProviderTiles(providers$OpenStreetMap) %>%
  addPolygons(data = celi_zone_10, color = '#440154') %>% ## 60 min
  addPolygons(data = celi_zone_9, color = '#472878') %>%
  addPolygons(data = celi_zone_8, color = '#3e4a89') %>%
  addPolygons(data = celi_zone_7, color = '#31688e') %>%
  addPolygons(data = celi_zone_6, color = '#25838e') %>%
  addPolygons(data = celi_zone_5, color = '#1e9e89') %>%
  addPolygons(data = celi_zone_4, color = '#35b779') %>%
  addPolygons(data = celi_zone_3, color = '#6cce59') %>%
  addPolygons(data = celi_zone_2, color = '#b5de2c') %>%
  addPolygons(data = celi_zone_1, color = '#fde725')     ## 6 min


lau_zone_10 <- st_difference(lau$geometry[10],lau$geometry[9])
lau_zone_9 <- st_difference(lau$geometry[9],lau$geometry[8])
lau_zone_8 <- st_difference(lau$geometry[8],lau$geometry[7])
lau_zone_7 <- st_difference(lau$geometry[7],lau$geometry[6])
lau_zone_6 <- st_difference(lau$geometry[6],lau$geometry[5])
lau_zone_5 <- st_difference(lau$geometry[5],lau$geometry[4])
lau_zone_4 <- st_difference(lau$geometry[4],lau$geometry[3])
lau_zone_3 <- st_difference(lau$geometry[3],lau$geometry[2])
lau_zone_2 <- st_difference(lau$geometry[2],lau$geometry[1])
lau_zone_1 <- lau$geometry[1]

plot(celi_zone_10, col= 'blue')
plot(lau_zone_9, col= rgb(1, 0, 0,0.5), add= TRUE)

celiw10_9 <- st_difference(celi_zone_10, lau_zone_9)
celiw10_8 <- st_difference(celiw10_9, lau_zone_8)
celiw10_7 <- st_difference(celiw10_8, lau_zone_7)
celiw10_6 <- st_difference(celiw10_7, lau_zone_6)
celiw10_5 <- st_difference(celiw10_6, lau_zone_5)
celiw10_4 <- st_difference(celiw10_5, lau_zone_4)
celiw10_3 <- st_difference(celiw10_4, lau_zone_3)
celiw10_2 <- st_difference(celiw10_3, lau_zone_2)
celiw10_1 <- st_difference(celiw10_2, lau_zone_1)

celiw9_8 <- st_difference(celi_zone_9, lau_zone_8)
celiw9_7 <- st_difference(celiw9_8, lau_zone_7)
celiw9_6 <- st_difference(celiw9_7, lau_zone_6)
celiw9_5 <- st_difference(celiw9_6, lau_zone_5)
celiw9_4 <- st_difference(celiw9_5, lau_zone_4)
celiw9_3 <- st_difference(celiw9_4, lau_zone_3)
celiw9_2 <- st_difference(celiw9_3, lau_zone_2)
celiw9_1 <- st_difference(celiw9_2, lau_zone_1)

celiw8_7 <- st_difference(celi_zone_8, lau_zone_7)
celiw8_6 <- st_difference(celiw8_7, lau_zone_6)
celiw8_5 <- st_difference(celiw8_6, lau_zone_5)
celiw8_4 <- st_difference(celiw8_5, lau_zone_4)
celiw8_3 <- st_difference(celiw8_4, lau_zone_3)
celiw8_2 <- st_difference(celiw8_3, lau_zone_2)
celiw8_1 <- st_difference(celiw8_2, lau_zone_1)

celiw7_6 <- st_difference(celi_zone_7, lau_zone_6)
celiw7_5 <- st_difference(celiw7_6, lau_zone_5)
celiw7_4 <- st_difference(celiw7_5, lau_zone_4)
celiw7_3 <- st_difference(celiw7_4, lau_zone_3)
celiw7_2 <- st_difference(celiw7_3, lau_zone_2)
celiw7_1 <- st_difference(celiw7_2, lau_zone_1)

celiw6_5 <- st_difference(celi_zone_6, lau_zone_5)
celiw6_4 <- st_difference(celiw6_5, lau_zone_4)
celiw6_3 <- st_difference(celiw6_4, lau_zone_3)
celiw6_2 <- st_difference(celiw6_3, lau_zone_2)
celiw6_1 <- st_difference(celiw6_2, lau_zone_1)

celiw5_4 <- st_difference(celi_zone_5, lau_zone_4)
celiw5_3 <- st_difference(celiw5_4, lau_zone_3)
celiw5_2 <- st_difference(celiw5_3, lau_zone_2)
celiw5_1 <- st_difference(celiw5_2, lau_zone_1)

celiw4_3 <- st_difference(celi_zone_4, lau_zone_3)
celiw4_2 <- st_difference(celiw4_3, lau_zone_2)
celiw4_1 <- st_difference(celiw4_2, lau_zone_1)

celiw3_2 <- st_difference(celi_zone_3, lau_zone_2)
celiw3_1 <- st_difference(celiw3_2, lau_zone_1)


celiw2_1 <- st_difference(celi_zone_2, lau_zone_1)

celiw1_1 <- st_difference(celi_zone_1, lau_zone_1)


plot(celi$geometry[10])
plot(celiw10_1, col= '#440154', add=TRUE)
plot(celiw9_1, col= '#472878', add=TRUE)
plot(celiw8_1, col= '#3e4a89', add=TRUE)
plot(celiw7_1, col= '#31688e', add=TRUE)
plot(celiw6_1, col= '#25838e', add=TRUE)
plot(celiw5_1, col= '#1e9e89', add=TRUE)
plot(celiw4_1, col= '#35b779', add=TRUE)
plot(celiw3_1, col= '#6cce59', add=TRUE)
plot(celiw2_1, col= '#b5de2c', add=TRUE)
plot(celiw1_1, col= '#fde725', add=TRUE)


## equidistance

plot(st_intersection(celi_zone_10, lau_zone_10), col= 'red', add=TRUE) # oui
plot(st_intersection(celi_zone_9, lau_zone_9), col= 'red', add=TRUE) # oui
plot(st_intersection(celi_zone_8, lau_zone_8), col= 'red', add=TRUE) # oui
plot(st_intersection(celi_zone_7, lau_zone_7), col= 'red', add=TRUE) # oui
plot(st_intersection(celi_zone_6, lau_zone_6), col= 'red', add=TRUE) # oui
plot(st_intersection(celi_zone_5, lau_zone_5), col= 'red', add=TRUE) # oui
plot(st_intersection(celi_zone_4, lau_zone_4), col= 'red', add=TRUE) # non
plot(st_intersection(celi_zone_3, lau_zone_3), col= 'red', add=TRUE) # non
plot(st_intersection(celi_zone_2, lau_zone_2), col= 'red', add=TRUE) # non
plot(st_intersection(celi_zone_1, lau_zone_1), col= 'red', add=TRUE) # non


length(st_intersection(celi_zone_5, lau_zone_5))
length(st_intersection(celi_zone_4, lau_zone_4))
