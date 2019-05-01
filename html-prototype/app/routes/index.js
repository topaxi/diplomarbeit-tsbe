import Route from '@ember/routing/route'

export default class IndexRoute extends Route {
  model() {
    let gigs = [
      {
        title: 'Darkside',
        where: 'Dachstock',
        city: 'Bern, Switzerland',
        date: '24.12.2019',
        image: 'pictures/gigs/darkside.jpg'
      },
      {
        title: 'Liquid Session',
        where: 'Dachstock',
        city: 'Bern, Switzerland',
        date: '24.12.2019',
        image: 'pictures/gigs/liquid-session.png'
      },
      {
        title: 'Anti-Flag',
        where: 'Dachstock',
        city: 'Bern, Switzerland',
        date: '24.12.2019',
        image: 'pictures/gigs/anti-flag.jpg'
      }
    ]

    return shuffle(Array.from({ length: 5 }, () => gigs).flat())
  }
}

function shuffle(array) {
  for (let i = 0; i < array.length; i++) {
    swap(array, i, Math.floor(Math.random() * array.length))
  }
  return array
}

function swap(array, i, j) {
  ;[array[i], array[j]] = [array[j], array[i]]
}
