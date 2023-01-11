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

vect <- c('fasd',ásdasdas)

#Hacemos un bulce for que recorra vect
