(function(commikerApp) {

  commikerApp.controller('UsersShowController', [
    '$modalInstance',
    'user',
    UsersShowController
  ]);

  /****************** PROTECTED ******************/

  function UsersShowController($modalInstance, user) {
    var self = this;

    self.user = user;

    self.cancel = function () {
      $modalInstance.dismiss('cancel');
    };
  }

})(angular.module('commikerApp'));
