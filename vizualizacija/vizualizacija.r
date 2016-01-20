# 3. faza: Izdelava zemljevida
source("lib/uvozi.zemljevid.r", encoding = "UTF-8")
source("uvoz/uvoz.r", encoding = "UTF-8")
library(ggplot2)
library(dplyr)

# Uvozimo zemljevid.
zemljevid <- uvozi.zemljevid("https://www.sharegeo.ac.uk/download/10672/50/English%20Government%20Office%20Network%20Regions%20(GOR).zip","Regions")
#zemljevid <- uvozi.zemljevid("http://biogeo.ucdavis.edu/data/gadm2.8/shp/GBR_adm_shp.zip","GBR_adm2")

pretvori.zemljevid <- function(zemljevid) {
  fo <- fortify(zemljevid)
  data <- zemljevid@data
  data$id <- as.character(0:(nrow(data)-1))
  return(inner_join(fo, data, by="id"))}
podatki<-drzave[c(2,3,4,8),]
podatki$regija <- factor(row.names(podatki))
podatki<-podatki[c(3,6)]
podatki[1]<-podatki[1]/1000000
podatki <- as.data.frame(podatki)
zemljevid$regija <- zemljevid$NAME %>%
{gsub("East of England|South East|South West","South", .)} %>%
{gsub("Greater London Authority","London total", .)} %>%
{gsub("North East|North West|Yorkshire and The Humber","North", .)} %>%
{gsub("East Midlands|West Midlands","Midlands and Wales", .)} %>%
  factor(levels = levels(podatki$regija))
#zemljevid<- merge(x=drzave,y=zemljevid,by="regija")
#zemljevid <- zemljevid[c(3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,1,2)]
zemljevid <- pretvori.zemljevid(zemljevid)

zemljevid <- ggplot() + geom_polygon(data = right_join(podatki,zemljevid),
                        aes(x = long, y = lat, group = group, fill = Drop)) + scale_fill_distiller(palette = "Spectral")+ggtitle("Vlozki v miljon £")


