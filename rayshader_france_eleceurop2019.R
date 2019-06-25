library(rayshader)
library(CARTElette)
library(sf)
library(tidyverse)

url_elec <- "https://static.data.gouv.fr/resources/resultats-des-elections-europeennes-2019/20190531-144250/resultats-definitifs-par-commune.xls"
download.file(url_elec,method="auto",destfile = "resultats_communes.xls",mode="wb")


resultats_communes <- readxl::read_excel("resultats_communes.xls", 
                                      sheet = "Resultats-definitifs-par-commun")

resultats_communes$insee <- paste0(resultats_communes$`Code du département`, resultats_communes$`Code de la commune`)

com <- loadMap(nivsupra = "COM")

com <- merge(com, resultats_communes[,c(5, 179,257)], by.x = "INSEE_COM", by.y = "insee")
colnames(com)[13] <- "Score"


d <- ggplot() +
    geom_sf(data=com, aes(fill = Score), color = NA)+
  scale_fill_viridis_c(option= "A", name = "Score RN")+

  theme_minimal()+
  theme(
    axis.line = element_blank(),
    axis.text.x = element_blank(),
    axis.text.y = element_blank(),
    axis.ticks = element_blank(),
    axis.title.x = element_blank(),
    axis.title.y = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
  )
d
plot_gg(d, width = 4,zoom = 0.4, theta = -45, phi = 30, 
        windowsize = c(1400,866))
render_movie(filename = "RN.mp4", type = "orbit", 
                          frames = 360,  phi = 30, zoom = 0.3, theta = 0)


