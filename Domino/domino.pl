dominos([(0,0),(0,1),(0,2),(0,3),(0,4),(0,5),(0,6),
 (1,1),(1,2),(1,3),(1,4),(1,5),(1,6),
 (2,2),(2,3),(2,4),(2,5),(2,6),
 (3,3),(3,4),(3,5),(3,6),
 (4,4),(4,5),(4,6),
 (5,5),(5,6),
 (6,6)]).
 
frame([[3,1,2,6,6,1,2,2],
 [3,4,1,5,3,0,3,6],
 [5,6,6,1,2,4,5,0],
 [5,6,4,1,3,3,0,0],
 [6,1,0,6,3,2,4,0],
 [4,1,5,2,4,3,5,5],
 [4,1,0,2,4,5,2,0]]).

getData(Dominos, Frame) :- 
	dominos(Dominos),
	frame(Frame).
	
put_dominos(Solution):-
	getData(DominosData, FrameData),
	make_frame(Frame, FrameData, 0),
	make_dominos(Frame,DominosData, Dominos).

make_frame([], [], _).
make_frame([X|Rest], [ListRow|Tail], CoordinateY):-
	make_frame_row(X, ListRow,CoordinateY, 0),
	CoordinateY1 is CoordinateY + 1,
	make_frame(Rest, Tail,CoordinateY1).
	
make_frame_row([], [], _,_).
make_frame_row([Head|Tail], [FValue|RValues], CoordinateY, CoordinateX):-
	Head = (FValue,CoordinateX, CoordinateY),
	CoordinateX1 is CoordinateX + 1,
	make_frame_row(Tail, RValues, CoordinateY, CoordinateX1).

make_dominos([],[],[]).
make_dominos(Frame,[(X,Y)|Rest], [(X,0,0)-(Y,0,0)-Domain|RestCoords]):-
	make_domain(Frame, (X,Y), Domain1),
	Domain = Domain1,
	make_dominos(Rest , RestCoords).

make_domain([],_, []).
make_domain(Frame, CurrentDomino, NewDomain) :-
   check_rows(Frame, CurrentDomino, RowList),
   check_columns(Frame, CurrentDomino, ColumnList),
   append(RowList, ColumnList, NewDomain).
   
check_rows([(Value1,0,X1,Y), (Value2, 0,X2,Y) | Rest], (Value1,_, _)-(Value2,_, _)-Domain, NewDomain):-
	append([(X1, Y, X2, Y)], Domain, NewDomain1).

check_rows([(Value1,0,X1,Y), (Value2, 0,X2,Y) | Rest], (Value2,_, _)-(Value1,_, _)-Domain, NewDomain):-
	append([(X2, Y, X1, Y)], Domain, NewDomain1).
	
check_rows([First,Second|Tail], [First, NewSecond|NewTail], NewDomino):-
	check_rows([Second|Tail], [NewSecond|NewTail], NewDomino).

check_columns([(Value1,0,X,Y1) | _], [(Value2,0,X,Y2) | _], (Value1,_, _)-(Value2,_, _)-Domain, NewDomain):-
	append([(X, Y1, X, Y2)], Domain, NewDomain1),
	check_columns(_, (Value1,_, _)-(Value2,_, _)-NewDomain1, NewDomain2),
	append(NewDomain1, NewDomain2, NewDomain).
	
check_columns([(Value1,0,X,Y1) | Rest1], [(Value2,0,X,Y2) | Rest2], (Value2,_, _)-(Value1,_, _)-Domain, NewDomain):-
	append([(X, Y2, X, Y1)], Domain, NewDomain1),
	check_columns(Rest1, Rest2, (Value2,_, _)-(Value1,_, _)-NewDomain1, NewDomain2),
	append(NewDomain1, NewDomain2, NewDomain).
			
place_dominos([], []).
place_dominos([FirstDomino|RestDominos], NewList):-
	place_domino([FirstDomino|RestDominos], _, List),
	update_domains(List, NewList),
	place_dominos(RestDominos, NewList).

place_domino([Domino], Domino, []).
place_domino([(Value1, X1,Y1)-(Value2, X2, Y2)-Domain1|Rest], (Value12, X12,Y12)-(Value21, X21, Y21)-Domain, List):-
	place_domino(Rest, (Value11, X11,Y11)-(Value22, X22, Y22)-Domain2, List1),
	length(Domain1, D1),
	length(Domain2,D2),
	(D1 < D2 -> 
		(Value12 = Value1,
		 X12 = X1,
		 Y12 = Y1,
		 Value21 = Value2,
		 X21 = X2,
		 Y21 = Y2,
		 Domain = Domain1,
		 List = Rest);
		 (Value12 = Value11,
		 X12 = X11,
		 Y12 = Y11,
		 Value21 = Value22,
		 X21 = X22,
		 Y21 = Y22,
		 Domain = Domain2,
		 List = [(Value1, X1,Y1)-(Value2, X2, Y2)-Domain1|List1])).

update_domains([], []).
update_domains([CurrentDomino|RestDominos], [(_,_, _)-(_,_, _)-NewDomain|RestDominos]) :-
   update_domain(CurrentDomino, NewDomain1),
   append(NewDomain1, [], NewDomain),
   update_domains(RestDominos, [(_,_, _)-(_,_, _)-NewDomain|RestDominos]).

update_domain((_,X1, Y1)-(_,X2, Y2)-Domain, NewDomain) :-
   remove_if_exists((X1,Y1,X2,Y2), Domain, Domain2),
   append(Domain2, [], NewDomain).

remove_if_exists(_, [], []).
remove_if_exists(X, [X|List], List) :-
   !.
remove_if_exists(X, [Y|List1], [Y|List2]) :-
   remove_if_exists(X, List1, List2).
