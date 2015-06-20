(function(commikerApp) {

  commikerApp.run([
    '$rootScope',
    '$window',
    run
  ]);

  /****************** PROTECTED ******************/

  function run($rootScope, $window) {
    $rootScope._ = $window._;
    $rootScope.moment = $window.moment;
    $rootScope.apiClient = $.api_client;
  }

})(angular.module('commikerApp'));
