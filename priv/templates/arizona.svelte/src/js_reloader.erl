-module({{name}}_js_reloader).
-behaviour(arizona_reloader).
-export([reload/2]).

reload(_Files, _Opts) ->
    try
        CompileResult = os:cmd("npm run build:js", #{exception_on_failure => true}),
        ok = io:format("~ts", [CompileResult]),
        arizona_pubsub:broadcast(~"reload", js)
    catch
        error:{command_failed, ResultBeforeFailure, _ExitCode} ->
            io:format("JS build failed:~n~ts~n", [ResultBeforeFailure])
    end.
