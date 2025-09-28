<script>
  let { name = 'World' } = $props();

  let items = $state([
    { id: 1, text: 'Drag me around!', color: 'arizona-teal', emoji: '🚀' },
    { id: 2, text: 'Reactive state', color: 'arizona-terracotta', emoji: '⚡' },
    { id: 3, text: 'No virtual DOM', color: 'arizona-gold', emoji: '💫' },
    { id: 4, text: 'Compile-time magic', color: 'arizona-sage', emoji: '✨' },
  ]);

  let draggedItem = $state(null);
  let hoveredZone = $state(null);
  let dragOverIndex = $state(-1);
  let dropZones = $state([
    { id: 'todo', title: 'To Do', items: [items[0], items[1]] },
    { id: 'doing', title: 'Doing', items: [items[2]] },
    { id: 'done', title: 'Done', items: [items[3]] }
  ]);

  function handleDragStart(event, item) {
    draggedItem = item;
    event.dataTransfer.effectAllowed = 'move';
    // Add some visual feedback to the dragged element
    event.target.style.opacity = '0.5';
  }

  function handleDragEnd(event) {
    // Reset visual feedback
    event.target.style.opacity = '1';
    hoveredZone = null;
    dragOverIndex = -1;
  }

  function handleDragOver(event) {
    event.preventDefault();
    event.dataTransfer.dropEffect = 'move';
  }

  function handleDragEnter(event, zone) {
    event.preventDefault();
    if (draggedItem) {
      hoveredZone = zone.id;
    }
  }

  function handleDragLeave(event, zone) {
    // Only reset hoveredZone if we're actually leaving the zone
    // (not just moving to a child element)
    if (!event.currentTarget.contains(event.relatedTarget)) {
      hoveredZone = null;
      dragOverIndex = -1;
    }
  }

  function handleItemDragOver(event, zone, index) {
    event.preventDefault();
    event.stopPropagation();
    if (draggedItem && hoveredZone === zone.id) {
      const rect = event.currentTarget.getBoundingClientRect();
      const midpoint = rect.top + rect.height / 2;
      dragOverIndex = event.clientY < midpoint ? index : index + 1;
    }
  }

  function handleDrop(event, targetZone, dropIndex = -1) {
    event.preventDefault();
    hoveredZone = null;
    const finalDropIndex = dropIndex !== -1 ? dropIndex : dragOverIndex;
    dragOverIndex = -1;

    if (!draggedItem) return;

    // Remove item from current zone
    dropZones = dropZones.map(zone => ({
      ...zone,
      items: zone.items.filter(item => item.id !== draggedItem.id)
    }));

    // Add item to target zone at specific position
    const targetZoneIndex = dropZones.findIndex(zone => zone.id === targetZone.id);
    const targetItems = [...dropZones[targetZoneIndex].items];

    // Insert at specific index, or at the end if no specific index
    const insertIndex = finalDropIndex >= 0 && finalDropIndex <= targetItems.length
      ? finalDropIndex
      : targetItems.length;

    targetItems.splice(insertIndex, 0, draggedItem);
    dropZones[targetZoneIndex].items = targetItems;

    draggedItem = null;
  }

  // Helper function to get preview items for a zone
  function getPreviewItems(zone) {
    if (hoveredZone === zone.id && draggedItem) {
      const items = zone.items.filter(item => item.id !== draggedItem.id);
      const insertIndex = dragOverIndex >= 0 && dragOverIndex <= items.length
        ? dragOverIndex
        : items.length;

      const result = [...items];
      result.splice(insertIndex, 0, draggedItem);
      return result;
    }
    return zone.items;
  }

  function resetBoard() {
    dropZones = [
      { id: 'todo', title: 'To Do', items: [items[0], items[1]] },
      { id: 'doing', title: 'Doing', items: [items[2]] },
      { id: 'done', title: 'Done', items: [items[3]] }
    ];
  }
</script>

<main class="h-full p-6 space-y-6">
  <div class="text-center">
    <h1 class="text-2xl font-bold text-arizona-teal mb-2">Hello, <span class="text-red-500">{name}</span>!</h1>
    <p class="text-gray-400 text-sm">Interactive drag & drop Kanban board</p>
  </div>

  <!-- Drag and Drop Kanban Board -->
  <div class="bg-charcoal/50 rounded-lg p-6 border border-arizona-teal/20">
    <div class="flex justify-between items-center mb-4">
      <h3 class="text-lg font-semibold text-arizona-teal">Svelte Features Board</h3>
      <button
        onclick={resetBoard}
        class="px-3 py-1 bg-slate/20 text-silver rounded border border-slate/30 hover:bg-slate/30 transition-colors text-xs"
      >
        Reset
      </button>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
      {#each dropZones as zone (zone.id)}
        <div
          role="region"
          aria-label="Drop zone for {zone.title}"
          class="bg-obsidian/60 rounded-lg p-4 border-2 border-dashed min-h-[200px] transition-all duration-200 {
            hoveredZone === zone.id
              ? 'border-arizona-teal/60 bg-arizona-teal/5 scale-105 shadow-lg shadow-arizona-teal/20'
              : 'border-arizona-teal/20 hover:border-arizona-teal/40'
          }"
          ondragover={handleDragOver}
          ondragenter={(e) => handleDragEnter(e, zone)}
          ondragleave={(e) => handleDragLeave(e, zone)}
          ondrop={(e) => handleDrop(e, zone)}
        >
          <h4 class="font-semibold text-arizona-teal mb-3 text-center">{zone.title}</h4>

          <div class="space-y-2">
            {#each getPreviewItems(zone) as item, index (item.id)}
              <div
                role="button"
                tabindex="0"
                aria-label="Draggable item: {item.text}"
                draggable="true"
                ondragstart={(e) => handleDragStart(e, item)}
                ondragend={handleDragEnd}
                ondragover={(e) => handleItemDragOver(e, zone, index)}
                ondrop={(e) => handleDrop(e, zone, index)}
                class="bg-{item.color}/20 border border-{item.color}/30 rounded-lg p-3 cursor-move transition-all duration-200 hover:bg-{item.color}/30 hover:scale-105 hover:shadow-lg {
                  hoveredZone === zone.id && draggedItem && item.id === draggedItem.id
                    ? 'opacity-60 scale-95 border-dashed animate-pulse'
                    : ''
                }"
                style="transform-origin: center;"
              >
                <div class="flex items-center gap-2">
                  <span class="text-lg">{item.emoji}</span>
                  <span class="text-sm text-{item.color} font-medium">{item.text}</span>
                </div>
              </div>
            {/each}
          </div>

          {#if getPreviewItems(zone).length === 0}
            <div class="text-center text-slate/50 text-sm mt-8 italic">
              Drop items here
            </div>
          {:else if zone.items.length === 0 && hoveredZone === zone.id}
            <div class="text-center text-arizona-teal/60 text-sm mt-4 italic animate-pulse">
              Release to add here
            </div>
          {/if}
        </div>
      {/each}
    </div>
  </div>

  <!-- Instructions -->
  <div class="bg-arizona-teal/5 rounded-lg p-4 border border-arizona-teal/20">
    <h3 class="text-sm font-semibold text-arizona-teal mb-2">How it works</h3>
    <div class="text-xs text-silver/80 space-y-1">
      <div>• Drag cards between columns to organize Svelte features</div>
      <div>• Hover effects and smooth animations powered by Svelte reactivity</div>
      <div>• State management with Svelte 5's $state rune</div>
      <div>• No external libraries needed - pure browser APIs</div>
    </div>
  </div>
</main>
