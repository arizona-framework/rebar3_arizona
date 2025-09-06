-module(rebar3_arizona_prv_SUITE).
-behaviour(ct_suite).
-include_lib("stdlib/include/assert.hrl").
-compile([export_all, nowarn_export_all]).

%%====================================================================
%% CT Callbacks
%%====================================================================

all() ->
    [
        {group, provider_tests}
    ].

groups() ->
    [
        {provider_tests, [parallel], [
            test_provider_init,
            test_format_error
        ]}
    ].

%%====================================================================
%% Test Cases
%%====================================================================

test_provider_init(_Config) ->
    % Test that the provider can be initialized
    State = rebar_state:new(),
    Result = rebar3_arizona_prv:init(State),

    % Should return {ok, NewState}
    ?assertMatch({ok, _}, Result).

test_format_error(_Config) ->
    % Test error formatting
    Error = {some_error, "test message"},
    Result = rebar3_arizona_prv:format_error(Error),

    % Should return an iolist
    ?assert(is_list(Result)),

    % Test with atom error
    AtomError = some_atom_error,
    AtomResult = rebar3_arizona_prv:format_error(AtomError),
    ?assert(is_list(AtomResult)).
