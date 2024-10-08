CafePOS.Common =
  init: ->
    @_changeDateFilterInputType()

  _changeDateFilterInputType: ->
    $(".date_filter").attr("type", "date")