-module(processRing).
-export([send/2]).

send(M, N) ->
  statistics(wall_clock),
  H = lists:foldl(fun(Id, Pid) -> 
			spawn_link(fun() -> loop(Id, Pid, M) end) end, 
			self(), 
			lists:seq(N, 2, -1)),
  {_, Time} = statistics(wall_clock),

  io:format("~p processes spawned in ~p ms~n", [N, Time]),
  statistics(wall_clock),
  H ! M,
  loop(1, H, M).
loop(Id, Pid, M) ->
  receive
    1 ->
      {_, Time} = statistics(wall_clock),
      io:format("~p messages sent in ~p ms~n", [M, Time]),
      exit(self(), ok);
    Index ->
      Pid ! Index - 1,
      loop(Id, Pid, M)
  end.