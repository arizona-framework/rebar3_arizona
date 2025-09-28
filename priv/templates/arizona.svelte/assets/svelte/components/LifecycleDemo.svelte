<script>
  import { mount, unmount } from 'svelte';

  let componentCounter = $state(0);
  let logEntries = $state([]);
  let showLog = $state(true);
  let mountedComponents = $state(0);
  let demoComponentCount = $state(0);

  // Update demo component count
  function updateDemoComponentCount() {
    if (typeof document !== 'undefined') {
      demoComponentCount = document.querySelectorAll('.demo-component').length;
    }
  }

  // Get arizonaSvelte instance from global and update counts
  $effect(() => {
    if (typeof window !== 'undefined' && window.arizonaSvelte) {
      // Update mounted component count
      const updateCounts = () => {
        mountedComponents = window.arizonaSvelte.getLifecycle().getAllMountedComponents().size;
        updateDemoComponentCount();
      };

      // Update counts initially and on interval
      updateCounts();
      const interval = setInterval(updateCounts, 1000);

      return () => clearInterval(interval);
    }
  });

  function addCounterComponent() {
    componentCounter++;
    const id = `demo-counter-${componentCounter}`;

    const componentDiv = document.createElement('div');
    componentDiv.id = id;
    componentDiv.className = 'demo-component mb-4 p-4 bg-arizona-teal/10 border border-arizona-teal/20 rounded-lg';
    componentDiv.setAttribute('data-svelte-component', 'Counter');
    componentDiv.setAttribute('data-svelte-props', JSON.stringify({
      title: `Demo Counter #${componentCounter}`,
      initialCount: Math.floor(Math.random() * 10)
    }));

    const container = getContainer();
    if (container) {
      container.appendChild(componentDiv);
    }
    updateDemoComponentCount();

    addLogEntry('demo', `➕ Added Counter component: ${id}`);
  }

  function addHelloWorldComponent() {
    componentCounter++;
    const id = `demo-helloworld-${componentCounter}`;

    const componentDiv = document.createElement('div');
    componentDiv.id = id;
    componentDiv.className = 'demo-component mb-4 p-4 bg-arizona-terracotta/10 border border-arizona-terracotta/20 rounded-lg';
    componentDiv.setAttribute('data-svelte-component', 'HelloWorld');
    componentDiv.setAttribute('data-svelte-props', JSON.stringify({
      name: `Demo User ${componentCounter}`
    }));

    const container = getContainer();
    if (container) {
      container.appendChild(componentDiv);
    }
    updateDemoComponentCount();

    addLogEntry('demo', `➕ Added HelloWorld component: ${id}`);
  }

  function removeRandomComponent() {
    const demoComponents = document.querySelectorAll('.demo-component');
    if (demoComponents.length === 0) {
      addLogEntry('demo', '⚠️ No demo components to remove');
      return;
    }

    const randomIndex = Math.floor(Math.random() * demoComponents.length);
    const componentToRemove = demoComponents[randomIndex];
    const componentId = componentToRemove.id;

    componentToRemove.remove();
    updateDemoComponentCount();
    addLogEntry('demo', `➖ Removed component: ${componentId}`);
  }

  function removeAllComponents() {
    const demoComponents = document.querySelectorAll('.demo-component');
    const count = demoComponents.length;

    demoComponents.forEach(component => component.remove());
    updateDemoComponentCount();
    addLogEntry('demo', `🗑️ Removed all ${count} demo components`);
  }

  function getContainer() {
    return document.querySelector('.demo-components-container');
  }

  function addLogEntry(type, message) {
    const timestamp = new Date().toLocaleTimeString();
    const entry = {
      id: Date.now() + Math.random(),
      timestamp,
      type,
      message
    };

    logEntries = [...logEntries.slice(-99), entry]; // Keep last 100 entries, newest at bottom
    scrollLogToBottom();
  }

  function scrollLogToBottom() {
    // Use setTimeout to ensure DOM is updated before scrolling
    setTimeout(() => {
      const logContainer = document.getElementById('log-container');
      if (logContainer) {
        logContainer.scrollTo({
          top: logContainer.scrollHeight,
          behavior: 'smooth'
        });
      }
    }, 10);
  }

  function clearLog() {
    logEntries = [];
  }

  function toggleLog() {
    showLog = !showLog;
  }

  // Enhanced logging by intercepting console (but only for non-demo components)
  $effect(() => {
    if (typeof window !== 'undefined') {
      const originalConsoleLog = console.log;
      const originalConsoleWarn = console.warn;
      const originalConsoleError = console.error;

      console.log = (...args) => {
        originalConsoleLog.apply(console, args);
        const message = args.map(arg =>
          typeof arg === 'object' && arg !== null ? JSON.stringify(arg, null, 2) : String(arg)
        ).join(' ');
        if (message.includes('[Arizona Svelte]') &&
            !message.includes('LifecycleDemo') &&
            !message.includes('Mounted 0 components')) {
          addLogEntry('info', message);
        }
      };

      console.warn = (...args) => {
        originalConsoleWarn.apply(console, args);
        const message = args.map(arg =>
          typeof arg === 'object' && arg !== null ? JSON.stringify(arg, null, 2) : String(arg)
        ).join(' ');
        if (message.includes('[Arizona Svelte]') && !message.includes('LifecycleDemo')) {
          addLogEntry('warning', message);
        }
      };

      console.error = (...args) => {
        originalConsoleError.apply(console, args);
        const message = args.map(arg =>
          typeof arg === 'object' && arg !== null ? JSON.stringify(arg, null, 2) : String(arg)
        ).join(' ');
        if (message.includes('[Arizona Svelte]') && !message.includes('LifecycleDemo')) {
          addLogEntry('error', message);
        }
      };

      // Cleanup function
      return () => {
        console.log = originalConsoleLog;
        console.warn = originalConsoleWarn;
        console.error = originalConsoleError;
      };
    }
  });

  function getLogEntryClasses(type) {
    switch (type) {
      case 'info':
        return 'bg-arizona-teal/5 border-arizona-teal text-arizona-teal';
      case 'warning':
        return 'bg-arizona-gold/5 border-arizona-gold text-arizona-gold';
      case 'error':
        return 'bg-red-500/5 border-red-500 text-red-400';
      case 'demo':
        return 'bg-arizona-terracotta/5 border-arizona-terracotta text-arizona-terracotta';
      default:
        return 'bg-slate/5 border-slate text-silver';
    }
  }
