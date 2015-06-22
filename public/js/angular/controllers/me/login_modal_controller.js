(function(commikerApp) {

  commikerApp.controller('MeLoginModalController', [
    '$modalInstance',
    MeLoginModalController
  ]);

  /****************** PROTECTED ******************/

  function MeLoginModalController($modalInstance) {
    var self = this;

    self.cancel = function () {
      $modalInstance.dismiss('cancel');
    };
  }

})(angular.module('commikerApp'));
