-module(helpers).
-export([get_nodes/2,startSim/1,stopSim/1,round/2,valueIdeaMatch/1]).

startSim(Nodes) -> 
    ItFunction = fun(K,V) -> V ! {start} end,
    dict:map(ItFunction,Nodes).

stopSim(Nodes) -> 
    ItFunction = fun(K,V) -> K ! {stop} end,
    dict:map(ItFunction,Nodes).%add a second arg and make it in one fun with start

round(Number, Precision) ->
    P = math:pow(10, Precision),
    round(Number * P) / P.

valueIdeaMatch(Valeur) -> 
    case round(Valeur,1) of
    0.0 -> "A";
    0.1 -> "B";
    0.2 -> "C";
    0.3 -> "D";
    0.4 -> "E";
    0.5 -> "F";
    0.6 -> "G";
    0.7 -> "H";
    0.8 -> "I";
    0.9 -> "J"
    end.

get_nodes(File,NodesDic)->
    case io:get_line(File,"") of
    eof ->          NodesDic;
    Line_Data ->    [Node_Name | _ ] = buildgraph:getNodesFromLine(element(2,erl_scan:string(Line_Data))),
                    get_nodes(File,dict:store(Node_Name,1,NodesDic))
end.            