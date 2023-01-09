import json
with open('token.json') as f:
    token = json.load(f)
import pyrebase as pyb
firebase = pyb.initialize_app(token)
auth = firebase.auth()
db = firebase.database()
storage = firebase.storage()
def registro(user,pwd):
    try:
        auth.create_user_with_email_and_password(user,pwd)
        print("Usuario creado")
    except:
        print("El usuario ya existe")

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

def anadirLocalizacion(id,lat,lon):
    data = {"lat":lat,"lon":lon, 'userID': id}
    #Subimos los datos 
    db.child("localizaciones").push(data)      