-module(algorithme).
-export([calculateProbability/2,stayInBound/1,imAlgorithme/5]).
-define(Mu,0.2).
-define(Alpha,1).

calculateProbability(X,Y) -> 
    Int = X+Y,
    Y / Int.

stayInBound (Val)->
    if 
        Val > 1.0 -> 1.0;
        Val < -1.0 -> -1.0;
        true -> Val
    end.

imAlgorithme (Xi,Xj,Ui,Ki,Kj)->  
    Cond = abs(Xi-Xj),
    if 
    Cond < Ui -> Var = Xi + ?Mu * (math:pow(Kj,?Alpha)/(math:pow(Kj,?Alpha)+math:pow(Ki,?Alpha)))*(Xj-Xi),
                Idea = helpers:valueIdeaMatch(Var),
                {Var,Idea};
    true      -> false
    end.