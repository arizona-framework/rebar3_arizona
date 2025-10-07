-module({{name}}_view).
-behaviour(arizona_view).
-compile({parse_transform, arizona_parse_transform}).
-export([mount/2]).
-export([layout/1]).
-export([render/1]).
-export([handle_event/3]).

mount(#{title := Title}, _Req) ->
    Bindings = #{id => ~"view"},
    Layout =
        {?MODULE, layout, main_content, #{
            title => Title
        }},
    arizona_view:new(?MODULE, Bindings, Layout).

% Layout is rendered only once when the page loads - it's never updated.
% Only the view content (inserted via render_slot) receives real-time updates.
layout(Bindings) ->
    arizona_template:from_erl([
        ~"<!DOCTYPE html>",
        {html, [], [
            {head, [], [
                {title, [], ~"Arizona Hello World"},
                {script, [{type, ~"module"}, async], ~"""
                import Arizona from '/assets/arizona/js/arizona.min.js';
                globalThis.arizona = new Arizona();
                arizona.connect('/live');
                """}
            ]},
            {body, [], arizona_template:render_slot(maps:get(main_content, Bindings))}
        ]}
    ]).

render(Bindings) ->
    arizona_template:from_erl(
        {'div', [{id, arizona_template:get_binding(id, Bindings)}], [
            case arizona_template:find_binding(name, Bindings) of
                {ok, Name} ->
                    [~"Hello, ", Name, ~"!"];
                error ->
                    arizona_template:from_erl({button,
                        [{onclick, ~"arizona.pushEvent('hello_world')"}],
                        ~"Say Hello!"
                    })
            end
        ]}
    ).

handle_event(~"hello_world", _Params, View) ->
    State = arizona_view:get_state(View),
    UpdatedState = arizona_stateful:put_binding(name, ~"World", State),
    {[], arizona_view:update_state(UpdatedState, View)}.
