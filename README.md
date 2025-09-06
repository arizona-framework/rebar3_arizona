# Arizona Framework CLI Toolkit

Interactive command-line toolkit for the [Arizona Framework](https://github.com/arizona-framework/arizona).
Create projects, manage servers, run development tasks, and more.

## Installation

### Global Installation (Recommended)

Add to your global rebar3 config at `~/.config/rebar3/rebar.config`:

```erlang
{plugins, [
    {rebar3_arizona, {git, "https://github.com/arizona-framework/rebar3_arizona.git", {branch, "main"}}}
]}.
```

### Project-Specific Installation

Add to your project's `rebar.config`:

```erlang
{plugins, [
    {rebar3_arizona, {git, "https://github.com/arizona-framework/rebar3_arizona.git", {branch, "main"}}}
]}.
```

## Usage

Run the interactive menu:

```bash
$ rebar3 arizona
    _          _
   / \   _ __ (_)_______  _ __   __ _
  / _ \ | '__|| |_  / _ \| '_ \ / _` |
 / ___ \| |   | |/ / (_) | | | | (_| |
/_/   \_\_|   |_/___\___/|_| |_|\__,_|

https://github.com/arizona-framework/arizona

Use ↑↓ arrows or j/k to navigate, Enter to select, Esc/q to cancel

[●] Create Arizona hello world app
[ ] Create Arizona presence app
[ ] Cancel
```

Navigate the menu options:

- **Create Arizona hello world app** - Basic Arizona application template
- **Create Arizona presence app** - Real-time presence/counter example

### Controls

- `↑↓` or `j/k` - Navigate menu options
- `Enter` - Select option
- `Esc` or `q` - Cancel/exit

## Development

Build the plugin:

```bash
$ rebar3 compile
```

Run tests and linting:

```bash
$ rebar3 lint
$ rebar3 xref
```

Run full CI pipeline:

```bash
$ rebar3 ci
```

## Requirements

- Erlang/OTP 28+

## License

Copyright (c) 2025 [William Fank Thomé](https://github.com/williamthome)

Arizona is 100% open-source and community-driven. All components are
available under the Apache 2 License on [GitHub](https://github.com/arizona-framework/arizona).

See [LICENSE.md](LICENSE.md) for more information.
