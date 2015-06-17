(function(commikerApp) {

  commikerApp.factory('StoryModel', function() {
    return {
      new: function(object) {
        // object.shortName = shortName;

        return object;
      }
    }
  });

  /****************** PROTECTED ******************/

  // function shortName() {
  //   return this.first_name +' '+ this.last_name;
  // }

})(angular.module('commikerApp'));