</script>

<!-- Demo Controls -->
<div class="fixed bottom-4 right-4 bg-obsidian/90 backdrop-blur-lg border border-arizona-teal/30 rounded-lg p-4 shadow-lg z-50 w-96">
  <div class="text-arizona-teal font-semibold mb-3 text-sm">
    🧪 Component Lifecycle Demo
  </div>

  <div class="space-y-2">
    <button
      onclick={addCounterComponent}
      class="w-full px-3 py-2 bg-arizona-teal/20 text-arizona-teal rounded border border-arizona-teal/30 hover:bg-arizona-teal/30 transition-colors text-xs"
    >
      ➕ Add Counter Component
    </button>

    <button
      onclick={addHelloWorldComponent}
      class="w-full px-3 py-2 bg-arizona-terracotta/20 text-arizona-terracotta rounded border border-arizona-terracotta/30 hover:bg-arizona-terracotta/30 transition-colors text-xs"
    >
      ➕ Add HelloWorld Component
    </button>

    <button
      onclick={removeRandomComponent}
      disabled={demoComponentCount === 0}
      class="w-full px-3 py-2 rounded border transition-colors text-xs {
        demoComponentCount === 0
          ? 'bg-slate/10 text-slate/50 border-slate/20 cursor-not-allowed'
          : 'bg-slate/20 text-silver border-slate/30 hover:bg-slate/30'
      }"
    >
      ➖ Remove Random Component
    </button>

    <button
      onclick={removeAllComponents}
      disabled={demoComponentCount === 0}
      class="w-full px-3 py-2 rounded border transition-colors text-xs {
        demoComponentCount === 0
          ? 'bg-slate/10 text-slate/50 border-slate/20 cursor-not-allowed'
          : 'bg-red-500/20 text-red-400 border-red-500/30 hover:bg-red-500/30'
      }"
    >
      🗑️ Remove All Components ({demoComponentCount})
    </button>

    <button
      onclick={toggleLog}
      class="w-full px-3 py-2 bg-arizona-gold/20 text-arizona-gold rounded border border-arizona-gold/30 hover:bg-arizona-gold/30 transition-colors text-xs"
    >
      📋 Toggle Log
    </button>
  </div>

  <div class="mt-3 text-xs text-silver/70">
    <div>Demo Components: <span class="text-arizona-teal">{demoComponentCount}</span></div>
    <div>Total Mounted: <span class="text-arizona-teal">{mountedComponents}</span></div>
    <div>Monitoring: <span class="text-arizona-teal">{typeof window !== 'undefined' && window.arizonaSvelte?.isMonitoring() ? '✅' : '❌'}</span></div>
  </div>
</div>

<!-- Log Panel -->
{#if showLog}
  <div class="fixed top-4 right-4 bg-obsidian/95 backdrop-blur-lg border border-arizona-teal/30 rounded-lg shadow-lg z-40 w-96 max-h-96 overflow-hidden">
    <div class="sticky top-0 bg-obsidian/95 border-b border-arizona-teal/20 p-3">
      <div class="flex justify-between items-center">
        <span class="text-arizona-teal font-semibold text-sm">📊 Lifecycle Events Log</span>
        <button
          onclick={clearLog}
          class="text-xs text-silver/70 hover:text-silver transition-colors"
        >
          Clear
        </button>
      </div>
    </div>

    <div id="log-container" class="p-3 space-y-1 max-h-80 overflow-y-auto">
      {#each logEntries as entry (entry.id)}
        <div class="text-xs p-2 rounded border-l-2 {getLogEntryClasses(entry.type)}">
          <div class="flex justify-between">
            <span class="font-mono">{entry.timestamp}</span>
            <span class="text-xs opacity-70">{entry.type}</span>
          </div>
          <div class="mt-1">{entry.message}</div>
        </div>
      {/each}

      {#if logEntries.length === 0}
        <div class="text-center text-silver/50 py-4">
          No log entries yet. Try adding/removing components!
        </div>
      {/if}
    </div>
  </div>
{/if}
