(function(commikerApp) {

  commikerApp.factory('UserModel', function() {
    return {
      new: function(object) {
        object.less = less;

        return object;
      }
    }
  });

  /****************** PROTECTED ******************/

  function less() {
    return {
      id: this.id,
      slack_handler: this.slack_handler
    };
  }

})(angular.module('commikerApp'));
