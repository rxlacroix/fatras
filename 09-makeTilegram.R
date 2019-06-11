library(sf)
# devtools::install_git("https://gitlab.com/lajh87/makeTilegram")

library(makeTilegram)

nc <- st_read(system.file("shape/nc.shp", package="sf"))

nc$id <- row.names(nc)

nc <- st_cast(nc, to="POLYGON")

nc$carea <- as.numeric(st_area(nc))
nc <- nc[order(nc$carea, decreasing = TRUE),]


nc <- nc[!duplicated(nc$id),]

nc <- as_Spatial(nc)

ncTileGram <- st_as_sf(makeTilegram(nc))

plot(ncTileGram["id"])
