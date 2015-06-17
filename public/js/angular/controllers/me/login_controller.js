(function(commikerApp) {

  commikerApp.controller('MeLoginController', [
    '$modalInstance',
    'back',
    MeLoginController
  ]);

  /****************** PROTECTED ******************/

  function MeLoginController($modalInstance, back) {
    var self = this;

    self.backUrl = [];
    self.backUrlStr = '';

    if(back != undefined)
      self.backUrl.push('origin=' + back);

    if(self.backUrl.length > 0)
       self.backUrlStr += '?' + self.backUrl.join('&');

    self.cancel = function () {
      $modalInstance.dismiss('cancel');
    };
  }

})(angular.module('commikerApp'));
