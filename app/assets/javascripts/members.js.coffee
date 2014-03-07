window.App.Members =
  init: ->
    $(document).on "click", ".card", ->
      window.open $(this).attr("data-trello-url"), "_blank"

$ ->
  window.App.Members.init()
