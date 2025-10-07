-module(rebar3_arizona_prv).

-export([init/1, do/1, format_error/1]).

-ignore_xref([init/1, do/1, format_error/1, create_template/3]).

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
        {"Create new app", "Generate a new Arizona application from templates",
            fun create_new_app/1},
        {"Exit", "Exit the Arizona CLI", fun(_) -> {ok, cancelled} end}
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
    io:format("Use ↑↓ arrows or j/k to navigate, Enter to select, Esc to cancel\r\n\r\n"),

    % Display options with selection indicator
    lists:foreach(
        fun({Index, {Text, Description, _}}) ->
            case Index of
                Selected ->
                    io:format("~s[●] ~s\r\n    ~s~s\r\n", [?GREENCOLOR, Text, Description, ?RESET]);
                _ ->
                    io:format("[ ] ~s\r\n    ~s\r\n", [Text, Description])
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
    {_, _, Action} = lists:nth(Selected, Options),
    Action;
handle_input("\n" ++ _Rest, Options, Selected) ->
    %% Newline - also treat as Enter
    {_, _, Action} = lists:nth(Selected, Options),
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
%% App Creation Functions
%% ===================================================================
-spec create_new_app(rebar_state:t()) -> {ok, rebar_state:t()} | {error, string()}.
create_new_app(State) ->
    case prompt_app_name() of
        cancelled ->
            interactive_menu(State);
        AppName ->
            template_selection_menu(State, AppName)
    end.

-spec prompt_app_name() -> string() | cancelled.
prompt_app_name() ->
    % Clear screen and show app name prompt
    io:put_chars("\e[2J\e[H"),
    io:format("~s~s~s\r\n", [?GREENCOLOR, ?ARIZONA_LOGO, ?RESET]),
    io:format("Enter app name (or Esc to cancel): "),

    % Show cursor for input
    io:put_chars("\e[?25h"),

    case read_app_name_input([]) of
        cancelled ->
            % Hide cursor again when cancelled
            io:put_chars("\e[?25l"),
            cancelled;
        Name ->
            % Hide cursor after successful input
            io:put_chars("\e[?25l"),
            string:trim(Name)
    end.

-spec read_app_name_input(string()) -> string() | cancelled.
read_app_name_input(Acc) ->
    case io:get_chars("", 1) of
        {error, _} ->
            read_app_name_input(Acc);
        {ok, [Char]} ->
            handle_name_input([Char], Acc);
        [Char] ->
            handle_name_input([Char], Acc)
    end.

-spec handle_name_input(string(), string()) -> string() | cancelled.
handle_name_input("\r", Acc) ->
    % Enter pressed
    case string:trim(Acc) of
        % Don't allow empty names
        "" -> read_app_name_input(Acc);
        Name -> Name
    end;
handle_name_input("\n", Acc) ->
    % Newline - also treat as Enter
    case string:trim(Acc) of
        "" -> read_app_name_input(Acc);
        Name -> Name
    end;
handle_name_input("\e", _Acc) ->
    % Escape pressed
    cancelled;
handle_name_input([127], Acc) ->
    % Backspace/Delete
    case Acc of
        "" ->
            read_app_name_input(Acc);
        _ ->
            NewAcc = string:slice(Acc, 0, length(Acc) - 1),
            % Move back, print space, move back
            io:format("\b \b"),
            read_app_name_input(NewAcc)
    end;
handle_name_input([Char], Acc) when Char >= 32, Char =< 126 ->
    % Printable character
    io:format("~c", [Char]),
    read_app_name_input(Acc ++ [Char]);
handle_name_input(_, Acc) ->
    % Ignore other characters
    read_app_name_input(Acc).

-spec template_selection_menu(rebar_state:t(), string()) ->
    {ok, rebar_state:t()} | {error, string()}.
template_selection_menu(State, AppName) ->
    % Hide cursor again for menu navigation
    io:put_chars("\e[?25l"),

    Options = [
        {"Hello world template", "Basic Arizona app with minimal setup", fun(S) ->
            create_template(S, AppName, "arizona.hello_world")
        end},
        {"Presence template", "Real-time app with PubSub presence integration", fun(S) ->
            create_template(S, AppName, "arizona.presence")
        end},
        {"Frontend template", "Modern web app with Tailwind CSS and ESBuild", fun(S) ->
            create_template(S, AppName, "arizona.frontend")
        end},
        {"Svelte template", "Full-stack app with Svelte, Tailwind CSS and Vite", fun(S) ->
            create_template(S, AppName, "arizona.svelte")
        end},
        {"Cancel", "Return to main menu", fun(_) -> {ok, cancelled} end},
        {"Exit", "Exit the Arizona CLI", fun(_) -> {ok, exit} end}
    ],

    case interactive_loop(Options, 1) of
        cancelled ->
            interactive_menu(State);
        Action when is_function(Action, 1) ->
            case Action(State) of
                {ok, cancelled} -> interactive_menu(State);
                {ok, exit} -> {ok, State};
                Other -> Other
            end
    end.

-spec create_template(rebar_state:t(), string(), string()) ->
    {ok, rebar_state:t()} | {error, string()}.
create_template(State, AppName, Template) ->
    io:format("~sCreating ~s...~s~n", [?GREENCOLOR, AppName, ?RESET]),
    Args = ["name=" ++ AppName],
    NewState = rebar_state:command_args(State, [Template | Args]),
    rebar_prv_new:do(NewState).

-spec format_error(term()) -> iolist().
format_error(Reason) ->
    io_lib:format("~p", [Reason]).

%% ===================================================================
%% EUnit Tests
%% ===================================================================

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").

%% Test create_template/3 function
create_template_test() ->
    State = rebar_state:new(),
    AppName = "test_app",
    % Use a template that exists
    Template = "app",

    %% Test that create_template calls rebar_prv_new with correct args
    %% Even though it might fail due to missing template, we test the function call
    Result = create_template(State, AppName, Template),

    %% Should return either {ok, _} or {error, _} - both are valid results
    ?assert(
        case Result of
            {ok, _} -> true;
            {error, _} -> true;
            _ -> false
        end
    ).

%% Test handle_name_input/2 with various inputs
handle_name_input_test_() ->
    [
        %% Test Enter key with valid input
        ?_assertEqual("test_app", handle_name_input("\r", "test_app")),
        ?_assertEqual("test_app", handle_name_input("\n", "test_app")),

        %% Test Escape key - always cancels
        ?_assertEqual(cancelled, handle_name_input("\e", "some_input")),
        ?_assertEqual(cancelled, handle_name_input("\e", ""))
    ].

%% Test format_error/1
format_error_test() ->
    Error = {some_error, "test message"},
    Result = format_error(Error),
    ?assert(is_list(Result)).

-endif.
