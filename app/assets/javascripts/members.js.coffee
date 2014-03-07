window.App.Members =
  init: ->
    window.App.Members.set_activity_height()

    $(window).resize ->
      window.App.Members.set_activity_height()

    $(document).on "click", ".card", ->
      window.open $(this).attr("data-trello-url"), "_blank"

  set_activity_height: ->
    $(".activities").css "height", $(".cards").outerHeight()

$ ->
  window.App.Members.init()
