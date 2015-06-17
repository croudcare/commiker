(function(commikerApp) {

  commikerApp.run([
    '$rootScope',
    '$window',
    'RefData',
    run
  ]);

  /****************** PROTECTED ******************/

  function run($rootScope, $window, RefData) {
    $rootScope._ = $window._;
    $rootScope.moment = $window.moment;
    $rootScope.refData = RefData;
  }

})(angular.module('commikerApp'));
