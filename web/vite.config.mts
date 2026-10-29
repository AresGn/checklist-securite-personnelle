import { defineConfig, type UserConfig } from 'vite';
import { qwikVite } from '@builder.io/qwik/optimizer';
import { qwikCity } from '@builder.io/qwik-city/vite';
import tsconfigPaths from 'vite-tsconfig-paths';
import { viteStaticCopy } from 'vite-plugin-static-copy';

// Fichier de la checklist affiché par le site (voir aussi CHECKLIST_FILE dans src/data/checklist.ts).
const checklistFile = '../personal-security-checklist.fr.yml';

export default defineConfig((): UserConfig => {
  return {
    plugins: [
      qwikCity(),
      qwikVite(),
      tsconfigPaths(),
      viteStaticCopy({
        targets: [
          {
            src: checklistFile,
            dest: 'public',
          },
        ],
      }),
    ],
    optimizeDeps: {
      include: ['chart.js', 'js-yaml', 'marked', 'progressbar.js', 'tailwindcss/colors'],
    },
    server: {
      fs: {
        allow: ['.', checklistFile],
      },
      headers: {
        'Cache-Control': 'public, max-age=0',
      },
    },
    preview: {
      headers: {
        'Cache-Control': 'public, max-age=600',
      },
    },
  };
});
