angular.module('supla-scripts')

.config (RestangularProvider) ->
  RestangularProvider.setBaseUrl('/api')

.config ($urlRouterProvider, $locationProvider, $urlMatcherFactoryProvider) ->
  $urlRouterProvider.otherwise ($injector, $location) ->
    $state = $injector.get('$state')
    $state.go('notFound')
    $location.path()
  $urlRouterProvider.when('', '/')
  $locationProvider.html5Mode(true)
  $urlMatcherFactoryProvider.defaultSquashPolicy(true)

.config ($stateProvider) ->
  $stateProvider
  .state 'home',
    url: '/'
    template: '<home-view></home-view>'

  .state 'login',
    url: '/login'
    template: '<login-view></login-view>'

  .state 'notFound',
    templateUrl: 'app/common/errors/404.html'

  .state 'notAllowed',
    templateUrl: 'app/common/errors/403.html'

.run ($rootScope, $state) ->
  $rootScope.$on 'AUTH_CHANGED', (event, user) ->
    $state.reload() if not user

###
  Automatically set location:replace for options when changing state with reloadOnSearch:false. This fixes the error when the
  "back" button changes the URL in browser but router does not handle it (as we told it not to do it by reloadOnSearch param).
###
angular.module('supla-scripts').decorator '$state', ($delegate) ->
  transitionTo = $delegate.transitionTo
  $delegate.transitionTo = (to, toParams, options = {}) ->
    toName = $delegate.get(to)?.name
    if $delegate.get(to)?.reloadOnSearch is false and $delegate.current.name is toName
      angular.extend(options, location: 'replace')
    transitionTo(to, toParams, options)
  $delegate

angular.module('supla-scripts').run ($rootScope, Token, $state) ->
  $rootScope.$on '$stateChangeStart', (event, toState) ->
    if not Token.getRememberedToken() and toState.name not in ['login', 'register']
      event.preventDefault()
      $state.go('login')