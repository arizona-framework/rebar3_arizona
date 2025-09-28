-module({{name}}_components).
-compile({parse_transform, arizona_parse_transform}).
-export([component/1]).

component(Bindings) ->
    arizona_template:from_html(~"""
    <div
        data-svelte-component="{arizona_template:get_binding(component, Bindings)}"
        data-svelte-props='{iolist_to_binary(
            json:encode(arizona_template:get_binding(props, Bindings, #{}))
        )}'
        data-arizona-update="false"
    ></div>
    """).
