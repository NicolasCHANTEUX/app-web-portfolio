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
  compressHTML: true
});
