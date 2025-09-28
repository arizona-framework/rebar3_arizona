/**
 * Svelte Component Registry
 * Manages dynamic loading and mounting of Svelte components
 */

class ArizonaSvelteRegistry {
  constructor() {
    this.components = new Map();
  }

  /**
   * Register a component with the given name
   * @param {string} name - Component name
   * @param {Function} component - Svelte component class
   */
  registerComponent(name, component) {
    if (typeof name !== 'string' || !name.trim()) {
      throw new Error('Component name must be a non-empty string');
    }

    if (typeof component !== 'function') {
      throw new Error('Component must be a Svelte component class');
    }

    this.components.set(name, component);
  }

  /**
   * Get a component by name
   * @param {string} name - Component name
   * @returns {Function|null} Svelte component class or null if not found
   */
  getComponent(name) {
    return this.components.get(name) || null;
  }

  /**
   * Check if a component is registered
   * @param {string} name - Component name
   * @returns {boolean}
   */
  hasComponent(name) {
    return this.components.has(name);
  }

  /**
   * Get all registered component names
   * @returns {string[]}
   */
  getComponentNames() {
    return Array.from(this.components.keys());
  }

  /**
   * Unregister a component
   * @param {string} name - Component name
   * @returns {boolean} True if component was removed, false if it didn't exist
   */
  unregisterComponent(name) {
    return this.components.delete(name);
  }

  /**
   * Clear all registered components
   */
  clear() {
    this.components.clear();
  }
}

// Export the class only
export { ArizonaSvelteRegistry };