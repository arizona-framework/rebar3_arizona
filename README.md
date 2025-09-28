# Arizona Framework CLI Toolkit

Interactive command-line toolkit for the [Arizona Framework](https://github.com/arizona-framework/arizona).
Create new Arizona applications with project templates.

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

### Option 1: Interactive CLI

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

[●] Create new app
    Generate a new Arizona application from templates
[ ] Exit
    Exit the Arizona CLI

## Step 2: Enter app name

Enter app name (or Esc/q to cancel): myapp

## Step 3: Choose template

Use ↑↓ arrows or j/k to navigate, Enter to select, Esc/q to cancel

[●] Hello world template
    Basic Arizona app with minimal setup
[ ] Presence template
    Real-time app with PubSub presence integration
[ ] Frontend template
    Modern web app with Tailwind CSS and ESBuild
[ ] Svelte template
    Full-stack app with Svelte, Tailwind CSS and Vite
[ ] Cancel
    Return to main menu
[ ] Exit
    Exit the Arizona CLI
```

The interactive flow:

1. **Choose "Create new app"** from the main menu
2. **Enter your app name** (e.g., "myapp")
3. **Select a template**:
   - **Hello world** - Basic Arizona app with minimal setup
   - **Presence** - Real-time app with PubSub Presence integration
   - **Frontend** - Modern web app with Tailwind CSS and ESBuild
   - **Svelte** - Full-stack app with Svelte, Tailwind CSS and Vite

### Option 2: Direct Template Commands

You can also create projects directly using rebar3's new command:

```bash
# Create a basic Arizona application
$ rebar3 new arizona.hello_world my_app

# Create a real-time application with presence
$ rebar3 new arizona.presence my_chat_app

# Create a modern frontend application
$ rebar3 new arizona.frontend my_web_app

# Create a full-stack Svelte application (uses arizona_svelte library)
$ rebar3 new arizona.svelte my_svelte_app
```

> **Note**: The arizona.svelte template leverages the **arizona_svelte library**
> for robust Svelte integration. This provides production-ready component management,
> automatic lifecycle monitoring, and seamless Arizona-Svelte interoperability out
> of the box.

## Templates

### Frontend Template

The Frontend template creates a modern Arizona web application with:

- **Tailwind CSS v4** - Modern utility-first CSS framework
- **ESBuild** - Fast JavaScript bundling and minification
- **Hot-reloading** - CSS changes reload automatically during development
- **Componentized views** - Reusable Arizona stateless components
- **Responsive design** - Mobile-first layout with modern UI components
- **Build scripts** - NPM scripts for development and production builds

After creating a Frontend template project:

```bash
cd myapp
npm install          # Install dependencies
npm run build        # Build CSS and JS
rebar3 shell         # Start the Arizona server
```

The app will be available at http://localhost:1912 with hot-reloading enabled.

### Svelte Template

The Svelte template creates a full-stack Arizona application powered by the
**arizona_svelte library**:

- **Arizona Svelte Library** - Production-ready Erlang/OTP and npm packages for
Svelte integration
- **Automatic Component Lifecycle** - Components mount/unmount automatically
with DOM changes
- **Svelte 5** - Modern reactive frontend framework with runes
- **Vite** - Fast build tool with hot module replacement
- **Tailwind CSS v4** - Modern utility-first CSS framework
- **Interactive Demo Components** - HelloWorld, Counter, and LifecycleDemo components
- **Real-time Monitoring** - Built-in component lifecycle monitoring and logging
- **WebSocket Integration** - Automatic re-mounting after Arizona HTML patches
- **Developer Tools** - Global `arizonaSvelte` debugging interface

After creating a Svelte template project:

```bash
cd myapp
npm install          # Install dependencies (includes @arizona-framework/svelte)
npm run build        # Build CSS and JS
rebar3 shell         # Start the Arizona server
```

The app will be available at http://localhost:1912 with:

- **Automatic component management** - No manual mounting/unmounting needed
- **Full hot-reloading** for both CSS and Svelte components
- **Interactive lifecycle demo** for testing and learning
- **Production-ready architecture** leveraging the arizona_svelte library

### Controls

- `↑↓` or `j/k` - Navigate menu options
- `Enter` - Select option
- `Esc` or `q` - Cancel/exit

## Development

### Local Development Setup

For local development, create a symlink in the global rebar3 checkouts directory:

```bash
mkdir -p ~/.config/rebar3/_checkouts
ln -sf /path/to/your/rebar3_arizona ~/.config/rebar3/_checkouts/rebar3_arizona
```

This allows rebar3 to use your local development version when the plugin is
configured in `~/.config/rebar3/rebar.config`.

> [!NOTE]
>
> Local checkouts work for project-specific development (when the plugin is in a
> project's `rebar.config`), but have limitations for global usage. For example:
>
> ```erlang
> % In a project's rebar.config - works with local checkouts
> {plugins, [
>     {rebar3_arizona, {git, "https://github.com/arizona-framework/rebar3_arizona.git", {branch, "main"}}}
> ]}.
> ```
>
> The plugin will only work globally from anywhere once merged to the main branch
> on GitHub, as rebar3's global plugin system doesn't fully support local checkouts
> for plugins that need to work outside project directories.

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
