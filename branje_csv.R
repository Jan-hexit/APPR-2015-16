require(dplyr)
require(rvest)
require(gsubfn)
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
