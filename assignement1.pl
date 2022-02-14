%arc(?[H|T], +Node, ?Cost, +KB)
arc([H|T],Node,Cost,KB) :- member([H|B],KB), append(B,T,Node),
	length(B,L), Cost is 1+ L/(L+1).

%heuristic(+Node, ?H)
heuristic(Node,H) :- length(Node,H).

goal([]).

%add2frontier(+Children, ?More, ?New).
add2frontier([], _, _).
add2frontier([H|T], [], []) :- !, add2frontier(T, [], H).
add2frontier([H|T], More, New) :- 
    lessThan(H,New), !, append(New, More), add2frontier(T, More, New).
add2frontier([H|T], More, New) :-
    append(H, More), add2frontier(T, More, New).


%lessThan([[Node1|_], Cost1], [[Node2|_], Cost2]])
%lessThan(_, []).
lessThan([[Node1|_],Cost1],[[Node2|_],Cost2]) :-
	heuristic(Node1,Hvalue1), heuristic(Node2,Hvalue2),
	F1 is Cost1+Hvalue1, F2 is Cost2+Hvalue2,
	F1 =< F2.

%search
search([Node|_], _) :- goal(Node).
search([Node|More], KB) :- findall([X,Cost],arc(X,Node,Cost,KB),Children),
	add2frontier(Children,More,New),
	search(New, KB).

%astar(+Node, ?Path, ?Cost, +KB).
