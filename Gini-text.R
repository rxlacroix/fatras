library(readtext)
library(tidyverse)
library(tidytext)
library(ineq)

'%!in%' <- function(x,y)!('%in%'(x,y))

x <-readtext("test.docx")
swfr <- readtext("https://raw.githubusercontent.com/stopwords-iso/stopwords-fr/master/stopwords-fr.txt") %>%
  unnest_tokens(word, text)


tidy <- x %>%
  unnest_tokens(word, text)

t <- as.data.frame(table(tidy$word))

g <- round(ineq(t$Freq, type = "Gini"),3)

vn <- round(nrow(t)/nrow(tidy),3)

plot(Lc(t$Freq),col="red",lwd=2, main = paste0("Mots différents = ", nrow(t),"   Gini = ", g, "   V/N = ",vn))

tidyclean <- tidy %>%
  filter(word %!in% swfr$word)

tclean <- as.data.frame(table(tidyclean$word))

gclean <- round(ineq(tclean$Freq, type = "Gini"),3)

vnclean <- round(nrow(tclean)/nrow(tidyclean),3)

plot(Lc(tclean$Freq),col="red",lwd=2, main = paste0("Mots différents = ", nrow(tclean),"   Gini = ", gclean, "   V/N = ",vnclean))
