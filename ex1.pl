fill(_, 0, []).

fill(X, N, [X|R]):-
	N > 0, 
	N1 is N-1,
	fill(X, N1, R).
	
decode_rl([],[]).

decode_rl([FP|R], F):- 
	tuple_destr(FP, X, N),
	!,
	decode_rl(R, MR),
	fill(X, N, H),
	append(H , MR, F).
	
decode_rl([S|R], [S|MR]):-
	decode_rl(R, MR).
	
tuple_destr((A,B), A, B).

