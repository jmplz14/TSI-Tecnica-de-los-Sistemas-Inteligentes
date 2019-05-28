(define (domain bloques)
(:requirements
  :typing
  :fluents
  :derived-predicates
  :negative-preconditions
  :htn-expansion)

(:types
  bloque superficie - object)

(:constants mesa - superficie) 

(:predicates
  (manovacia)
  (libre ?x - bloque)
  (cogido ?x - bloque)
  (sobremesa ?x - bloque)
  (sobre ?x ?y - bloque)
  (igual ?x ?y)
  (distinto ?x ?y))

(:derived
  (igual ?x ?x) ())

(:derived 
  (distinto ?x ?y) (not (igual ?x ?y)))

(:task sobre
 :parameters (?x ?y)
 (:method poner_encima
  :precondition () ; vacío
  :tasks ((limpiar ?x)(limpiar ?y)(colocar ?x ?y))))

(:task limpiar
 :parameters (?x)
 (:method limpiar_mesa
  :precondition (igual ?x mesa)
  :tasks())
 (:method limpiar_libre
  :precondition (libre ?x)
  :tasks ())
 (:method limpiar_ocupado
  :precondition (sobre ?y ?x)
  :tasks ((limpiar ?y)(colocar ?y mesa))))
  
(:task colocar
 :parameters (?x ?y)
 (:method colocar
  :precondition ()
  :tasks ((primero-coge ?x)(despues-deja ?x ?y))))

(:task primero-coge
 :parameters (?x - bloque)
 (:method cogelo_de_la_mesa
  :precondition (sobremesa ?x)
  :tasks (coger ?x))
 (:method cogelo_de_la_pila
  :precondition (sobre ?x ?y)
  :tasks (desapilar ?x ?y)))

(:task despues-deja
 :parameters (?x - bloque ?y - object)
 (:method dejalo_en_la_mesa
  :precondition (igual ?y mesa)
  :tasks (dejar ?x))
 (:method dejalo_en_la_pila
  :precondition (distinto ?y mesa)
  :tasks (apilar ?x ?y)))


(:action coger
 :parameters (?x - bloque)
 :precondition (and (sobremesa ?x)(libre ?x)(manovacia))
 :effect (and (not (sobremesa ?x)) (not (libre ?x))(not (manovacia))
	      (cogido ?x)))

(:action dejar
 :parameters (?x - bloque)
 :precondition (cogido ?x)
 :effect (and (sobremesa ?x) (libre ?x) (manovacia)
              (not (cogido ?x))))

(:action apilar
 :parameters (?x ?y - bloque)
 :precondition (and (cogido ?x)(libre ?y))
 :effect (and (not (cogido ?x)) (not (libre ?y)) (libre ?x) (sobre ?x ?y) (manovacia)))

(:action desapilar
 :parameters (?x ?y - bloque)
 :precondition (and (manovacia) (libre ?x) (sobre ?x ?y))
 :effect  (and (cogido ?x) (libre ?y) (not (libre ?x)) (not (sobre ?x ?y)) (not (manovacia))))
)
