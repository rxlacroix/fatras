library(tidyverse)
library(osmdata)
library(ggthemes)
library(magrittr)


opq(bb= getbb("Lausanne Suisse")) %>%
  add_osm_feature(key = 'highway') %>%
  add_osm_feature(key = 'name|maxspeed', value=".*", key_exact = FALSE, value_exact = FALSE) %>%
  osmdata_sf() %$%
  osm_lines %>%
  mutate(lanes = coalesce(as.numeric(as.character(lanes)), 1), 
         maxspeed = as.numeric(as.character(maxspeed))) %>%
         {
           ggplot(., aes(size=lanes, color=maxspeed)) +  
             geom_sf(date = filter(., is.na(maxspeed))) + 
             geom_sf(data = filter(., !is.na(maxspeed))) + 
             scale_size_continuous(range=c(0.3, 1), guide="none") +
             scale_color_gradientn(colors = rev(c('#FFC65B','#EB9026','#B65419','#662918')), na.value = "#52413D") +
             ggthemes::theme_map() +
             theme(text = element_text(color='white'),
                   plot.background = element_rect(fill = 'black'),
                   panel.background = element_rect(fill = 'black'),
                   legend.background = element_rect(fill = 'black'),
                   panel.grid.major = element_line(color = 'transparent'))
         }




library(OpenStreetMap)
library(osmdata)
library(osmar)

src <- osmsource_api()

bb <- center_bbox(6.629701, 46.518949, 1500, 1500)
ctown <- get_osm(bb, source = src)
plot(ctown)

pedestrian <-  find(ctown, way(tags(k == "highway" & v == "pedestrian")))
pedestrian <- find_down(ctown, way(pedestrian))
pedestrian <- subset(ctown, ids = pedestrian)
plot(ctown)
plot_ways(pedestrian, add = T, col = "red", lwd = 3)

footway <- find(ctown, way(tags(k == "highway" & v == "footway")))
footway <- find_down(ctown, way(footway))
footway <- subset(ctown, ids = footway)
plot(ctown)
plot_ways(footway, add = T, col = "red", lwd = 3)

service <- find(ctown, way(tags(k == "highway" & v == "service")))
service <- find_down(ctown, way(service))
service <- subset(ctown, ids = service)
plot(ctown)
plot_ways(service, add = T, col = "red", lwd = 3)

