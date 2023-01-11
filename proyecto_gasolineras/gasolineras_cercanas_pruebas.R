# ID SCRIPT ---------------------------------------------------------------

## LENGUAJES DE PROGRAMACION ESTADISTICA
## PROFESOR: CHRISTIAN SUCUZHANAY AREVALO
## ALUMNO: CRISTINA GUERRERO, EXP 22021108
## Trabajo grupal gasolineras


# IMPORT -------------------------------------------------------------

# Libraries
if(!require("pacman")) install.packages("pacman")
pacman::p_load(pacman, magrittr, tidyverse, leaflet, janitor, geosphere, ggmap, mapsapi, reticulate, osrm)

# Dataset gasolineras
url_ <- ("https://sedeaplicaciones.minetur.gob.es/ServiciosRESTCarburantes/PreciosCarburantes/EstacionesTerrestres/")
f_raw <- jsonlite::fromJSON(url_) %>% glimpse()
df_source_gas <- f_raw$ListaEESSPrecio %>% glimpse()


# CLEANING ----------------------------------------------------------------

dim(df_source_gas) 
summary(df_source_gas) 
colnames(df_source_gas) 
locale() # configuracion
# limpiar los nombres de las columnas y cambiar el decimal por la coma 
df_gas <- df_source_gas %>% janitor::clean_names() %>% type_convert(locale = locale(decimal_mark = ",")) %>% as_tibble()

# DISTANCE CALCULATION ------------------------------------------------------

## COSAS A TENER EN CUENTA
  # El usuario pone una ubicacion, 
        # si no esta creada se crea y aniade a la tabla,
        # si esta creada se hace el get de la tabla para coger las gasolineras cercanas que ya tienen que estar calculadas en la BD.
        # Usamos reticulate para conectar R con Firebase

# CASE 1 : TENEMOS QUE CREAR:
                              # Nueva localizacion a partir de la calle del usuario.
                              # Aniadir id, lat y long de la localizacion a la tabla de ubicaciones.
                              # Calcular las gasolineras cercanas y aniadir a la tabla.


# conseguir latitud y longitud a partir de la calle 

# coordenadas de prueba (longitud, latitud):
## u1 <- c(-3.919257897378161, 40.373942679873714) # C. Tajo, s/n, 28670 Villaviciosa de Odón, Madrid # (uem) 
## u2 <- c(-3.870636188707822, 40.33936849062731)# C. Gladiolo, s/n, 28933 Móstoles, Madrid # (hospital rey juan carlos) 
## u3 <- c(-3.688033292588252, 40.45349588127293)# Av. de Concha Espina, 1, 28036 Madrid # (SANTIAGO BERNABEU)

uem_address <- "C. Tajo, s/n, 28670 Villaviciosa de Odón, Madrid" #uem
key <- "apikey" # key del profesor

ggmap::register_google(key=key)                                                                           
coord <- data.frame(geocode(location=uem_address, output = "latlona", source = "google"))

# ya tenemos el id y coordenadas de la localizacion, solo falta la lista con las gasolineras que corresponden al indice de df_gas


# aniadimos una columna que sea el indice ya que correspondera al id
df_gas["gasolineras"] <- 1:nrow(df_gas)


# Calculamos las gasolineras cercanas con el id de usuario, id ubicacion (calle), distancias entre gas y ubi,  lat y lon de gas., rotulo y precio gasoleo 
df_localizacion <- df_gas %>% mutate(
                                distancias = round(distGeo(df_gas %>% select("longitud_wgs84", "latitud"), c(coord[1,"lon"], coord[1,"lat"]))/1000, 2)) %>% 
                              select("distancias", "gasolineras")



# Aniadimos la nueva localizacion con codigo dani:
#  banadirLocalizacion("user1", coord[1,"calle"], "nombre", coord[1,"lat"], coord[1,"lon"], df_localizacion %>% select("gasolineras"), df_localizacion %>% select("distancias"))


# Visualizacion de gasolineras cercanas

gas_station_icon <- makeIcon(iconUrl = "./icons/icon_gas_station.png", iconWidth = 30, iconHeight = 30)
ubi_icon <- makeAwesomeIcon(icon = "home", markerColor = "red")

df_ubi_gas <- df_gas %>% mutate(calle_ubi= coord[1,"address"], 
                                distancias = round(distGeo(df_gas %>% select("longitud_wgs84", "latitud"), c(coord[1,"lon"], coord[1,"lat"]))/1000, 2)) %>% 
                         filter(distancias < 10) %>% 
                         select("rotulo", "calle_ubi", "distancias", "precio_gasoleo_a", "latitud", "longitud_wgs84")

df_ubi_gas %>% 
              leaflet() %>%                       # iteractive map
              addTiles() %>%                      # map design
              addMarkers(lng = ~longitud_wgs84,lat= ~latitud, # coordenates gas stations
                         popup = ~rotulo, # value to click
                         label = ~precio_gasoleo_a,
                         icon = gas_station_icon) %>%  # value to pass 
              addAwesomeMarkers(lng = ~coord[1,"lon"],lat= ~coord[1,"lat"],
                                label = ~calle_ubi, 
                                icon = ubi_icon)


# CASE 2 : La ubicacion ya esta creada y tenemos que buscarla en la tabla. 
# Si existe una tabla de gasolineras y ubicaciones se cogerian de alli las gasolineras cercanas con las funciones de Dani.

                        



# TEST: WAYS TO FIND DISTNACE BETWEEN COORDENATES (longitud, latitud)
u1 <- c(-3.919257897378161, 40.373942679873714) #uem LONG_LAT
u2 <- c(-3.870636188707822, 40.33936849062731)# hospital rey juan carlos LONG_LAT


method_geo <- distm (u1, u2, fun = distHaversine) %>% glimpse()
method_osrm <-  osrmRoute(src=u1, dst=u2, overview = FALSE) %>% glimpse()
method_geo2 <- (distGeo(u1,u2)) %>% glimpse()# in m
