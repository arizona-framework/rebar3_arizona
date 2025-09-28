/**
 * Arizona Svelte Lifecycle
 * Handles component mounting, unmounting, and lifecycle management
 */

import { mount, unmount } from 'svelte';

class ArizonaSvelteLifecycle {
  constructor(registry, options = {}) {
    if (!registry) {
      throw new Error('ArizonaSvelteLifecycle requires a registry instance');
    }

    this.registry = registry;
    this.mountedComponents = new Map(); // target -> component instance
    this.observers = new Set(); // Set of active observers
    this.isMonitoring = false;
    this.options = {
      autoMount: options.autoMount !== false, // Default true
      autoUnmount: options.autoUnmount !== false, // Default true
      observeSubtree: options.observeSubtree !== false, // Default true
      debounceMs: options.debounceMs || 100, // Debounce DOM changes
      ...options
    };
    this.debounceTimer = null;
  }

  /**
   * Mount Svelte components from DOM data attributes
   * @returns {Promise<number>} Number of components mounted */
  async mountComponents() {
    const svelteTargets = document.querySelectorAll('[data-svelte-component]');
    let mountedCount = 0;

    svelteTargets.forEach(target => {
      // Skip if already mounted
      if (this.mountedComponents.has(target)) {
        return;
      }

      const componentName = target.dataset.svelteComponent;
      const props = target.dataset.svelteProps ? JSON.parse(target.dataset.svelteProps) : {};

      const ComponentClass = this.registry.getComponent(componentName);

      if (ComponentClass) {
        try {
          const instance = mount(ComponentClass, { target, props });
          this.mountedComponents.set(target, instance);
          mountedCount++;
          console.log(`[Arizona Svelte] ✅ Mounted '${componentName}' component`, {
            target: target.id || target.className || 'unnamed',
            props,
            totalMounted: this.mountedComponents.size
          });
        } catch (error) {
          console.error(`[Arizona Svelte] ❌ Failed to mount component '${componentName}':`, error);
        }
      } else {
        console.warn(`[Arizona Svelte] Component '${componentName}' not found in registry`);
      }
    });

    if (mountedCount > 0) {
      console.log(`[Arizona Svelte] Mounted ${mountedCount} components`);
    }
    return mountedCount;
  }

  /**
   * Unmount a specific component
   * @param {Element} target - DOM element containing the component
   * @returns {boolean} True if component was unmounted, false if not found
   */
  unmountComponent(target) {
    const instance = this.mountedComponents.get(target);

    if (instance) {
      try {
        const componentName = target.dataset.svelteComponent || 'unknown';
        unmount(instance);
        this.mountedComponents.delete(target);
        console.log(`[Arizona Svelte] 🗑️ Unmounted '${componentName}' component`, {
          target: target.id || target.className || 'unnamed',
          totalMounted: this.mountedComponents.size
        });
        return true;
      } catch (error) {
        console.error(`[Arizona Svelte] ❌ Failed to unmount component:`, error);
        return false;
      }
    }

    return false;
  }

  /**
   * Unmount all mounted components
   * @returns {number} Number of components unmounted
   */
  unmountAllComponents() {
    let unmountedCount = 0;

    this.mountedComponents.forEach((_instance, target) => {
      if (this.unmountComponent(target)) {
        unmountedCount++;
      }
    });

    console.log(`[Arizona Svelte] Unmounted ${unmountedCount} components`);
    return unmountedCount;
  }

  /**
   * Remount components (useful for updates)
   * @returns {Promise<number>} Number of components remounted
   */
  async remountComponents() {
    this.unmountAllComponents();
    return await this.mountComponents();
  }

  /**
   * Get mounted component instance by target
   * @param {Element} target - DOM element
   * @returns {Object|null} Component instance or null if not found
   */
  getMountedComponent(target) {
    return this.mountedComponents.get(target) || null;
  }

  /**
   * Get all mounted components
   * @returns {Map} Map of target elements to component instances
   */
  getAllMountedComponents() {
    return new Map(this.mountedComponents);
  }

  /**
   * Check if a target has a mounted component
   * @param {Element} target - DOM element
   * @returns {boolean}
   */
  isComponentMounted(target) {
    return this.mountedComponents.has(target);
  }

  /**
   * Start automatic monitoring for component lifecycle
   * @returns {void}
   */
  startMonitoring() {
    if (this.isMonitoring) {
      console.warn('[Arizona Svelte] Monitoring already started');
      return;
    }

    this.isMonitoring = true;
    console.log('[Arizona Svelte] Starting automatic component monitoring');

    // Initial mount
    if (this.options.autoMount) {
      this.mountComponents();
    }

    // Set up DOM mutation observer
    this.setupDOMObserver();

    // Set up Arizona WebSocket listener
    this.setupArizonaListener();

    // Set up page visibility listener
    this.setupVisibilityListener();

    // Set up cleanup on page unload
    this.setupUnloadListener();
  }

  /**
   * Stop automatic monitoring
   * @returns {void}
   */
  stopMonitoring() {
    if (!this.isMonitoring) {
      return;
    }

    this.isMonitoring = false;
    console.log('[Arizona Svelte] Stopping automatic component monitoring');

    // Clean up all observers
    this.observers.forEach(observer => {
      if (observer.disconnect) {
        observer.disconnect();
      } else if (typeof observer === 'function') {
        observer(); // Cleanup function
      }
    });
    this.observers.clear();

    // Clear debounce timer
    if (this.debounceTimer) {
      clearTimeout(this.debounceTimer);
      this.debounceTimer = null;
    }
  }

