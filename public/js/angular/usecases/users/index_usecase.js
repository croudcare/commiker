(function(commikerApp) {

  commikerApp.factory('UsersIndexUseCase', [
    'UserSmooth',
    UsersIndexUseCase
  ]);

  /****************** PROTECTED ******************/

  function UsersIndexUseCase(UserSmooth) {

    var self = this;

    return { perform: perform };

    /****************** PRIVATE ******************/

    function perform(context, cb) {

      UserSmooth.find('')
        .success(onSuccess)
        .error(onError);

      function onSuccess(response) {
        cb(null, { users: response });
      }

      function onError(response) {
        cb(response, {});
      }

      /****************** PROTECTED ******************/

    }
  }

})(angular.module('commikerApp'));
