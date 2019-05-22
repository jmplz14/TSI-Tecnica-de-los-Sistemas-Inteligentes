#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue May 21 19:01:27 2019

@author: jose
"""
def devolverCaracteristicas(nuevo,pos,tipo):
    personajes_objetos = ""
    posiciones = ""
    if nuevo != '':
        personajes_objetos += nuevo.replace("-"," - ") + "\n"
        dividir = nuevo.split("-")
        if "jugador" == dividir[1]:
                posiciones += "(orientacion_jugador " + dividir[0] + " norte)\n"
                posiciones += "(posicion_jugador " + dividir[0] + " " + pos + ")\n"
                    
        if tipos_personajes.find(dividir[1]) != -1:
            posiciones += "(posicion_personaje " + dividir[0] + " " + pos + ")\n"
                    
        if tipos_objetos.find(dividir[1]) != -1:
            posiciones += "(posicion_objeto " + dividir[0] + " " + pos + ")\n"
            
    if tipo != '':
        posiciones += "(tipo_terreno " + pos + " " + tipo + ")\n"
    return personajes_objetos, posiciones
    
f = open("ejer3.txt", "r")
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
tipos_objetos = "manzana oro algoritmo oscar rosa bikini zapatilla"
tipos_terreno = "piedra arena precipicio bosque agua"

personajes_objetos = ""
posiciones = ""
conesiones = ""

for x in f:

    if len(x) > 1:
        linea = x.split("->") 
        tipo = linea[0]
        zonas = linea[1].replace("[",";")
        zonas = zonas.replace("]","")
        zonas = zonas.replace("=",";")
        zonas = zonas.replace("\n","")

        zonas = zonas.split(";")
        zonas_conectadas = list()
        distancias_zonas = list()
    
        conectado = ""
        
        zonas_conectadas.append(zonas[0])
        zonas_conectadas.append(zonas[4])
        
        personajes, pos = devolverCaracteristicas(zonas[1],zonas[0],zonas[2])
        personajes_objetos += personajes
        posiciones += pos
            
        personajes, pos = devolverCaracteristicas(zonas[5],zonas[4],zonas[6])
        personajes_objetos += personajes
        posiciones += pos
        distancias_zonas.append(zonas[3])
        
        if len(zonas) == 11:

            zonas_conectadas.append(zonas[8])
            
            
            personajes, pos = devolverCaracteristicas(zonas[9],zonas[8],zonas[10])
            personajes_objetos += personajes
            posiciones += pos
            
            distancias_zonas.append(zonas[7])                    
                    
                
                
            
            #print(nuevo)
    
        if tipo == 'V':
            if(len(zonas_conectadas) == 3):
                conesiones += "(conectada oeste " + zonas_conectadas[1] + " " + zonas_conectadas[0] + ")\n"
                conesiones += "(conectada este " + zonas_conectadas[0] + " " + zonas_conectadas[1] + ")\n"
                conesiones += "(= (coste "+ zonas_conectadas[1] + " " + zonas_conectadas[0] + ") " + distancias_zonas[0] + ")\n"
                conesiones += "(= (coste "+ zonas_conectadas[0] + " " + zonas_conectadas[1] + ") " + distancias_zonas[0] + ")\n"
                
                
                conesiones += "(conectada este " + zonas_conectadas[1] + " " + zonas_conectadas[2] + ")\n"
                conesiones += "(conectada oeste " + zonas_conectadas[2] + " " + zonas_conectadas[1] + ")\n"
                conesiones += "(= (coste "+ zonas_conectadas[1] + " " + zonas_conectadas[2] + ") " + distancias_zonas[1] + ")\n"
                conesiones += "(= (coste "+ zonas_conectadas[2] + " " + zonas_conectadas[1] + ") " + distancias_zonas[1] + ")\n"
            else:
                conesiones += "(conectada oeste " + zonas_conectadas[1] + " " + zonas_conectadas[0] + ")\n"
                conesiones += "(conectada este " + zonas_conectadas[0] + " " + zonas_conectadas[1] + ")\n"
                conesiones += "(= (coste "+ zonas_conectadas[1] + " " + zonas_conectadas[0] + ") " + distancias_zonas[0] + ")\n"
                conesiones += "(= (coste "+ zonas_conectadas[0] + " " + zonas_conectadas[1] + ") " + distancias_zonas[0] + ")\n"
                
        if tipo == 'H':
            if(len(zonas_conectadas) == 3):
                conesiones += "(conectada norte " + zonas_conectadas[1] + " " + zonas_conectadas[0] + ")\n"
                conesiones += "(conectada sur " + zonas_conectadas[0] + " " + zonas_conectadas[1] + ")\n"
                conesiones += "(= (coste "+ zonas_conectadas[1] + " " + zonas_conectadas[0] + ") " + distancias_zonas[0] + ")\n"
                conesiones += "(= (coste "+ zonas_conectadas[0] + " " + zonas_conectadas[1] + ") " + distancias_zonas[0] + ")\n"
                
                conesiones += "(conectada sur " + zonas_conectadas[1] + " " + zonas_conectadas[2] + ")\n"
                conesiones += "(conectada norte " + zonas_conectadas[2] + " " + zonas_conectadas[1] + ")\n"
                conesiones += "(= (coste "+ zonas_conectadas[1] + " " + zonas_conectadas[2] + ") " + distancias_zonas[1] + ")\n"
                conesiones += "(= (coste "+ zonas_conectadas[2] + " " + zonas_conectadas[1] + ") " + distancias_zonas[1] + ")\n"
               
            else:
                conesiones += "(conectada norte " + zonas_conectadas[1] + " " + zonas_conectadas[0] + ")\n"
                conesiones += "(conectada sur " + zonas_conectadas[0] + " " + zonas_conectadas[1] + ")\n"
                conesiones += "(= (coste "+ zonas_conectadas[1] + " " + zonas_conectadas[0] + ") " + distancias_zonas[0] + ")\n"
                conesiones += "(= (coste "+ zonas_conectadas[0] + " " + zonas_conectadas[1] + ") " + distancias_zonas[0] + ")\n"
                
    
    
        
    #print(conectado)
    #for i in nuevo.split(";"):tipo_terreno
     #   print(i)

f = open("ProblemaEjer3.pddl", "w")

f.write("(define (problem " + problema + ")\n")
f.write("(:domain " + dominio + ")")
f.write("(:objects\n")

f.write(stringZonas + "\n")
f.write("piedra agua bosque arena precipicio - suelos\n")
f.write(personajes_objetos)
f.write(stringOrientacion + "\n")
f.write(")\n")
f.write("(:init\n")
f.write("(jugador_sin_objeto jugador1)\n")
f.write("(mochila_vacia jugador1)\n")
f.write(posiciones) 
f.write(conesiones)
f.write("(= (coste_total) 0)\n")
f.write(")\n")

f.write("(:goal (AND\n")
f.write(";(personaje_tiene princesa1 rosa1)\n")
f.write(";(personaje_tiene principe1 oro1)\n")
f.write("(personaje_tiene profesor1 algoritmo1)\n")
f.write(";(personaje_tiene bruja1 manzana1)\n")
f.write(";(personaje_tiene dicaprio1 oscar1)\n")

f.write(")))\n")
#f.write("(:metric minimize (coste_total)))")
f.close()


      


