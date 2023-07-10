(define (problem ISZERO)
; if ab = 0 and b \= 0, then a = 0

(:domain INTEGRALDOMAIN)

(:objects ab zero)

(:init
        (iszero zero)
        (isprod ab a b)
        (equal ab zero)
        (assumenonzero b)
    )

(:goal (and (goal)))

)
