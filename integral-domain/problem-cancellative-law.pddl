(define (problem CANCLAW)
; if ab = ac, then b = c

(:domain INTEGRALDOMAIN)

(:objects a b c ab ac abMINac bMINc aTIMESbMINc minc minac zero)

(:init 
        (iszero zero)

        (isprod ab a b)
        (isprod ac a c)
        (isprod minac a minc)
        (isprod aTIMESbMINc a bMINc)

        (issum abMINac ab minac)
        (issum bMINc b minc)

        (isadditiveinverse ac minac)
        (isadditiveinverse c minc)

        ; Problem set up
        (assumenonzero a)
        (equal ab ac)

    )

(:goal (and (equal b c) (not (contradiction)))) 

)