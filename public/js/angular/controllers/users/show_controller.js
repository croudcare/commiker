(function(commikerApp) {

  commikerApp.controller('UsersShowController', [
    'UsersShowUseCase',
    UsersShowController
  ]);

  /****************** PROTECTED ******************/

  function UsersShowController(UsersShowUseCase) {
    var self = this;
  }

})(angular.module('commikerApp'));
