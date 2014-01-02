((doc, nav) ->

  class VectorReader

    readVectorAt: (x, y, imageData) =>
      pos = ((y * imageData.width) + x) * 4
      r = imageData.data[pos]
      g = imageData.data[pos + 1]
      b = imageData.data[pos + 2]
      a = imageData.data[pos + 3]

      maxMagnitude = 1
      velocityX = ((r - b) / 255.0) * maxMagnitude
      velocityY = ((g - a) / 255.0) * maxMagnitude

#      scale = 16
#      velocityX = @_threshold(Math.floor((r - 128) / scale), 5)
#      velocityY = @_threshold(Math.floor((g - 128) / scale), 5)

      console.log("#{r},#{g},#{b},#{a} -> #{velocityX},#{velocityY}")

      {
        x: velocityX
        y: velocityY
      }

    _threshold: (value, threshold) =>
      value
#      if Math.abs(value) < threshold
#        0
#      else
#        value

  class Ball
    constructor: (@x, @y, @reader) ->
      @radius = 10

    draw: (context) =>
      context.beginPath();
      context.arc(@x, @y, @radius, 0, 2 * Math.PI, false);
      context.strokeStyle = "red"
      context.stroke()

    readOffset: (imageData) =>
      velocity = @reader.readVectorAt(@x, @y, imageData)

      nextX = @_clamp(@x + velocity.x, 0, imageData.width - 1)
      nextY = @_clamp(@y + velocity.y, 0, imageData.height - 1)
      changed = !(nextX == @x && nextY == @y)
#      if (changed)
#        console.dir("(#{@x},#{@y}) => (#{nextX},#{nextY})")
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

    @reader = new VectorReader

    numBalls = 0
    @balls = for i in [0...numBalls]
      new Ball(Math.floor(Math.random() * width), Math.floor(Math.random() * height), @reader)

    @dirty = true

    @canvas.addEventListener('click', (e) =>
#      console.dir(e)
      if e.shiftKey
        console.log("Adding")
        @balls.push(new Ball(e.offsetX, e.offsetY, @reader))
        @dirty = true
      else
        console.log("Marking as dirty")
        @dirty = true
    )

    @canvas.addEventListener('mousemove', (e) =>
#      if e.altKey
      imageData = @context.getImageData(0, 0, @width, @height)
      x = e.offsetX
      y = e.offsetY
      velocity = @reader.readVectorAt(x, y, imageData)
      console.log("#{x},#{y}: v.x: #{velocity.x}, v.y: #{velocity.y}")
#      @context.strokeStyle = "green"
#      @context.moveTo(x, y)
#      @context.lineTo(x + velocity.x, y)
#      @context.stroke()
#      @context.moveTo(x, y)
#      @context.lineTo(x, y + velocity.y)
#      @context.stroke()
    )

    draw()

    console.log("Started")

  draw = () =>

    if @dirty
      saved = _saveContextProperties(@context)

      @context.fillStyle = "black"
      @context.fillRect(0, 0, @width, @height)

      @context.globalCompositeOperation = "lighter"

      @context.fillStyle = "rgba(0,0,0,255)"
      @context.fillRect(0, 0, @width / 2, @height)
      @context.fillStyle = "rgba(0,255,0,255)"
      @context.fillRect(@width / 2, 0, @width, @height)

      @context.fillStyle = "rgba(0,0,0,255)"
      @context.fillRect(0, 0, @width, @height / 2)
      @context.fillStyle = "rgba(255,0,0,255)"
      @context.fillRect(0, @height / 2, @width, @height)

      @context.globalCompositeOperation = "multiply"
      radial = @context.createRadialGradient(
        (@width / 2) - 5, (@height / 2) - 5, 10,
        (@width / 2) - 5, (@height / 2) - 5, @height / 2)
      radial.addColorStop(0, "black")
      radial.addColorStop(0.99, "white")
      radial.addColorStop(1, "rgb(0, 0, 0)")
      @context.fillStyle = radial
      @context.fillRect(0, 0, @width, @height)

#      gradientA = @context.createLinearGradient(0, 0, 0, @height)
#      gradientA.addColorStop(0, "rgb(0,0,0)")
#      gradientA.addColorStop(1, "rgb(255,0,0)")
#      @context.fillStyle = gradientA
#      @context.fillRect(0, 0, @width, @height)
#
#      gradientB = @context.createLinearGradient(0, 0, @width, 0)
#      gradientB.addColorStop(0, "rgb(0,0,0)")
#      gradientB.addColorStop(1, "rgb(0,255,0)")
#      @context.fillStyle = gradientB
#      @context.fillRect(0, 0, @width, @height)

      @context.globalCompositeOperation = "lighter"
      for ball in @balls
        ball.draw(@context)

      imageData = @context.getImageData(0, 0, @width, @height)

      @dirty = false
      for ball in @balls
        dirty = ball.readOffset(imageData)
        @dirty = @dirty || dirty

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