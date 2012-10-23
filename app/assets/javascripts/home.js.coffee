# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
valobox.bind 'ready', () ->

  valobox.widget('#valobox-reader').bind 'ready', (widget) ->

    $('a.start').click (e) ->
      widget.start()


  valobox.widget('#valobox-reader').bind 'loaded', (widget) ->

    # find the toc menu object
    menu = $('ul#menu')

    # bind up the valobox notifications
    widget.bind 'notify', (event, args) =>

      # if it is a page change notification
      if args['pageIndex']

        # Grab the page number (page Index + 1)
        pageIndex = parseInt(args['pageIndex'])

        # Remove the active class from all the toc menu list items
        menu.find('li').removeClass("active")

        # Find and select the appropriate list item
        $.each menu.find('li'), (idx, item) ->
          item = $(item)
          l = item.children("a")
          chapterPageIndex = parseInt(l.attr('start_page'))
          endPageIndex     = parseInt(l.attr('end_page'))
          item.addClass("active") if chapterPageIndex <= pageIndex < endPageIndex || chapterPageIndex == pageIndex

    # turn to the appropriate page when the toc is clicked
    menu.find('a').bind 'click', (event) ->
      pageIndex = parseInt $(this).attr('start_page')
      widget.jumpTo(pageIndex)


    # turn to previous page
    $("a.prev-page").click (e) ->
      widget.pageUp()


    # turn to the next page
    $("a.next-page").click (e) ->
      widget.pageDown()

    # alert the current page
    $("a.current-page").click (e) ->
      widget.currentPage (success, value) =>
        alert value
