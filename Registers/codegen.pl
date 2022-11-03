same_list_length(List1, List2) :-
	length(List1,N),
	length(List2, N).
	
swap_action(List, I, J, Swapped) :-
	same_list_length(List,Swapped),
	append(BeforeIndexI, [ElementI | PastIndexI], List),
	append(BeforeIndexI, [ElementJ | PastIndexI], List2),
	append(BeforeIndexJ, [ElementJ | PastIndexJ], List2),
	append(BeforeIndexJ, [ElementI | PastIndexJ], Swapped),
	ItemsBeforeI is I - 1,
	ItemsBeforeJ is J - 1,
	length(BeforeIndexI, ItemsBeforeI),
	length(BeforeIndexJ, ItemsBeforeJ).
	
get_next_index(List, I, J) :-
	length(List, L),
	I < L,
	J is I+1.
	
get_next_index(List, L, 0) :-
	length(List, L).
	
move_action(List, I, Moved) :-
	get_next_index(List, I, J),
	same_list_length(List,Moved),
	append(BeforeIndexI, [ElementI | PastIndexI], List),
	append(BeforeIndexI, [ElementI | PastIndexI], List2),
	append(BeforeIndexJ, [ _ | PastIndexJ], List2),
	append(BeforeIndexJ, [ElementI | PastIndexJ], Moved),
	ItemsBeforeI is I - 1,
	ItemsBeforeJ is J - 1,
	length(BeforeIndexI, ItemsBeforeI),
	length(BeforeIndexJ, ItemsBeforeJ).
	
between(LBound, RBound, LBound) :-
    LBound =< RBound. 
between(LBound, RBound, Result) :-
    LBound < RBound,
    NextLBound is LBound + 1,
    between(NextLBound, RBound, Result).

codegen(Input, Input, []).
codegen(Input, Output, Actions) :-
	N = 2,
	codegen_rec(Input, Output, Actions, N).

codegen_rec(_ , _ , _ , 10).
codegen_rec(Input, Output, Actions, MaxDepth):- 
	append([], [Input], SoFarStates),
	NextDepth is MaxDepth+1,
	( find_moves(Input, Output, SoFarStates, Actions, MaxDepth) -> ! ; codegen_rec(Input, Output, Actions, NextDepth) ).

final_state([], []).
final_state([FT|RestTarget], [FF|RestFinal]) :-
	(FT = FF -> !; FF = *),
	final_state(RestTarget, RestFinal).

find_moves(FinalState, FinalState1, _, [], _):-
	final_state(FinalState, FinalState1).

find_moves(CurrentState, FinalState, SoFarStates, [Move|Rest], MaxDepth) :-
	length(SoFarStates, Length),
	Length =< MaxDepth,
	next_move(CurrentState, NextState, Move),
	not member(NextState, SoFarStates),
	append(SoFarStates, [NextState], NewSoFarStates),
	find_moves(NextState, FinalState, NewSoFarStates, Rest, MaxDepth).

move(_).
swap(_,_).
next_move(CurrentState, NextState, move(I) ):-
	length(CurrentState, Len),
	between(1, Len, I),
	move_action(CurrentState, I, NextState).
	
next_move(CurrentState, NextState, swap(I, J)) :-
	length(CurrentState, Len),
	between(1, Len, I),
	between(1, Len, J),
	J > I,
	swap_action(CurrentState, I, J, NextState).
