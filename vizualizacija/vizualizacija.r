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

 zemljevid <- pretvori.zemljevid(zemljevid)
 zemljevid <- apply(zemljevid,2,function(x) gsub("East of England|South East|South West","South",x))
 zemljevid <- apply(zemljevid,2,function(x) gsub("Greater London Authority","London total",x))
 zemljevid <- apply(zemljevid,2,function(x) gsub("North East|North West|Yorkshire and The Humber","North",x))
 zemljevid <- apply(zemljevid,2,function(x) gsub("East Midlands|West Midlands","Midlands and Wales",x))
 drzave=drzave[c(-5,-6,-7,-9),]
 drzave$imena<-rownames(drzave)


 
 ggplot() + geom_polygon(data = drzave %>% right_join(zemljevid, by = c("imena" = "NAME")),aes(x = long, y = lat, group = group, fill = Drop))
print(zemljevid)