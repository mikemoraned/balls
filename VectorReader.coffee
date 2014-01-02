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

window.VectorReader = VectorReader