library(tidyverse)

url <- "https://static.data.gouv.fr/resources/finess-extraction-du-fichier-des-etablissements/20190517-100024/etalab-cs1100507-stock-20190516-0453.csv"

download.file(url, destfile = "etalab-cs1100507-stock-20190516-0453.csv")

finess_brut <- read.csv("etalab-cs1100507-stock-20190516-0453.csv", encoding = "latin1", header = F, sep = ";")

finess_structureet <- finess_brut %>%
  filter(V1 == "structureet")

colnames(finess_structureet) <- c("type_data","nofinesset","nofinessej","rs","rslongue","complrs","compldistrib","numvoie",
                                      "typvoie","voie","compvoie","lieuditbp","commune","departement","libdepartement",
                                      "ligneacheminement","telephone","telecopie","categetab","libcategetab",
                                      "categagretab","libcategagretab","siret","codeape","codemft","libmft",
                                      "codesph","libsph","dateouv","dateautor","datemaj")


finess_geolocalisation <- finess_brut %>%
  filter(V1 == "geolocalisation") %>%
  select(V1,V2,V3,V4,V5,V6)%>%
  separate(col = V5, sep = ",", into = c("num","source", "source_num", "org", "bd", "vers_bd", "crs"), fill = "left")

colnames(finess_geolocalisation)[1:4] <- c("type_data", "numuai","coordxet","coordyet")
colnames(finess_geolocalisation)[12] <- "datemaj"



finess <- merge(finess_structureet, finess_geolocalisation, by.x = "nofinesset", by.y = "numuai" )

write.csv2(finess, "finess.csv", row.names = FALSE)

# ouvrir dans qgis en lambert 93 - utf8

# pour chaque autre crs
# copier coller les entites correspondantes dans une couche memoire CTRL C  / CTRL ALT V
# supprimer les entites de la couche source
# Redefinir la proj de la couche créée
# copier coller les entites de la couche créée vers la couche source
