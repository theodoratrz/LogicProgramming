%% the output format [Row1,Row2,Row3...] of the 2d array of our variables.
%% its not working properly when the array is not n x n

:- lib(ic).
:- lib(branch_and_bound).

tents(RowTents,ColumnTents,Trees,Pos):-
	length(RowTents, NumRows),
	length(ColumnTents, NumColumns),
	make_array(NumRows, Pos, NumColumns),
	constraint_max_row(Pos, RowTents),
	constraint_max_column(NumColumns, 1, Pos, ColumnTents),
	constraint_trees(Trees,Pos,NumColumns, NumRows),
	constraint_tents(Pos,Pos,NumColumns, NumRows),
	flatten(Pos, FlattenPos),
	S #= sum(FlattenPos),
	bb_min(search(FlattenPos, 0, most_constrained, indomain_middle, complete, []),
		S, bb_options{strategy: continue, solutions: all, report_success:true/0,report_failure:true/0}).

make_array(0, [],_).
make_array(CounterRow, [FirstRow|Rows], ColumnLength):-
	CounterRow > 0,
	Counter is CounterRow - 1,
	make_array(Counter, Rows,ColumnLength),
	length(FirstRow, ColumnLength),
	FirstRow #:: 0..1.

constraint_max_row([],[]).

constraint_max_row([Head|Tail], [FirstRow|RestRows]):-
	FirstRow > -1, 
	sum(Head) #=< FirstRow,
	constraint_max_row(Tail,RestRows).
	
constraint_max_row([_|Tail], [FirstRow|RestRows]):-
	FirstRow = -1, 
	constraint_max_row(Tail,RestRows).

constraint_max_column(NofColumns, CurrentColumn, _, []):-
	CurrentColumn > NofColumns.
	
constraint_max_column(NofColumns, CurrentColumn, Frame, [ColumnTents|RestColumns]):-
	NofColumns >= CurrentColumn,
	ColumnTents > -1,
	get_column(CurrentColumn, Frame, Column),
	sum(Column) #=< ColumnTents,
	CurrentColumn1 is CurrentColumn + 1,
	constraint_max_column(NofColumns, CurrentColumn1, Frame, RestColumns).
	
constraint_max_column(NofColumns, CurrentColumn, Frame, [ColumnTents|RestColumns]):-
	NofColumns >= CurrentColumn,
	ColumnTents = -1,
	CurrentColumn1 is CurrentColumn + 1,
	constraint_max_column(NofColumns, CurrentColumn1, Frame, RestColumns).

get_column(_, [], []).
get_column(NumColumn, [Row|RestRows], [Element|RestElements]):-
	get_ith(NumColumn, Row,Element),
	get_column(NumColumn,RestRows,RestElements).

constraint_trees([],_,_,_).
constraint_trees([I-J|RestTrees], Matrix, NumColumns, NumRows):-
	get_ijth(I, J, Matrix, Element),
	Element #= 0,
	constraint_tree(I,J,Matrix,NumColumns, NumRows),
	constraint_trees(RestTrees, Matrix,NumColumns, NumRows).

constraint_tents([],_,_,_).
constraint_tents([Head|Tail],Matrix, NumColumns, NumRows):-
	length(Tail,L),
	J is NumRows - L,
	constraint_tents_row(Head,J,Matrix, NumColumns, NumRows),
	constraint_tents(Tail,Matrix,NumColumns, NumRows).

constraint_tents_row([],_,_,_,_).
constraint_tents_row([Head|Tail],J,Matrix, NumColumns, NumRows):-
	length(Tail,L),
	I is NumColumns - L,
	constraint_tent(I,J,Matrix,NumColumns, NumRows,Head),
	constraint_tents_row(Tail,J,Matrix, NumColumns, NumRows).

constraint_tree(I,J,Matrix,NumColumns, NumRows):-
	get_neighbours(I, J, Neighbours, NumColumns, NumRows, Matrix),
	sum(Neighbours) #>= 1.
		
