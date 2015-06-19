(function(commikerApp) {

  commikerApp.factory('MeLoginUsecase', [
    '$modal',
    MeLoginUsecase
  ]);

  /****************** PROTECTED ******************/

  function MeLoginUsecase($modal) {

    var self = this;

    return { perform: perform };

    /****************** PRIVATE ******************/

    function perform(context, cb) {

      var modalInstance = $modal.open({
        templateUrl: '/templates/me/login/modal.html',
        controller: 'MeLoginModalController',
        controllerAs: 'meLoginModalCtrl',
        size: context.size,
        resolve: {
          back: function() {
            return context.from;
          }
        }
      });

      /****************** PROTECTED ******************/

    }
  }

})(angular.module('commikerApp'));
