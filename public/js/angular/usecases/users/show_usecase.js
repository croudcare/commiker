(function(commikerApp) {

  commikerApp.factory('UsersShowUseCase', [
    '$modal',
    UsersShowUseCase
  ]);

  /****************** PROTECTED ******************/

  function UsersShowUseCase($modal) {

    var self = this;

    return { perform: perform };

    /****************** PRIVATE ******************/

    function perform(context, cb) {

      var modalInstance = $modal.open({
        templateUrl: '/templates/users/show.html',
        controller: 'UsersShowController',
        controllerAs: 'usersShowCtrl',
        size: context.size,
        resolve: {
          user: function() {
            return context.user;
          }
        }
      });

      /****************** PROTECTED ******************/

    }
  }

})(angular.module('commikerApp'));
