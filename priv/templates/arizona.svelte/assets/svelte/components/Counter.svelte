<script>
  let { title = "Svelte Counter", initialCount = 0 } = $props();
  let count = $state(initialCount);

  $effect(() => {
    count = initialCount;
  });

  function increment() {
    count += 1;
  }

  function decrement() {
    count -= 1;
  }

  function reset() {
    count = 0;
  }
</script>

<div class="w-full">
  <div class="p-4">
    <h2 class="text-lg font-bold text-red-500">{title}</h2>
    <p class="text-gray-400 text-sm">Independent reactive state</p>
  </div>

  <div class="p-6">
    <div class="text-center mb-6">
      <div class="text-4xl font-bold text-red-500 mb-3">
        {count}
      </div>
      <div class="text-sm text-gray-400">Current value</div>
    </div>

    <div class="flex gap-3">
      <button
        onclick={decrement}
        class="flex-1 py-3 px-4 bg-arizona-terracotta/10 text-arizona-terracotta border border-arizona-terracotta/20 rounded-lg hover:bg-arizona-terracotta/20 hover:border-arizona-terracotta/40 hover:text-arizona-mesa focus:ring-2 focus:ring-arizona-terracotta/50 focus:ring-offset-2 focus:ring-offset-charcoal transition-all duration-200 font-medium cursor-pointer"
      >
        −
      </button>

      <button
        onclick={reset}
        class="flex-1 py-3 px-4 bg-slate/20 text-silver border border-slate/30 rounded-lg hover:bg-slate/30 hover:border-slate/50 hover:text-pearl focus:ring-2 focus:ring-slate/50 focus:ring-offset-2 focus:ring-offset-charcoal transition-all duration-200 font-medium cursor-pointer"
      >
        Reset
      </button>

      <button
        onclick={increment}
        class="flex-1 py-3 px-4 bg-arizona-teal/10 text-arizona-teal border border-arizona-teal/20 rounded-lg hover:bg-arizona-teal/20 hover:border-arizona-teal/40 hover:text-arizona-sage focus:ring-2 focus:ring-arizona-teal/50 focus:ring-offset-2 focus:ring-offset-charcoal transition-all duration-200 font-medium cursor-pointer"
      >
        +
      </button>
    </div>
  </div>
</div>
