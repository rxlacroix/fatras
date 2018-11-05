library(R.utils)
library(data.table)

mkdirs("/media/rlx/HDD/DATA/cadastre")
setwd("/media/rlx/HDD/DATA/cadastre")


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



