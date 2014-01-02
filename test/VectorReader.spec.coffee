describe('VectorReader', () =>

  baseImageData = {
    width: 1
    height: 1
    data: [0, 0, 0, 0]
  }

  describe('readVectorAt', () =>

    reader = null
    imageData = null
    beforeEach(() =>
      reader = new VectorReader
      imageData = _.extend({}, baseImageData)
    )

    it('can read zero movement', () =>
      imageData.data = [0, 0, 0, 0]

      vector = reader.readVectorAt(0, 0, imageData)

      assert.equal(vector.x, 0)
      assert.equal(vector.y, 0)
    )

    it('can read max negative x', () =>
      imageData.data = [0, 0, 255, 0]

      vector = reader.readVectorAt(0, 0, imageData)

      assert.equal(vector.x, -1.0)
      assert.equal(vector.y, 0)
    )
  )
)