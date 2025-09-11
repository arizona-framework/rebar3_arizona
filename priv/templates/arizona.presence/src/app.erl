-module({{name}}_app).
-behaviour(application).

-export([start/2]).
-export([stop/1]).

-spec start(StartType, StartArgs) -> StartRet when
    StartType :: application:start_type(),
    StartArgs :: term(),
    StartRet :: {ok, pid()} | {error, term()}.
start(_StartType, _StartArgs) ->
    maybe
        {ok, SupPid} ?= {{name}}_sup:start_link(),
        CounterRef = counters:new(1, [write_concurrency]),
        ok = persistent_term:put(counter_ref, CounterRef),
        ok = io:format("Arizona app started at http://localhost:1912~n"),
        {ok, SupPid}
    else
        {error, Reason} ->
            {error, Reason}
    end.

-spec stop(State) -> Stopped when
    State :: term(),
    Stopped :: ok.
stop(_State) ->
    ok.
