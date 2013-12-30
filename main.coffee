((doc, nav) ->

  class Ball
    constructor: (@x, @y) ->

    gradient: (context) =>
      gradient = context.createRadialGradient(@x,@y,5,@x,@y,10)
      gradient.addColorStop(0, '#00C9FF')
      gradient.addColorStop(0.8, '#00B5E2')
      gradient.addColorStop(1, 'rgba(0,201,255,0)')
      gradient

    readOffset: (imageData) =>
      pos = ((@y * imageData.width) + @x) * 4
      r = imageData.data[pos]
      g = imageData.data[pos + 1]

      scale = 16
      velocityX = (r - 128) / scale
      velocityY = (g - 128) / scale

      nextX = @_clamp(@x + velocityX, 0, imageData.width - 1)
      nextY = @_clamp(@y + velocityY, 0, imageData.height - 1)
      changed = !(nextX == @x && nextY == @y)
      @x = nextX
      @y = nextY
      changed

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

    @balls = for i in [0..5]
      new Ball(Math.floor(Math.random() * width), Math.floor(Math.random() * height))
    @dirty = true

    draw()

    console.log("Started")

  draw = () =>

    if @dirty
      savedFillStyle = @context.fillStyle

      for ball in @balls
        @context.globalCompositeOperation = "multiply"
        @context.fillStyle = ball.gradient(@context)
        @context.fillRect(0, 0, @width, @height)

      imageData = @context.getImageData(0, 0, @width, @height)

      @dirty = false
      for ball in @balls
        @dirty = @dirty || ball.readOffset(imageData)

      @context.fillStyle = savedFillStyle

    requestAnimationFrame(draw)

  addEventListener("DOMContentLoaded", detect)
)(document, navigator)