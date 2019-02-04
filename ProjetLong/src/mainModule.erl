-module(mainModule).
-export([compile/0,launch/1,stop/1]).
-define(FD1k,element(2,file:open("graphs\\edges1k.graph", [read]))).
-define(FD10k,element(2,file:open("graphs\\edges10k.graph", [read]))).
-define(FD50,element(2,file:open("graphs\\edges50P.graph", [read]))).
-define(FD1kP,element(2,file:open("graphs\\edges1kP.graph", [read]))).

compile() -> 
        compile:file(algorithme),
        compile:file(buildgraph),
        compile:file(centralizedProcess),
        compile:file(workerProcess),
        compile:file(helpers).

launch(Choice) -> 
    case Choice of 
      1  -> Nodes = buildgraph:construct_graph(?FD1k,dict:new()),
            centralizedProcess:create(),
            helpers:startSim(Nodes); 
      2 ->  Nodes = buildgraph:construct_graph(?FD50,dict:new()),
            centralizedProcess:create(),
            helpers:startSim(Nodes);
      3 ->  Nodes = buildgraph:construct_graph(?FD1kP,dict:new()),
            centralizedProcess:create(),
            helpers:startSim(Nodes);
      10 -> Nodes = buildgraph:construct_graph(?FD10k,dict:new()),
            centralizedProcess:create(),
            helpers:startSim(Nodes) 
    end. 


stop(Choice) -> 
    case Choice of 
      1  -> Nodes = helpers:get_nodes(?FD1k,dict:new()),
            helpers:stopSim(Nodes);
      2  -> Nodes = helpers:get_nodes(?FD50,dict:new()),
            helpers:stopSim(Nodes);
      3  -> Nodes = helpers:get_nodes(?FD1kP,dict:new()),
            helpers:stopSim(Nodes);
      10 -> Nodes = helpers:get_nodes(?FD10k,dict:new()),
            helpers:stopSim(Nodes)
    end. 