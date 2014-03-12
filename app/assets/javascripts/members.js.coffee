window.App.Members =
  init: ->
    $(document).on "click", ".card", ->
      window.open $(this).attr("data-trello-url"), "_blank"

    $(document).on "click", ".members_tabs a", ->
      $(".members_tabs li").removeClass "active"
      $(this).closest("li").addClass "active"
      $("#activity_loader").show()
      $("#activity_loader").show()

    $("#activity_loader").show()
    $("#activity_loader").show()

  get_activity: (url) ->
    $.ajax
      url: url
      method: "GET"
      async: true
      success: (data) ->
        $("#activity_loader").hide()

  get_cards: (url) ->
    $.ajax
      url: url
      method: "GET"
      async: true
      success: (data) ->
        $("#cards_loader").hide()


$ ->
  window.App.Members.init()
