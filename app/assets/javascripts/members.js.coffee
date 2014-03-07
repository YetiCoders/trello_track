window.App.Members =
  init: ->
    $(document).on "click", ".card", ->
      window.open $(this).attr("data-trello-url"), "_blank"

    $(document).on "click", ".members_tabs a", ->
      $(".members_tabs li").removeClass "active"
      $(this).closest("li").addClass "active"

$ ->
  window.App.Members.init()
