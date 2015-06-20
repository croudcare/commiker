(function(commikerApp) {

  commikerApp.factory('SprintModel', ['UserModel', SprintModel]);

  function SprintModel(UserModel) {

    return {
      new: function(object) {

        object.users = _.map(object.users, function(user) {
          user.completedStories = userCompletedStories;
          user.totalStories = userTotalStories;
          user.completionPerc = userCompletionPerc;

          return user;
        });

        object.completionPercentage = function(){
          var total = this.users.length * 100;

          if(total == 0)
            return 0;

          var completionSumAry = _.map(this.users, function(user){
            return user.completionPerc();
          });

          completionSum = _.sum(completionSumAry);

          return Math.round(completionSum * 100 / total)
        }

        return object;
      }
    }
  }

  /****************** PROTECTED ******************/

  function userCompletedStories() {
    var stories = this.stories.filter(function(story) {
      if(story.completion_percentage == 100)
        return story;
    });

    return stories.length;
  }

  function userTotalStories() {
    return this.stories.length;
  }

  function userCompletionPerc() {
    var total = this.totalStories() * 100;

    if(total == 0)
      return 0;

    var completionSumAry = _.map(this.stories, function(story){
      return story.completion_percentage;
    });

    completionSum = _.sum(completionSumAry);

    return Math.round(completionSum * 100 / total);
  }

})(angular.module('commikerApp'));
