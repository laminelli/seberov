#= require_self
#= require angular/controllers/application_controller
#= require angular/controllers/home_controller
#= require angular/controllers/location_controller
#= require angular/controllers/apartments_controller

# Initialisation
app = angular.module('seberov', ['duScroll', 'uiGmapgoogle-maps'])

# Configuration
app.config (uiGmapGoogleMapApiProvider) ->
  uiGmapGoogleMapApiProvider.configure
    key: gon.global.gmaps_key,
    v: '3.17',
    libraries: 'weather, geometry, visualization'

# Initializing foundation
app.run ($rootScope) ->
  $rootScope.$on '$viewContentLoaded', ->
    $(document).foundation()

#
# Info block
#
app.controller 'InfoBlockController', ($scope, $document) ->
  $scope.shown = true

  $document.on 'scroll', ->
    $scope.shown = false
    return $scope.$apply()

  $scope.toggle = ->
    $scope.shown = if $scope.shown == true then false else true

  return $scope

#
# Image broadcaster
#
app.controller 'ImageBroadcasterController', ->
  @.imageNumber = 1
  @.imageUrl = ""

  @.setImage = (newValue, newImageUrl) ->
    @.imageNumber = newValue
    @.imageUrl = newImageUrl

  @.isSet = (imageNumber) ->
    @.imageNumber == imageNumber


  return @

#
# Stop Event directive
#
app.directive 'stopEvent', ->
  {
    restrict: 'A',
    link: (scope, element, attr) ->
      element.bind 'click', (e) ->
        e.stopPropagation()
  }

#
# Background image directive
#
app.directive 'backImg', ->
  (scope, element, attrs) ->
    attrs.$observe 'backImg', (value) ->
      element.css
        'background-image': 'url(' + value + ')'
        'background-size': 'cover'

#
# Resize directive
#
app.directive 'resize', ($window) ->
  (scope, element, attr) ->
    w = angular.element($window)
    scope.$watch (->
      {
        'h': window.innerHeight
        'w': window.innerWidth
      }
    ), ((newValue, oldValue) ->
      console.log newValue, oldValue
      scope.windowHeight = newValue.h
      scope.windowWidth = newValue.w

      scope.resizeWithOffset = (offsetH) ->
        scope.$eval attr.notifier
        { 'height': newValue.h - offsetH + 'px' }

      return
    ), true
    w.bind 'resize', ->
      scope.$apply()

# Filter for url trusting
# Example
# ng-src="{ object.url | trusted }"
app.filter 'trusted', ['$sce', ($sce) ->
    return (url) ->
      return $sce.trustAsResourceUrl(url)
]

# Filter helps render html untrusted content
app.filter 'unsafe', ($sce) ->
  $sce.trustAsHtml

app.filter 'rangeFilter', ->
  (items, rangeInfo) ->
    filtered = []
    min = parseInt(rangeInfo.min)
    max = parseInt(rangeInfo.max)
    # If time is with the range
    angular.forEach items, (item) ->
      if item.time >= min && item.time <= max then filtered.push(item)

    return filtered


app.directive 'preloadResource', ->
  {
    link: (scope, element, attrs) ->
      scope.preloadResource = JSON.parse(attrs.preloadResource)
      element.remove()
  }

# MiltiSlider Service
app.factory 'multiSliderService', ($timeout, $window, $interval) ->
  slider = {}
  slider.screenNum = 1
  slider.webcamUrl = 'http://151.249.106.49/images/logo.gif'
  slider.webcamSrc = slider.webcamUrl

  slider.setScreen = (number) ->
    slider.screenNum = number

  slider.isCurrentScreen = (number) ->
    @.screenNum == number

  slider.refreshOrbit = ->
    $timeout ->
      $(document).foundation('orbit', 'reflow')
    , 100

  slider.loadWebcam = ->
    $interval ->
      slider.webcamSrc = slider.webcamUrl + '?' + new Date().getTime()
    , 2000

  # Orbit styling
  slider.screenHeight = 200 # minimal height
  if Foundation.utils.is_medium_only()
    slider.screenHeight = 400 # minimal height
  if Foundation.utils.is_large_up()
    slider.screenHeight = 700 # minimal height

  $interval ->
    angular.element('.js-multi-slider.active').resize()
    if angular.element('.js-multi-slider.active').height() > 10
      slider.screenHeight = angular.element('.js-multi-slider.active').height()
  , 300

  return slider

