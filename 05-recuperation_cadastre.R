library(R.utils)
library(data.table)
library(sf)

mkdirs("cadastre")
setwd("cadastre")


x <- c("07","26","30","42","69","84")

#parcelles 

for (i in x) {
  url <- paste("https://cadastre.data.gouv.fr/data/etalab-cadastre/latest/geojson/departements/", i, "/cadastre-",i,"-parcelles.json.gz", sep = "")
  destfile <- paste("parcelles-",i,".json.gz", sep = "")
  download.file(url = url, destfile = destfile)
  gunzip(filename = paste("parcelles-",i,".json.gz", sep = ""))
}


# sections

for (i in x) {
  url <- paste("https://cadastre.data.gouv.fr/data/etalab-cadastre/latest/geojson/departements/", i, "/cadastre-",i,"-sections.json.gz", sep = "")
  destfile <- paste("sections-",i,".json.gz", sep = "")
  download.file(url = url, destfile = destfile)
  gunzip(filename = paste("sections-",i,".json.gz", sep = ""))
}



# lieux-dits

for (i in x) {
  url <- paste("https://cadastre.data.gouv.fr/data/etalab-cadastre/latest/geojson/departements/", i, "/cadastre-",i,"-lieux_dits.json.gz", sep = "")
  destfile <- paste("lieux_dits-",i,".json.gz", sep = "")
  download.file(url = url, destfile = destfile)
  gunzip(filename = paste("lieux_dits-",i,".json.gz", sep = ""))
}


# batiments

for (i in x) {
  url <- paste("https://cadastre.data.gouv.fr/data/etalab-cadastre/latest/geojson/departements/", i, "/cadastre-",i,"-batiments.json.gz", sep = "")
  destfile <- paste("batiments-",i,".json.gz", sep = "")
  download.file(url = url, destfile = destfile)
  gunzip(filename = paste("batiments-",i,".json.gz", sep = ""))
}



# communes

for (i in x) {
  url <- paste("https://cadastre.data.gouv.fr/data/etalab-cadastre/latest/geojson/departements/", i, "/cadastre-",i,"-communes.json.gz", sep = "")
  destfile <- paste("communes-",i,".json.gz", sep = "")
  download.file(url = url, destfile = destfile)
  gunzip(filename = paste("communes-",i,".json.gz", sep = ""))
}


# fusion et export
for (i in x) {
  assign(paste("communes-",i,sep = ""),  st_read(paste("communes-",i,".json",sep = "")))
}

for (i in x) {
  assign(paste("batiments-",i,sep = ""),  st_read(paste("batiments-",i,".json",sep = "")))
}

for (i in x) {
  assign(paste("sections-",i,sep = ""),  st_read(paste("sections-",i,".json",sep = "")))
}

for (i in x) {
  assign(paste("lieux_dits-",i,sep = ""),  st_read(paste("lieux_dits-",i,".json",sep = "")))
}

for (i in x) {
  assign(paste("parcelles-",i,sep = ""),  st_read(paste("parcelles-",i,".json",sep = "")))
}


communes <- rbindlist(mget(ls(pattern = "communes-*")))
batiments <- rbindlist(mget(ls(pattern = "batiments-*")))
sections <- rbindlist(mget(ls(pattern = "sections-*")))
lieux_dits <- rbindlist(mget(ls(pattern = "lieux_dits-*")))
parcelles <- rbindlist(mget(ls(pattern = "parcelles-*")))




write_sf(parcelles, "parcelles.gpkg")
write_sf(lieux_dits, "lieux_dits.gpkg")
write_sf(sections, "sections.gpkg")
write_sf(batiments, "batiments.gpkg")
write_sf(communes, "communes.gpkg")


# filtre cdr

cdr <- c("07009","07013","07015","07042","07051", "07056", "07059", "07070", "07089", "07097", "07102", "07140",
       "07143", "07152", "07169", "07174", "07228", "07234", "07245", "07255", "07259", "07264", "07268", "07281",
       "07308", "07312", "07313", "07317", "07323", "07324", "07345","26038", "26054", "26071", "26110", "26119", "26156", "26165", "26179", "26180", "26182", "26188", "26192", 
       "26220", "26226", "26233", "26250", "26271", "26275", "26285", "26317", "26322", "26341", "26345", "26347",
       "26348", "26357", "26367", "26377", "26380","30005", "30012", "30028", "30070", "30073", "30076", "30081", "30084", "30089", "30092", "30096", "30103", 
       "30107", "30116", "30127", "30141", "30143", "30149", "30179", "30191", "30196", "30202", "30205", "30207", 
       "30209", "30212", "30217", "30221", "30222", "30225", "30226", "30232", "30251", "30254", "30256", "30260",
       "30273", "30277", "30278", "30282", "30287", "30288", "30290", "30292", "30302", "30312", "30315", "30326", 
       "30328", "30331", "30340", "30342", "30351", "30355","42056", "42132", "42265", "42272", "42327","69007", 
       "69064", "69193", "69253","84007", "84012", "84016", "84019", "84022", "84028", "84029", "84034", "84036", 
       "84037", "84039", "84045", "84049", "84053", "84055", "84056", "84059", "84061", "84078", "84081", "84083", 
       "84087", "84091", "84094", "84096", "84097", "84098", "84100", "84104", "84106", "84111", "84116", "84117", 
       "84119", "84122", "84126", "84127", "84129", "84130", "84134", "84135", "84136", "84137", "84138", "84141", 
       "84146", "84149", "84150")

parcelles_cdr <- subset(parcelles,parcelles$commune %in% cdr)

head(parcelles)


write_sf(parcelles_cdr, "parcelles_cdr.gpkg")
