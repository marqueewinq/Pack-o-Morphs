# Автор: Гусев Илья.
# Описание: Класс панели действий.

class window.ActionBar extends window.Bar
    constructor: (@game, @grid, @borderMargin = 40, @x = 10, @width = 300, @height = 128) ->
        @buttons = []
        @isLock = false
        @buttonWidth = 128
        @callbacks = {}
        @locked = false

    Draw: () ->
        @Destroy()
        if not @locked && @callbacks? && @toRedraw? && @toRedraw
            actions = Object.keys(@callbacks)

            @width = Math.max(@grid.fieldWidth, @buttonWidth * actions.length + @borderMargin )
            @x = (@game.width - @width) / 2
            @y = @game.height - @height

            super(@game, @x, @y, @width, @height)

            for action in actions
                x = @x + (@width - @buttonWidth * actions.length)/2 + @buttonWidth * actions.indexOf(action)
                button = @game.add.button(x, @y, "button_"+action, @callbacks[action], this, 0, 1, 1)
                button.fixedToCamera = true
                @buttons.push(button)
        return

    Destroy: () ->
        if @locked
            @callbacks = undefined
        if @buttons?
            for button in @buttons
                button.destroy()
            @buttons = []
        super()
        return

    DisplayObjectActions: (object, @callbacks) ->
        @toRedraw = false
        if object.IsCreature()
            @toRedraw = true
            @Draw()
        else
            @toRedraw = false
            @Destroy()
        return

    Lock: () ->
        @locked = true
        @Draw()

    Unlock: () ->
        @locked = false
        @Draw()