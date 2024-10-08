CafePOS.Initializer =
  exec: (pageName) ->
    if pageName && CafePOS[pageName]
      CafePOS[pageName]['init']()

  currentPage: ->
    return '' unless $('body').attr('id')

    bodyIds     = $('body').attr('id').split('_')
    pageName    = ''
    for bodyId in bodyIds
      pageName += CafePOS.Util.capitalize(bodyId)
    pageName = pageName.replace(" Page-top", "")
    pageName

  init: ->
    CafePOS.Initializer.exec('Common')
    if @currentPage()
      CafePOS.Initializer.exec(@currentPage())
  
$(document).on "turbolinks:load", ->
  CafePOS.Initializer.init()