-module({{name}}_conf).

-export([arizona/0]).

-spec arizona() -> Config when
    Config :: arizona:config().
arizona() ->
    #{
        server => #{
            routes => routes()
        },
        reloader => #{
            enabled => true,
            rules => [
                #{
                    directories => ["src"],
                    patterns => [".*\\.erl$", ".*\\.hrl$"],
                    callback => fun recompile/1
                }
            ]
        }
    }.

routes() ->
    [
        {asset, ~"/favicon.ico", {priv_file, {{name}}, ~"static/favicon.ico"}},
        {asset, ~"/robots.txt", {priv_file, {{name}}, ~"static/robots.txt"}},
        {view, ~"/", {{name}}_view, #{title => ~"Arizona Framework"}}
    ].

recompile(Files) ->
    try
        CompileResult = os:cmd("rebar3 compile", #{exception_on_failure => true}),
        ok = io:format("~ts", [CompileResult]),
        {ok, Cwd0} = file:get_cwd(),
        Cwd = Cwd0 ++ "/",
        ErlFiles = [F || F <- Files, filename:extension(F) =:= ".erl"],
        lists:foreach(
            fun(AbsFilename) ->
                Filename = case string:prefix(AbsFilename, Cwd) of
                    nomatch -> AbsFilename;
                    Suffix -> Suffix
                end,
                ok = io:format("===> Reloading ~s~n", [Filename]),
                BaseName = filename:basename(Filename, ".erl"),
                Module = list_to_existing_atom(BaseName),
                code:purge(Module),
                code:load_file(Module)
            end,
            ErlFiles
        )
    catch
        error:{command_failed, ResultBeforeFailure, _ExitCode} ->
            io:format("~ts~n", [ResultBeforeFailure])
    end.
