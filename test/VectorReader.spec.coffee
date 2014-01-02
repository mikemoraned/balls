describe('VectorReader', () =>

  describe('readVectorAt', () =>

    it('can read zero movement', () =>
      reader = new VectorReader
      imageData = {
        width: 1
        height: 1
        data: [0, 0, 0, 0]
      }

      vector = reader.readVectorAt(0, 0, imageData)

      assert.equal(vector.x, 0)
      assert.equal(vector.y, 0)
    )

    it('can read max negative x', () =>
      reader = new VectorReader
      imageData = {
        width: 1
        height: 1
        data: [0, 0, 255, 0]
      }

      vector = reader.readVectorAt(0, 0, imageData)

      assert.equal(vector.x, -1.0)
      assert.equal(vector.y, 0)
    )
  )
)