-module(workerProcess).
-export([create/3,workerProcessLoop/6,broadcastIdea/4,broadcastIdea/5]).

create(NodeName,Neighbours,NodeParameters) -> 
        I  = lists:nth(1,NodeParameters),
        Iv = lists:nth(2,NodeParameters),
        U  = lists:nth(3,NodeParameters),
        C  = lists:nth(4,NodeParameters),
        spawn(?MODULE,workerProcessLoop,[NodeName,Neighbours,I,Iv,U,C]).

workerProcessLoop(NodeNamei,Neighbours,Idea,IdeaValuei,Uncertainty,CentralityDegreei) ->
 receive 
 {start} ->  IteratFunction = fun(Elem) -> Elem ! {calc,IdeaValuei,CentralityDegreei,NodeNamei} end,
             lists:foreach(IteratFunction,Neighbours),
             workerProcessLoop(NodeNamei,Neighbours,Idea,IdeaValuei,Uncertainty,CentralityDegreei);
   
 {calc,IdeaValuej,CentralityDegreej,NodeNamej} ->  
                Value = algorithme:imAlgorithme(IdeaValuei,IdeaValuej,Uncertainty,CentralityDegreei,CentralityDegreej),
                case Value of 
                false -> workerProcessLoop(NodeNamei,Neighbours,Idea,IdeaValuei,Uncertainty,CentralityDegreei);
                {NewIdeaValue,NewIdea} ->
                        if
                        Idea == NewIdea -> workerProcessLoop(NodeNamei,Neighbours,Idea,NewIdeaValue,Uncertainty,CentralityDegreei);
                        true -> centralizedProcess ! {NodeNamej,NodeNamei,Idea,NewIdea},
                                NewListOfNeighbours = broadcastIdea(Neighbours,NewIdeaValue,CentralityDegreei,NodeNamei),
                                timer:sleep(200),
                                workerProcessLoop(NodeNamei,NewListOfNeighbours,NewIdea,NewIdeaValue,Uncertainty,CentralityDegreei)
                        end
                end;     
 {stop}  ->  io:format("Stop !",[])
end.

broadcastIdea (List,IdeaValue,CentralityDegree,NodeName) -> broadcastIdea (List,[],IdeaValue,CentralityDegree,NodeName).
broadcastIdea (List,Acc,IdeaValue,CentralityDegree,NodeName) ->  
 case List of 
 [H|Q] ->  case whereis(H) of 
           undefined -> NvList = lists:delete(H,List),
                        broadcastIdea(NvList,Acc,IdeaValue,CentralityDegree,NodeName);
           _  ->        H ! {calc,IdeaValue,CentralityDegree,NodeName},     
                        ListAcc = lists:append([H],Acc),
                        broadcastIdea(Q,ListAcc,IdeaValue,CentralityDegree,NodeName)
           end;   
 [] ->   Acc
 end.