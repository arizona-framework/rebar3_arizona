-module({{name}}_layout).
-compile({parse_transform, arizona_parse_transform}).
-export([render/1]).

render(Bindings) ->
    arizona_template:from_html(~"""
    <!DOCTYPE html>
    <html>
    <head>
        <title>{arizona_template:get_binding(title, Bindings)}</title>
        <script src="assets/js/main.js" type="module"></script>
    </head>
    <body>
        {arizona_template:render_slot(arizona_template:get_binding(main_content, Bindings))}
    </body>
    </html>
    """).
