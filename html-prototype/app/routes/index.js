import Route from '@ember/routing/route'

export default class IndexRoute extends Route {
  model() {
    return [
      {
        title: 'Darkside',
        where: 'Dachstock',
        date: '24.12.2019',
        image: 'pictures/gigs/darkside.jpg'
      },
      {
        title: 'Liquid Session',
        where: 'Dachstock',
        date: '24.12.2019',
        image: 'pictures/gigs/liquid-session.png'
      },
      {
        title: 'Anti-Flag',
        where: 'Dachstock',
        date: '24.12.2019',
        image: 'pictures/gigs/anti-flag.jpg'
      }
    ]
  }
}
