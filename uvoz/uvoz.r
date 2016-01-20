
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
drzave <- apply(drzave,2,function(x) gsub("^[^0-9]{1,2}$",NA,x))
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
drzave[3]<-as.numeric(drzave[,3])
drzave<-data.frame(drzave)

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
profit <- data.frame(profit)
colnames(profit)<-colnames(st_miz)
vlozki <- data.frame(vlozki)
colnames(vlozki)<-colnames(st_miz)
dobicek <- data.frame(dobicek)
colnames(dobicek)<-colnames(st_miz)
dobicek_na_mizo <- data.frame(dobicek_na_mizo)
colnames(dobicek_na_mizo)<-colnames(st_miz)
st_miz <- data.frame(st_miz)
colnames(st_miz)<-colnames(dobicek)

profit <- t(profit)
G_profit <- melt(profit[,-9],id=row.names(profit))
G_profit <- ggplot(data=G_profit,aes(x=as.numeric(Var1),y=value,color=Var2))+geom_line()+ylab("Milijon £")+xlim(rownames(profit))+xlab("Leta")+ggtitle("Dobički")

dobicek <- t(dobicek)
G_dobicek <- melt(dobicek[,-9],id=row.names(dobicek))
G_dobicek <- ggplot(data=G_dobicek,aes(x=as.numeric(Var1),y=value*100,color=Var2))+geom_line()+ylab("% dobička glede na vložek")+xlim(rownames(dobicek))+xlab("Leta")+ggtitle("Dobički v %")

dobicek_na_mizo <- t(dobicek_na_mizo)
G_dobicek_na_mizo <- melt(dobicek_na_mizo[,-9],id=row.names(dobicek_na_mizo))
G_dobicek_na_mizo <- ggplot(data=G_dobicek_na_mizo,aes(x=as.numeric(Var1),y=value,color=Var2))+geom_line()+ylab("Milijon £")+xlim(rownames(dobicek_na_mizo))+xlab("Leta")+ggtitle("Dobički na mizo")
