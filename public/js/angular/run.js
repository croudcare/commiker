(function(commikerApp) {

  commikerApp.run([
    '$rootScope',
    '$window',
    'SprintFactory',
    run
  ]);

  /****************** PROTECTED ******************/

  function run($rootScope, $window, SprintFactory) {
    $rootScope._ = $window._;
    $rootScope.moment = $window.moment;
    $rootScope.SprintFactory = SprintFactory;
    $rootScope.apiClient = $.api_client;
  }

})(angular.module('commikerApp'));
