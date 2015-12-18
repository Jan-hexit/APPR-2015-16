# # 2. faza: Uvoz podatkov
# 
# # Funkcija, ki uvozi podatke iz datoteke druzine.csv
# uvozi.druzine <- function() {
#   return(read.table("podatki/druzine.csv", sep = ";", as.is = TRUE,
#                       row.names = 1,
#                       col.names = c("obcina", "en", "dva", "tri", "stiri"),
#                       fileEncoding = "Windows-1250"))
# }
# 
# # Zapišimo podatke v razpredelnico druzine.
# druzine <- uvozi.druzine()
# 
# obcine <- uvozi.obcine()
# 
# # Če bi imeli več funkcij za uvoz in nekaterih npr. še ne bi
# # potrebovali v 3. fazi, bi bilo smiselno funkcije dati v svojo
# # datoteko, tukaj pa bi klicali tiste, ki jih potrebujemo v
# # 2. fazi. Seveda bi morali ustrezno datoteko uvoziti v prihodnjih
# # fazah.
require(dplyr)
require(rvest)
require(gsubfn)
library(reshape2)
library(ggplot2)

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

tabela <- read.csv(file="podatki/Industry-Statistics-April-2008-to-March-2015.csv",sep = ";",skip=6,nrows=54, as.is=TRUE)
tabela <- tabela[1:8]
st_miz <- tabela[1:10,]
colnames(st_miz)<-st_miz[1,]
st_miz <- st_miz[-1,]
imena_miz<-st_miz[,1]
st_miz<-st_miz[,-1]
st_miz <- apply(st_miz,2,function(x) as.numeric(gsub("\\.","",x)))
rownames(st_miz) <- imena_miz
vlozki <-tabela[14:23,]
colnames(vlozki)<-vlozki[1,]
vlozki <- vlozki[-1,]
imena_miz<-vlozki[,1]
vlozki<-vlozki[,-1]
vlozki <- apply(vlozki,2,function(x) as.numeric(gsub(",",".",gsub("\\.","",x))))
rownames(vlozki) <- imena_miz
profit<-tabela[27:36,]
colnames(profit)<-profit[1,]
profit <- profit[-1,]
imena_miz<-profit[,1]
profit<-profit[,-1]
profit <- apply(profit,2,function(x) as.numeric(gsub(",",".",gsub("\\.","",x))))
rownames(profit) <- imena_miz

dobicek <- data.frame()
dobicek <- profit/vlozki
rownames(dobicek) <- imena_miz
colnames(dobicek) <- colnames(profit)

dobicek_na_mizo <- data.frame()
dobicek_na_mizo <- profit/st_miz
rownames(dobicek_na_mizo) <- imena_miz
colnames(dobicek_na_mizo) <- colnames(profit)

ggplot(drzave)

