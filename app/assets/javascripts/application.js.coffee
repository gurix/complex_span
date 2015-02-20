#= require jquery
#= require jquery_ujs
#= require bigscreen
#= require angular/angular
#= require angular-route/angular-route
#= require angular-rails-templates
#= require angular-local-storage
#= require angular-cookies
#= require angular-translate
#= require angular-translate-storage-cookie
#= require angular-translate-storage-local
#= require_tree .

@logger = new window.Logger()
@logger.clear()
@logger.push('initializing')

window.debug = true unless location.hostname == "complexspan.herokuapp.com"
