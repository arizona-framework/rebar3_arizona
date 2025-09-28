-module({{name}}_view).
-behaviour(arizona_view).
-compile({parse_transform, arizona_parse_transform}).
-export([mount/2]).
-export([render/1]).
% Components
-export([hero/1]).
-export([welcome_card/1]).
-export([demo_section/1]).
-export([enhanced_next_steps/1]).
-export([next_step/1]).
-export([quick_link_card/1]).
-export([arrow_icon/1]).

mount(#{title := Title}, _Req) ->
    Bindings = #{id => ~"view"},
    Layout =
        {{{name}}_layout, render, main_content, #{
            title => Title
        }},
    arizona_view:new(?MODULE, Bindings, Layout).

render(Bindings) ->
    Module = ?MODULE,
    arizona_template:from_html(~""""
    <div
        id="{arizona_template:get_binding(id, Bindings)}"
        class="min-h-screen relative overflow-hidden bg-arizona-landscape"
    >
        {% Subtle background elements }
        <div class="absolute inset-0 opacity-5">
            <div class="absolute top-20 left-20 w-72 h-72 bg-arizona-terracotta/10 rounded-full blur-3xl"></div>
            <div class="absolute bottom-20 right-20 w-96 h-96 bg-pearl/5 rounded-full blur-3xl"></div>
            <div class="absolute top-1/2 left-1/4 w-48 h-48 bg-arizona-gold/8 rounded-full blur-2xl"></div>
        </div>

        <div class="relative z-10 flex items-center justify-center min-h-screen p-4 sm:p-8">
            <div class="max-w-6xl mx-auto">
                {% Hero Section }
                {arizona_template:render_stateless(Module, hero, #{})}

                {% Welcome Card }
                {arizona_template:render_stateless(Module, welcome_card, #{})}

                {% Demo Section }
                {arizona_template:render_stateless(Module, demo_section, #{})}

                {% Enhanced Next Steps }
                {arizona_template:render_stateless(Module, enhanced_next_steps, #{})}
            </div>
        </div>

        {% Lifecycle Demo Component }
        {arizona_svelte:render_component(~"LifecycleDemo", #{})}
    </div>
    """").

hero(_Bindings) ->
    arizona_template:from_html(~"""
    <div class="text-center mb-16 pt-16">
        <div class="inline-block relative">
            <h1 class="text-5xl sm:text-7xl lg:text-8xl font-bold text-pearl mb-8 leading-none">
                <span class="{[
                    ~"text-arizona-terracotta bg-gradient-to-r from-arizona-terracotta",
                    ~"to-arizona-gold bg-clip-text text-transparent"
                ]}">
                    Arizona
                </span>
            </h1>
            <div class="{[
                ~"absolute -bottom-1 left-1/2 transform -translate-x-1/2 w-24 h-1 bg-gradient-to-r ",
                ~"from-arizona-terracotta to-arizona-gold rounded-full animate-expand"
            ]}"></div>
        </div>
        <p class="text-xl sm:text-2xl text-silver max-w-2xl mx-auto leading-relaxed mt-8">
            A modern Erlang web framework for
            <span class="{[
                ~"bg-gradient-to-r from-arizona-teal to-arizona-terracotta ",
                ~"bg-clip-text text-transparent"
            ]}">
                real-time
            </span>
            applications
        </p>
    </div>
    """).

welcome_card(_Bindings) ->
    Module = ?MODULE,
    arizona_template:from_html(~""""
    <div class="{[
        ~"bg-charcoal/80 backdrop-blur-xl rounded-2xl p-8 sm:p-10 mb-16 shadow-2xl border ",
        ~"border-pearl/10 hover:border-arizona-teal/40 hover:shadow-2xl ",
        ~"hover:shadow-arizona-teal/10 transition-all duration-300"
    ]}">
        <div class="text-center mb-8">
            <h2 class="text-3xl sm:text-4xl font-bold text-pearl mb-4">
                Welcome to your new Arizona <span class="text-red-500">Svelte</span> project!
            </h2>
            <p class="text-lg text-silver/90 max-w-3xl mx-auto leading-relaxed">
                Your application is running successfully. You're now ready to build
                scalable, fault-tolerant real-time web applications with Svelte components on the BEAM.
            </p>
        </div>

        {% Enhanced Quick Links Grid }
        <div class="grid sm:grid-cols-2 lg:grid-cols-3 gap-6 mb-8">
            {arizona_template:render_list(fun(Card) ->
                arizona_template:from_html(~"""
                {arizona_template:render_stateless(Module, quick_link_card, Card)}
                """)
            end, [
                #{
                    href => ~"https://github.com/arizona-framework/arizona/blob/main/README.md",
                    icon => ~[<span class="text-2xl">📚</span>],
                    title => ~"Arizona Docs",
                    description => ~"Learn how to build powerful applications with Arizona's comprehensive guides"
                },
                #{
                    href => ~"https://svelte.dev/docs",
                    icon => ~[<span class="text-2xl">⚡</span>],
                    title => ~"Svelte Docs",
                    description => ~"Master Svelte's reactive components and modern development patterns"
                },
                #{
                    href => ~"https://github.com/arizona-framework/arizona",
                    icon => arizona_template:from_html(~"""
                    <svg class="w-6 h-6 text-pearl" fill="currentColor" viewBox="0 0 24 24">
                        <path d="{[
                            ~"M12 0C5.374 0 0 5.373 0 12 0 17.302 3.438 21.8 8.207 ",
                            ~"23.387c.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.",
                            ~"033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.",
                            ~"729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.",
                            ~"997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 ",
                            ~"0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 ",
                            ~"1.008-.322 3.301 1.23A11.509 11.509 0 0112 5.803c1.02.005 2.047.138 ",
                            ~"3.006.404 2.291-1.552 3.297-1.30 3.297-1.30.653 1.653.242 2.874.118 ",
                            ~"3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 ",
                            ~"5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576C20.566 ",
                            ~"21.797 24 17.3 24 12c0-6.627-5.373-12-12-12z"
                        ]}"/>
                    </svg>
                    """),
                    title => ~"GitHub",
                    description => ~"View source code, report issues, and contribute to the Arizona framework",
                    extra_classes => ~"sm:col-span-2 lg:col-span-1"
                }
            ])}
        </div>
    </div>
    """").

