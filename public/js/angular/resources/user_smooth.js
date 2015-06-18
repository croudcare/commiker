(function(commikerApp) {

  commikerApp.factory('UserSmooth', [
    'SmoothOperator',
    'UserModel',
    UserSmooth
  ]);

  /****************** PROTECTED ******************/

  function UserSmooth(SmoothOperator, UserModel) {
    var user = SmoothOperator.new({
      url: 'http://localhost:5000/api/v0/',
      modelFactory: UserModel,
      resourceName: 'user',
      resourcesName: 'users',
    });

    return user;
  }

})(angular.module('commikerApp'));
