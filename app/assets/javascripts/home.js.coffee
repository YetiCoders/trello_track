window.App.Main =
  init: ->
    $(".finish_set_up_following_button").hide()

    $(document).on "click", ".set_up_following_button", ->
      $(this).hide()
      $(".finish_set_up_following_button").show()
      $(".organizations .member .follow_status .status_icon").hide()
      $(".organizations .member .follow_status .status_checkbox").show()

    $(document).on "click", ".finish_set_up_following_button", ->
      $(this).hide()
      $(".set_up_following_button").show()
      $(".organizations .member .follow_status .status_checkbox").hide()
      $(".organizations .member .follow_status .status_icon").show()
      $(".organizations .follow_status .status_checkbox:not(:checked)").prev(".status_icon").hide()

    $(document).on "change", ".organizations .status_checkbox", ->
      alert $(".status_checkbox:checked").val()

    $(".organizations .follow_status .status_checkbox:not(:checked)").prev(".status_icon").hide()

$ ->
  window.App.Main.init()
