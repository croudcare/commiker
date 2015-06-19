(function(commikerApp) {

  commikerApp.factory('SprintModel', ['UserModel', SprintModel]);

  function SprintModel(UserModel) {

    return {
      new: function(object) {
        var completedStories = [];

        object.users = _.map(object.users, function(user) {
          completedStories = user.stories.filter(function(story) {
            if(story.completion_percentage == 100)
              return story;
          })

          user.completedStories = completedStories.length;
          user.totalStories = user.stories.length;

          if(user.totalStories > 0)
            user.completionPerc = Math.round(user.completedStories*100/user.totalStories);
          else
            user.completionPerc = 0;

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
