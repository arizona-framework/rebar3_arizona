import { Arizona, ArizonaConsoleLogger, LOG_LEVELS } from '@arizona-framework/client';
import ArizonaSvelte from '@arizona-framework/svelte';
import * as components from '../svelte/components';

// Initialize Arizona framework
const logger = new ArizonaConsoleLogger({ logLevel: LOG_LEVELS.debug });
globalThis.arizona = new Arizona({ logger });
arizona.connect('/live');

// Initialize ArizonaSvelte with automatic monitoring
const arizonaSvelte = new ArizonaSvelte({ components });

// Start automatic monitoring - components will mount/unmount automatically
arizonaSvelte.startMonitoring({
  autoMount: true,        // Automatically mount new components
  autoUnmount: true,      // Automatically unmount removed components
  observeSubtree: true,   // Monitor the entire DOM tree
  debounceMs: 0           // Debounce DOM changes for 0ms
});

// Make available globally for debugging
globalThis.arizonaSvelte = arizonaSvelte;

// Add some helpful logging
console.log('[Arizona Svelte] 🚀 Automatic component monitoring started');
console.log('[Arizona Svelte] 🧪 LifecycleDemo component available in UI');
console.log('[Arizona Svelte] 🔍 Global access: window.arizonaSvelte');
