window.App.Users =
  filter_condition_example: null

  init: ->
    window.App.Users.filter_condition_init()

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

  filter_condition_init: ->
    window.App.Users.filter_condition_example = $(".filter_conditions .filter_condition.example").clone()
    window.App.Users.filter_condition_example.removeClass "example"

    $(".filter_conditions .filter_condition.example").remove()

    $(document).on "click", ".add_filter_condition_link", ->
      $(".filter_conditions").append window.App.Users.filter_condition_example.clone()

    $(document).on "click", ".delete_filter_condition_link", ->
      $(this).closest(".filter_condition").remove()

$ ->
  window.App.Users.init()
