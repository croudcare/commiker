/**
 * A generic confirmation for risky actions.
 * Usage: Add attributes: ng-really-message="Are you sure"? ng-really-click="takeAction()" function
 */
(function(commikerApp) {

  commikerApp.directive('ngReallyClick', [
    NgReally
  ]);

  /****************** PROTECTED ******************/

  function NgReally() {
    return {
      restrict: 'A',
      link: function(scope, element, attrs) {
        element.bind('click', function() {
          var message = attrs.ngReallyMessage;
          if (message && confirm(message)) {
            scope.$apply(attrs.ngReallyClick);
          }
        });
      }
    }
  }

})(angular.module('commikerApp'));
