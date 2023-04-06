# commring-planning-domain

The following planning domains models the axioms and elementary operations of a commutative ring.
We include a number of basic proofs as examples.

## Part One: comm-ring

A fully observable deterministic (FOD) planning model deals with the problem of finding an optimal sequence of actions that achieve a specific goal in a fully observable and deterministic environment.
In this domain, we model all the ring axioms and elementary operations.

To run the model:
> lama-first <domain_file.pddl> <problem_file.pddl>

## Part Two: integral-domain

A fully observable non-deterministic (FOND) planning model deals with the problem of finding an optimal sequence of actions that achieve a specific goal in a fully observable, but non-deterministic environment.
In this domain, we model all the ring axioms, integral domain axioms, and a subset of elementary operations.

To run the model:
> prp <domain_file.pddl> <problem_file.pddl>
