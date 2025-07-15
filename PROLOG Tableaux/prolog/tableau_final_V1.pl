%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% some examples
% sat( not((p => q) => (not q => not p)) ).
% sat( ((p or q) and (not p and not q)) ).
% sat( ((p and q) and not q) ).
% sat( (not (p => not q) => (p and q)) ).
% tautology( (not (p => not q) => (p and q)) ).
% 
% de morgan
% tautology( (not(p and q)) <=> ((not p) or (not q)) ).
% tautology( (not(p or q)) <=> ((not p) and (not q)) ).
% 
% implicazione
% tautology( (p => q) <=> (not p or q) ).
% 
% modus ponens
% tautology( ((p => q) and p) => q ).
% 
% rag. per assurdo
% tautology( (p => q) => ((p => not q) => not p) ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% defining logical operators %%%
:- op(650, xfy, '<=>').
:- op(640, xfy, '=>').
:- op(630, yfx, 'and').
:- op(620, yfx, 'or').
:- op(610, fy, 'not').

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% checks if a formula is satisfiable using tableau %%%
sat(Formula) :-
    semantic_tableau(Formula, Tree),
    count_open_branches(Tree, Count),
    nl, write(Formula), nl,
    (   Count > 0 ->
        write('is satisfiable'), nl
    ;
        write('is not satisfiable'), nl
    ).


%%% checks if a formula is a tautology using tableau %%%
tautology(Formula) :-
    semantic_tableau(not Formula, Tree),
    count_open_branches(Tree, Count),
    nl, write(Formula), nl,
    (   Count = 0 ->  write('tautology'), nl
    ;   write('not a tautology'), nl
    ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% predicates to count open branches in a tree %%%
count_open_branches(Tree, Count) :-
    count_open_branches(Tree, 0, Count).

count_open_branches(empty, Count, Count).
count_open_branches(closed, Count, Count).

count_open_branches(open, Count, NewCount) :-
    NewCount is Count + 1.

count_open_branches(t(Left, Right, _), Count, FinalCount) :-
    count_open_branches(Left, Count, LeftCount),
    count_open_branches(Right, LeftCount, FinalCount).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% construct the tableau %%%
semantic_tableau(Formula, Tableau) :- 
    Tableau = t(_, _, [Formula]), 
    extend_tableau(Tableau), 
    write_tableau(Tableau, 0), 
    !.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% tableau extension %%%
extend_tableau(t(closed, empty, L)) :-
	check_closed(L).

extend_tableau(t(open, empty, L)) :-
	contains_only_literals(L).

extend_tableau(t(Left, empty, L)) :-
	alpha_rule(L, L1),
	Left = t(_, _, L1),
	extend_tableau(Left).

extend_tableau(t(Left, Right, L)) :-
	beta_rule(L, L1, L2),
	Left = t(_, _, L1),
	Right = t(_, _, L2),
	extend_tableau(Left),
	extend_tableau(Right).

check_closed(L) :- 
    mymember(F, L), mymember(not F, L).

contains_only_literals([]).
contains_only_literals([F | Tail]) :-
	literal(F),
	contains_only_literals(Tail).

literal(F) :- atom(F).
literal(not F) :- atom(F).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% rules %%%
alpha_rule(L, [A1, A2 | Ltemp]) :-
	alpha_formula(A, A1, A2),
	mymember(A, L), 
	delete(A, L, Ltemp).
alpha_rule(L, [A1 | Ltemp]) :-
	A = not not A1,
	mymember(A, L),
	delete(A, L, Ltemp).
beta_rule(L, [B1 | Ltemp], [B2 | Ltemp]) :-
	beta_formula(B, B1, B2),
	mymember(B, L),
	delete(B, L, Ltemp).

%%% alpha - beta formulas %%%
alpha_formula(A1 and A2, A1, A2).
alpha_formula(not (A1 => A2), A1, not A2).
alpha_formula(not (A1 or A2), not A1, not A2).
alpha_formula(not (A1 <=> A2), not (A1 => A2), not(A2 => A1)).

beta_formula(A1 or A2, A1, A2).
beta_formula(A1 => A2, not A1, A2).
beta_formula(not (A1 and A2), not A1, not A2).
beta_formula(A1 <=> A2, A1 => A2, A2 => A1).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% printing the tableau (simple) %%%
write_formula_list([F]) :- write(F).
write_formula_list([F | Tail]) :-
	write(F),
	write(', '),
	write_formula_list(Tail).
write_tableau(empty, _).
write_tableau(closed, _) :- write(' Closed').
write_tableau(open, _) :- write(' Open').
write_tableau(t(Left, Right, List), K) :-
	nl, write_multiple_chars('- ', K), K1 is K+3,
	write_formula_list(List),
	write_tableau(Left, K1),
	write_tableau(Right, K1).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% list utils %%% 
mymember(X, [X | _]).
mymember(X, [_ | Tail]) :- mymember(X,Tail).

delete(X, [X | Tail], Tail).
delete(X, [Head | Tail], [Head | Tail1]) :- delete(X, Tail, Tail1).

write_multiple_chars(_, 0). 
write_multiple_chars(Char, N) :-
    write(Char),
    N1 is N - 1,
    write_multiple_chars(Char, N1).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%