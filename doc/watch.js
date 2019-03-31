const { watch } = require('chokidar')
const { execSync } = require('child_process')
const Rx = require('rxjs')
const rx = require('rxjs/operators')

Rx.fromEvent(watch('.', { ignored: /[\/\\]\./ }), 'all', (event, path) => path)
  .pipe(rx.filter(shouldUpdate))
  .pipe(rx.debounceTime(1000))
  .subscribe(generatePDF)

function generatePDF(path) {
  try {
    console.log('%o rebuilding pdf...', new Date())
    execSync('pdflatex main.tex -o main.pdf')
  } catch (error) {
    console.error(error)
  }
}

function shouldUpdate(path) {
  return /\.(?:tex|pdf|svg)/.test(path) && !/main.pdf$/.test(path)
}