demo_section(_Bindings) ->
    arizona_template:from_html(~""""
    <div class="mb-16">
        <div class="text-center mb-12">
            <h2 class="text-3xl sm:text-4xl font-bold text-pearl mb-4">
                Component Architecture Demo
            </h2>
            <p class="text-lg text-silver/90 max-w-4xl mx-auto leading-relaxed">
                Experience the power of mixing pure Svelte components with Arizona's real-time server components
            </p>
        </div>

        {% Runtime Lifecycle Demo Components Section }
        <div class="mb-16">
            <div class="{[
                ~"bg-gradient-to-br from-charcoal/80 to-slate/60 backdrop-blur-xl rounded-2xl p-8 ",
                ~"border border-arizona-teal/20 hover:border-arizona-teal/40 transition-all duration-300 ",
                ~"hover:shadow-xl hover:shadow-arizona-teal/10"
            ]}">
                <div class="flex items-center gap-3 mb-6">
                    <div class="{[
                        ~"w-10 h-10 bg-arizona-teal/20 rounded-xl flex items-center justify-center"
                    ]}">
                        <span class="text-xl">🧪</span>
                    </div>
                    <div>
                        <h3 class="text-xl font-bold text-arizona-teal">Demo Components</h3>
                        <p class="text-sm text-arizona-teal/70">Runtime lifecycle testing • Live monitoring</p>
                    </div>
                </div>
                <div class="mb-6">
                    <p class="text-sm text-silver/80 leading-relaxed mb-3">
                        Components added here will be automatically mounted/unmounted by the lifecycle monitoring system.
                        Watch the console and log for real-time events.
                    </p>
                    <div class="text-xs text-arizona-teal/70 bg-arizona-teal/5 border border-arizona-teal/20 rounded-lg p-3">
                        💡 <strong>Tip:</strong> Use the <span class="text-arizona-teal font-semibold">Component Lifecycle Demo</span> controls
                        (bottom-right corner) to add or remove components and see the lifecycle monitoring in action!
                    </div>
                </div>
                <div class="demo-components-container" data-arizona-update="false">
                    {% Demo components will be dynamically added here }
                </div>
            </div>
        </div>

        {% Pure Svelte Components Section }
        <div class="{[
            ~"bg-gradient-to-br from-charcoal/80 to-slate/60 backdrop-blur-xl rounded-2xl p-8 mb-8 ",
            ~"border border-arizona-teal/20 hover:border-arizona-teal/40 transition-all duration-300 ",
            ~"hover:shadow-xl hover:shadow-arizona-teal/10"
        ]}">
            <div class="flex items-center gap-3 mb-6">
                <div class="{[
                    ~"w-10 h-10 bg-arizona-teal/20 rounded-xl flex items-center justify-center"
                ]}">
                    <span class="text-xl">⚡</span>
                </div>
                <div>
                    <h3 class="text-xl font-bold text-arizona-teal">Pure Svelte Components</h3>
                    <p class="text-sm text-arizona-teal/70">Client-side only • No server updates</p>
                </div>
            </div>

            <div class="grid lg:grid-cols-3 gap-6 mb-6">
                <div class="lg:col-span-2">
                    {% Svelte HelloWorld }
                    <div class="bg-obsidian/40 rounded-lg p-4 border border-arizona-teal/10 h-full">
                        {arizona_svelte:render_component(~"HelloWorld", #{
                            name => ~"Svelte"
                        })}
                    </div>
                </div>

                <div class="flex flex-col justify-between p-4 bg-arizona-teal/5 rounded-lg border border-arizona-teal/20">
                    <p class="text-sm text-silver/90 leading-relaxed">
                        <strong class="text-arizona-teal">Pure Svelte Components:</strong> This HelloWorld component runs entirely in the browser using Svelte 5's reactive system. It operates with completely independent state management that never synchronizes with the server.
                    </p>
                    <p class="text-sm text-silver/90 leading-relaxed">
                        <strong class="text-arizona-teal">Compile-Time Optimization:</strong> These components compile to optimized vanilla JavaScript, providing excellent performance with minimal bundle overhead while maintaining full client-side reactivity and interactivity.
                    </p>
                    <p class="text-sm text-silver/90 leading-relaxed">
                        <strong class="text-arizona-teal">Independent State:</strong> Changes in Pure Svelte components are isolated to the browser and do not trigger any server communication or Arizona state updates.
                    </p>
                    <div class="bg-obsidian/60 p-4 rounded-lg border border-arizona-teal/30">
                        <p class="text-sm text-arizona-teal font-semibold mb-2">
                            ⚡ Client-Side Features
                        </p>
                        <p class="text-xs text-silver/90 leading-relaxed">
                            Try the drag & drop Kanban board below. Notice how all interactions happen instantly without any network requests - this is pure client-side reactivity powered by Svelte's compile-time optimizations!
                        </p>
                    </div>
                </div>
            </div>
        </div>

        {% Arizona Server Components Section }
        <div class="{[
            ~"bg-gradient-to-br from-charcoal/80 to-slate/60 backdrop-blur-xl rounded-2xl p-8 ",
            ~"border border-arizona-terracotta/20 hover:border-arizona-terracotta/40 transition-all duration-300 ",
            ~"hover:shadow-xl hover:shadow-arizona-terracotta/10"
        ]}">
            <div class="flex items-center gap-3 mb-6">
                <div class="{[
                    ~"w-10 h-10 bg-arizona-terracotta/20 rounded-xl flex items-center justify-center"
                ]}">
                    <span class="text-xl">🔄</span>
                </div>
                <div>
                    <h3 class="text-xl font-bold text-arizona-terracotta">Arizona Server Components</h3>
                    <p class="text-sm text-arizona-terracotta/70">Server-side • Real-time updates</p>
                </div>
            </div>

            <div class="grid lg:grid-cols-3 gap-6 mb-6">
                <div class="lg:col-span-2 bg-obsidian/40 rounded-lg p-4 border border-arizona-terracotta/10">
                    {arizona_template:render_stateful({{name}}_counter, #{})}
                </div>

                <div class="flex flex-col justify-between p-4 bg-arizona-terracotta/5 rounded-lg border border-arizona-terracotta/20">
                    <p class="text-sm text-silver/90 leading-relaxed">
                        <strong class="text-arizona-terracotta">Arizona Stateful Components:</strong> Server-rendered components that update in real-time through WebSocket connections. State is managed on the server with automatic synchronization to all connected clients.
                    </p>
                    <p class="text-sm text-silver/90 leading-relaxed">
                        <strong class="text-arizona-terracotta">Component Embedding:</strong> Arizona components can contain embedded Svelte components, creating a hybrid architecture where server-side state management coexists with client-side reactive components.
                    </p>
                    <p class="text-sm text-silver/90 leading-relaxed">
                        <strong class="text-arizona-terracotta">Independent State:</strong> The Arizona counter and embedded Svelte counter maintain completely separate state. Changes to one don't affect the other, demonstrating how both architectures can coexist without interference.
                    </p>
                    <div class="bg-obsidian/60 p-4 rounded-lg border border-arizona-terracotta/30">
                        <p class="text-sm text-arizona-terracotta font-semibold mb-2">
                            🔍 Developer Tip
                        </p>
                        <p class="text-xs text-silver/90 leading-relaxed">
                            Open browser DevTools → Network tab → Filter by "Socket" (WebSocket).
                            Click the Arizona counter buttons to see real-time WebSocket messages.
                            Notice how the Svelte counter generates no network traffic - it's purely client-side!
                        </p>
                    </div>
                </div>
            </div>
        </div>

        {% Architecture Benefits }
        <div class="mt-12 bg-gradient-to-r from-obsidian/60 to-charcoal/40 rounded-2xl p-8 border border-pearl/10">
            <h4 class="text-lg font-bold text-pearl mb-4 text-center">Best of Both Worlds</h4>
            <div class="grid sm:grid-cols-2 gap-6">
                <div class="text-center">
                    <div class="w-12 h-12 bg-arizona-teal/20 rounded-full flex items-center justify-center mx-auto mb-3">
                        <span class="text-arizona-teal font-bold">S</span>
                    </div>
                    <p class="text-sm text-silver/90">
                        <span class="text-arizona-teal font-semibold">Svelte components</span> for rich client-side interactions, animations, and immediate user feedback
                    </p>
                </div>
                <div class="text-center">
                    <div class="w-12 h-12 bg-arizona-terracotta/20 rounded-full flex items-center justify-center mx-auto mb-3">
                        <span class="text-arizona-terracotta font-bold">A</span>
                    </div>
                    <p class="text-sm text-silver/90">
                        <span class="text-arizona-terracotta font-semibold">Arizona components</span> for real-time collaboration, live data updates, and server-side business logic
                    </p>
                </div>
            </div>
        </div>
    </div>
    """").

enhanced_next_steps(_Bindings) ->
    Module = ?MODULE,
    arizona_template:from_html(~""""
    <div class="{[
        ~"bg-gradient-to-r from-slate/10 via-charcoal/20 to-slate/10 ",
        ~"backdrop-blur-sm rounded-2xl p-8 border border-pearl/10"
    ]}">
        <div class="flex items-center gap-3 mb-6">
            <div class="{[
                ~"w-8 h-8 bg-arizona-terracotta/20 rounded-lg ",
                ~"flex items-center justify-center"
            ]}">
                <svg
                    class="w-5 h-5 text-arizona-terracotta"
                    fill="currentColor"
                    viewBox="0 0 20 20"
                >
                    <path
                        fill-rule="evenodd"
                        d="{[
                            ~"M12.316 3.051a1 1 0 01.633 1.265l-4 12a1 1 0 11-1.898-.632l4-12a1 1 0 ",
                            ~"011.265-.633zM5.707 6.293a1 1 0 010 1.414L3.414 10l2.293 2.293a1 1 0 11-1.414 ",
                            ~"1.414l-3-3a1 1 0 010-1.414l3-3a1 1 0 011.414 0zm8.586 0a1 1 0 011.414 0l3 3a1 1 0 ",
                            ~"010 1.414l-3 3a1 1 0 11-1.414-1.414L16.586 10l-2.293-2.293a1 1 0 010-1.414z"
                        ]}"
                        clip-rule="evenodd"
                    ></path>
                </svg>
            </div>
            <h3 class="text-2xl font-bold text-pearl">Ready to Start Building?</h3>
        </div>

        <div class="grid sm:grid-cols-2 gap-4">
            <div class="space-y-4">
                {arizona_template:render_list(fun(Item) ->
                    arizona_template:from_html(~"""
                    {arizona_template:render_stateless(Module, next_step, Item)}
                    """)
                end, [
                    #{
                        prefix_text => ~"Edit ",
                        filename => ~"src/{{name}}_view.erl",
                        suffix_text => ~" to customize this page"
                    },
                    #{
                        prefix_text => ~"Add Svelte components in ",
                        filename => ~"assets/svelte/components/"
                    }
                ])}
            </div>

            <div class="space-y-4">
                {arizona_template:render_list(fun(Item) ->
                    arizona_template:from_html(~"""
                    {arizona_template:render_stateless(Module, next_step, Item)}
                    """)
                end, [
                    #{
                        prefix_text => ~"Configure routes in ",
                        filename => ~"config/sys.config"
                    },
                    #{
                        prefix_text => ~"Customize styles in ",
                        filename => ~"assets/css/app.css"
                    }
                ])}
            </div>
        </div>
    </div>
    """").

next_step(Bindings) ->
    arizona_template:from_html(~"""
    <div class="{[
        ~"group flex items-start gap-3 p-4 rounded-lg ",
        ~"hover:bg-obsidian/30 transition-colors duration-200"
    ]}">
        <div class="w-2 h-2 bg-arizona-terracotta rounded-full mt-2"></div>
        <div>
            <span class="text-silver/90">
                {arizona_template:get_binding(prefix_text, Bindings)}
            </span>
            <code class="{[
                ~"bg-obsidian/60 px-2 py-1 rounded text-arizona-gold font-mono text-sm ",
                ~"border border-arizona-terracotta/20 group-hover:border-arizona-terracotta/40 ",
                ~"transition-colors duration-200 group-hover:shadow-sm ",
                ~"group-hover:shadow-arizona-terracotta/20"
            ]}">
                {arizona_template:get_binding(filename, Bindings)}
            </code>
            <span class="text-silver/90">
                {arizona_template:get_binding(suffix_text, Bindings, ~"")}
            </span>
        </div>
    </div>
    """).

quick_link_card(Bindings) ->
    Module = ?MODULE,
    arizona_template:from_html(~""""
    <a
        href="{arizona_template:get_binding(href, Bindings)}"
        target="_blank"
        class="{[
            ~"group bg-obsidian/60 rounded-xl p-6 hover:bg-obsidian/80 transition-all ",
            ~"duration-300 hover:scale-105 hover:shadow-lg hover:shadow-arizona-terracotta/20 ",
            ~"border border-transparent hover:border-arizona-terracotta/40 cursor-pointer ",
            ~"transform hover:-translate-y-1 block {arizona_template:get_binding(extra_classes, Bindings, ~\"\")}"
        ]}">
        <div class="flex items-center justify-between mb-4">
            <div class="{[
                ~"w-12 h-12 bg-arizona-terracotta/20 rounded-lg flex items-center justify-center ",
                ~"group-hover:bg-arizona-terracotta/30 transition-colors duration-300"
            ]}">
                {arizona_template:get_binding(icon, Bindings)}
            </div>
            {arizona_template:render_stateless(Module, arrow_icon, #{})}
        </div>
        <h3 class="{[
            ~"text-arizona-terracotta font-bold text-lg mb-2 group-hover:text-arizona-gold ",
            ~"transition-colors duration-300"
        ]}">
            {arizona_template:get_binding(title, Bindings)}
        </h3>
        <p class="{[
            ~"text-sm text-silver/80 group-hover:text-silver ",
            ~"transition-colors duration-300"
        ]}">
            {arizona_template:get_binding(description, Bindings)}
        </p>
    </a>
    """").

arrow_icon(_Bindings) ->
    arizona_template:from_html(~"""
    <div class="{[
        ~"w-6 h-6 text-arizona-terracotta opacity-0 group-hover:opacity-100 ",
        ~"transition-opacity duration-300"
    ]}">
        <svg fill="currentColor" viewBox="0 0 20 20">
            <path
                fill-rule="evenodd"
                d="{[
                    ~"M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 ",
                    ~"1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z"
                ]}"
                clip-rule="evenodd"
            ></path>
        </svg>
    </div>
    """).
