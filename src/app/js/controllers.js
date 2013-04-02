'use strict';

/* Controllers */

function TopCtrl($scope, Article) {
    var article = Article.get({ articleId: 1 }, function() {
        console.log(article);
    });
}
TopCtrl.$inject = ['$scope', 'Article'];


function MyCtrl1() {}
MyCtrl1.$inject = [];


function MyCtrl2() {
}
MyCtrl2.$inject = [];
