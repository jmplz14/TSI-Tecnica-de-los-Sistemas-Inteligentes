(define (problem torre1)
(:domain bloques)
(:objects
  A B C D - bloque)
(:init
  (sobremesa a)
  (sobre b a)
  (sobre c b)
  (sobre d c)
  (libre d)
  (manovacia))
(:tasks-goal
 :tasks ((sobre d mesa)(sobre c d)(sobre b c)(sobre a b)))
)
