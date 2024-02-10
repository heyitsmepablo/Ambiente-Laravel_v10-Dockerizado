import { defineConfig } from 'vite';
import laravel from 'laravel-vite-plugin';

export default defineConfig({
    plugins: [
        laravel({
            input: ['resources/css/app.css', 'resources/js/app.js'],
            refresh: true,
        }),
    ],
    server: {
        host:true,
        // we need a strict port to match on PHP side
        strictPort: true,
        port: 5173,
        hmr: {

            // The host where the Vite dev server can be accessed
            // This will also force this host to be written to the public/hot file
            host: `localhost`
        }
    }
});
