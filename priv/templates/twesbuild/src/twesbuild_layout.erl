-module(twesbuild_layout).
-compile({parse_transform, arizona_parse_transform}).
-export([render/1]).

render(Bindings) ->
    Description = [
        ~"Arizona - A modern Erlang web framework for building scalable, ",
        ~"fault-tolerant real-time applications on the BEAM"
    ],
    Image = ~"images/arizona-hero-bg.jpg",
    arizona_template:from_string(~"""
    <!DOCTYPE html>
    <html lang="en" class="h-full">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta name="description" content="{Description}">
        <meta name="keywords" content="Erlang, BEAM, web framework, real-time, WebSocket, fault-tolerant, scalable">
        <meta name="author" content="Arizona Framework">

        {% Open Graph / Facebook }
        <meta property="og:type" content="website">
        <meta property="og:title" content="{arizona_template:get_binding(title, Bindings)}">
        <meta property="og:description" content="{Description}">
        <meta property="og:image" content="{Image}">

        {% Twitter }
        <meta property="twitter:card" content="summary_large_image">
        <meta property="twitter:title" content="{arizona_template:get_binding(title, Bindings)}">
        <meta property="twitter:description" content="{Description}">
        <meta property="twitter:image" content="{Image}">

        <title>{arizona_template:get_binding(title, Bindings)}</title>
        <link rel="icon" type="image/x-icon" href="favicon.ico">
        <link rel="stylesheet" href="assets/app.css">
        <script type="module" src="assets/app.js" defer></script>

        {% Preload critical fonts if using custom fonts }
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    </head>
    <body class="bg-obsidian text-pearl antialiased">
        {arizona_template:render_slot(arizona_template:get_binding(main_content, Bindings))}
    </body>
    </html>
    """).
