/*
*
* Directive to render service down on element.
* in loading="" attribute just give a boolean, true for loading, false to no loading.
* If the attribute has 'service_down', the directive will render: '/templates/service_down/message.html'
*
* If you want to give a custom service down template, just add:
* - service-down-template="" attribute with the path for your template.
*
* And if you want to send a ´more´ scope for the custom template, just use:
* - service-down-scope="" attribute with the object. This object will be merged with scope
*
*/
(function(commikerApp) {

  commikerApp.directive('loading', [
    '$http',
    '$compile',
    '$templateCache',
    Loading
  ]);

  /****************** PROTECTED ******************/

  function Loading($http, $compile, $templateCache) {
    var self = this;

    self.baseTemplateUrl = '/templates/service_down/message.html';

    return {
      link: link,
      scope: {
        loading: '=',
        serviceDownScope: '=',
        serviceDownTemplate: '='
      },
      restrict: 'A'
    };

    function link(scope, element, attrs) {
      $http.get(self.baseTemplateUrl, { cache: $templateCache });

      // merge scope if service down scope is given
      if(scope.serviceDownScope instanceof Object)
        scope = _.merge(scope, scope.serviceDownScope);

      // that ´true´ flag with check the change of the entire object.
      // without that, $watch would only be trigger
      // if the object reference was changed
      scope.$watch('loading', checkCurrentState, true);

      function checkCurrentState(obj) {
        // loading = true, stop loading = false, service down = 'service down'
        if(obj != undefined) {
          if(isBooleanValue(obj))
            setLoading(element, bool(obj));
          else {
            if(obj == 'service_down')
              renderServiceDownTemplate(element);
            else
              console.log('!!!! loading directive: unkown state "'+ obj +'"');
          }
        }
      }

      function renderServiceDownTemplate(container) {
        var _html = '';

        if(scope.serviceDownTemplate)
          _html = $templateCache.get(scope.serviceDownTemplate);
        else
          _html = $templateCache.get(self.baseTemplateUrl);

        // remove loading if has it
        setLoading(container, false);

        // render the actual service down template
        container.html(_html[1]);
        $compile(container.contents())(scope);
      }

      function setLoading(container, tru) {
        var idClass = '';

        if(tru) {
          // if true, add custom tmp_loading_timestamp class to use it later
          idClass += 'tmp_loading_' + (+new Date());
          // default loading height is 100px
          jQuery(container)
            .addClass(idClass)
            .height(100);
        } else {
          jQuery(container).css('height', 'auto');

          var classes = jQuery(container).attr('class').split(' ');

          // check for tmp_loading_timestamp class, need to have it if usign
          // this directive
          angular.forEach(classes, function(klass){
            if(_.contains(klass, 'tmp_loading_')){
              idClass += klass;
            }
          });
        }

        // add . to idClass
        var jQueryClassSelector = '.' + idClass;

        if(idClass.length > 0) {
          if(tru)
            setStartLoading(jQueryClassSelector);
          else
            setStopLoading(jQueryClassSelector);
        }
      }

      function setStartLoading(container) {
        $.railsAjaxHandler.spinnerAnimationStart(container);
      }

      function setStopLoading(container) {
        $.railsAjaxHandler.spinnerAnimationStop(container);
        jQuery(container).removeClass(container.split('.')[1]);
      }

      function isBooleanValue(value) {
        return (value != undefined && _.contains(['true', 'false'], value.toString()));
      }

      function bool(value) {
        return (value != undefined && value.toString() == 'true');
      }
    }
  }

})(angular.module('commikerApp'));
