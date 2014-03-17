window.App.Members =
  first_time: true,
  requests_pool: [],

  init: ->
    $("#tab_loader").show()
    $("#followers").bootstrapSwitch()
      .bootstrapSwitch("setSizeClass", "switch-large")
      .bootstrapSwitch("setOnLabel", "<span class='fa fa-users'></span>")
      .bootstrapSwitch("setOffLabel", "<span class='fa fa-eye'></span>")
      .bootstrapSwitch("setOffClass", "followers")
      .bootstrapSwitch("setOnClass", "organization")

    $("#followers").on "switch-change", (e, data) ->
      if data.value
        $(".members_tabs li[follower='']").hide()
      else
        $(".members_tabs li").show()

    $(".members_tabs a").bind "ajax:complete", (event, request) ->
      $("#tab_loader").hide()

    $(".members_tabs a").bind "ajax:beforeSend", (event, request) ->
      window.App.Members.abort_requests()
      window.App.Members.requests_pool.push(request)

    $(document).on "click", ".members_tabs a", ->
      $("#tab_loader, #activity_loader, #cards_loader").show()
      $(".members_tabs li").removeClass "active"
      $(this).closest("li").addClass "active"
      window.App.Members.save_state $(this)

    $(document).on "mouseup", ".card", (e) ->
      switch e.which
        when 1, 2
          window.open $(this).attr("data-trello-url"), "_blank"

    $(window).on "popstate", ->
      state = window.history.state
      if !window.App.Members.first_time && state?
        $(".members_tabs li").removeClass "active"
        $("#" + state["tab_id"]).closest("li").addClass "active"
        window.App.Members.get_all state["path"]

      window.App.Members.first_time = false

  abort_requests: ->
    $.each window.App.Members.requests_pool, (idx, request) ->
      if request.readyState != 4
        request.abort()

    window.App.Members.requests_pool = []

  save_state: (a_selector)->
    state = { tab_id: a_selector.prop("id"), path: a_selector.prop("href") }
    if window.App.Members.first_time
      window.history.replaceState state, '', a_selector.prop("href")
    else
      window.history.pushState state, '', a_selector.prop("href")

  get_all: (url) ->
    $.ajax(
      url: url
      method: "GET"
      async: true
      beforeSend: (request)->
        window.App.Members.requests_pool.push(request)
    )

  get_activity: (url) ->
    $.ajax(
      url: url
      method: "GET"
      async: true
      beforeSend: (request)->
        window.App.Members.requests_pool.push(request)
    ).done ->
      $("#tab_loader").hide()
      $("#activity_loader").hide()

  get_cards: (url) ->
    $.ajax(
      url: url
      method: "GET"
      async: true
      beforeSend: (request)->
        window.App.Members.requests_pool.push(request)
    ).done ->
      $("#tab_loader").hide()
      $("#cards_loader").hide()

$ ->
  window.App.Members.init()
