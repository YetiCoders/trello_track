window.App.Users =
  init: ->
    window.App.Users.toggle_subscription()
    $("#user_subscribed").on "click", (e) ->
      window.App.Users.toggle_subscription()

  toggle_subscription: ->
    if $("#user_subscribed").prop("checked")
      $(".report_types input[type=radio]").prop( "disabled", false )
      $(".report_types").removeClass "disabled"
    else
      $(".report_types input[type=radio]").prop( "disabled", true )
      $(".report_types").addClass "disabled"
$ ->
  window.App.Users.init()
