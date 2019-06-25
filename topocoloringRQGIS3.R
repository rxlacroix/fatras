library(sf)
# devtools::install_github("jannes-m/RQGIS3")
library(RQGIS3)

nc <- st_read(system.file("shape/nc.shp", package = "sf"))

get_usage(alg = "qgis:topologicalcoloring")

params <- get_args_man(alg = "qgis:topologicalcoloring")

params$INPUT <- nc
params$OUTPUT <- "nc_color.geojson"
params$MIN_COLORS <- 4
params$MIN_DISTANCE <- 0
params$BALANCE <- 0

out <- run_qgis(
  alg = "qgis:topologicalcoloring",
  params = params,
  load_output = FALSE
)

nc_color <- st_read("nc_color.geojson")

plot(nc_color[, "color_id"])
