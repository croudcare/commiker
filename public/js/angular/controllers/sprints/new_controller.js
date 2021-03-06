(function(commikerApp) {

  commikerApp.controller('SprintsNewController', [
    '$state',
    'SprintSmooth',
    '$location',
    'UsersIndexUseCase',
    SprintsNewController
  ]);

  /****************** PROTECTED ******************/

  function SprintsNewController($state, SprintSmooth, $location, UsersIndexUseCase) {
    var self = this;

    self.sprintAttributes = {
      started_at: moment(),
      ended_at: moment().add(7, 'days'),
      obs: '',
      users: [],
      start_bot: true
    };

    self.createSprint = createSprint;

    getUsers();

    /****************** PRIVATE ******************/

    function createSprint() {
      // complete params
      var users = _.map(self.users, function(user) {
        if(user.isChecked == true)
          return user.less();
      });

      self.sprintAttributes.users = _.select(users, function(user) {
        return user != null;
      });

      SprintSmooth.create('', self.sprintAttributes)
        .success(onSuccess)
        .error(onError);

      function onSuccess(sprint) {
        $state.go('home');
      }

      function onError(response) {
        debugger
      }
    }

    function getUsers() {
      UsersIndexUseCase.perform({}, onComplete);

      function onComplete(err, ctx) {
        self.users = _.map(ctx.users, function(user) {
          user.isChecked = true;
          return user;
        });
      }
    }

  }

})(angular.module('commikerApp'));
