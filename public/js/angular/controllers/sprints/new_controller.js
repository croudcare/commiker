(function(commikerApp) {

  commikerApp.controller('SprintsNewController', [
    '$state',
    'SprintSmooth',
    '$location',
    'MeLoginUsecase',
    SprintsNewController
  ]);

  /****************** PROTECTED ******************/

  function SprintsNewController($state, SprintSmooth, $location, MeLoginUsecase) {
    var self = this;

    self.sprintAttributes = {
      started_at: moment(),
      ended_at: moment().add(7, 'days'),
      obs: ''
    };

    /****************** PRIVATE ******************/

    self.createSprint = function() {
      SprintSmooth.create('', self.sprintAttributes)
        .success(onSuccess)
        .error(onError)

      function onSuccess(sprint) {
        $state.go('home')
      }

      function onError(response) {
        debugger
      }
    }
  }

})(angular.module('commikerApp'));
