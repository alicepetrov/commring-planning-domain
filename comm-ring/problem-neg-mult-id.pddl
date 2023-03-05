(define (problem ZERO-PROD)
; -1 * a = -a

(:domain COMMRING)
; WIP INCOMPLETE

(:objects a i mini zero iPLUSmini iPLUSminiTIMESa zeroTIMESa)

(:init 
       (ismultidentity i)
       (isadditiveinverse i mini)

       (iszero zero)
       (allowzeroprod)

       (issum iPLUSmini i mini)
       (isprod iPLUSminiTIMESa iPLUSmini a)

       (isprod zeroTIMESa zero a)
    )

(:goal (and (equal iPLUSminiTIMESa zeroTIMESa)))

)