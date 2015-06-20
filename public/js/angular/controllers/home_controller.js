(function(commikerApp) {

  commikerApp.controller('HomeController', [
    '$timeout',
    '$location',
    HomeController
  ]);

  /****************** PROTECTED ******************/

  function HomeController($timeout, $location) {
    var self = this;

    $timeout(function(){
      $location.path('/sprints/active');
    });
  }

})(angular.module('commikerApp'));
