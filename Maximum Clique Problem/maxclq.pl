:- lib(branch_and_bound).
:- lib(ic).
:- [create_graph].

% we use binary encoding. A node belongs(1) or it doesnt belong(0) to the graph.
% we want the max clique, so we use negative numbers and bbmin
maxclq(N, D, Clique, Size):-
	create_graph(N,D,Graph),
	N1 is N + 1,
	create_complement(Graph, 1, N1, EdgesList),
	flatten(EdgesList, Edges),
	length(Vars, N),
	Vars #:: 0..1,
	constraints(Vars, Edges),
	map_1_to_neg1(Vars,NewVars),
	MaxC #= sum(NewVars),
	bb_min(search(Vars, 0, most_constrained, indomain_middle, complete, []),
		MaxC, bb_options{strategy: continue, solutions: all, report_success:true/0,report_failure:true/0}),
	get_clique(Vars, 1, Clique),
	Size is -MaxC.

% bbmin minimizes the MaxC. We switch 1 with -1 to take the "max".
map_1_to_neg1([],[]).
map_1_to_neg1([Head|Tail], [NewHead|NewTail]):-
	NewHead #= -Head,
	map_1_to_neg1(Tail, NewTail).

% take every node which var is 1(== belongs to the clique)

get_clique([], _, []).

get_clique([0|Vars], Index, Clique):-
	Index1 is Index +1,
	get_clique(Vars, Index1, Clique).
	
get_clique([1|Vars], Index, [Index|Clique]):-
	Index1 is Index +1,
	get_clique(Vars, Index1, Clique).
	
% check the egdes of the complement graph
constraints(_, []).
constraints(Vars, [I-J|Edges]):-
	element_at(Vars, 1, I, VI),
	element_at(Vars, 1, J, VJ),
	VI + VJ #< 2,
	constraints(Vars, Edges).
	
% take the value of Index
element_at([Element|_], Index, Index, Element):- !.
element_at([_|Tail], Current, Index, Element):-
	Current =\= Index,
	Current1 is Current + 1,
	element_at(Tail, Current1, Index, Element).
	
% find all posible matches between 1 and N. If the maych belongs to our graph, continue. If not, it belongs to the complement graph.
find_edges(_,_, J, Limit, []):-
	J >= Limit.
find_edges(Graph, I, J, Limit, Edges):-
	J < Limit,
	member(I-J, Graph),
	J1 is J + 1,
	find_edges(Graph, I, J1, Limit, Edges).
	
find_edges(Graph, I, J, Limit, [I-J|Edges]):-
	J < Limit,	
	\+ member(I-J, Graph),
	J1 is J + 1,
	find_edges(Graph, I, J1, Limit, Edges).

create_complement(_,N,N,[]).
create_complement(Graph, I, N, [Edges|Complement]):-
	I < N,
	I1 is I+1,
	find_edges(Graph, I, I1, N, Edges),
	create_complement(Graph, I1, N, Complement).
	

