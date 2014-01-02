class VectorReader

  constructor: (@maxMagnitude = 10) ->

  readVectorAt: (x, y, imageData) =>
    pos = ((y * imageData.width) + x) * 4
    r = imageData.data[pos]
    g = imageData.data[pos + 1]
    b = imageData.data[pos + 2]
    a = imageData.data[pos + 3]

    velocityX = @_interpretAsVelocity(r, b)
    velocityY = @_interpretAsVelocity(g, a)

    console.log("#{r},#{g},#{b},#{a} -> #{velocityX},#{velocityY}")

    {
      x: velocityX
      y: velocityY
    }

  _interpretAsVelocity: (positive, negative) =>
    ((positive / 255.0) - (negative / 255.0)) * @maxMagnitude

window.VectorReader = VectorReader