  /**
   * Setup DOM mutation observer to detect component additions/removals
   * @private
   */
  setupDOMObserver() {
    const observer = new MutationObserver((mutations) => {
      this.debouncedHandleMutations(mutations);
    });

    observer.observe(document.body, {
      childList: true,
      subtree: this.options.observeSubtree,
      attributes: true,
      attributeFilter: ['data-svelte-component', 'data-svelte-props']
    });

    this.observers.add(observer);
  }

  /**
   * Setup Arizona WebSocket event listener for patches
   * @private
   */
  setupArizonaListener() {
    const handleArizonaEvent = (event) => {
      const { type, data } = event.detail;

      if (type === 'html_patch') {
        // When Arizona applies HTML patches, we need to check for new components
        this.debouncedScanAndMount();
      }
    };

    document.addEventListener('arizonaEvent', handleArizonaEvent);

    // Return cleanup function
    const cleanup = () => {
      document.removeEventListener('arizonaEvent', handleArizonaEvent);
    };

    this.observers.add(cleanup);
  }

  /**
   * Setup page visibility listener to pause/resume components
   * @private
   */
  setupVisibilityListener() {
    const handleVisibilityChange = () => {
      if (document.hidden) {
        console.log('[Arizona Svelte] Page hidden - components may pause updates');
      } else {
        console.log('[Arizona Svelte] Page visible - checking for component updates');
        this.debouncedScanAndMount();
      }
    };

    document.addEventListener('visibilitychange', handleVisibilityChange);

    const cleanup = () => {
      document.removeEventListener('visibilitychange', handleVisibilityChange);
    };

    this.observers.add(cleanup);
  }

  /**
   * Setup page unload listener for cleanup
   * @private
   */
  setupUnloadListener() {
    const handleUnload = () => {
      console.log('[Arizona Svelte] Page unloading - cleaning up components');
      if (this.options.autoUnmount) {
        this.unmountAllComponents();
      }
      this.stopMonitoring();
    };

    window.addEventListener('beforeunload', handleUnload);
    window.addEventListener('unload', handleUnload);

    const cleanup = () => {
      window.removeEventListener('beforeunload', handleUnload);
      window.removeEventListener('unload', handleUnload);
    };

    this.observers.add(cleanup);
  }

  /**
   * Debounced mutation handler to avoid excessive re-scanning
   * @private
   */
  debouncedHandleMutations(mutations) {
    if (this.debounceTimer) {
      clearTimeout(this.debounceTimer);
    }

    this.debounceTimer = setTimeout(() => {
      this.handleMutations(mutations);
    }, this.options.debounceMs);
  }

  /**
   * Debounced scan and mount to avoid excessive operations
   * @private
   */
  debouncedScanAndMount() {
    if (this.debounceTimer) {
      clearTimeout(this.debounceTimer);
    }

    this.debounceTimer = setTimeout(() => {
      this.scanAndMount();
    }, this.options.debounceMs);
  }

  /**
   * Handle DOM mutations and update components accordingly
   * @private
   */
  handleMutations(mutations) {
    let shouldScan = false;
    const removedNodes = new Set();

    mutations.forEach(mutation => {
      // Handle removed nodes
      if (mutation.type === 'childList' && mutation.removedNodes.length > 0) {
        mutation.removedNodes.forEach(node => {
          if (node.nodeType === Node.ELEMENT_NODE) {
            removedNodes.add(node);
            // Check if removed node or its children had mounted components
            this.unmountRemovedComponents(node);
          }
        });
      }

      // Handle added nodes or attribute changes
      if (mutation.type === 'childList' && mutation.addedNodes.length > 0) {
        shouldScan = true;
      } else if (mutation.type === 'attributes' &&
        (mutation.attributeName === 'data-svelte-component' ||
          mutation.attributeName === 'data-svelte-props')) {
        shouldScan = true;
      }
    });

    if (shouldScan && this.options.autoMount) {
      this.scanAndMount();
    }
  }

  /**
   * Scan for new components and mount them
   * @private
   */
  async scanAndMount() {
    try {
      const mounted = await this.mountComponents();
      if (mounted > 0) {
        console.log(`[Arizona Svelte] 🔄 Auto-mounted ${mounted} new components`);
      }
    } catch (error) {
      console.error('[Arizona Svelte] Error during auto-mount:', error);
    }
  }

  /**
   * Unmount components that were removed from DOM
   * @private
   */
  unmountRemovedComponents(removedNode) {
    if (!this.options.autoUnmount) {
      return;
    }

    // Check if the removed node itself was a component target
    if (this.mountedComponents.has(removedNode)) {
      console.log('[Arizona Svelte] Auto-unmounting removed component');
      this.unmountComponent(removedNode);
    }

    // Check children of removed node
    if (removedNode.querySelectorAll) {
      const childTargets = removedNode.querySelectorAll('[data-svelte-component]');
      childTargets.forEach(target => {
        if (this.mountedComponents.has(target)) {
          console.log('[Arizona Svelte] Auto-unmounting removed child component');
          this.unmountComponent(target);
        }
      });
    }
  }

  /**
   * Get monitoring status
   * @returns {boolean}
   */
  isMonitoringActive() {
    return this.isMonitoring;
  }

  /**
   * Get current monitoring options
   * @returns {Object}
   */
  getMonitoringOptions() {
    return { ...this.options };
  }

  /**
   * Update monitoring options
   * @param {Object} newOptions - New options to merge
   */
  updateMonitoringOptions(newOptions) {
    this.options = { ...this.options, ...newOptions };
  }
}

export { ArizonaSvelteLifecycle };
