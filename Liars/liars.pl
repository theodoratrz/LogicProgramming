:- set_flag(print_depth, 100).
:- lib(ic).
:- [genrand].
liars(List, Liars):-
	length(List, N),
	length(Liars, N),
	Liars #:: 0..1,
	constraints(Liars, Liars, List),
	search(Liars, 0, first_fail, indomain_middle, complete, []).
	
constraints([], _, []).
constraints([Head|Liars], L, [Num|RNum]):-
	(Head #= 0) #= (Num #=< sum(L)),
	(Head #= 1) #= (Num #> sum(L)),
	constraints(Liars,L,RNum).
	
