const fs = require('fs')
const { watch } = require('chokidar')
const { execSync } = require('child_process')
const Rx = require('rxjs')
const rx = require('rxjs/operators')
const glob = require('glob')

Rx.fromEvent(watch('.', { ignored: /[\/\\]\./ }), 'all', (event, path) => path)
  .pipe(rx.filter(shouldUpdate))
  .pipe(rx.debounceTime(1000))
  .subscribe(generatePDF)

function generatePDF(path) {
  try {
    let time = new Date()
    console.log('%o rebuilding pdf...', time)
    execSync('pdflatex main.tex -o main.pdf')
    let done = new Date()
    console.log('%o rebuilt pdf (%sms)', done, done - time)
  } catch (error) {
    console.error(String(error.stdout))
    console.error(String(error.stderr))
  }
}

function shouldUpdate(path) {
  return /\.(?:tex|pdf|svg)/.test(path) && !/main.pdf$/.test(path)
}

// For some reasons, pdflatex sometimes gets stuck if these are lying around
function cleanupAuxFiles() {
  for (let file of glob.sync('**/*.aux')) {
    fs.unlinkSync(file)
  }
}
