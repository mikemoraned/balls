((doc, nav) ->

  class Ball
    constructor: (@x, @y) ->
      @radius = 100

    draw: (context) =>
      context.beginPath();
      context.arc(@x, @y, @radius, 0, 2 * Math.PI, false);
      context.fillStyle = @gradient(context)
      context.fill()

    gradient: (context) =>
      gradient = context.createLinearGradient(@x - @radius, @y - @radius, @x + @radius,@y + @radius)
      gradient.addColorStop(0, "white")
      gradient.addColorStop(0.5, "rgb(128,128,0)")
      gradient.addColorStop(1, "black")
      gradient

    readOffset: (imageData) =>
      pos = ((@y * imageData.width) + @x) * 4
      r = imageData.data[pos]
      g = imageData.data[pos + 1]

      console.log("#{r},#{g}")

      scale = 16
      velocityX = @_threshold(Math.floor((r - 128) / scale), 5)
      velocityY = @_threshold(Math.floor((g - 128) / scale), 5)

      nextX = @_clamp(@x + velocityX, 0, imageData.width - 1)
      nextY = @_clamp(@y + velocityY, 0, imageData.height - 1)
      changed = !(nextX == @x && nextY == @y)
      if (changed)
        console.dir("(#{@x},#{@y}) => (#{nextX},#{nextY})")
      @x = nextX
      @y = nextY
      changed

    _threshold: (value, threshold) =>
      if Math.abs(value) < threshold
        0
      else
        value

    _clamp: (value, min, max) =>
      Math.min(max, Math.max(min, value))

  detect = () =>
    initialize()

  initialize = () =>
    console.log("Starting")

    @canvas = doc.getElementById("balls")
    @width = canvas.width
    @height = canvas.height

    @context = canvas.getContext("2d");

#    numBalls = 20
#    @balls = for i in [0...numBalls]
#      new Ball(Math.floor(Math.random() * width), Math.floor(Math.random() * height))

    @balls = []
#    proportions = [0.40, 0.60]
#    for w in proportions
#      for h in proportions
#        @balls.push(new Ball(w * @width, h * @height))

    @balls.push(new Ball(0.40 * @width, 0.40 * @height))
    @balls.push(new Ball(0.40 * @width, 0.60 * @height))

    @dirty = true

    @canvas.onclick = () =>
      @dirty = true

    draw()

    console.log("Started")

  draw = () =>

    if @dirty
      saved = _saveContextProperties(@context)

      @context.fillStyle = "black"
      @context.fillRect(0, 0, @width, @height)

#      @p = 100
#      @size = 100
#      @context.fillStyle = @context.createLinearGradient(@p, @p, @p + @size, @p + @size)
#      @context.fillStyle.addColorStop(0, "white")
#      @context.fillStyle.addColorStop(0.5, "black")
#      @context.fillStyle.addColorStop(1, "white")
#      @context.fillRect(@p, @p, @size, @size)
#
#      @context.fillStyle = "red"
#      @context.fillRect(@p, @p, 5, 5)
#      @context.fillRect(@p + @size, @p + @size, 5, 5)

      for ball in @balls
        @context.globalCompositeOperation = "lighter"
        ball.draw(@context)

      imageData = @context.getImageData(0, 0, @width, @height)

      @dirty = false
      for ball in @balls
        dirty = ball.readOffset(imageData)
#        @dirty = @dirty || dirty

      saved.restore()

    requestAnimationFrame(draw)

  _saveContextProperties = (context) =>
    globalCompositeOperation = context.globalCompositeOperation
    fillStyle = context.fillStyle
    {
      restore: () =>
        @context.globalCompositeOperation = globalCompositeOperation
        @context.fillStyle = fillStyle
    }

  addEventListener("DOMContentLoaded", detect)
)(document, navigator)