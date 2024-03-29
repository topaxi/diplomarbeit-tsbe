import EmberRouter from '@ember/routing/router'
import config from './config/environment'

const Router = EmberRouter.extend({
  location: config.locationType,
  rootURL: config.rootURL
})

Router.map(function() {
  this.route('login')
  this.route('register')
  this.route('add-gig')
  this.route('gig-detail');
  this.route('search');
})

export default Router
