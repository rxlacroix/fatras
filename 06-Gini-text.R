library(readtext)
library(tidyverse)
library(tidytext)
library(ineq)

x <-readtext("test.docx")

tidy <- x %>%
  unnest_tokens(word, text)

t <- as.data.frame(table(tidy$word))

g <- round(ineq(t$Freq, type = "Gini"),3)

vn <- round(nrow(t)/nrow(tidy),3)

plot(Lc(t$Freq),col="red",lwd=2, main = paste0("Mots différents = ", nrow(t),"   Gini = ", g, "   V/N = ",vn))
