(function(commikerApp) {
  commikerApp.factory('SprintFactory', [
    '$rootScope',
    SprintFactory
  ]);

  function SprintFactory ($rootScope){
    var self = this;

    return self;
  }

})(angular.module('commikerApp'));
