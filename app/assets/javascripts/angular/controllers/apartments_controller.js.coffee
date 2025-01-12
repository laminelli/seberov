#
# GET apartments/id
#
angular.module('seberov').controller 'ApartmentController', ($scope, $http, multiSliderService) ->

  calculator = {}
  calculator.currencies = ['czk', 'usd', 'eur']
  calculator.priceSigns = {
    eur: '€'
    czk: 'Kč'
    usd: '$'
  }
  calculator.currency = 'czk'
  calculator.exchangeUrl = "http://api.fixer.io/latest?base=CZK"

  # Caching feature limits requests
  cached = {}
  cached['usdRates'] = null
  cached['eurRates'] = null

  calculator.decorate = (price) ->
    priceFormated = numeral(price).format('0,0').replace(/,/g, ' ')
    "#{priceFormated} #{calculator.priceSigns[calculator.currency]}"

  calculator.setCurrency = (currency) ->
    calculator.currency = currency
    calculator.getRates()

  calculator.getRates = ->
    unless cached["#{calculator.currency}Rates"] != null
      $http.get(calculator.exchangeUrl).success (data) ->
        rates = data.rates[calculator.currency.toUpperCase()]
        # Caching
        cached["#{calculator.currency}Rates"] = rates

  calculator.calculate = (basePrice) ->
    if calculator.currency == 'czk'
      calculator.decorate(basePrice)
    else
      price = Math.round(basePrice * cached["#{calculator.currency}Rates"])
      calculator.decorate(price)

  $scope.calculator = calculator
  $scope.slider = multiSliderService

  return $scope

# Mortgage calculator
angular.module('seberov').controller 'ApartmentMortgageCalculatorController', ($scope) ->

  $scope.calculate = ->
    x     = $scope.interestRate / 12 / 100
    value = ($scope.extentOfMortgage * (x / (1 - Math.pow((1/(1 + x)),($scope.repaymentLength * 12))))).toFixed(0)

    $scope.decorate(value)

  $scope.decorate = (value) ->
    number = numeral(value).format('0,0').replace(/,/g, ' ')
    "#{number} Kč"

  return $scope

#
# GET apartments/by-parameters
#
angular.module('seberov').controller 'ApartmentsByParametersController', ($scope, $timeout) ->
  a = @

  a.path = (apartment) ->
    "/#{$scope.locale}" + Routes.refinery_apartments_apartment_path(apartment.id)

  $scope.priceFilter = (apartment) ->
    return (parseInt(apartment.price) >= parseInt(a.minPrice) && parseInt(apartment.price) <= parseInt(a.maxPrice))

  $scope.floorSpaceFilter = (apartment) ->
    return (parseInt(apartment.apartment_area) >= parseInt(a.minFloorSpace) && parseInt(apartment.apartment_area) <= parseInt(a.maxFloorSpace))

  $scope.floorFilter = (apartment) ->
    return (parseInt(apartment.floor) >= parseInt(a.minFloor) && parseInt(apartment.floor) <= parseInt(a.maxFloor))

  $scope.groundsFliter = (apartment) ->
    if a.cbGrounds
      return (parseInt(apartment.floor) == 1)
    else
      true

  # Funny filter
  $scope.roomsFilter = (apartment) ->
    if a.cbOneRoom || a.cbTwoRooms || a.cbThreeRooms || a.cbFourRooms || a.cbPenthouse
      return ((if a.cbTwoRooms   then parseInt(apartment.rooms) == 2) ||
              (if a.cbThreeRooms then parseInt(apartment.rooms) == 3) ||
              (if a.cbFourRooms  then parseInt(apartment.rooms) == 4) ||
              (if a.cbPenthouse  then parseInt(apartment.rooms) == 5))
    else true

  return $scope


#
# GET apartments/index
# Apartments map
#
angular.module('seberov').controller 'ApartmentsMapController', ($scope, $http, $document, $sce, $timeout) ->
  map = @
  map.buildings = ['a', 'b', 'c', 'd']
  map.building = 'a'
  map.floor = 1
  map.apartments = []
  map.currentApartment = null
  map.tooltip = false

  options = {
    waitAfterMouseEnter: 2000 # milliseconds
  }

  tmp = {
    clickedAt: null
  }

  $http.get('/apartments.json').success (data) ->
    map.apartments = data

  map.setBuilding = (object, event = 'hover') ->
    if tmp.clickedAt != null && (Date.now() - tmp.clickedAt) < options.waitAfterMouseEnter
      return false
    else if event == 'click'
      tmp.clickedAt = Date.now()

      map.floor = object.floor
      map.building = object.building
    else
      map.floor = object.floor
      map.building = object.building

  map.setCurrentApartment = (apartment) ->
    map.currentApartment = apartment if apartment.state == 'active'

  map.rerender = ->
    map.renderClass = "building-#{map.building}-floor-#{map.floor}"

  map.renderClass = ->
    return map.renderClass

  map.showTooltip = ->
    $timeout ->
      if map.tooltip == false
        $scope.tooltipHtml = $sce.trustAsHtml(angular.element('#base-tooltip').html())
        map.tooltip = true
    , 50

  map.hideTooltip = ->
    $scope.tooltipHtml = ""
    map.tooltip = false

  # Make href only for available apartments
  map.apartmentHref = (apartment) ->
    if apartment.state == 'active'
      "/#{$scope.locale}" + Routes.refinery_apartments_apartment_path(apartment.id)
    else '#'

  return $scope


