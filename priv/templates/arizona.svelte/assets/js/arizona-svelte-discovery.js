/**
 * Svelte Components Auto-Discovery
 * Flexible component discovery and registration system
 */

class ArizonaSvelteDiscovery {
  constructor(options = {}) {
    this.componentsDir = options.componentsDir || '../svelte/components';
    this.pattern = options.pattern || '*.svelte';
    this.registry = options.registry || { registerComponent };
    this.componentModules = null;
  }

  /**
   * Discover components using import.meta.glob
   * @returns {Promise<Object>} Map of component paths to modules
   */
  async discoverComponents() {
    // Use static glob pattern for Vite compatibility
    this.componentModules = import.meta.glob('../svelte/components/*.svelte', { eager: true });

    return this.componentModules;
  }

  /**
   * Register all discovered components
   * @param {Object} componentModules - Optional modules object, uses discovered if not provided
   */
  registerComponents(componentModules = null) {
    const modules = componentModules || this.componentModules;

    if (!modules) {
      throw new Error('No components discovered. Run discoverComponents() first.');
    }

    Object.entries(modules).forEach(([path, module]) => {
      // Extract component name from file path
      const componentName = this.extractComponentName(path);

      // Register the component (module.default contains the Svelte component)
      this.registry.registerComponent(componentName, module.default);
    });

    console.log(`[Arizona Svelte] Auto-discovered and registered ${Object.keys(modules).length} components`);
    return Object.keys(modules).length;
  }

  /**
   * Extract component name from file path
   * @param {string} path - File path
   * @returns {string} Component name
   */
  extractComponentName(path) {
    return path.split('/').pop().replace('.svelte', '');
  }

  /**
   * Discover and register components in one call
   * @returns {Promise<number>} Number of components registered
   */
  async discoverAndRegister() {
    await this.discoverComponents();
    return this.registerComponents();
  }

  /**
   * Get discovered component modules
   * @returns {Object|null} Component modules or null if not discovered
   */
  getComponentModules() {
    return this.componentModules;
  }
}

// Export the class only
export { ArizonaSvelteDiscovery };
