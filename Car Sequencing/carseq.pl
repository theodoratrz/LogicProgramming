:- lib(ic_global).
:- lib(ic_global_gac).

carseq(S) :-
	classes(Class),
	options(Options),
	length(Class, NofConfig),
	Sum is sum(Class),
	length(S, Sum),
	S #:: 1..NofConfig,
	constraints(S, Class, Options),
	search(S, 0, input_order, indomain, complete, []).

constraints(_, _, []).	
constraints(S, Class, [Options|RestOptions]):-
	occurances_constraints(Class, S, 1),
	rest_constraints(Options, S, Class),
	constraints(S, Class, RestOptions).
	
% take constraints for each option, calling sequence_total for better executing time
rest_constraints(N/M/List, S, Class):-
	get_pos(List, Pos, 1),
	sum_at_pos(Pos, Class, Sum),
	Sum1 is sum(Sum),
	sequence_total(Sum1, Sum1, 0, M, N, S,Pos).
	
% for computing occurences for every integer 1-6
occurances_constraints([], _,_).
occurances_constraints([Class|Rest], S, Count):-
	occurrences(Count, S, Class),
	Count1 is Count + 1,
	occurances_constraints(Rest, S, Count1).

% map 0,1 to 1-6. We want to store which car model has the specific configuration.
get_pos([], [], _).

get_pos([1|Tail], [Pos|Rest], Start):-
	Pos is Start,
	Start1 is Start + 1,
	get_pos(Tail,Rest,Start1).
	
get_pos([0|Tail], Pos, Start):-
	Start1 is Start + 1,
	get_pos(Tail,Pos,Start1).
	
% map every "1" in options to the int in "classes". We want to map the amount of a car model with its 
% configurations.
sum_at_pos([], _, []).
sum_at_pos([Pos|Rest], Class, [Sum|R]):-
	element_at(Class, 1, Pos, Value),
	Sum is Value,
	sum_at_pos(Rest,Class,R).
	
% take the value of element i
element_at([Element|_], Index, Index, Element):- !.
element_at([_|Tail], Current, Index, Element):-
	Current =\= Index,
	Current1 is Current + 1,
	element_at(Tail, Current1, Index, Element).
