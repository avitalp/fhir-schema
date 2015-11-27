require('file?name=/index.html!jade-env-html!./index.jade')

require('ng-cache?!jade-env-html!./404.jade')
require('ng-cache?!jade-env-html!./_index.jade')
require('./app.less')
require('angular-ui-codemirror')

fhir = require('../../src/ajv.js')
schema = require('../../build/fhir.schema.json')

validator = fhir.load(schema)

app = angular.module('app', [
  'ngCookies'
  'ngRoute'
  'ngAnimate'
  'ui.codemirror'
])

app.run ($rootScope, $window) ->
  console.log('run')

app.config ($routeProvider) ->
  rp = $routeProvider
  rp.when '/',
    name: 'index'
    templateUrl: '_index.jade'
    controller: 'IndexCtrl'
    reloadOnSearch: false
  rp.otherwise templateUrl: '404.jade'



app.controller 'IndexCtrl', ($scope)->
  $scope.resource = '{"resourceType": "Patient", "name": {"given": ["John"]}}'
  $scope.update = ()->
    $scope.parseError = null
    try
      resource = JSON.parse($scope.resource)
      $scope.result = validator.validate(resource)
      console.log($scope.result)
    catch e
      $scope.result = null
      $scope.parseError = e.toString()

  $scope.update()

  codemirrorExtraKeys = window.CodeMirror.normalizeKeyMap
    "Ctrl-Space": () ->
      $scope.$apply('doMapping()')

    Tab: (cm) ->
      cm.replaceSelection("  ")

  $scope.codemirrorConfig =
    lineWrapping: false
    lineNumbers: true
    mode: 'javascript'
    extraKeys: codemirrorExtraKeys,
    viewportMargin: Infinity
