packs<-c("stringr")
lapply(packs, library,character.only = TRUE)
packeges <- c("sf","sp","proj4","leaflet","rgeos")
lapply(packeges, library,character.only = TRUE)


# Ponemos la ruta donde tenemos el shaoe de manzanas
setwd("C://Users//basa9009//Downloads//drive-download-20201117T191940Z-001")

Shape_AGEB<- st_read("REP_MZN.shp")
## Let's simplify the polygons, in order to reduce the size of the
## object.



### Now we change this property of the shape,
#st_crs(Shape_MZN)<- "+proj=longlat +ellps=WGS84 +datum=WGS84"

Shape_AGEB <- st_transform(Shape_AGEB, "+proj=longlat +ellps=WGS84 +datum=WGS84")

MA<- read.csv("C://Users//basa9009//Downloads//Marco_FINAL_AGEB.csv")
library(stringr)
MA$edo<- str_pad(MA$edo,2,"left","0")
MA$mun<- str_pad(MA$mun,3,"left","0")
MA$loc<- str_pad(MA$loc,4,"left","0")
MA$ageb<- str_pad(MA$ageb,4,"left","0")

MA$llave.ageb<- paste0(MA$edo,
                       MA$mun,
                       MA$loc,
                       MA$ageb)

Shape_AGEB$llave.ageb<- substr(Shape_AGEB$CLAVE,1,13)

# Pegamos la ciudad nielsen
Shape_AGEB<- merge(Shape_AGEB,MA[,c("llave.ageb","Ciudad_Nielsen"),],by="llave.ageb"
                   ,all.x=TRUE)



ML<- read.csv("C://Users//basa9009//Downloads//marco_loc2016.csv")
ML$CVE_ENT<- str_pad(ML$CVE_ENT,2,"left","0")
ML$CVE_MUN<- str_pad(ML$CVE_MUN,3,"left","0")
ML$CVE_LOC<- str_pad(ML$CVE_LOC,4,"left","0")

ML$llave.loc<- paste0(ML$CVE_ENT,ML$CVE_MUN,ML$CVE_LOC)

Shape_AGEB$llave.loc<- substr(Shape_AGEB$CLAVE,1,9)

Shape_AGEB<- merge(Shape_AGEB,ML[,c("llave.loc","Ciudad_Nielsen"),],by="llave.loc"
                   ,all.x=TRUE)

Shape_AGEB[is.na(Shape_AGEB$Ciudad_Nielsen.x),"Ciudad_Nielsen.x"]<- 
  Shape_AGEB[is.na(Shape_AGEB$Ciudad_Nielsen.x),"Ciudad_Nielsen.y"]

Shape_AGEB<- Shape_AGEB[!is.na(Shape_AGEB$Ciudad_Nielsen.x),]


######################################################
### Importante:: aqui poner la ruta donde se guardaran los shapes
setwd("C://Users//basa9009//Documents//Shapes_MZN_Ciudad_Nielsen")


Ciudades_Nielsen<- unique(Shape_AGEB$Ciudad_Nielsen.x)
for(i in Ciudades_Nielsen)
{
  Shape_Ciudad<- Shape_AGEB[Shape_AGEB$Ciudad_Nielsen.x%in%i,]
  dir.create(as.character(i))
  ruta<- paste0("C://Users//basa9009//Documents//Shapes_MZN_Ciudad_Nielsen//",i,
                "//",i,"_Manzana.shp")
  st_write(Shape_Ciudad,ruta)
  print(i)
  
  
  
}


