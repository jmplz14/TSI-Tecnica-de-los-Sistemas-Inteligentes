(define (problem PEjer3)
(:domain DEjer3)(:objects
z1 z2 z3 z4 z5 z6 z7 z8 z9 z10 z11 z12 z13 z14 z15 z16 z17 z18 z19 z20 z21 z22 z23 z24 z25 - zona
piedra agua bosque arena precipicio - suelos
jugador1 - jugador
dicaprio1 - dicaprio
zapatilla1 - zapatilla
rosa1 - rosa
oscar1 - oscar
bikini1 - bikini
princesa1 - princesa
manzana1 - manzana
algoritmo1 - algoritmo
oro1 - oro
bruja1 - bruja
principe1 - principe
profesor1 - profesor
norte este sur oeste - orientacion
)
(:init
(jugador_sin_objeto jugador1)
(mochila_vacia jugador1)
(orientacion_jugador jugador1 norte)
(posicion_jugador jugador1 z1)
(= (puntos_totales jugador1) 0)
(tipo_terreno z1 arena)
(tipo_terreno z2 arena)
(tipo_terreno z3 piedra)
(tipo_terreno z4 piedra)
(tipo_terreno z5 piedra)
(posicion_personaje dicaprio1 z5)
(posicion_objeto zapatilla1 z6)
(tipo_terreno z6 arena)
(posicion_objeto rosa1 z7)
(tipo_terreno z7 piedra)
(posicion_objeto oscar1 z8)
(tipo_terreno z8 arena)
(tipo_terreno z9 bosque)
(posicion_objeto bikini1 z9)
(tipo_terreno z10 bosque)
(posicion_personaje princesa1 z11)
(tipo_terreno z11 bosque)
(tipo_terreno z13 precipicio)
(posicion_objeto manzana1 z12)
(tipo_terreno z12 arena)
(posicion_objeto algoritmo1 z14)
(tipo_terreno z14 piedra)
(posicion_objeto oro1 z15)
(tipo_terreno z15 arena)
(tipo_terreno z16 arena)
(posicion_personaje bruja1 z16)
(posicion_personaje principe1 z18)
(tipo_terreno z18 piedra)
(tipo_terreno z17 arena)
(tipo_terreno z19 agua)
(tipo_terreno z21 precipicio)
(tipo_terreno z20 agua)
(tipo_terreno z22 piedra)
(tipo_terreno z23 piedra)
(tipo_terreno z25 piedra)
(tipo_terreno z24 piedra)
(posicion_personaje profesor1 z24)
(conectada oeste z2 z1)
(conectada este z1 z2)
(= (coste z2 z1) 1)
(= (coste z1 z2) 1)
(conectada este z2 z3)
(conectada oeste z3 z2)
(= (coste z2 z3) 3)
(= (coste z3 z2) 3)
(conectada oeste z4 z3)
(conectada este z3 z4)
(= (coste z4 z3) 1)
(= (coste z3 z4) 1)
(conectada este z4 z5)
(conectada oeste z5 z4)
(= (coste z4 z5) 4)
(= (coste z5 z4) 4)
(conectada oeste z6 z5)
(conectada este z5 z6)
(= (coste z6 z5) 1)
(= (coste z5 z6) 1)
(conectada norte z8 z7)
(conectada sur z7 z8)
(= (coste z8 z7) 2)
(= (coste z7 z8) 2)
(conectada sur z8 z9)
(conectada norte z9 z8)
(= (coste z8 z9) 1)
(= (coste z9 z8) 1)
(conectada norte z4 z9)
(conectada sur z9 z4)
(= (coste z4 z9) 1)
(= (coste z9 z4) 1)
(conectada sur z4 z10)
(conectada norte z10 z4)
(= (coste z4 z10) 3)
(= (coste z10 z4) 3)
(conectada norte z11 z10)
(conectada sur z10 z11)
(= (coste z11 z10) 2)
(= (coste z10 z11) 2)
(conectada norte z12 z13)
(conectada sur z13 z12)
(= (coste z12 z13) 1)
(= (coste z13 z12) 1)
(conectada sur z12 z1)
(conectada norte z1 z12)
(= (coste z12 z1) 2)
(= (coste z1 z12) 2)
(conectada norte z13 z14)
(conectada sur z14 z13)
(= (coste z13 z14) 1)
(= (coste z14 z13) 1)
(conectada oeste z15 z14)
(conectada este z14 z15)
(= (coste z15 z14) 2)
(= (coste z14 z15) 2)
(conectada este z15 z16)
(conectada oeste z16 z15)
(= (coste z15 z16) 1)
(= (coste z16 z15) 1)
(conectada oeste z7 z16)
(conectada este z16 z7)
(= (coste z7 z16) 3)
(= (coste z16 z7) 3)
(conectada norte z17 z18)
(conectada sur z18 z17)
(= (coste z17 z18) 1)
(= (coste z18 z17) 1)
(conectada sur z17 z16)
(conectada norte z16 z17)
(= (coste z17 z16) 4)
(= (coste z16 z17) 4)
(conectada oeste z19 z18)
(conectada este z18 z19)
(= (coste z19 z18) 2)
(= (coste z18 z19) 2)
(conectada este z19 z21)
(conectada oeste z21 z19)
(= (coste z19 z21) 2)
(= (coste z21 z19) 2)
(conectada norte z19 z20)
(conectada sur z20 z19)
(= (coste z19 z20) 1)
(= (coste z20 z19) 1)
(conectada oeste z22 z20)
(conectada este z20 z22)
(= (coste z22 z20) 1)
(= (coste z20 z22) 1)
(conectada este z22 z23)
(conectada oeste z23 z22)
(= (coste z22 z23) 3)
(= (coste z23 z22) 3)
(conectada norte z22 z25)
(conectada sur z25 z22)
(= (coste z22 z25) 2)
(= (coste z25 z22) 2)
(conectada sur z22 z21)
(conectada norte z21 z22)
(= (coste z22 z21) 1)
(= (coste z21 z22) 1)
(conectada oeste z24 z25)
(conectada este z25 z24)
(= (coste z24 z25) 2)
(= (coste z25 z24) 2)
(conectada norte z23 z24)
(conectada sur z24 z23)
(= (coste z23 z24) 1)
(= (coste z24 z23) 1)
(= (coste_total) 0)
(= (puntos_minimos) 10)
(= (valor_objeto rosa1 dicaprio1) 1)
(= (valor_objeto rosa1 princesa1) 10)
(= (valor_objeto rosa1 bruja1) 5)
(= (valor_objeto rosa1 principe1) 3)
(= (valor_objeto rosa1 profesor1) 4)
(= (valor_objeto oscar1 dicaprio1) 10)
(= (valor_objeto oscar1 princesa1) 5)
(= (valor_objeto oscar1 bruja1) 4)
(= (valor_objeto oscar1 principe1) 1)
(= (valor_objeto oscar1 profesor1) 3)
(= (valor_objeto manzana1 dicaprio1) 3)
(= (valor_objeto manzana1 princesa1) 1)
(= (valor_objeto manzana1 bruja1) 10)
(= (valor_objeto manzana1 principe1) 4)
(= (valor_objeto manzana1 profesor1) 5)
(= (valor_objeto algoritmo1 dicaprio1) 4)
(= (valor_objeto algoritmo1 princesa1) 3)
(= (valor_objeto algoritmo1 bruja1) 1)
(= (valor_objeto algoritmo1 principe1) 5)
(= (valor_objeto algoritmo1 profesor1) 10)
(= (valor_objeto oro1 dicaprio1) 5)
(= (valor_objeto oro1 princesa1) 4)
(= (valor_objeto oro1 bruja1) 3)
(= (valor_objeto oro1 principe1) 10)
(= (valor_objeto oro1 profesor1) 1)
)
(:goal (AND
(= (puntos_totales jugador1) (puntos_minimos))
)))
