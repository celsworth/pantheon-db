const path = require('path')
const ElmPlugin = require('esbuild-plugin-elm')
const esbuild = require('esbuild')

// the absWorkingDirectory set below allows us to use paths relative to that location
const isWatching = process.argv.includes("--watch");
esbuild.build({
  entryPoints: ['./application.js'],
  bundle: true,
  outdir: path.join(process.cwd(), "app/assets/builds"),
  absWorkingDir: path.join(process.cwd(), "app/javascript"),
  //watch: process.argv.includes("--watch"),
  sourcemap: true,
  plugins: [
    ElmPlugin({ debug: isWatching })
  ],
}).catch(e => (console.error(e), process.exit(1)))
