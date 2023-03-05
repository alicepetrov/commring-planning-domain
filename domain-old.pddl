(define (domain COMMRING)
  (:requirements :strips :adl)
  (:types element)
  (:predicates (equal ?a ?b)
               (issum ?a ?b ?z)
			   (istrisum ?a ?b ?c ?d)
               (iszero ?z)
			   (isprod ?ab ?a ?b)
               (isdiff ?bMINc ?b ?c)
			   (isadditiveinverse ?a ?ADDINVa)
               (assumenonzero ?a)
               (assumezero ?a)
			   (undeclared ?a)
			   (contradiction))

	; =========================================================================
	; SECTION 0: AXIOMS

	; Definition. A ring is a set R with an operation called addition:
	; for any a, b ∈ R, there is an element a + b ∈ R,
	(:action addition-axiom
    	     :parameters (?a ?b ?c)
    	     :precondition (and
				(undeclared ?c)
				(not (undeclared ?a))
				(not (undeclared ?b)))
    	     :effect (and 
			 	(issum ?c ?a ?b)
				(not (undeclared  ?c))))

	; and another operation called multiplication:
	; for any a, b ∈ R, there is an element ab ∈ R,
	(:action multiplication-axiom
    	     :parameters (?a ?b ?c)
    	     :precondition (and
				(undeclared ?c)
				(not (undeclared ?a))
				(not (undeclared ?b)))
    	     :effect (and 
			 	(isprod ?c ?a ?b)
				(not (undeclared  ?c))))

	; satisfying the following axioms:
	; (i) Addition is associative, i.e.
	; (a + b) + c = a + (b + c) for all a, b, c ∈ R. (associative-addition-axiom b2 a b1 zero zero b1 b2)
	(:action associative-addition-axiom
    	     :parameters (?a ?b ?c ?aPLUSb ?bPLUSc ?aPLUSbANDc ?aANDbPLUSc)
    	     :precondition (and 
			 	(issum ?aPLUSb ?a ?b)
				(issum ?bPLUSc ?b ?c)
			 	(issum ?aPLUSbANDc ?aPLUSb ?c) 
				(issum ?aANDbPLUSc ?a ?bPLUSc))
    	     :effect (and (equal ?aPLUSbANDc ?aANDbPLUSc)))

	; (ii) There is an element of R, called the zero element and written 0,
	; which has the property that
	; a + 0 = 0 + a = a for all a ∈ R.
	(:action zero-axiom
    	     :parameters (?a ?z ?aPLUSz ?zPLUSa)
    	     :precondition (and (issum ?aPLUSz ?a ?z) (issum ?zPLUSa ?z ?a) (iszero ?z))
    	     :effect (and 
			 	(equal ?aPLUSz ?zPLUSa)
				(equal ?a ?zPLUSa)
				(equal ?aPLUSz ?a)))

	; (iii) Every element a ∈ R has a negative, an element of R written −a,
	; which satisfies
	; a + (−a) = (−a) + a = 0.
	(:action additive-inverse-axiom
    	     :parameters (?a ?ADDINVa ?aPLUSADDINVa ?z)
    	     :precondition (and 
			 (issum ?aPLUSADDINVa ?a ?ADDINVa)
			 (iszero ?z) 
			 (or 
			 	(and (undeclared ?ADDINVa) (not (undeclared ?a))) 
			 	(isadditiveinverse ?a ?ADDINVa)))
    	     :effect (and 
			 	(equal ?aPLUSADDINVa ?z)
				(isadditiveinverse ?a ?ADDINVa)
				(not (undeclared ?ADDINVa))))

	; (iv) Addition is commutative, i.e.
	; a + b = b + a for all a, b ∈ R.
	(:action commutative-addition-axiom
    	     :parameters (?a ?b ?aPLUSb ?bPLUSa)
    	     :precondition (and (issum ?aPLUSb ?a ?b) (issum ?bPLUSa ?b ?a))
    	     :effect (and (equal ?aPLUSb ?bPLUSa)))


	; (v) Multiplication is associative, i.e.
	; (ab)c = a(bc) for all a, b, c ∈ R.
	(:action associative-multiplication-axiom
    	     :parameters (?a ?b ?c ?ab ?bc ?abTIMESc ?aTIMESbc)
    	     :precondition (and 
			 	(isprod ?ab ?a ?b)
				(isprod ?bc ?b ?c)
			 	(isprod ?abTIMESc ?ab ?c) 
				(isprod ?aTIMESbc ?a ?bc))
    	     :effect (and (equal ?abTIMESc ?aTIMESbc)))

	; (vi) Multiplication is distributive over addition, i.e.
	; a(b + c) = ab + ac for all a, b, c ∈ R.
	(:action distributivity-axiom-aTIMESbPLUSc
    	     :parameters (?a ?b ?c ?bPLUSc ?ab ?ac ?aTIMESbPLUSc ?abPLUSac)
    	     :precondition (and 
                (issum ?bPLUSc ?b ?c)
                (isprod ?aTIMESbPLUSc ?a ?bPLUSc)
                (issum ?abPLUSac ?ab ?ac)
				(isprod ?ab ?a ?b)
                (isprod ?ac ?a ?c))
    	     :effect (and (equal ?aTIMESbPLUSc ?abPLUSac)))

	; and (a + b)c = ac + bc for all a, b, c ∈ R.
	(:action distributivity-axiom-aPLUSbTIMESc
    	     :parameters (?a ?b ?c ?aPLUSb ?ac ?bc ?aPLUSbTIMESc ?acPLUSbc)
    	     :precondition (and
                (issum ?aPLUSb ?a ?b)
                (isprod ?aPLUSbTIMESc ?aPLUSb ?c)
                (issum ?acPLUSbc ?ac ?bc)
				(isprod ?ac ?a ?c)
                (isprod ?bc ?b ?c))
    	     :effect (and (equal ?aPLUSbTIMESc ?acPLUSbc)))

	; =========================================================================
	; SECTION 1: EQUALITY
	       
	; a = a
	(:action set-equal-self
    	     :parameters (?a)
    	     :precondition ()
    	     :effect (and (equal ?a ?a)))
    	     
	
	; if a = b then b = a
	(:action swap-equal
    	     :parameters (?a ?b)
    	     :precondition (and (equal ?a ?b))
    	     :effect (and (equal ?b ?a)))

	
	; TODO simplified action of set-equal below, separate if planner struggles
	; if a = b and b = c, then a = c
    ; (:action set-equal
    ; 	     :parameters (?a ?b ?c)
    ; 	     :precondition (and (equal ?a ?b) (equal ?b ?c))
    ; 	     :effect (and (equal ?a ?c)))

    ; if a = b and b = c, then a = c or if a = b - c and a = 0, then b = c
    (:action set-equal
    	     :parameters (?a ?b ?c)
    	     :precondition (or
                    (and (equal ?a ?b) (equal ?b ?c))
                    (and (iszero ?a) (isdiff ?a ?b ?c)))
    	     :effect (and 
                (when
                    (and (equal ?a ?b) (equal ?b ?c))
                    (equal ?a ?c))
                (when
                    (and (iszero ?a) (isdiff ?a ?b ?c))
                    (equal ?b ?c))))

	; =========================================================================
	; SECTION 2: ZEROS

	; TODO Add integral domain assumption
	; if a \= 0 and b \= 0, then ab \= zero
    ; (:action integraldom-set-zero
    ; 	     :parameters (?ab ?a ?b)
    ; 	     :precondition (and 
    ; 	        (isprod ?ab ?a ?b)
    ;             (not (iszero ?a))
    ;             (not (iszero ?b)))
    ;             
    ;         :effect (and
    ;             (when (assumezero ?ab) (contradiction))
    ;             (not (iszero ?ab))))

	
	; if a = b and a = 0 or b = 0, then a = 0 and b = 0
    (:action set-zero
    	     :parameters (?a ?b)
    	     :precondition (and 
    	        (equal ?a ?b)
    	        (or 
					(iszero ?a) 
					(iszero ?b)))
    	     :effect (and 
                (when (assumenonzero ?a) (contradiction))
                (iszero ?a) 
                (when (assumenonzero ?b) (contradiction))
                (iszero ?b)))
    
    ; if a = 0 or b = 0, then ab = 0
	(:action set-zero-prod
    	     :parameters (?ab ?a ?b)
    	     :precondition (and 
    	        (isprod ?az ?a ?b)
    	        (or 
					(iszero ?a) 
					(iszero ?b)))
    	     :effect (and 
                (when (assumenonzero ?ab) (contradiction))
                (iszero ?ab)))
	    	     
	; if a = b and z = 0, then a = b + z
    (:action add-zero
    	     :parameters (?a ?b ?z)
    	     :precondition (and (equal ?a ?b) (iszero ?z))
    	     :effect (and (issum ?a ?b ?z)))

	; if a = b + z and b = 0 or z = 0, then a = z or a = b
    (:action drop-zero
    	     :parameters (?a ?b ?z)
    	     :precondition (and 
			 	(issum ?a ?b ?z) 
				(or 
					(iszero ?b) 
					(iszero ?z)))
    	     :effect (and 
			 	(when 
					(iszero ?b) 
					(equal ?a ?z))
				(when 
					(iszero ?z) 
					(equal ?a ?b))))

	; =========================================================================
	; SECTION 3: SUMS

	; if a = b and b = c + d, then a = c + d
	(:action set-sum
    	     :parameters (?a ?b ?c ?d)
    	     :precondition (and (equal ?a ?b)(issum ?b ?c ?d))
    	     :effect (and (issum ?a ?c ?d)))

    ; if a = b + c and b = d, then a = d + c
	(:action replace-sum
    	     :parameters (?a ?b ?c ?d)
    	     :precondition (and (issum ?a ?b ?c) (equal ?b ?d))
    	     :effect (and (issum ?a ?d ?c)))

	; if a = b + c, then a = c + b            
    (:action swap-sum
    	     :parameters (?a ?b ?c)
    	     :precondition (and (issum ?a ?b ?c))
    	     :effect (and (issum ?a ?c ?b)))

	; if a = b + c and b = d + e or c = d + e, then a = d + e + c or a = b + d + e
	(:action expand-sum
				:parameters (?a ?b ?c ?d ?e)
				:precondition (and 
					(issum ?a ?b ?c) 
					(or
						(issum ?b ?d ?e)
						(issum ?d ?d ?e)))
				:effect (and 
						(when 
							(issum ?b ?d ?e) 
							(istrisum ?a ?d ?e ?c))
						(when 
							(issum ?c ?d ?e) 
							(istrisum ?a ?b ?d ?e))))

	; if a = b + c + d, then a = c + b + d and a = b + d +c
	(:action swap-tri-sum
    	     :parameters (?a ?b ?c ?d)
    	     :precondition (and (istrisum ?a ?b ?c ?d))
    	     :effect (and 
    	        	(istrisum ?a ?c ?b ?d)
    	        	(istrisum ?a ?b ?d ?c)))

	; if a = b + c + d and e = b + c or e = c + d, then a = e + d or a = b + e
	(:action collapse-sum
				:parameters (?a ?b ?c ?d ?e)
				:precondition (and
						(istrisum ?a ?b ?c ?d)
						(or 
							(issum ?e ?b ?c) 
							(issum ?e ?c ?d)))
				:effect (and 
						(when 
							(issum ?e ?b ?c) 
							(issum ?a ?e ?d))
						(when 
							(issum ?e ?c ?d) 
							(issum ?a ?b ?e))))

	; =========================================================================
	; SECTION 4: PRODUCTS

    ; if ab = a * b then ab = b * a
    (:action swap-prod
    	     :parameters (?ab ?a ?b)
    	     :precondition (and 
    	        (isprod ?ab ?a ?b))
            :effect (and(isprod ?ab ?b ?a)))
	
	; =========================================================================
	; SECTION 5: DIFFERENCES

    ; if a = b, then 0 = a - b
    (:action set-difference
    	     :parameters (?a ?b ?z)
    	     :precondition (and (equal ?a ?b) (iszero ?z))
    	     :effect (and (isdiff ?z ?a ?b)))

	; =========================================================================
	; SECTION 6: FACTORIZATION

    ; ab - ac = a(b - c)
    (:action factor-difference
    	     :parameters (?a ?b ?c ?ab ?ac ?abMINac ?bMINc)
    	     :precondition (and 
                (isdiff ?abMINac ?ab ?ac)
                (isdiff ?bMINc ?b ?c)
                (isprod ?ab ?a ?b)
                (isprod ?ac ?a ?c))
    	     :effect (and (isprod ?abMINac ?a ?bMINc)))

	; =========================================================================
	; SECTION 7: IDENTITIES



	; =========================================================================

)