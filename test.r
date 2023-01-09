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


#Q: por que esto no funcion
#A: porque no se puede llamar a una funcion que no existe
#Q: pero si que existe
#A: porque no se ha cargado el archivo registro.py

fb <- myInit()

db <- getDB(fb)
storage <- getStorage(fb)
auth <- getAuth(fb)

#Creamos un usuario
registro("hola@gmail.com", "pruebanumero1")
#Iniciamos sesión
login("hola@gmail.com", "pruebanumero1")
#Creamos un usuario
introducirDatosUser("luis@gmail.com", "luis", "seat", "ibiza", "gasolina", 5.5)
