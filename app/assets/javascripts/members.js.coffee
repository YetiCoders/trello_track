window.App.Members =
  init: ->
    $(document).on "click", ".card", ->
      window.open $(this).attr("data-trello-url"), "_blank"

    $(document).on "click", ".members_tabs a", ->
      $(".members_tabs li").removeClass "active"
      $(this).closest("li").addClass "active"

  get_activity: (url) ->
    $("#activity_loader").show()

    $.ajax
      url: url
      method: "GET"
      async: true
      success: (data) ->
        $("#activity_loader").hide()

  get_cards: (url) ->
    $("#cards_loader").show()

    $.ajax
      url: url
      method: "GET"
      async: true
      success: (data) ->
        $("#cards_loader").hide()


$ ->
  window.App.Members.init()
