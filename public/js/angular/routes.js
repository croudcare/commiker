(function(commikerApp) {

  commikerApp.config([
    '$httpProvider',
    '$stateProvider',
    '$locationProvider',
    '$urlRouterProvider',
    commikerRoutes
  ]);

  /****************** PROTECTED ******************/

  function commikerRoutes($httpProvider, $stateProvider, $locationProvider, $urlRouterProvider) {

    $stateProvider
      .state('home', {
        url: '/',
        templateUrl: '/templates/home.html',
        controller: 'HomeController',
        controllerAs: 'homeCtrl'
      })
      .state('me', {
        url: '/me',
        templateUrl: '/templates/me/index.html',
        controller: 'MeIndexController',
        controllerAs: 'meIndexCtrl'
      })
      .state('stories-new', {
        url: '/stories/new',
        templateUrl: '/templates/stories/new.html',
        controller: 'StoriesNewController',
        controllerAs: 'storiesNewCtrl',
        resolve: { authenticate: authenticate }
      })
      .state('sprints-new', {
        url: '/sprints/new',
        templateUrl: '/templates/sprints/new.html',
        controller: 'SprintsNewController',
        controllerAs: 'sprintsNewCtrl',
        resolve: { authenticate: authenticate }
      })
      .state('sprints-show', {
        url: '/sprints/:id',
        templateUrl: '/templates/sprints/show.html',
        controller: 'SprintsShowController',
        controllerAs: 'sprintsShowCtrl'
      })
      .state('stories-show', {
        url: '/stories/:name',
        templateUrl: '/templates/stories/show.html',
        controller: 'StoriesShowController',
        controllerAs: 'storiesShowCtrl'
      })
      .state('not_found', {
        url: '/404',
        templateUrl: '/templates/404.html'
      });

    $urlRouterProvider.when('/stories', '/');
    $urlRouterProvider.otherwise('/404');
    $locationProvider.html5Mode(true);
    $httpProvider.interceptors.push('AuthInjector');

    function authenticate($q, $http, $timeout, $window, $location, MeLoginUsecase) {
      if($.api_client.authenticated)
        return $q.when();
      else {
        $timeout(function() {
          MeLoginUsecase.perform({ from: '/stories/new' });
        });

        return $q.reject()
      }
    }

  }

})(angular.module('commikerApp'));
