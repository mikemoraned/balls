((doc, nav) ->

  class Ball
    constructor: (@x, @y) ->

    gradient: (context) =>
      gradient = context.createRadialGradient(@x,@y,15,@x,@y,100)
      gradient.addColorStop(0, '#00C9FF')
      gradient.addColorStop(0.8, '#00B5E2')
      gradient.addColorStop(1, 'rgba(0,201,255,0)')
      gradient

  detect = () =>
    initialize()

  initialize = () =>
    console.log("Starting")

    @canvas = doc.getElementById("balls")
    @width = canvas.width
    @height = canvas.height

    @context = canvas.getContext("2d");

    @balls = for i in [0..5]
      new Ball(Math.random() * width, Math.random() * height)
    @dirty = true

    draw()

    console.log("Started")

  draw = () =>

    if @dirty
      for ball in @balls
        @context.globalCompositeOperation = "multiply"
        @context.fillStyle = ball.gradient(@context)
        @context.fillRect(0, 0, @width, @height)
      @dirty = false

    requestAnimationFrame(draw)

  addEventListener("DOMContentLoaded", detect)
)(document, navigator)