-module(buildgraph).
-export([getListOfParameters/1,getWeightOfNodeFromLine/1,getNodesFromLine/1,construct_graph/2]).


getWeightOfNodeFromLine([])-> [];
getWeightOfNodeFromLine([H|T])->
        case H of
        {float,_,NodeWeight} -> NodeWeight;
        {integer,_,NodeWeight} -> NodeWeight;
        _ -> getWeightOfNodeFromLine(T)
        end.

getNodesFromLine([]) -> [];
getNodesFromLine([H|T]) -> 
        case H of
        {atom,_, Node_Name} -> [Node_Name | getNodesFromLine(T)];        
	_ -> getNodesFromLine(T)
        end.

getListOfParameters([]) -> [];
getListOfParameters([H|T]) -> 
        case H of
        {float,_, VALUE} -> [VALUE | getListOfParameters(T)];
        {integer,_, VALUE} -> [VALUE | getListOfParameters(T)];
        {var,_, VALUE} -> [VALUE | getListOfParameters(T)];
        _ ->   getListOfParameters(T)
        end.

construct_graph(File,NodesDic)->
        case io:get_line(File,"") of
        eof ->  NodesDic;
        Line_Data ->    [Node_Name | Neighbours]=getNodesFromLine(element(2,erl_scan:string(Line_Data))),
                        NodeParameters=getListOfParameters(element(2,erl_scan:string(Line_Data))),
                        Pid = workerProcess:create(Node_Name,Neighbours,NodeParameters),
                        register(Node_Name,Pid),
                        construct_graph(File,dict:store(Node_Name,Pid,NodesDic))
        end.