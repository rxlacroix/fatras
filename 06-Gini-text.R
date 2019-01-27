library(readtext)
library(tidyverse)
library(tidytext)
library(ineq)

x <-readtext("test.docx")

tidy <- x %>%
  unnest_tokens(word, text)

t <- as.data.frame(table(tidy$word))

ineq(t$Freq, type = "Gini")

plot(Lc(t$Freq),col="red",lwd=2)
