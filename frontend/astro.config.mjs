import { defineConfig } from 'astro/config';

export default defineConfig({
  site: 'http://localhost',
  server: {
    host: true,
    port: 4321
  },
  build: {
    assets: 'assets'
  },
  compressHTML: true,
  markdown: {
    shikiConfig: {
      // Theme adapté au dark mode avec bon contraste
      theme: 'one-dark-pro',
      // Wrap pour éviter l'overflow horizontal excessif
      wrap: true,
      // Langages supportés (auto-détecté généralement)
      langs: []
    }
  }
});
