library(tidyverse)
library(rvest)

url <- "https://elections.interieur.gouv.fr/europeennes-2019/"
comm <- read.csv("./Documents/comm.csv")
colnames(comm)[6] <- "DEP"
codep <- read.csv("./Documents/codedep.csv")
comm <- merge(comm, codep, by = "DEP", all.x = TRUE)
for (t in 1:35012) {
  insee_t <- as.character(comm$insee[t])
  dep_t <- as.character(comm$DEP[t])
  reg_t <- as.character(comm$REGION[t])
  url_t <- paste0(url, "0", reg_t,"/0",dep_t,"/0",insee_t,".html")
  cat(insee_t, "\n")
  
  tryCatch(
    {page_t <- read_html(url_t) %>%
      html_table(header = TRUE)
    
    result_t1 <- page_t[[2]] %>%
      select(Listes, Voix) %>%
      spread(key = Listes, value = Voix)
    result_t2 <- page_t[[3]]
    colnames(result_t2)[1] <- "Type"
    result_t2 <- result_t2 %>%
      select(Type, Nombre) %>%
      spread(key = Type, value = Nombre)
    y <- cbind(comm[t,], result_t2, result_t1)
    colnames(y) <- make.names(colnames(y))
    
    df <- read.csv("resultats.csv")
    df <- rbind(df, y)
    write.csv(df, "resultats.csv", row.names = FALSE)
    }) 
  
  
}