(function(commikerApp) {

  commikerApp.factory('SprintModel', ['UserModel', SprintModel]);

  function SprintModel(UserModel) {

    return {
      new: function(object) {
        // object.shortName = shortName;

        object.users = _.map(object.users, function(user) {
          user.completedStories = 0;
          user.totalStories = user.stories.length;

          user.completionPerc = (user.completedStories*100/user.totalStories);

          return user;
        });

        return object;
      }
    }

  }


  /****************** PROTECTED ******************/

  // function shortName() {
  //   return this.first_name +' '+ this.last_name;
  // }

})(angular.module('commikerApp'));
