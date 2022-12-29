#Importamos pacman
library(pacman)
#Instalamos reticulate
p_load(reticulate)
#Cargamos la librería de python
use_python("/usr/bin/python3")
#Indicamos que utilizamos le env de anaconda
use_condaenv("base", required = TRUE)
#Cargamos las funcione del archivo registro.py
source_python("registro.py")
#Ejecutamos la función
registro <- function(user, pwd) {
  registro(user, pwd)
}

login <- function(user, pwd) {
  login(user, pwd)
}

introducirDatosUser <- function (email, name, coche, modelo, combustible, consumo) {
  introducirDatosUser(email, name, coche, modelo, combustible, consumo)
}

getUserID <- function (email) {
  getUserID(email)
}

leerDatosUser <- function (id) {
  leerDatosUser(id)
}

anadirLocalizacion <- function (id, lat, lon) {
  anadirLocalizacion(id, lat, lon)
}




