class WorldView.ItemOptions
  constructor: (options) ->
    @amount = options.amount ? 1
    @color = options.color ? 0xffffff
    @girth = options.girth ? 1
    @grow = options.grow ? WorldView.HEIGHT
    @height = options.height ? 1
    @lat = options.lat ? 0
    @label = options.label ? ''
    @long = options.long ? 0
    @opacity = options.opacity ? 1
    @scale = options.scale ? 1
