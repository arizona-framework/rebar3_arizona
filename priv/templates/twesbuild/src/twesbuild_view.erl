-module(twesbuild_view).
-behaviour(arizona_view).
-compile({parse_transform, arizona_parse_transform}).
-export([mount/2]).
-export([render/1]).

mount(#{title := Title}, _Req) ->
    Bindings = #{
        id => ~"view",
        name => ~"World"
    },
    Layout =
        {twesbuild_layout, render, main_content, #{
            title => Title
        }},
    arizona_view:new(?MODULE, Bindings, Layout).

render(_Bindings) ->
    arizona_template:from_string(~""""
    <!-- Hero Section -->
    <section class="min-h-screen bg-gradient-to-br from-obsidian via-charcoal to-arizona-terracotta flex items-center">
        <div class="container mx-auto px-6 lg:px-8">
            <div class="grid lg:grid-cols-2 gap-12 items-center">
                <!-- Hero Content -->
                <div class="space-y-8">
                    <div class="space-y-4">
                        <h1 class="text-5xl lg:text-7xl font-bold text-pearl leading-tight">
                            Build
                            <span class="bg-gradient-arizona bg-clip-text text-transparent">
                                Real-time
                            </span>
                            <br>Web Applications
                        </h1>
                        <p class="text-xl lg:text-2xl text-silver leading-relaxed">
                            Arizona is a modern Erlang web framework designed for building
                            scalable, fault-tolerant real-time applications on the BEAM.
                        </p>
                    </div>

                    <!-- CTA Buttons -->
                    <div class="flex flex-col sm:flex-row gap-4">
                        <button class="px-8 py-4 bg-gradient-arizona text-pearl font-semibold rounded-lg
                                     hover:shadow-lg hover:scale-105 transition-all duration-200">
                            Get Started
                        </button>
                        <button class="px-8 py-4 border-2 border-arizona-terracotta text-arizona-terracotta
                                     font-semibold rounded-lg hover:bg-arizona-terracotta hover:text-pearl
                                     transition-all duration-200">
                            View Documentation
                        </button>
                    </div>

                    <!-- Key Stats -->
                    <div class="grid grid-cols-3 gap-8 pt-8 border-t border-slate">
                        <div class="text-center">
                            <div class="text-2xl font-bold text-arizona-terracotta">99.9%</div>
                            <div class="text-sm text-silver">Uptime</div>
                        </div>
                        <div class="text-center">
                            <div class="text-2xl font-bold text-arizona-terracotta">&lt;1ms</div>
                            <div class="text-sm text-silver">Latency</div>
                        </div>
                        <div class="text-center">
                            <div class="text-2xl font-bold text-arizona-terracotta">Millions</div>
                            <div class="text-sm text-silver">Connections</div>
                        </div>
                    </div>
                </div>

                <!-- Hero Visual -->
                <div class="relative">
                    <div class="bg-charcoal rounded-xl p-6 shadow-2xl">
                        <div class="flex items-center gap-2 mb-4">
                            <div class="w-3 h-3 bg-red-500 rounded-full"></div>
                            <div class="w-3 h-3 bg-yellow-500 rounded-full"></div>
                            <div class="w-3 h-3 bg-green-500 rounded-full"></div>
                            <span class="ml-4 text-silver text-sm">arizona_live_view.erl</span>
                        </div>
                        <pre class="text-sm text-pearl font-mono leading-relaxed">
    <span class="text-arizona-teal">-module</span><span class="text-pearl">(chat_view).</span>
    <span class="text-arizona-teal">-behaviour</span><span class="text-pearl">(arizona_live_view).</span>

    <span class="text-arizona-teal">handle_event</span><span class="text-pearl">(</span><span class="text-arizona-gold">"send_message"</span><span class="text-pearl">, Msg, State) -></span>
        <span class="text-arizona-sage">arizona_pubsub:broadcast</span><span class="text-pearl">(</span><span class="text-arizona-gold">"chat"</span><span class="text-pearl">, Msg),</span>
        <span class="text-pearl">\{noreply, State}.</span>
                        </pre>
                    </div>
                    <!-- Floating elements for visual interest -->
                    <div class="absolute -top-4 -right-4 w-24 h-24 bg-gradient-arizona rounded-full blur-xl opacity-30"></div>
                    <div class="absolute -bottom-4 -left-4 w-16 h-16 bg-arizona-teal rounded-full blur-lg opacity-20"></div>
                </div>
            </div>
        </div>
    </section>

    <!-- Features Section -->
    <section class="py-20 bg-obsidian">
        <div class="container mx-auto px-6 lg:px-8">
            <div class="text-center mb-16">
                <h2 class="text-4xl lg:text-5xl font-bold text-pearl mb-6">
                    Built for the
                    <span class="text-arizona-terracotta">BEAM</span>
                </h2>
                <p class="text-xl text-silver max-w-3xl mx-auto">
                    Leverage the power of Erlang's battle-tested concurrency model with modern web development patterns.
                </p>
            </div>

            <div class="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
                <!-- Feature 1 -->
                <div class="bg-charcoal rounded-xl p-8 hover:bg-slate transition-colors duration-200">
                    <div class="w-12 h-12 bg-gradient-arizona rounded-lg flex items-center justify-center mb-6">
                        <svg class="w-6 h-6 text-pearl" fill="currentColor" viewBox="0 0 20 20">
                            <path fill-rule="evenodd" d="M11.3 1.046A1 1 0 0112 2v5h4a1 1 0 01.82 1.573l-7 10A1 1 0 018 18v-5H4a1 1 0 01-.82-1.573l7-10a1 1 0 011.12-.38z" clip-rule="evenodd"/>
                        </svg>
                    </div>
                    <h3 class="text-xl font-semibold text-pearl mb-4">Real-time by Default</h3>
                    <p class="text-silver">Built-in WebSocket support and LiveView-style updates without the complexity.</p>
                </div>

                <!-- Feature 2 -->
                <div class="bg-charcoal rounded-xl p-8 hover:bg-slate transition-colors duration-200">
                    <div class="w-12 h-12 bg-gradient-arizona rounded-lg flex items-center justify-center mb-6">
                        <svg class="w-6 h-6 text-pearl" fill="currentColor" viewBox="0 0 20 20">
                            <path fill-rule="evenodd" d="M2.166 4.999A11.954 11.954 0 0010 1.944 11.954 11.954 0 0017.834 5c.11.65.166 1.32.166 2.001 0 5.225-3.34 9.67-8 11.317C5.34 16.67 2 12.225 2 7c0-.682.057-1.35.166-2.001zm11.541 3.708a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"/>
                        </svg>
                    </div>
                    <h3 class="text-xl font-semibold text-pearl mb-4">Fault Tolerant</h3>
                    <p class="text-silver">Erlang's supervision trees ensure your application stays running even when components fail.</p>
                </div>

                <!-- Feature 3 -->
                <div class="bg-charcoal rounded-xl p-8 hover:bg-slate transition-colors duration-200">
                    <div class="w-12 h-12 bg-gradient-arizona rounded-lg flex items-center justify-center mb-6">
                        <svg class="w-6 h-6 text-pearl" fill="currentColor" viewBox="0 0 20 20">
                            <path fill-rule="evenodd" d="M3 4a1 1 0 011-1h12a1 1 0 110 2H4a1 1 0 01-1-1zm0 4a1 1 0 011-1h12a1 1 0 110 2H4a1 1 0 01-1-1zm0 4a1 1 0 011-1h12a1 1 0 110 2H4a1 1 0 01-1-1z" clip-rule="evenodd"/>
                        </svg>
                    </div>
                    <h3 class="text-xl font-semibold text-pearl mb-4">Massively Scalable</h3>
                    <p class="text-silver">Handle millions of concurrent connections with lightweight Erlang processes.</p>
                </div>

                <!-- Feature 4 -->
                <div class="bg-charcoal rounded-xl p-8 hover:bg-slate transition-colors duration-200">
                    <div class="w-12 h-12 bg-gradient-arizona rounded-lg flex items-center justify-center mb-6">
                        <svg class="w-6 h-6 text-pearl" fill="currentColor" viewBox="0 0 20 20">
                            <path fill-rule="evenodd" d="M12.395 2.553a1 1 0 00-1.45-.385c-.345.23-.614.558-.822.88-.214.33-.403.713-.57 1.116-.334.804-.614 1.768-.84 2.734a31.365 31.365 0 00-.613 3.58 2.64 2.64 0 01-.945-1.067c-.328-.68-.398-1.534-.398-2.654A1 1 0 005.05 6.05 6.981 6.981 0 003 11a7 7 0 1011.95-4.95c-.592-.591-.98-.985-1.348-1.467-.363-.476-.724-1.063-1.207-2.03zM12.12 15.12A3 3 0 017 13s.879.5 2.5.5c0-1 .5-4 1.25-4.5.5 1 .786 1.293 1.371 1.879A2.99 2.99 0 0113 13a2.99 2.99 0 01-.879 2.121z" clip-rule="evenodd"/>
                        </svg>
                    </div>
                    <h3 class="text-xl font-semibold text-pearl mb-4">Hot Code Reloading</h3>
                    <p class="text-silver">Update your application code without stopping the server or losing state.</p>
                </div>

                <!-- Feature 5 -->
                <div class="bg-charcoal rounded-xl p-8 hover:bg-slate transition-colors duration-200">
                    <div class="w-12 h-12 bg-gradient-arizona rounded-lg flex items-center justify-center mb-6">
                        <svg class="w-6 h-6 text-pearl" fill="currentColor" viewBox="0 0 20 20">
                            <path fill-rule="evenodd" d="M6 2a2 2 0 00-2 2v12a2 2 0 002 2h8a2 2 0 002-2V7.414A2 2 0 0015.414 6L12 2.586A2 2 0 0010.586 2H6zm5 6a1 1 0 10-2 0v3.586l-1.293-1.293a1 1 0 10-1.414 1.414l3 3a1 1 0 001.414 0l3-3a1 1 0 00-1.414-1.414L11 11.586V8z" clip-rule="evenodd"/>
                        </svg>
                    </div>
                    <h3 class="text-xl font-semibold text-pearl mb-4">Developer Experience</h3>
                    <p class="text-silver">Intuitive APIs, comprehensive documentation, and powerful debugging tools.</p>
                </div>

                <!-- Feature 6 -->
                <div class="bg-charcoal rounded-xl p-8 hover:bg-slate transition-colors duration-200">
                    <div class="w-12 h-12 bg-gradient-arizona rounded-lg flex items-center justify-center mb-6">
                        <svg class="w-6 h-6 text-pearl" fill="currentColor" viewBox="0 0 20 20">
                            <path fill-rule="evenodd" d="M3 3a1 1 0 000 2v8a2 2 0 002 2h2.586l-1.293 1.293a1 1 0 101.414 1.414L10 15.414l2.293 2.293a1 1 0 001.414-1.414L12.414 15H15a2 2 0 002-2V5a1 1 0 100-2H3zm11.707 4.707a1 1 0 00-1.414-1.414L10 9.586 8.707 8.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"/>
                        </svg>
                    </div>
                    <h3 class="text-xl font-semibold text-pearl mb-4">Production Ready</h3>
                    <p class="text-silver">Battle-tested in production environments with comprehensive monitoring and observability.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Code Example Section -->
    <section class="py-20 bg-charcoal">
        <div class="container mx-auto px-6 lg:px-8">
            <div class="text-center mb-16">
                <h2 class="text-4xl lg:text-5xl font-bold text-pearl mb-6">
                    Simple, Yet
                    <span class="text-arizona-terracotta">Powerful</span>
                </h2>
                <p class="text-xl text-silver max-w-3xl mx-auto">
                    Build interactive applications with familiar patterns and the reliability of Erlang.
                </p>
            </div>

            <div class="max-w-4xl mx-auto">
                <div class="bg-obsidian rounded-xl p-8 shadow-2xl">
                    <div class="flex items-center justify-between mb-6">
                        <div class="flex items-center gap-2">
                            <div class="w-3 h-3 bg-red-500 rounded-full"></div>
                            <div class="w-3 h-3 bg-yellow-500 rounded-full"></div>
                            <div class="w-3 h-3 bg-green-500 rounded-full"></div>
                        </div>
                        <span class="text-silver text-sm">Live Counter Example</span>
                    </div>
                    <pre class="text-sm font-mono leading-relaxed overflow-x-auto">
    <span class="text-arizona-sage">-module</span><span class="text-pearl">(counter_view).</span>
    <span class="text-arizona-sage">-behaviour</span><span class="text-pearl">(arizona_live_view).</span>
    <span class="text-arizona-sage">-export</span><span class="text-pearl">([mount/2, handle_event/3, render/1]).</span>

    <span class="text-arizona-sage">mount</span><span class="text-pearl">(_, _) -></span>
        <span class="text-pearl">\{ok, #\{count => 0}}.</span>

    <span class="text-arizona-sage">handle_event</span><span class="text-pearl">(</span><span class="text-arizona-gold">"increment"</span><span class="text-pearl">, _, #\{count := Count} = State) -></span>
        <span class="text-pearl">\{noreply, State#\{count => Count + 1}};</span>
    <span class="text-arizona-sage">handle_event</span><span class="text-pearl">(</span><span class="text-arizona-gold">"decrement"</span><span class="text-pearl">, _, #\{count := Count} = State) -></span>
        <span class="text-pearl">\{noreply, State#\{count => Count - 1}}.</span>

    <span class="text-arizona-sage">render</span><span class="text-pearl">(#\{count := Count}) -></span>
        <span class="text-arizona-teal">arizona_template:from_string</span><span class="text-pearl">(~"""</span>
        <span class="text-arizona-gold">&lt;div class="counter"&gt;</span>
            <span class="text-arizona-gold">&lt;h1&gt;Count: \{Count}&lt;/h1&gt;</span>
            <span class="text-arizona-gold">&lt;button az-click="increment"&gt;+&lt;/button&gt;</span>
            <span class="text-arizona-gold">&lt;button az-click="decrement"&gt;-&lt;/button&gt;</span>
        <span class="text-arizona-gold">&lt;/div&gt;</span>
        <span class="text-pearl">""").</span>
                    </pre>
                </div>
            </div>
        </div>
    </section>

    <!-- Comparison Section -->
    <section class="py-20 bg-obsidian">
        <div class="container mx-auto px-6 lg:px-8">
            <div class="text-center mb-16">
                <h2 class="text-4xl lg:text-5xl font-bold text-pearl mb-6">
                    Why Choose
                    <span class="text-arizona-terracotta">Arizona</span>?
                </h2>
            </div>

            <div class="grid lg:grid-cols-3 gap-8">
                <!-- Arizona -->
                <div class="bg-gradient-arizona rounded-xl p-8 text-pearl">
                    <h3 class="text-2xl font-bold mb-6 text-center">Arizona</h3>
                    <ul class="space-y-4">
                        <li class="flex items-center gap-3">
                            <svg class="w-5 h-5 text-pearl" fill="currentColor" viewBox="0 0 20 20">
                                <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/>
                            </svg>
                            Native Erlang/BEAM performance
                        </li>
                        <li class="flex items-center gap-3">
                            <svg class="w-5 h-5 text-pearl" fill="currentColor" viewBox="0 0 20 20">
                                <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/>
                            </svg>
                            Built-in fault tolerance
                        </li>
                        <li class="flex items-center gap-3">
                            <svg class="w-5 h-5 text-pearl" fill="currentColor" viewBox="0 0 20 20">
                                <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/>
                            </svg>
                            Zero downtime deployments
                        </li>
                        <li class="flex items-center gap-3">
                            <svg class="w-5 h-5 text-pearl" fill="currentColor" viewBox="0 0 20 20">
                                <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/>
                            </svg>
                            Lightweight processes
                        </li>
                        <li class="flex items-center gap-3">
                            <svg class="w-5 h-5 text-pearl" fill="currentColor" viewBox="0 0 20 20">
                                <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/>
                            </svg>
                            Simple, intuitive API
                        </li>
                    </ul>
                </div>

                <!-- Phoenix -->
                <div class="bg-charcoal rounded-xl p-8 border border-slate">
                    <h3 class="text-2xl font-bold mb-6 text-center text-pearl">Phoenix</h3>
                    <ul class="space-y-4 text-silver">
                        <li class="flex items-center gap-3">
                            <svg class="w-5 h-5 text-green-500" fill="currentColor" viewBox="0 0 20 20">
                                <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/>
                            </svg>
                            Elixir ecosystem
                        </li>
                        <li class="flex items-center gap-3">
                            <svg class="w-5 h-5 text-green-500" fill="currentColor" viewBox="0 0 20 20">
                                <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/>
                            </svg>
                            Mature framework
                        </li>
                        <li class="flex items-center gap-3">
                            <svg class="w-5 h-5 text-red-500" fill="currentColor" viewBox="0 0 20 20">
                                <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd"/>
                            </svg>
                            Complex abstractions
                        </li>
                        <li class="flex items-center gap-3">
                            <svg class="w-5 h-5 text-red-500" fill="currentColor" viewBox="0 0 20 20">
                                <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd"/>
                            </svg>
                            Learning curve
                        </li>
                        <li class="flex items-center gap-3">
                            <svg class="w-5 h-5 text-red-500" fill="currentColor" viewBox="0 0 20 20">
                                <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd"/>
                            </svg>
                            Overhead for simple apps
                        </li>
                    </ul>
                </div>

                <!-- Node.js -->
                <div class="bg-charcoal rounded-xl p-8 border border-slate">
                    <h3 class="text-2xl font-bold mb-6 text-center text-pearl">Node.js</h3>
                    <ul class="space-y-4 text-silver">
                        <li class="flex items-center gap-3">
                            <svg class="w-5 h-5 text-green-500" fill="currentColor" viewBox="0 0 20 20">
                                <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/>
                            </svg>
                            Large ecosystem
                        </li>
                        <li class="flex items-center gap-3">
                            <svg class="w-5 h-5 text-green-500" fill="currentColor" viewBox="0 0 20 20">
                                <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/>
                            </svg>
                            Fast development
                        </li>
                        <li class="flex items-center gap-3">
                            <svg class="w-5 h-5 text-red-500" fill="currentColor" viewBox="0 0 20 20">
                                <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd"/>
                            </svg>
                            Single-threaded bottlenecks
                        </li>
                        <li class="flex items-center gap-3">
                            <svg class="w-5 h-5 text-red-500" fill="currentColor" viewBox="0 0 20 20">
                                <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd"/>
                            </svg>
                            Memory management issues
                        </li>
                        <li class="flex items-center gap-3">
                            <svg class="w-5 h-5 text-red-500" fill="currentColor" viewBox="0 0 20 20">
                                <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd"/>
                            </svg>
                            Callback complexity
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </section>

    <!-- Getting Started Section -->
    <section class="py-20 bg-gradient-desert">
        <div class="container mx-auto px-6 lg:px-8">
            <div class="text-center mb-16">
                <h2 class="text-4xl lg:text-5xl font-bold text-pearl mb-6">
                    Get Started in
                    <span class="text-arizona-gold">Minutes</span>
                </h2>
                <p class="text-xl text-silver max-w-3xl mx-auto">
                    Bootstrap your Arizona application with a single command and start building real-time features immediately.
                </p>
            </div>

            <div class="max-w-4xl mx-auto grid md:grid-cols-2 gap-8">
                <!-- Installation -->
                <div class="bg-obsidian rounded-xl p-8">
                    <h3 class="text-2xl font-bold text-pearl mb-6">Quick Start</h3>
                    <div class="space-y-4">
                        <div class="bg-charcoal rounded-lg p-4">
                            <pre class="text-arizona-teal text-sm font-mono">
    <span class="text-silver"># Install Arizona</span>
    rebar3 new arizona my_app
    cd my_app

    <span class="text-silver"># Start development server</span>
    rebar3 shell
                            </pre>
                        </div>
                        <p class="text-silver">Your app will be running at <code class="text-arizona-terracotta">http://localhost:4000</code></p>
                    </div>
                </div>

                <!-- Next Steps -->
                <div class="bg-obsidian rounded-xl p-8">
                    <h3 class="text-2xl font-bold text-pearl mb-6">What's Included</h3>
                    <ul class="space-y-3 text-silver">
                        <li class="flex items-center gap-3">
                            <div class="w-2 h-2 bg-arizona-terracotta rounded-full"></div>
                            Live reloading development server
                        </li>
                        <li class="flex items-center gap-3">
                            <div class="w-2 h-2 bg-arizona-terracotta rounded-full"></div>
                            Real-time WebSocket connections
                        </li>
                        <li class="flex items-center gap-3">
                            <div class="w-2 h-2 bg-arizona-terracotta rounded-full"></div>
                            Built-in asset pipeline
                        </li>
                        <li class="flex items-center gap-3">
                            <div class="w-2 h-2 bg-arizona-terracotta rounded-full"></div>
                            Production-ready configuration
                        </li>
                        <li class="flex items-center gap-3">
                            <div class="w-2 h-2 bg-arizona-terracotta rounded-full"></div>
                            Comprehensive documentation
                        </li>
                    </ul>
                </div>
            </div>

            <!-- CTA -->
            <div class="text-center mt-12">
                <button class="px-12 py-4 bg-pearl text-obsidian font-bold rounded-lg text-lg
                             hover:bg-silver transition-colors duration-200 shadow-lg">
                    Start Building Today
                </button>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="py-12 bg-obsidian border-t border-slate">
        <div class="container mx-auto px-6 lg:px-8">
            <div class="grid md:grid-cols-4 gap-8 mb-8">
                <!-- Brand -->
                <div class="space-y-4">
                    <h3 class="text-2xl font-bold text-arizona-terracotta">Arizona</h3>
                    <p class="text-silver">Building the future of real-time web applications on the BEAM.</p>
                </div>

                <!-- Documentation -->
                <div class="space-y-4">
                    <h4 class="font-semibold text-pearl">Documentation</h4>
                    <ul class="space-y-2 text-silver">
                        <li><a href="#" class="hover:text-arizona-terracotta transition-colors">Quick Start</a></li>
                        <li><a href="#" class="hover:text-arizona-terracotta transition-colors">Guides</a></li>
                        <li><a href="#" class="hover:text-arizona-terracotta transition-colors">API Reference</a></li>
                        <li><a href="#" class="hover:text-arizona-terracotta transition-colors">Examples</a></li>
                    </ul>
                </div>

                <!-- Community -->
                <div class="space-y-4">
                    <h4 class="font-semibold text-pearl">Community</h4>
                    <ul class="space-y-2 text-silver">
                        <li><a href="#" class="hover:text-arizona-terracotta transition-colors">GitHub</a></li>
                        <li><a href="#" class="hover:text-arizona-terracotta transition-colors">Discord</a></li>
                        <li><a href="#" class="hover:text-arizona-terracotta transition-colors">Forum</a></li>
                        <li><a href="#" class="hover:text-arizona-terracotta transition-colors">Blog</a></li>
                    </ul>
                </div>

                <!-- Support -->
                <div class="space-y-4">
                    <h4 class="font-semibold text-pearl">Support</h4>
                    <ul class="space-y-2 text-silver">
                        <li><a href="#" class="hover:text-arizona-terracotta transition-colors">Help Center</a></li>
                        <li><a href="#" class="hover:text-arizona-terracotta transition-colors">Report Issues</a></li>
                        <li><a href="#" class="hover:text-arizona-terracotta transition-colors">Feature Requests</a></li>
                        <li><a href="#" class="hover:text-arizona-terracotta transition-colors">Contributing</a></li>
                    </ul>
                </div>
            </div>

            <div class="border-t border-slate pt-8 text-center text-silver">
                <p>&copy; 2025 Arizona Framework. Built with love for the BEAM community.</p>
            </div>
        </div>
    </footer>
    """").
