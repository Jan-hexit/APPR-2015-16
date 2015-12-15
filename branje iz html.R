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


url <- "podatki/Drop-and-win-summary-report.htm"
stran <-read_html(url,encoding="UTF-8")
drzave <- stran %>% html_nodes(xpath ="//table[1]") %>% .[[2]] %>% html_table(fill = TRUE)
drzave <- apply(drzave,2,function(x) gsub("^[^0-9]{2}$",NA,x))
drzave <- drzave[!apply(is.na(drzave), 1, all),]
drzave <- drzave[,!apply(is.na(drzave), 2, all)]
drzave <- data.frame(drzave, stringsAsFactors = FALSE)
drzave["X4"]<-ifelse(is.na(drzave[,"X4"]), drzave[,"X5"], drzave[,"X4"])
drzave <- drzave[c(1,seq(2,18,2)),]
drzave <- drzave[,-3]
drzave[2:10,4:7]<-apply(drzave[2:10,4:7],2,function(x) as.numeric(gsub("[^0-9]","",x)))
drzave["X10"]<-ifelse(is.na(drzave[,"X10"]), drzave[,"X11"], drzave[,"X10"])
drzave<-drzave[,-5]
drzave["X14"]<-ifelse(is.na(drzave[,"X14"]), drzave[,"X13"], drzave[,"X14"])
drzave<-drzave[,-5]
drzave["X17"]<-ifelse(is.na(drzave[,"X17"]), drzave[,"X16"], drzave[,"X17"])
drzave<-drzave[,-6]
colnames(drzave)<-drzave[1,]
drzave<-drzave[-1,]
rownames(drzave)<- drzave[,1]
drzave<-drzave[,-1]


