-module(centralizedProcess).
-export([create/0,centralizedProccessLoop/3,log/7]).

create() ->       
    {ok,SimulationFileHandler} = file:open("logs\\SimulationLog.txt",[append]),
    Pid = spawn(?MODULE,centralizedProccessLoop,[SimulationFileHandler,[],0]),
    register(centralizedProcess,Pid).

centralizedProccessLoop(SimulationFileHandler,Message,N) ->     
    receive
    {SrcNode,DestNode,OldValue,NewValue} -> {Message1,N1} = log(SimulationFileHandler,SrcNode,DestNode,OldValue,NewValue,Message,N),
                                            centralizedProccessLoop(SimulationFileHandler,Message1,N1)
    after 10000 ->  log(SimulationFileHandler,last,last,"la","st",Message,1001),
                    io:format("==========!!!!< end of centralizedProccessLoop >!!!!========== \n", [])
    end.

log(SimulationFileHandler,SrcNode,DestNode,OldValue,NewValue,Message,N) ->
    Message1 = lists:append([atom_to_list(SrcNode),";",atom_to_list(DestNode),";", [OldValue],";", [NewValue], "\r\n",Message]),
    if 
    N>1000 -> file:write(SimulationFileHandler,Message1), %liste inversé%
                {[],0};
    true -> {Message1,N+1}
    end.