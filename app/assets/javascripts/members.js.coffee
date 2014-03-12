window.App.Members =
  init: ->
    $("#tab_loader").show()

    $(".members_tabs a").bind "ajax:complete", (request) ->
      $("#tab_loader").hide()

    $(document).on "click", ".members_tabs a", ->
      $("#tab_loader, #activity_loader, #cards_loader").show()
      $(".members_tabs li").removeClass "active"
      $(this).closest("li").addClass "active"

    $(document).on "mouseup", ".card", (e) ->
      switch e.which
        when 1, 2
          window.open $(this).attr("data-trello-url"), "_blank"

  get_activity: (url) ->
    $.ajax
      url: url
      method: "GET"
      async: true
      success: (data) ->
        $("#tab_loader").hide()
        $("#activity_loader").hide()

  get_cards: (url) ->
    $.ajax
      url: url
      method: "GET"
      async: true
      success: (data) ->
        $("#tab_loader").hide()
        $("#cards_loader").hide()

$ ->
  window.App.Members.init()
