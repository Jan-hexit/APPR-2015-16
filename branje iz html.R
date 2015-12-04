require(dplyr)
require(rvest)
require(gsubfn)
library(reshape2)

url <- "http://www.casinonewsdaily.com/2015/05/13/united-kingdom-gambling-market-development/"
stran <- html_session(url) %>% read_html(encoding="UTF-8")
tabela <- stran %>% html_nodes(xpath ="//table[1]") %>% .[[1]] %>% html_table()
colnames(tabela)<-c("Panoga","Moski","Zenske")
tabela<-tabela[-1,]
tabela<-t(tabela)

