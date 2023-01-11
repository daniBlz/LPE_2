# ID SCRIPT ---------------------------------------------------------------

## LENGUAJES DE PROGRAMACION ESTADISTICA
## PROFESOR: CHRISTIAN SUCUZHANAY AREVALO
## ALUMNO: CRISTINA GUERRERO, EXP 22021108
## Trabajo grupal gasolineras


#Importamos librerias
if(!require("pacman")) install.packages("pacman")
pacman::p_load(pacman, magrittr, tidyverse, leaflet, janitor, geosphere, ggmap, mapsapi, reticulate, osrm)

# Nos logeamos
login("cristina@gmail.com", "cristina1101")
userId <- getUserID("cristina@gmail.com")

# aniadimos ubicacion junto a sus gasolineras cercanas
aniadir_ubi(userId, "C. Tajo, s/n, 28670 Villaviciosa de Odón, Madrid", "uni")


# FUNCIONES ---------------------------------------------------------------

aniadir_ubi <- function(userId, calle, idLoc){
  
  # cogemos las coordenadas de la calle que nos da el usuario
  coord <- get_coord_localizacion(calle)
  
  # calculamos las distancias con las coordenadas anteriores
  gasolineras <- get_calculo_gas(coord) # c(id, distancias)
  
  #aniadimos la localizacion a Firebase
  anadirLocalizacion(userId, calle, idLoc, coord[1,"lat"], coord[1,"lon"])
  for (i in 1:nrow(gasolineras)){
    anadirGasolinera(userId, idLoc, gasolineras$idGasol[i], gasolineras$distancias[i])
  }
}


get_calculo_gas <- function(coord){
  
 # leemos las gasolineras de la API
  url_ <- ("https://sedeaplicaciones.minetur.gob.es/ServiciosRESTCarburantes/PreciosCarburantes/EstacionesTerrestres/")
  f_raw <- jsonlite::fromJSON(url_) 
  df_source_gas <- f_raw$ListaEESSPrecio 
  
  # limpieza
  df_gas <- df_source_gas %>% janitor::clean_names() %>% type_convert(locale = locale(decimal_mark = ",")) %>% as_tibble()
  
  #calculamos las distancias
  
  # aniadimos una columna que sea el indice ya que correspondera al id de la gasolinera
  df_gas["idGasol"] <- 1:nrow(df_gas)
  
  # Calculamos las gasolineras cercanas  
  df_localizacion <- df_gas %>% mutate(
    distancias = round(distGeo(df_gas %>% select("longitud_wgs84", "latitud"), c(coord[1,"lon"], coord[1,"lat"]))/1000, 2)) %>% 
    filter(distancias < 10) %>% 
    select("distancias", "idGasol")
  
  # devolvemos el vector con el id de las gasolineras y las distancias
  return(df_localizacion)
}

get_coord_localizacion <- function(calle) {
  
  # registramos la key del profesor en ggmap
  key <- "apikey" # key del profesor
  ggmap::register_google(key=key)     
  
  # Obtenemos la localizacion con ggmap
  coord <- data.frame(geocode(location=calle, output = "latlona", source = "google"))
  return(coord)
}

