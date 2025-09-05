rebar3_arizona
=====

A rebar plugin

Build
-----

    $ rebar3 compile

Use
---

Add the plugin to your rebar config:

    {plugins, [
        {rebar3_arizona, {git, "https://github.com/arizona-framework/rebar3_arizona.git", {branch, "main"}}}
    ]}.

Then just call your plugin directly in an existing application:


    $ rebar3 arizona
    ===> Fetching rebar3_arizona
    ===> Compiling rebar3_arizona
    <Plugin Output>
