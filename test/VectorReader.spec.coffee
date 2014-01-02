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
      reader = new VectorReader(100)
      imageData = _.extend({}, baseImageData)
    )

    describe('basic', () =>

      it('can read zero movement', () =>
        imageData.data = [0, 0, 0, 0]

        vector = reader.readVectorAt(0, 0, imageData)

        assert.equal(vector.x, 0)
        assert.equal(vector.y, 0)
      )

      it('can read max negative x', () =>
        imageData.data = [0, 0, 255, 0]

        vector = reader.readVectorAt(0, 0, imageData)

        assert.equal(vector.x, -100)
        assert.equal(vector.y, 0)
      )

      it('can read max negative y', () =>
        imageData.data = [0, 0, 0, 255]

        vector = reader.readVectorAt(0, 0, imageData)

        assert.equal(vector.x, 0)
        assert.equal(vector.y, -100)
      )

      it('can read max positive x', () =>
        imageData.data = [255, 0, 0, 0]

        vector = reader.readVectorAt(0, 0, imageData)

        assert.equal(vector.x, 100)
        assert.equal(vector.y, 0)
      )

      it('can read max positive y', () =>
        imageData.data = [0, 255, 0, 0]

        vector = reader.readVectorAt(0, 0, imageData)

        assert.equal(vector.x, 0)
        assert.equal(vector.y, 100)
      )

    )

    describe('mixed', () =>
      it('positive and negative x components combine to cancel out', () =>
        imageData.data = [255, 0, 255, 0]

        vector = reader.readVectorAt(0, 0, imageData)

        assert.equal(vector.x, 0)
        assert.equal(vector.y, 0)
      )

      it('positive and negative y components combine to cancel out', () =>
        imageData.data = [0, 255, 0, 255]

        vector = reader.readVectorAt(0, 0, imageData)

        assert.equal(vector.x, 0)
        assert.equal(vector.y, 0)
      )

      it('unequal positive and negative x components combine to produce positive x', () =>
        imageData.data = [128, 0, 65, 0]

        vector = reader.readVectorAt(0, 0, imageData)

        assert.equal(vector.x, 25)
        assert.equal(vector.y, 0)
      )

      it('unequal positive and negative x components combine to produce negative x', () =>
        imageData.data = [65, 0, 128, 0]

        vector = reader.readVectorAt(0, 0, imageData)

        assert.equal(vector.x, -25)
        assert.equal(vector.y, 0)
      )

      it('unequal positive and negative y components combine to produce positive y', () =>
        imageData.data = [0, 128, 0, 65]

        vector = reader.readVectorAt(0, 0, imageData)

        assert.equal(vector.x, 0)
        assert.equal(vector.y, 25)
      )

      it('unequal positive and negative y components combine to produce negative y', () =>
        imageData.data = [0, 65, 0, 128]

        vector = reader.readVectorAt(0, 0, imageData)

        assert.equal(vector.x, 0)
        assert.equal(vector.y, -25)
      )
    )
  )
)