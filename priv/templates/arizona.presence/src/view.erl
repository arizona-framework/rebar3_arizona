-module({{name}}_view).
-behaviour(arizona_view).
-compile({parse_transform, arizona_parse_transform}).
-export([mount/2]).
-export([render/1]).
-export([handle_event/3]).
-export([handle_info/2]).
-export([terminate/2]).

mount(#{title := PageTitle, counter_ref := OnlineCounterRef}, _HttpRequest) ->
    _ = arizona_live:is_connected(self()) andalso initialize_connected_session(OnlineCounterRef),
    Bindings = #{
        id => ~"main-view",
        uptime_seconds => 0,
        online_users_count => counters:get(OnlineCounterRef, 1),
        counter_ref => OnlineCounterRef
    },
    PageLayout =
        {{{name}}_layout, render, main_content, #{
            title => PageTitle
        }},
    arizona_view:new(?MODULE, Bindings, PageLayout).

render(Bindings) ->
    arizona_template:from_string(~"""
    <div id="{arizona_template:get_binding(id, Bindings)}">
        {% Counters section }
        <section class="counters">
            <h2>Interactive Counters</h2>
            <p>
                Click the + button to increment each counter.
                Each counter maintains its own state independently.
            </p>
            <div>
                <h3>Default Counter (starts at 1):</h3>
                {arizona_template:render_stateful({{name}}_counter, #{
                    id => ~"counter-default"
                })}
            </div>
            <div>
                <h3>Preset Counter (starts at 100):</h3>
                {arizona_template:render_stateful({{name}}_counter, #{
                    id => ~"counter-preset",
                    count => 100
                })}
            </div>
        </section>
        {% Status section }
        <section class="status">
            <h2>System Status</h2>
            <p>This section shows real-time information that updates automatically:</p>
            <ul>
                <li>
                    <b>Uptime:</b>
                    {arizona_template:get_binding(uptime_seconds, Bindings)} seconds -
                    How long this view has been active</li>
                <li>
                    <b>Active Sessions:</b>
                    {arizona_template:get_binding(online_users_count, Bindings)} -
                    Number of active browser sessions viewing this page
                </li>
            </ul>
            <p><em>
                Uptime updates every second.
                Active sessions updates when users connect or disconnect.
            </em></p>
        </section>
    </div>
    """).

handle_event(~"presence", _EventParams, View) ->
    CurrentState = arizona_view:get_state(View),
    OnlineCounterRef = arizona_stateful:get_binding(counter_ref, CurrentState),
    CurrentOnlineCount = counters:get(OnlineCounterRef, 1),
    UpdatedState = arizona_stateful:put_binding(online_users_count, CurrentOnlineCount, CurrentState),
    {noreply, arizona_view:update_state(UpdatedState, View)}.

handle_info(tick, View) ->
    _ = schedule_uptime_tick(),
    CurrentState = arizona_view:get_state(View),
    CurrentUptime = arizona_stateful:get_binding(uptime_seconds, CurrentState),
    UpdatedState = arizona_stateful:put_binding(uptime_seconds, CurrentUptime + 1, CurrentState),
    {noreply, arizona_view:update_state(UpdatedState, View)}.

terminate(_ShutdownReason, View) ->
    ViewState = arizona_view:get_state(View),
    OnlineCounterRef = arizona_stateful:get_binding(counter_ref, ViewState),
    ok = counters:sub(OnlineCounterRef, 1, 1),
    ok = arizona_pubsub:broadcast_from(self(), ~"presence", undefined),
    ok.

initialize_connected_session(OnlineCounterRef) ->
    ok = counters:add(OnlineCounterRef, 1, 1),
    ok = arizona_pubsub:broadcast_from(self(), ~"presence", undefined),
    ok = arizona_pubsub:join(~"presence", self()),
    _UptimeTimerRef = schedule_uptime_tick(),
    ok.

schedule_uptime_tick() ->
    erlang:send_after(1000, self(), tick).
