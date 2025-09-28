/**
 * Arizona Svelte Integration
 * Main class for Svelte component management
 */

import { ArizonaSvelteRegistry } from './arizona-svelte-registry.js';
import { ArizonaSvelteDiscovery } from './arizona-svelte-discovery.js';
import { ArizonaSvelteLifecycle } from './arizona-svelte-lifecycle.js';

class ArizonaSvelte {
  constructor(options = {}) {
    this.registry = new ArizonaSvelteRegistry();
    this.discovery = new ArizonaSvelteDiscovery({
      registry: this.registry,
      componentsDir: options.componentsDir || '../svelte/components',
      pattern: options.pattern || '*.svelte'
    });
    this.lifecycle = new ArizonaSvelteLifecycle(this.registry);
  }

  /**
   * Initialize component discovery and registration
   * @returns {Promise<number>} Number of components registered
   */
  async init() {
    return await this.discovery.discoverAndRegister();
  }

  /**
   * Get a component by name
   * @param {string} name - Component name
   * @returns {Function|null} Svelte component class or null if not found
   */
  getComponent(name) {
    return this.registry.getComponent(name);
  }

  /**
   * Check if a component is registered
   * @param {string} name - Component name
   * @returns {boolean}
   */
  hasComponent(name) {
    return this.registry.hasComponent(name);
  }

  /**
   * Get all registered component names
   * @returns {string[]}
   */
  getComponentNames() {
    return this.registry.getComponentNames();
  }

  /**
   * Get the registry instance
   * @returns {ArizonaSvelteRegistry}
   */
  getRegistry() {
    return this.registry;
  }

  /**
   * Get the discovery instance
   * @returns {ArizonaSvelteDiscovery}
   */
  getDiscovery() {
    return this.discovery;
  }

  /**
   * Get the lifecycle instance
   * @returns {ArizonaSvelteLifecycle}
   */
  getLifecycle() {
    return this.lifecycle;
  }

  /**
   * Mount Svelte components from DOM
   * @returns {Promise<number>} Number of components mounted
   */
  async mountComponents() {
    await this.init(); // Ensure components are discovered
    return await this.lifecycle.mountComponents();
  }
}

export default ArizonaSvelte;
export { ArizonaSvelte };