constraint_tent(I,J,Matrix,NumColumns, NumRows,Head):-
	get_neighbours(I, J, Neighbours, NumColumns, NumRows, Matrix),
	(Head #= 1) => (sum(Neighbours) #=< 1).

get_neighbours(I, J, Neighbours, NumColumns, NumRows, Matrix):-
	get_same_column_neighbours(Matrix, I,J, NumRows, SameColumn),
	get_same_row_neighbours(Matrix, I,J, NumColumns, SameRow),
	get_same_left_diagonial_neighbours(Matrix, I,J, NumRows, NumColumns, SameLeftDiagonial),
	get_same_right_diagonial_neighbours(Matrix, I,J, NumRows, NumColumns, SameRightDiagonial),
	append(SameColumn, SameRow, List1),
	append(List1,SameLeftDiagonial,List2),
	append(List2,SameRightDiagonial,Neighbours).

get_same_column_neighbours(Matrix, I,J, NumRows, [Up,Down]):-
	I > 1,
	I < NumRows,!,
	I1 is I - 1,
	I2 is I + 1,
	get_ijth(I1, J, Matrix, Up),
	get_ijth(I2, J, Matrix, Down).
	
get_same_column_neighbours(Matrix, 1,J, NumRows, [Down]):-
	NumRows > 1,!,
	I2 is 2,
	get_ijth(I2, J, Matrix, Down).
	
get_same_column_neighbours(Matrix,NumRows, J, NumRows, [Up]):-
	NumRows > 1,!,
	I1 is NumRows - 1,
	get_ijth(I1, J, Matrix, Up).

get_same_column_neighbours(_,1, _, 1, []).
	
get_same_row_neighbours(Matrix, I,J, NumColumns, [Left,Right]):-
	J > 1,
	J < NumColumns,!,
	J1 is J - 1,
	J2 is J + 1,
	get_ijth(I, J1, Matrix, Left),
	get_ijth(I, J2, Matrix, Right).
	
get_same_row_neighbours(Matrix, I,1, NumColumns, [Right]):-
	NumColumns > 1,!,
	J1 is 2,
	get_ijth(I, J1, Matrix, Right).
	
get_same_row_neighbours(Matrix,I, NumColumns, NumColumns, [Left]):-
	NumColumns > 1,!,
	J1 is NumColumns - 1,
	get_ijth(I, J1, Matrix, Left).

get_same_row_neighbours(_,_, 1, 1, []).


get_same_left_diagonial_neighbours(Matrix, I,J, NumRows, NumColumns, [Left,Right]):-
	J > 1,
	J < NumColumns,
	I > 1,
	I < NumRows,!,
	J1 is J - 1,
	J2 is J + 1,
	I1 is I - 1,
	I2 is I + 1,
	get_ijth(I1, J1, Matrix, Left),
	get_ijth(I2, J2, Matrix, Right).
	
get_same_left_diagonial_neighbours(Matrix, I,1, NumRows,NumColumns, [Right]):-
	I < NumRows,
	NumColumns > 1,
	NumRows > 1,!,
	J1 is 2,
	I1 is I + 1,
	get_ijth(I1, J1, Matrix, Right).
	
get_same_left_diagonial_neighbours(Matrix,I, NumColumns, NumRows, NumColumns, [Left]):-
	I > 1,
	NumColumns > 1,
	NumRows > 1,!,
	J1 is NumColumns - 1,
	I1 is I - 1,
	get_ijth(I1, J1, Matrix, Left).
	
get_same_left_diagonial_neighbours(Matrix, 1,J, NumRows, NumColumns, [Right]):-
	NumRows > 1,
	J < NumColumns,
	NumColumns > 1,!,
	I2 is 2,
	J1 is J + 1,
	get_ijth(I2, J1, Matrix, Right).
	
get_same_left_diagonial_neighbours(Matrix,NumRows, J, NumRows, NumColumns, [Left]):-
	NumRows > 1,
	NumColumns > 1,
	J > 1,!,
	I1 is NumRows - 1,
	J1 is J - 1,
	get_ijth(I1, J1, Matrix, Left).
	
get_same_left_diagonial_neighbours(_,1, NumColumns, _, NumColumns, []).

get_same_left_diagonial_neighbours(_,NumRows, 1, NumRows, _, []).

get_same_left_diagonial_neighbours(_,_, _, _, 1, []).

get_same_left_diagonial_neighbours(_,_, _, 1, _, []).


get_same_right_diagonial_neighbours(Matrix, I,J, NumRows, NumColumns, [Left,Right]):-
	J > 1,
	J < NumColumns,
	I > 1,
	I < NumRows,!,
	J1 is J - 1,
	J2 is J + 1,
	I1 is I - 1,
	I2 is I + 1,
	get_ijth(I1, J2, Matrix, Left),
	get_ijth(I2, J1, Matrix, Right).
	
get_same_right_diagonial_neighbours(Matrix, I,1, NumRows,NumColumns, [Right]):-
	I > 1,
	NumColumns > 1,
	NumRows > 1,!,
	J1 is 2,
	I1 is I - 1,
	get_ijth(I1, J1, Matrix, Right).
	
get_same_right_diagonial_neighbours(Matrix,I, NumColumns, NumRows, NumColumns, [Left]):-
	I < NumRows,
	NumColumns > 1,
	NumRows > 1,!,
	J1 is NumColumns - 1,
	I1 is I + 1,
	get_ijth(I1, J1, Matrix, Left).
	
get_same_right_diagonial_neighbours(Matrix, 1,J, NumRows, NumColumns, [Left]):-
	J > 1,
	NumRows > 1,
	NumColumns > 1,!,
	I2 is 2,
	J1 is J - 1,
	get_ijth(I2, J1, Matrix, Left).
	
get_same_right_diagonial_neighbours(Matrix,NumRows, J, NumRows, NumColumns, [Right]):-
	J < NumColumns,
	NumRows > 1,
	NumColumns > 1,!,
	I1 is NumRows - 1,
	J1 is J + 1,
	get_ijth(I1, J1, Matrix, Right).
	
get_same_right_diagonial_neighbours(_,1, 1, _, _, []).

get_same_right_diagonial_neighbours(_,NumRows, NumColumns, NumRows, NumColumns, []).

get_same_right_diagonial_neighbours(_,_, _, 1, _, []).

get_same_right_diagonial_neighbours(_,_, _, _, 1, []).


get_ith(1, [X|_], X).
get_ith(I, [_|L], X) :-
   I > 1,
   I1 is I-1,
   get_ith(I1, L, X).
   
get_ijth(I, J, Matrix, X) :-
   get_ith(I, Matrix, Line),
   get_ith(J, Line, X).
