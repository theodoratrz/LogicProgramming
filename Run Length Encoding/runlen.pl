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

find_prefix([X], [X] , []).

find_prefix([ X, X | L], [X|P], R):-
	find_prefix([X|L], P, R).
	
find_prefix([X,Y | List], [X], [Y|List]):-
	X \= Y.
	
count_elements([], 0).
count_elements([_|R], N):-
	count_elements(R, N1),
	N is N1+1.
	
fill_with_tuples(_, []).

fill_with_tuples(X, L):-
	append(X, L, L).

tuple_constr(A, B, (A,B)).
	
encode_rl([],[]).

encode_rl([FP|R], F):-
	find_prefix(FP, P, R),
	count_elements(P, N),
	tuple_constr(P, N, C),
	encode(R, MR),
	fill_with_tuples(C, H),
	append(H, MR, F).
	

encode_rl([S|R], [S|MR]):-
	encode_rl(R, MR).

