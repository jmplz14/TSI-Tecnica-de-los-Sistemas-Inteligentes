(define (problem PEjer1)
    (:domain DEjer1)
  (:objects z1 z2 z3 z4 z5 z6 z7 z8 z9 z10 z11 z12 z13 z14 z15 z16 z17 z18 z19 z20 z21 z22 z23 z24 z25 - zona
    
            jugador1 - jugador
            princesa1 - princesa
            principe1 - principe
            profesor1 - profesor
            dicaprio1 - dicaprio
            bruja1 - bruja

            oro1 - oro
            manzana1 -manzana
            algoritmo1 - algoritmo
            oscar1 - oscar
            rosa1 - rosa
 			      norte este sur oeste - orientacion)

  (:init 
	
	(orientacion_jugador jugador1 norte)
  (posicion_personaje princesa1 z7)
  (posicion_personaje principe1 z10)
  (posicion_personaje bruja1 z5)
  (posicion_personaje profesor1 z20)
  (posicion_personaje dicaprio1 z6)

  (posicion_jugador jugador1 z1)

  (posicion_objeto manzana1 z11)
  (posicion_objeto oscar1 z18)
  (posicion_objeto rosa1 z9)
  (posicion_objeto algoritmo1 z12)
  (posicion_objeto oro1 z25)

  (conectada norte z1 z12)
  (conectada este z1 z2)
  
  (conectada oeste z2 z1)
  (conectada este z2 z3)

  (conectada oeste z3 z2)
  (conectada este z3 z4)

  (conectada oeste z4 z3)
  (conectada este z4 z5)
  (conectada norte z4 z9)
  (conectada sur z4 z10)

  (conectada oeste z5 z4)
  (conectada este z5 z6)

  (conectada oeste z6 z5)
  
  (conectada oeste z7 z16)
  (conectada sur z7 z8)

  (conectada norte z8 z7)
  (conectada sur z8 z9)

  (conectada norte z9 z8)
  (conectada sur z9 z4)

  (conectada norte z10 z4)
  (conectada sur z10 z11)

  (conectada norte z11 z10)
  
  (conectada norte z12 z13)
  (conectada sur z12 z1)

  (conectada norte z13 z14)
  (conectada sur z13 z12)

  (conectada este z14 z15)
  (conectada sur z14 z13)

  (conectada oeste z15 z14)
  (conectada este z15 z16)

  (conectada oeste z16 z15)
  (conectada este z16 z7)
  (conectada norte z16 z17)
  
  (conectada sur z17 z16)
  (conectada norte z17 z18)

  (conectada sur z18 z17)
  (conectada este z18 z19)
  
  (conectada oeste z19 z18)
  (conectada norte z19 z20)
  (conectada este z19 z21)

  (conectada sur z20 z19)
  (conectada este z20 z22)

  (conectada oeste z21 z19)
  (conectada norte z21 z22)

  (conectada norte z22 z25)
  (conectada sur z22 z21)
  (conectada oeste z22 z20)
  (conectada este z22 z23)

  (conectada oeste z23 z22)
  (conectada norte z23 z24)

  (conectada sur z24 z23)
  (conectada oeste z24 z25)

  (conectada este z25 z24)
  (conectada sur z25 z22)
  
	 )
  (:goal (AND 
          (personaje_tiene_objeto princesa1)
          (personaje_tiene_objeto principe1)
          (personaje_tiene_objeto bruja1)
          (personaje_tiene_objeto dicaprio1)
          (personaje_tiene_objeto profesor1)
  
  )))