import json
import pyrebase as pyb
token = {
"apiKey": "AIzaSyBM_eg6WTAXTG2hw0CEduIWW4GTCEiRISI",
"authDomain": "gasolinero-47f02.firebaseapp.com",
"databaseURL": "https://gasolinero-47f02-default-rtdb.europe-west1.firebasedatabase.app",
"projectId": "gasolinero-47f02",
"storageBucket": "gasolinero-47f02.appspot.com",
"messagingSenderId": "166067131970",
"appId": "1:166067131970:web:dd5ab99fad4bbaf0ae7fdb",
"measurementId": "G-VC6QZ0BTZW"
}
firebase = pyb.initialize_app(token)
auth = firebase.auth()
db = firebase.database()
storage = firebase.storage()
def registro(user,pwd):
        auth.create_user_with_email_and_password(user,pwd)


def login(user,pwd):
    try:
        auth.sign_in_with_email_and_password(user,pwd)
        print("Login correcto")
    except:
        print("Login incorrecto")
def introducirDatosUser (email,name,coche,modelo,combustible,consumo):
    data = {"email":email,"name":name,"coche":coche,"modelo":modelo,"combustible":combustible,"consumo":consumo}
    #Subimos los datos 
    db.child("users").push(data)
def getUserID(email):
    users = db.child("users").get()
    for user in users.each():
        if user.val()["email"] == email:
            return user.key()

def leerDatosUser(id):
    #Leemos los datos del usuario con el id
    datos = db.child("usuarios").child(id).get()
    print(datos.val())

def anadirLocalizacion(id : str , calle: str, nombre:str, lat : float ,lon : float):
    
    data = {"calle": calle,"nombre": nombre, "lat":lat,"lon":lon}
   
    #Añadimos la localizacion con clave igual a nombre al usuario
    db.child(f"users/{id}/localizaciones").child(nombre).set(data)
def anadirGasolinera(idUser,idLoc,idGasol,distancia):
    data = {'distancia':distancia}
    db.child(f"users/{idUser}/localizaciones/{idLoc}/gasolineras").child(idGasol).set(data)
    
def myInit():
    with open('token.json') as f:
        token = json.load(f)
    firebase = pyb.initialize_app(token)
    return firebase
def getDB(firebase):
    db = firebase.database()
    return db

def getAuth(firebase):
    auth = firebase.auth()
    return auth
    
def getStorage(firebase):
    storage = firebase.storage()
    return storage

def GetGasolLoc(idUser,idLoc):
    gasolineras = db.child(f"users/{idUser}/localizaciones/{idLoc}/gasolineras").get()
    return gasolineras.val()

