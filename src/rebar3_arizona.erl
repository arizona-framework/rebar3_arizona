-module(rebar3_arizona).

-export([init/1]).

-ignore_xref([init/1]).

-spec init(rebar_state:t()) -> {ok, rebar_state:t()}.
init(State) ->
    {ok, State1} = rebar3_arizona_prv:init(State),
    {ok, State1}.
