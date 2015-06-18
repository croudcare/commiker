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

    self.sprint = { id: 1};

    // findCurrentSprint(1);

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
