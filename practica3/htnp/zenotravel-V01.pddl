(define (domain zeno-travel)


(:requirements
  :typing
  :fluents
  :derived-predicates
  :negative-preconditions
  :universal-preconditions
  :disjuntive-preconditions
  :conditional-effects
  :htn-expansion

  ; Requisitos adicionales para el manejo del tiempo
  :durative-actions
  :metatags
 )

(:types aircraft person city - object)
(:constants slow fast - object)
(:predicates (at ?x - (either person aircraft) ?c - city)
             (destino ?p - person ?c1 - city)
             (in ?p - person ?a - aircraft)
             (different ?x ?y) (igual ?x ?y)
             (hay-fuel-lento ?a ?c1 ?c2)
             (hay-fuel-rapido ?a ?c1 ?c2)
             (sobrepasa-limite-rapido ?a ?c1 ?c2)
             (sobrepasa-limite-lento ?a ?c1 ?c2)
             )
(:functions (fuel ?a - aircraft)
            (distance ?c1 - city ?c2 - city)
            (slow-speed ?a - aircraft)
            (fast-speed ?a - aircraft)
            (slow-burn ?a - aircraft)
            (fast-burn ?a - aircraft)
            (capacity ?a - aircraft)
            (refuel-rate ?a - aircraft)
            (total-fuel-used)
            (boarding-time)
            (debarking-time)
            (fuel-limit)
            (personas-montadas ?a - aircraft)
            (limite-pasajeros ?a - aircraft)
            )

;; el consecuente "vac�o" se representa como "()" y significa "siempre verdad"
(:derived
  (igual ?x ?x) ())

(:derived 
  (different ?x ?y) (not (igual ?x ?y)))



;; este literal derivado se utiliza para deducir, a partir de la información en el estado actual, 
;; si hay fuel suficiente para que el avión ?a vuele de la ciudad ?c1 a la ?c2
;; el antecedente de este literal derivado comprueba si el fuel actual de ?a es mayor que 1. 
;; En este caso es una forma de describir que no hay restricciones de fuel. Pueden introducirse una
;; restricción más copleja  si en lugar de 1 se representa una expresión más elaborada (esto es objeto de
;; los siguientes ejercicios).
(:derived 
  
  (hay-fuel-lento ?a - aircraft ?c1 - city ?c2 - city)
  (>= (fuel ?a) (* (distance ?c1 ?c2) (slow-burn ?a))) )

(:derived 
  
  (hay-fuel-rapido ?a - aircraft ?c1 - city ?c2 - city)
  (>= (fuel ?a) (* (distance ?c1 ?c2) (fast-burn ?a))) )

(:derived 
  
  (sobrepasa-limite-lento ?a - aircraft ?c1 - city ?c2 - city)
   (> (fuel-limit)(+ (total-fuel-used) (* (distance ?c1 ?c2) (slow-burn ?a)) ) ))

(:derived 
  
  (sobrepasa-limite-rapido ?a - aircraft ?c1 - city ?c2 - city)
   (> (fuel-limit)(+ (total-fuel-used) (* (distance ?c1 ?c2) (fast-burn ?a)) ) ))

  (:task transport-person
  	:parameters ()
    (:method Case1 ;
     :precondition (and (in ?p - person ?a - aircraft)
                      (at ?a - aircraft ?c1 - city)
                      (destino ?p - person ?c2 - city)
                      (= ?c1 ?c2)
                   )

     :tasks (
             (debark ?p ?a ?c1)
             (transport-person)
            )
     )
      (:method Case3 ;
     :precondition (and (at ?p - person ?c1 - city)
                      (at ?a - aircraft ?c2 - city)
                      (destino ?p - person ?c3 - city)
                      (not(= ?c1 ?c2))
                      (not(= ?c1 ?c3))
                      
                   )

     :tasks (
             (mover-avion ?a ?c2 ?c1)


             (transport-person)
            )
     )
     (:method Case2 ;
     :precondition (and (at ?p - person ?c1 - city)
                      (at ?a - aircraft ?c2 - city)
                      (destino ?p - person ?c3 - city)
                      (= ?c1 ?c2)
                      (not(= ?c1 ?c3))
                   )

     :tasks (
             (board ?p ?a ?c1)

             (transport-person)
            )
     )

     

     (:method Case4 ;
     :precondition (and (in ?p - person ?a - aircraft)
                      (at ?a - aircraft ?c1 - city)
                      (destino ?p - person ?c2 - city)
                      (not(= ?c1 ?c2))
                   )

     :tasks (
             (mover-avion ?a ?c1 ?c2)
             (transport-person)
            )
     )

     (:method Case5
   	 :precondition (and (at ?p - person ?c1 - city)
                      (destino ?p - person ?c2 - city)
                      (= ?c1 ?c2)
                    )
   	 :tasks ()
  )



)
	 

   
  



(:task mover-avion
 :parameters (?a - aircraft ?c1 - city ?c2 -city)
 (:method fuel-suficiente-rapido ;; este método se escogerá para usar la acción fly siempre que el avión tenga fuel para
                          ;; volar desde ?c1 a ?c2
			  ;; si no hay fuel suficiente el método no se aplicará y la descomposición de esta tarea
			  ;; se intentará hacer con otro método. Cuando se agotan todos los métodos posibles, la
			  ;; descomponsición de la tarea mover-avión "fallará". 
			  ;; En consecuencia HTNP hará backtracking y escogerá otra posible vía para descomponer
			  ;; la tarea mover-avion (por ejemplo, escogiendo otra instanciación para la variable ?a)
  :precondition (and (sobrepasa-limite-rapido ?a ?c1 ?c2) (hay-fuel-rapido ?a ?c1 ?c2))
  :tasks (
          (zoom ?a ?c1 ?c2)
         )
   )
   (:method fuel-no-suficiente-rapido ;; este método se escogerá para usar la acción fly siempre que el avión tenga fuel para
                          ;; volar desde ?c1 a ?c2
			  ;; si no hay fuel suficiente el método no se aplicará y la descomposición de esta tarea
			  ;; se intentará hacer con otro método. Cuando se agotan todos los métodos posibles, la
			  ;; descomponsición de la tarea mover-avión "fallará". 
			  ;; En consecuencia HTNP hará backtracking y escogerá otra posible vía para descomponer
			  ;; la tarea mover-avion (por ejemplo, escogiendo otra instanciación para la variable ?a)
  :precondition (and (sobrepasa-limite-rapido ?a ?c1 ?c2) (not(hay-fuel-rapido ?a ?c1 ?c2)))
  :tasks (
          (refuel ?a ?c1)
          (zoom ?a ?c1 ?c2)
         )
   )
 (:method fuel-suficiente-lento ;; este método se escogerá para usar la acción fly siempre que el avión tenga fuel para
                          ;; volar desde ?c1 a ?c2
			  ;; si no hay fuel suficiente el método no se aplicará y la descomposición de esta tarea
			  ;; se intentará hacer con otro método. Cuando se agotan todos los métodos posibles, la
			  ;; descomponsición de la tarea mover-avión "fallará". 
			  ;; En consecuencia HTNP hará backtracking y escogerá otra posible vía para descomponer
			  ;; la tarea mover-avion (por ejemplo, escogiendo otra instanciación para la variable ?a)
  :precondition (and (sobrepasa-limite-lento ?a ?c1 ?c2) (hay-fuel-lento ?a ?c1 ?c2))
  :tasks (
          (fly ?a ?c1 ?c2)
         )
   )
   (:method fuel-no-suficiente-lento ;; este método se escogerá para usar la acción fly siempre que el avión tenga fuel para
                          ;; volar desde ?c1 a ?c2
			  ;; si no hay fuel suficiente el método no se aplicará y la descomposición de esta tarea
			  ;; se intentará hacer con otro método. Cuando se agotan todos los métodos posibles, la
			  ;; descomponsición de la tarea mover-avión "fallará". 
			  ;; En consecuencia HTNP hará backtracking y escogerá otra posible vía para descomponer
			  ;; la tarea mover-avion (por ejemplo, escogiendo otra instanciación para la variable ?a)
  :precondition (and (sobrepasa-limite-lento ?a ?c1 ?c2) (not(hay-fuel-lento ?a ?c1 ?c2)))
  :tasks (
          (refuel ?a ?c1)
          (fly ?a ?c1 ?c2)
         )
   )
  )

(:task embarcar-recursivo ;;tarea de mayor nivel de abstracción
 :parameters(?a - aircraft ?c1 - city) 

 (:method embarcar ;; método para decidir si una persona va a la pelicula de terror.
  :precondition (AND 
                  (at ?p - person ?c1)
                  (< (personas-montadas ?a)  (limite-pasajeros ?a))
                  (NOT (destino ?p - person  ?c1)))
  :tasks ( 
           (board ?p ?a ?c1)
           ;(+ (personas-montadas ?a) 1)
           (embarcar-recursivo ?a ?c1)))			;; recurre para decidir la siguiente persona en la cola
 
  (:method caso-base ;; método caso base de la recursión
   :precondition():tasks()))

(:task desembarcar-recursivo ;;tarea de mayor nivel de abstracción
 :parameters(?a - aircraft ?c1 - city) 

 (:method desembarcar ;; método para decidir si una persona va a la pelicula de terror.
  :precondition (and (destino ?p - person  ?c1)
                (in ?p - person ?a))
  :tasks ( 
           (debark ?p ?a ?c1)
           ;(+ (personas-montadas ?a) 1)
           (desembarcar-recursivo ?a ?c1)))			;; recurre para decidir la siguiente persona en la cola
 
  (:method caso-base ;; método caso base de la recursión
   :precondition():tasks()))










 
(:import "C:\Users\jo_se\Desktop\practica3\htnp\Primitivas-ZenoTravel.pddl") 


)
