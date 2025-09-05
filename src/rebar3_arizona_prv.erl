-module(rebar3_arizona_prv).

-export([init/1, do/1, format_error/1]).

-ignore_xref([init/1, do/1, format_error/1]).

%% ===================================================================
%% Public API
%% ===================================================================
-spec init(rebar_state:t()) -> {ok, rebar_state:t()}.
init(State) ->
    Provider = providers:create([
        % The 'user friendly' name of the task
        {name, arizona},
        % The module implementation of the task
        {module, ?MODULE},
        % The task can be run by the user, always true
        {bare, true},
        % The list of dependencies
        {deps, []},
        % How to use the plugin
        {example, "rebar3 arizona"},
        % list of options understood by the plugin
        {opts, []},
        {short_desc, "Arizona framework tooling"},
        {desc,
            "Arizona framework tooling for project management, "
            "server operations, and development tasks"}
    ]),
    {ok, rebar_state:add_provider(State, Provider)}.

-spec do(rebar_state:t()) -> {ok, rebar_state:t()} | {error, string()}.
do(State) ->
    {ok, State}.

-spec format_error(term()) -> iolist().
format_error(Reason) ->
    io_lib:format("~p", [Reason]).
