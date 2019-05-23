(define (domain DEjer4); girar izquierda
  (:requirements :strips :equality :typing)
  (:types  jugador - tipos
				orientacion
				princesa principe bruja profesor dicaprio - personaje
			    oscar manzana rosa algoritmo oro bikini zapatilla - objeto
				roca arena - zonas_validas
				    )
 
  (:predicates 
	       ;(on-floor ?player - monkey )
	       ;(at ?m - locatable ?player - location)
	       ;(onbox ?player - monkey ?cardinal - location)
	       ;(hasbananas ?player - monkey)
	       (orientacion_jugador ?player - jugador ?cardinal - orientacion)
				 (conectada ?cardinal - orientacion ?zona1 - zona ?zona2 - zona)
				 (posicion_jugador ?player - jugador ?zona - zona)
				 (jugador_tiene ?player - jugador ?objeto - objeto)
				 (personaje_tiene ?personaje - personaje ?objeto - objeto)
				 (personaje_tiene_objeto ?personaje - personaje)
				 (posicion_objeto ?objeto - objeto ?zona - zona)
				 (posicion_personaje ?personaje - personaje ?zona - zona)
				 (tipo_terreno ?zona - zona ?tipo_suelo - suelos)
				 (jugador_sin_objeto ?player - jugador)
				 (mochila_vacia ?player - jugador)
				 (mochila_tiene ?player - jugador ?objeto - objeto)
	       )
	(:functions
		(coste ?zona1 - zona ?zona2 - zona)
		(coste_total)
		(valor_objeto ?objeto - objeto ?personaje - personaje)
		(puntos_minimos)
		(puntos_totales ?player - jugador)
	)

  (:action girarIzquierda
	     :parameters (?player - jugador)
	     :effect
		 		(and
			 	(when (orientacion_jugador ?player norte) (and (not(orientacion_jugador ?player norte)) (orientacion_jugador ?player oeste)))
				(when (orientacion_jugador ?player oeste) (and (not(orientacion_jugador ?player oeste)) (orientacion_jugador ?player sur)))
				(when (orientacion_jugador ?player sur) (and (not(orientacion_jugador ?player sur)) (orientacion_jugador ?player este)))
				(when (orientacion_jugador ?player este) (and (not(orientacion_jugador ?player este)) (orientacion_jugador ?player norte)))
				)
  )

  (:action girarDerecha
	     :parameters (?player - jugador)
	     :effect
		 		(and
			 	(when (orientacion_jugador ?player norte) (and (not(orientacion_jugador ?player norte)) (orientacion_jugador ?player este)))
				(when (orientacion_jugador ?player este) (and (not(orientacion_jugador ?player este)) (orientacion_jugador ?player sur)))
				(when (orientacion_jugador ?player sur) (and (not(orientacion_jugador ?player sur)) (orientacion_jugador ?player oeste)))
				(when (orientacion_jugador ?player oeste) (and (not(orientacion_jugador ?player oeste)) (orientacion_jugador ?player norte)))
				)
  )

  (:action moverseOrientado
	:parameters(?player - jugador ?cardinal - orientacion ?zona_actual - zona ?zona_destino - zona  ?terreno - suelos)
	:precondition (and (orientacion_jugador ?player ?cardinal)
										(posicion_jugador ?player ?zona_actual)
										(conectada ?cardinal ?zona_actual ?zona_destino)
										(tipo_terreno ?zona_destino ?terreno)
										
								)
	:effect(and 
				(when (tipo_terreno ?zona_destino arena) (and (not (posicion_jugador ?player ?zona_actual))
															(posicion_jugador ?player ?zona_destino)
															(increase (coste_total) (coste ?zona_actual ?zona_destino))
														 )
				)

				(when (tipo_terreno ?zona_destino piedra) (and (not (posicion_jugador ?player ?zona_actual))
															(posicion_jugador ?player ?zona_destino)
															(increase (coste_total) (coste ?zona_actual ?zona_destino))
														 )
				)
				
					

			)
  )

  

  (:action moverseOrientadoBosque
	:parameters(?player - jugador ?cardinal - orientacion ?zona_actual - zona ?zona_destino - zona  ?terreno - suelos ?objeto - zapatilla)
	:precondition (and (orientacion_jugador ?player ?cardinal)
										(posicion_jugador ?player ?zona_actual)
										(conectada ?cardinal ?zona_actual ?zona_destino)
										(tipo_terreno ?zona_destino ?terreno)
										(or (jugador_tiene ?player ?objeto) (mochila_tiene ?player ?objeto))
										
								)
	:effect(and 
				
				(when (tipo_terreno ?zona_destino bosque) (and 
															(not (posicion_jugador ?player ?zona_actual))
															(posicion_jugador ?player ?zona_destino)
															(increase (coste_total) (coste ?zona_actual ?zona_destino))
														 )
				)


				
					

			)
  )

  (:action moverseOrientadoAgua
	:parameters(?player - jugador ?cardinal - orientacion ?zona_actual - zona ?zona_destino - zona  ?terreno - suelos ?objeto - bikini)
	:precondition (and (orientacion_jugador ?player ?cardinal)
										(posicion_jugador ?player ?zona_actual)
										(conectada ?cardinal ?zona_actual ?zona_destino)
										(tipo_terreno ?zona_destino ?terreno)
										(or (jugador_tiene ?player ?objeto) (mochila_tiene ?player ?objeto))
										
								)
	:effect(and 
				
				(when (tipo_terreno ?zona_destino agua) (and 
															(not (posicion_jugador ?player ?zona_actual))
															(posicion_jugador ?player ?zona_destino)
															(increase (coste_total) (coste ?zona_actual ?zona_destino))
														 )
				)


				
					

			)
  )


	(:action cogerObjeto 
	:parameters (?player - jugador ?objeto - objeto, ?zona - zona)
	:precondition(and			
								(jugador_sin_objeto ?player)
								(posicion_jugador ?player ?zona)
								(posicion_objeto ?objeto ?zona)
							)
	:effect(and 
					(not (posicion_objeto ?objeto ?zona))
					(not (jugador_sin_objeto ?player))
					(jugador_tiene ?player ?objeto)
					
			)
	)
	

	(:action dejarObjeto 
	:parameters (?player - jugador ?objeto - objeto, ?zona - zona)
	:precondition(and
								(posicion_jugador ?player ?zona)
								(jugador_tiene ?player ?objeto)
								
							)
	:effect(and 
					(not (jugador_tiene ?player ?objeto))
					(posicion_objeto ?objeto ?zona)
					(jugador_sin_objeto ?player)
					)
	)

	(:action meterObjetoMochila 
	:parameters (?player - jugador ?objeto - objeto)
	:precondition(and			
								(mochila_vacia ?player)
								(jugador_tiene ?player ?objeto)
								
							)
	:effect(and 
					(not (jugador_tiene ?player ?objeto))
					(not (mochila_vacia ?player))
					(mochila_tiene ?player ?objeto)
					(jugador_sin_objeto ?player)
					
			)
	)

	(:action sacarObjetoMochila 
	:parameters (?player - jugador ?objeto - objeto ?zona - zona)
	:precondition(and			
								(posicion_jugador ?player ?zona)
								(mochila_tiene ?player ?objeto)
								
							)
	:effect(and 
					(mochila_vacia ?player)
					(not (mochila_tiene ?player ?objeto))
					(posicion_objeto ?objeto ?zona)
					
			)
	)

	(:action entregarObjeto
	:parameters (?player -jugador ?personaje - personaje ?objeto - objeto ?zona - zona )
	:precondition(and
								(posicion_jugador ?player ?zona)
								(posicion_personaje ?personaje ?zona)
								(jugador_tiene ?player ?objeto)
								)
	:effect(and 
					(not (jugador_tiene ?player ?objeto))
					(jugador_sin_objeto ?player)
					(personaje_tiene ?personaje ?objeto)
					(personaje_tiene_objeto ?personaje)
					(increase (puntos_totales ?player) (valor_objeto ?objeto ?personaje))
					)
	)



)

			
