#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue May 21 19:01:27 2019

@author: jose
"""

f = open("ejer1.txt", "r")
dominio = f.readline()
problema = f.readline()
problema = problema.replace("\n","")
num_zonas = f.readline()
dominio = dominio.split(":")[1]
dominio = dominio.replace("\n","")
problema = problema.split(":")[1]
num_zonas = int(num_zonas.split(":")[1])

stringZonas = ""

for i in range(1,num_zonas + 1):
    stringZonas += "z"
    stringZonas += str(i)
    stringZonas += " "
stringZonas += "- zona"
stringOrientacion = "norte este sur oeste - orientacion"

tipos_personajes = "bruja princesa principe profesor dicaprio"
tipos_objetos = "manzana oro algoritmo oscar rosa"

personajes_objetos = ""
posiciones = ""
conesiones = ""

for x in f:

    if len(x) > 1:
        linea = x.split("->") 
        tipo = linea[0]
        zonas = linea[1].split()
        zonas_conectadas = list()
    
        conectado = ""
        for i in range(0,len(zonas)):
            nuevo = zonas[i].replace("]","")
            nuevo = nuevo.replace("[",";")
            nuevo = nuevo.split(";")
            zonas_conectadas.append(nuevo[0])
            
            if nuevo[1] != '':
                personajes_objetos += nuevo[1].replace("-"," - ") + "\n"
                dividir = nuevo[1].split("-")
                if "jugador" == dividir[1]:
                    posiciones += "(orientacion_jugador " + dividir[0] + " norte)\n"
                    posiciones += "(posicion_jugador " + dividir[0] + " " + nuevo[0] + ")\n"
                    
                if tipos_personajes.find(dividir[1]) != -1:
                    posiciones += "(posicion_personaje " + dividir[0] + " " + nuevo[0] + ")\n"
                    
                if tipos_objetos.find(dividir[1]) != -1:
                    posiciones += "(posicion_objeto " + dividir[0] + " " + nuevo[0] + ")\n"
                    
                    
                
                
            
            #print(nuevo)
    
        if tipo == 'V':
            if(len(zonas_conectadas) == 3):
                conesiones += "(conectada oeste " + zonas_conectadas[1] + " " + zonas_conectadas[0] + ")\n"
                conesiones += "(conectada este " + zonas_conectadas[0] + " " + zonas_conectadas[1] + ")\n"
                
                conesiones += "(conectada este " + zonas_conectadas[1] + " " + zonas_conectadas[2] + ")\n"
                conesiones += "(conectada oeste " + zonas_conectadas[2] + " " + zonas_conectadas[1] + ")\n"
            else:
                conesiones += "(conectada oeste " + zonas_conectadas[1] + " " + zonas_conectadas[0] + ")\n"
                conesiones += "(conectada este " + zonas_conectadas[0] + " " + zonas_conectadas[1] + ")\n"
        if tipo == 'H':
            if(len(zonas_conectadas) == 3):
                conesiones += "(conectada norte " + zonas_conectadas[1] + " " + zonas_conectadas[0] + ")\n"
                conesiones += "(conectada sur " + zonas_conectadas[0] + " " + zonas_conectadas[1] + ")\n"
                
                conesiones += "(conectada sur " + zonas_conectadas[1] + " " + zonas_conectadas[2] + ")\n"
                conesiones += "(conectada norte " + zonas_conectadas[2] + " " + zonas_conectadas[1] + ")\n"
            else:
                conesiones += "(conectada norte " + zonas_conectadas[1] + " " + zonas_conectadas[0] + ")\n"
                conesiones += "(conectada sur " + zonas_conectadas[0] + " " + zonas_conectadas[1] + ")\n"
                
    
    
        
    #print(conectado)
    #for i in nuevo.split(";"):
     #   print(i)

f = open("ProblemaEjer1.pddl", "w")

f.write("(define (problem " + problema + ")\n")
f.write("(:domain " + dominio + ")")
f.write("(:objects\n")

f.write(stringZonas + "\n")
f.write(personajes_objetos)
f.write(stringOrientacion + "\n")
f.write(")\n")
f.write("(:init\n")
f.write(posiciones) 
f.write(conesiones)
f.write(")\n")

f.write("(:goal (AND\n")
f.write("(personaje_tiene_objeto princesa1)\n")
f.write("(personaje_tiene_objeto principe1)\n")
f.write("(personaje_tiene_objeto bruja1)\n")
f.write("(personaje_tiene_objeto dicaprio1)\n")
f.write("(personaje_tiene_objeto profesor1)\n")

f.write(")))")
f.close()


      


