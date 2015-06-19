(function(commikerApp) {

  commikerApp.factory('UserSmooth', [
    'SmoothOperator',
    'UserModel',
    UserSmooth
  ]);

  /****************** PROTECTED ******************/

  function UserSmooth(SmoothOperator, UserModel) {
    var user = SmoothOperator.new({
      url: $.api_client.endpoint,
      modelFactory: UserModel,
      resourceName: 'user',
      resourcesName: 'users',
    });

    return user;
  }

})(angular.module('commikerApp'));
