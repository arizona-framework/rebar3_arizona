-module({{name}}_counter).
-behaviour(arizona_stateful).
-compile({parse_transform, arizona_parse_transform}).
-export([mount/1]).
-export([render/1]).
-export([handle_event/3]).

mount(Bindings) ->
    arizona_stateful:new(?MODULE, Bindings#{
        count => maps:get(count, Bindings, 1)
    }).

render(Bindings) ->
    arizona_template:from_string(~"""
    <div id="{arizona_template:get_binding(id, Bindings)}">
        <span>Count: {arizona_template:get_binding(count, Bindings)}</span>
        <button
            type="button"
            onclick="arizona.sendEventTo(
                '{arizona_template:get_binding(id, Bindings)}',
                'increment'
            )"
        >
            +
        </button>
    </div>
    """).

handle_event(~"increment", _Payload, State) ->
    Count = arizona_stateful:get_binding(count, State),
    {noreply, arizona_stateful:put_binding(count, Count + 1, State)}.
