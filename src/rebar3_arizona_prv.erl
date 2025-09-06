-module(rebar3_arizona_prv).

-export([init/1, do/1, format_error/1]).

-ignore_xref([init/1, do/1, format_error/1, create_hello_world/1]).

-elvis([{elvis_style, no_macros, disable}, {elvis_style, no_debug_call, disable}]).

-define(GREENCOLOR, "\x1b[32m").
-define(RESET, "\x1b[0m").

-define(ARIZONA_LOGO, [
    "    _          _\r\n",
    "   / \\   _ __ (_)_______  _ __   __ _\r\n",
    "  / _ \\ | '__|| |_  / _ \\| '_ \\ / _` |\r\n",
    " / ___ \\| |   | |/ / (_) | | | | (_| |\r\n",
    "/_/   \\_\\_|   |_/___\\___/|_| |_|\\__,_|\r\n",
    "\r\n",
    "https://github.com/arizona-framework/arizona\r\n"
]).

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
        {short_desc, "Arizona Framework CLI toolkit"},
        {desc,
            "Interactive command-line toolkit for Arizona Framework. "
            "Create new Arizona applications with project templates."}
    ]),
    {ok, rebar_state:add_provider(State, Provider)}.

-spec do(rebar_state:t()) -> {ok, rebar_state:t()} | {error, string()}.
do(State) ->
    % Set up raw mode for proper arrow key handling
    ok = shell:start_interactive({noshell, raw}),

    %% Enable alternate screen buffer
    io:put_chars("\e[?1049h"),
    %% Hide the cursor
    io:put_chars("\e[?25l"),

    try
        interactive_menu(State)
    after
        %% Show the cursor
        io:put_chars("\e[?25h"),
        %% Disable alternate screen buffer
        io:put_chars("\e[?1049l")
    end.

%% ===================================================================
%% Interactive Menu System
%% ===================================================================
-spec interactive_menu(rebar_state:t()) -> {ok, rebar_state:t()} | {error, string()}.
interactive_menu(State) ->
    Options = [
        {"Create hello world app", fun create_hello_world/1},
        {"Create presence app", fun create_arizona_presence/1},
        {"Cancel", fun(_) -> {ok, cancelled} end}
    ],

    case interactive_loop(Options, 1) of
        cancelled ->
            {ok, State};
        Action when is_function(Action, 1) ->
            case Action(State) of
                {ok, cancelled} -> {ok, State};
                {ok, NewState} -> {ok, NewState};
                Other -> {ok, Other}
            end
    end.

%% Main interactive loop - follows tic-tac-toe pattern
-spec interactive_loop([{string(), function()}], integer()) -> function() | cancelled.
interactive_loop(Options, Selected) ->
    % Clear screen and position cursor at top-left
    io:put_chars("\e[2J\e[H"),

    % Display header
    io:format("~s~s~s\r\n", [?GREENCOLOR, ?ARIZONA_LOGO, ?RESET]),
    io:format("Use ↑↓ arrows or j/k to navigate, Enter to select, Esc/q to cancel\r\n\r\n"),

    % Display options with selection indicator
    lists:foreach(
        fun({Index, {Text, _}}) ->
            case Index of
                Selected ->
                    io:format("~s[●] ~s~s\r\n", [?GREENCOLOR, Text, ?RESET]);
                _ ->
                    io:format("[ ] ~s\r\n", [Text])
            end
        end,
        lists:zip(lists:seq(1, length(Options)), Options)
    ),

    % Read input using the same pattern as tic-tac-toe

    % Read up to 30 chars like tic-tac-toe
    case io:get_chars("", 30) of
        {error, _} ->
            interactive_loop(Options, Selected);
        {ok, Chars} ->
            handle_input(Chars, Options, Selected);
        Chars when is_list(Chars) ->
            handle_input(Chars, Options, Selected)
    end.

%% Handle input using recursive pattern matching like tic-tac-toe
-spec handle_input(string(), [{string(), function()}], integer()) -> function() | cancelled.
handle_input("\e[A" ++ Rest, Options, Selected) ->
    %% Up key
    NewSelected = max(1, Selected - 1),
    handle_input(Rest, Options, NewSelected);
handle_input("\e[B" ++ Rest, Options, Selected) ->
    %% Down key
    NewSelected = min(length(Options), Selected + 1),
    handle_input(Rest, Options, NewSelected);
handle_input("k" ++ Rest, Options, Selected) ->
    %% Vim-style up key
    NewSelected = max(1, Selected - 1),
    handle_input(Rest, Options, NewSelected);
handle_input("j" ++ Rest, Options, Selected) ->
    %% Vim-style down key
    NewSelected = min(length(Options), Selected + 1),
    handle_input(Rest, Options, NewSelected);
handle_input("\r" ++ _Rest, Options, Selected) ->
    %% Enter key - return the selected action
    {_, Action} = lists:nth(Selected, Options),
    Action;
handle_input("\n" ++ _Rest, Options, Selected) ->
    %% Newline - also treat as Enter
    {_, Action} = lists:nth(Selected, Options),
    Action;
handle_input("q" ++ _, _Options, _Selected) ->
    cancelled;
handle_input("Q" ++ _, _Options, _Selected) ->
    cancelled;
handle_input("\e" ++ _, _Options, _Selected) ->
    %% Escape key
    cancelled;
handle_input([_ | Rest], Options, Selected) ->
    %% Ignore other characters and continue processing
    handle_input(Rest, Options, Selected);
handle_input([], Options, Selected) ->
    %% No more input, continue the loop
    interactive_loop(Options, Selected).

%% ===================================================================
%% Template Functions
%% ===================================================================
-spec create_hello_world(rebar_state:t()) -> {ok, rebar_state:t()} | {error, string()}.
create_hello_world(State) ->
    io:format("~sCreating Arizona application...~s~n", [?GREENCOLOR, ?RESET]),
    Args = [],
    NewState = rebar_state:command_args(State, ["arizona.hello_world" | Args]),
    rebar_prv_new:do(NewState).

-spec create_arizona_presence(rebar_state:t()) -> {ok, rebar_state:t()} | {error, string()}.
create_arizona_presence(State) ->
    io:format("~sCreating Arizona presence example...~s~n", [?GREENCOLOR, ?RESET]),
    Args = [],
    NewState = rebar_state:command_args(State, ["arizona.presence" | Args]),
    rebar_prv_new:do(NewState).

-spec format_error(term()) -> iolist().
format_error(Reason) ->
    io_lib:format("~p", [Reason]).
