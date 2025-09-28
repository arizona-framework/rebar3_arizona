/**
 * Arizona Svelte Lifecycle
 * Handles component mounting, unmounting, and lifecycle management
 */

import { mount, unmount } from 'svelte';

class ArizonaSvelteLifecycle {
  constructor(registry) {
    if (!registry) {
      throw new Error('ArizonaSvelteLifecycle requires a registry instance');
    }

    this.registry = registry;
    this.mountedComponents = new Map(); // target -> component instance
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
        } catch (error) {
          console.error(`[Arizona Svelte] Failed to mount component '${componentName}':`, error);
        }
      } else {
        console.warn(`[Arizona Svelte] Component '${componentName}' not found in registry`);
      }
    });

    console.log(`[Arizona Svelte] Mounted ${mountedCount} components`);
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
        unmount(instance);
        this.mountedComponents.delete(target);
        return true;
      } catch (error) {
        console.error(`[Arizona Svelte] Failed to unmount component:`, error);
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
}

export { ArizonaSvelteLifecycle };
