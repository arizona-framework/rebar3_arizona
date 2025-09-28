-module({{name}}_counter).
-behaviour(arizona_stateful).
-compile({parse_transform, arizona_parse_transform}).

-export([mount/1]).
-export([render/1]).
-export([handle_event/3]).

-spec mount(Bindings) -> State when
    Bindings :: arizona_binder:map(),
    State :: arizona_stateful:state().
mount(Bindings) ->
    arizona_stateful:new(?MODULE, Bindings#{
        id => ~"counter",
        count => 0
    }).

-spec render(Bindings) -> Template when
    Bindings :: arizona_binder:bindings(),
    Template :: arizona_template:template().
render(Bindings) ->
    arizona_template:from_html(~"""
    <div id="{arizona_template:get_binding(id, Bindings)}" class="space-y-4">
        {% Arizona Server Counter }
        <div class="w-full">
            <div class="p-4">
                <h2 class="text-lg font-bold text-arizona-terracotta">Arizona Counter (Server-side)</h2>
                <p class="text-gray-400 text-sm">Real-time synchronized state</p>
            </div>

            <div class="p-6">
                <div class="text-center mb-6">
                    <div class="text-4xl font-bold text-arizona-terracotta mb-3">
                        {arizona_template:get_binding(count, Bindings)}
                    </div>
                    <div class="text-sm text-gray-400">Current value</div>
                </div>

                <div class="flex gap-3">
                    <button
                        type="button"
                        onclick="{[~"arizona.sendEventTo('", arizona_template:get_binding(id, Bindings), ~"', 'decr')"]}"
                        class="flex-1 py-3 px-4 bg-arizona-terracotta/10 text-arizona-terracotta border border-arizona-terracotta/20 rounded-lg hover:bg-arizona-terracotta/20 hover:border-arizona-terracotta/40 hover:text-arizona-mesa focus:ring-2 focus:ring-arizona-terracotta/50 focus:ring-offset-2 focus:ring-offset-charcoal transition-all duration-200 font-medium cursor-pointer"
                    >
                        −
                    </button>

                    <button
                        type="button"
                        onclick="{[~"arizona.sendEventTo('", arizona_template:get_binding(id, Bindings), ~"', 'reset')"]}"
                        class="flex-1 py-3 px-4 bg-slate/20 text-silver border border-slate/30 rounded-lg hover:bg-slate/30 hover:border-slate/50 hover:text-pearl focus:ring-2 focus:ring-slate/50 focus:ring-offset-2 focus:ring-offset-charcoal transition-all duration-200 font-medium cursor-pointer"
                    >
                        Reset
                    </button>

                    <button
                        type="button"
                        onclick="{[~"arizona.sendEventTo('", arizona_template:get_binding(id, Bindings), ~"', 'incr')"]}"
                        class="flex-1 py-3 px-4 bg-arizona-teal/10 text-arizona-teal border border-arizona-teal/20 rounded-lg hover:bg-arizona-teal/20 hover:border-arizona-teal/40 hover:text-arizona-sage focus:ring-2 focus:ring-arizona-teal/50 focus:ring-offset-2 focus:ring-offset-charcoal transition-all duration-200 font-medium cursor-pointer"
                    >
                        +
                    </button>
                </div>
            </div>
        </div>

        {% Embedded Svelte Counter (Client-side) }
        <div class="border-2 border-dashed border-arizona-teal/30 rounded-lg p-2">
            <div class="text-xs text-arizona-teal/70 mb-2 text-center font-mono">
                ↳ Svelte Component embedded inside Arizona Stateful Component
            </div>
            {arizona_svelte:render_component(~"Counter", #{
                title => ~"Svelte Counter (Client-side)",
                initialCount => arizona_template:get_binding(count, Bindings)
            })}
        </div>
    </div>
    """).

-spec handle_event(Event, Params, State) -> Result when
    Event :: arizona_stateful:event_name(),
    Params :: arizona_stateful:event_params(),
    State :: arizona_stateful:state(),
    Result :: arizona_stateful:handle_event_result().
handle_event(~"incr", _Params, State) ->
    Count = arizona_stateful:get_binding(count, State),
    State1 = arizona_stateful:put_binding(count, Count + 1, State),
    {[], State1};
handle_event(~"decr", _Params, State) ->
    Count = arizona_stateful:get_binding(count, State),
    State1 = arizona_stateful:put_binding(count, Count - 1, State),
    {[], State1};
handle_event(~"reset", _Params, State) ->
    State1 = arizona_stateful:put_binding(count, 0, State),
    {[], State1}.
