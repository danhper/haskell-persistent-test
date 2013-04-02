'use strict';

/* Services */


// Demonstrate how to register services
// In this case it is a simple value service.
angular.module('myApp.services', []).
  value('version', '0.1');

angular.module('blog.services', ['ngResource']).
        factory('Article', function($resource) {
    return $resource('http://api.blog/articles/:articleId', {articleId: '@id'});
});
