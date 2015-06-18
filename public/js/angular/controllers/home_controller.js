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

    self.currentSprint = null;

    findCurrentSprint();

    function findCurrentSprint() {
      SprintSmooth.find('', { page: 1, per_page: 1 })
        .success(onSuccess)
        .error(onError)

      function onSuccess(sprints) {
        self.currentSprint = sprints[0];
      }

      function onError(response) {
        debugger
      }
    }
  }

})(angular.module('commikerApp'));
