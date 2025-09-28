-module({{name}}_css_reloader).
-behaviour(arizona_reloader).
-export([reload/2]).

reload(_Files, _Opts) ->
    try
        CompileResult = os:cmd("npm run build:css", #{exception_on_failure => true}),
        ok = io:format("~ts", [CompileResult]),
        arizona_pubsub:broadcast(~"reload", css)
    catch
        error:{command_failed, ResultBeforeFailure, _ExitCode} ->
            io:format("CSS build failed:~n~ts~n", [ResultBeforeFailure])
    end.
