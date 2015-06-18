(function(commikerApp) {

  commikerApp.controller('HomeController', [
    '$state',
    'SprintSmooth',
    'MeLoginUsecase',
    HomeController
  ]);

  /****************** PROTECTED ******************/

  function HomeController($state, SprintSmooth, MeLoginUsecase) {
    var self = this;

    self.sprint = null;

    findCurrentSprint(8);

    function findCurrentSprint(id) {
      SprintSmooth.find(id)
        .success(onSuccess)
        .error(onError)

      function onSuccess(sprint) {
        self.sprint = sprint;
      }

      function onError(response) {
        debugger
      }
    }
  }

})(angular.module('commikerApp'));
