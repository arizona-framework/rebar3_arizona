-module({{name}}_template).
-export([render_component/2]).

render_component(Component, Props) ->
    arizona_template:render_stateless({{name}}_components, component, #{
        component => Component,
        props => Props
    }, #{update => false}).
