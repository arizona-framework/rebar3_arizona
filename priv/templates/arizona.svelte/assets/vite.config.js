import { defineConfig } from 'vite';
import { svelte } from '@sveltejs/vite-plugin-svelte';
import legacy from '@vitejs/plugin-legacy';

export default defineConfig(({ mode }) => {
  const isDev = mode === 'development';

  const plugins = [
    svelte({
      compilerOptions: {
        dev: isDev
      }
    })
  ];

  // Only add legacy support for production builds
  if (!isDev) {
    plugins.push(legacy({
      targets: ['defaults', 'not IE 11']
    }));
  }

  return {
    plugins,
    build: {
      outDir: 'priv/static/assets',
      minify: !isDev,
      sourcemap: isDev,
      reportCompressedSize: !isDev, // Skip gzip reporting in dev for faster builds
      emptyOutDir: false, // Don't clean the output directory to preserve app.css
      rollupOptions: {
        input: 'assets/js/main.js',
        output: {
          entryFileNames: 'app.js',
          chunkFileNames: 'chunks/[name]-[hash].js',
          assetFileNames: 'assets/[name]-[hash][extname]'
        }
      }
    },
  };
});
