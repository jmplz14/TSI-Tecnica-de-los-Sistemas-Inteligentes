#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue May 21 19:01:27 2019

@author: jose
"""
import sys
def matrizPuntos(per,obj):
    matriz = [[10,5,4,3,1],
              [1,10,5,4,3],
              [3,1,10,5,4],
              [4,3,1,10,5],
              [5,4,3,1,10]]
    objetos = ["oscar","rosa","manzana","algoritmo","oro"]
    personajes = ["dicaprio","princesa","bruja","profesor","principe"]
    valores_objetos = ""
    for i in range(int(len(obj)/2)):
        for j in range(int(len(per)/2)):
            valor_i = objetos.index(obj[i*2 + 1])
            valor_j = personajes.index(per[j*2 + 1])
            
            valores_objetos += "(= (valor_objeto " + str(obj[i*2]) + " " + (per[j*2]) + ") " + str(matriz[valor_i][valor_j]) + ")\n"
            
    return valores_objetos    

personajes_introducidos = list()
objetos_introducidos = list()
cadena_bolsillos = ""
def devolverCaracteristicas(nuevo,pos,tipo,bols_usado):
    personajes_objetos = ""
    posiciones = ""
    bolsillos = ""
    if nuevo != '':
        personajes_objetos += nuevo.replace("-"," - ") + "\n"
        dividir = nuevo.split("-")
        if "jugador" == dividir[1]:
                posiciones += "(orientacion_jugador " + dividir[0] + " norte)\n"
                posiciones += "(posicion_jugador " + dividir[0] + " " + pos + ")\n"
                posiciones += "(= (puntos_totales "+ dividir[0] +") 0)\n"
                    
        if tipos_personajes.find(dividir[1]) != -1:
            posiciones += "(posicion_personaje " + dividir[0] + " " + pos + ")\n"
            personajes_introducidos.append(dividir[0])
            personajes_introducidos.append(dividir[1])
            copia = dividir[0]
            if bols_usado.find(copia) == -1:
                bolsillos += "(= (bolsillo " + dividir[0] + ") 1)\n"
                
            
        if tipos_objetos.find(dividir[1]) != -1:
            posiciones += "(posicion_objeto " + dividir[0] + " " + pos + ")\n"
            if dividir[1] != "zapatilla" and dividir[1] != "bikini":
                objetos_introducidos.append(dividir[0])
                objetos_introducidos.append(dividir[1])
            
    if tipo != '':
        posiciones += "(tipo_terreno " + pos + " " + tipo + ")\n"
    return personajes_objetos, posiciones, bolsillos

f = open(sys.argv[1], "r")
dominio = f.readline()
problema = f.readline()
problema = problema.replace("\n","")
num_zonas = f.readline()
puntos_totales = f.readline()
bolsillos = f.readline()
dominio = dominio.split(":")[1]
dominio = dominio.replace("\n","")
problema = problema.split(":")[1]
num_zonas = int(num_zonas.split(":")[1])
puntos_totales = puntos_totales.split(":")[1]
puntos_totales = puntos_totales.replace("\n","")

bolsillos = bolsillos.split("[")[1]
bolsillos = bolsillos.replace("]","")
bolsillos = bolsillos.split()

bolsillos_usado = ""

for i in bolsillos:
    divison = i.split(":")
    bolsillos_usado += divison[0] + " "
    cadena_bolsillos += "(= (bolsillo " + divison[0] + ") " + str(divison[1]) + ")\n" 


#bolsillos = bolsillos.replace()



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
        
        personajes, pos, bol = devolverCaracteristicas(zonas[1],zonas[0],zonas[2],bolsillos_usado)
        personajes_objetos += personajes
        posiciones += pos
        cadena_bolsillos += bol
        
        personajes, pos, bol = devolverCaracteristicas(zonas[5],zonas[4],zonas[6],bolsillos_usado)
        personajes_objetos += personajes
        posiciones += pos
        cadena_bolsillos += bol
        
        distancias_zonas.append(zonas[3])
        
        if len(zonas) == 11:

            zonas_conectadas.append(zonas[8])
            
            
            personajes, pos, bol = devolverCaracteristicas(zonas[9],zonas[8],zonas[10],bolsillos_usado)
            personajes_objetos += personajes
            posiciones += pos
            cadena_bolsillos += bol
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
f = open(sys.argv[2], "w")

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
f.write("(= (puntos_minimos) "+ puntos_totales +")\n")
f.write(cadena_bolsillos)
#f.write("(= (puntos_totales) 0)\n")
f.write(matrizPuntos(personajes_introducidos,objetos_introducidos))
f.write(")\n")

f.write("(:goal (AND\n")
f.write("(> (puntos_totales jugador1) (puntos_minimos))\n")
f.write(")))\n")
#f.write("(:metric minimize (coste_total)))")
f.close()


      


