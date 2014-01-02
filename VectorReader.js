// Generated by CoffeeScript 1.6.3
(function() {
  var VectorReader,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  VectorReader = (function() {
    function VectorReader() {
      this._threshold = __bind(this._threshold, this);
      this.readVectorAt = __bind(this.readVectorAt, this);
    }

    VectorReader.prototype.readVectorAt = function(x, y, imageData) {
      var a, b, g, maxMagnitude, pos, r, velocityX, velocityY;
      pos = ((y * imageData.width) + x) * 4;
      r = imageData.data[pos];
      g = imageData.data[pos + 1];
      b = imageData.data[pos + 2];
      a = imageData.data[pos + 3];
      maxMagnitude = 1;
      velocityX = ((r - b) / 255.0) * maxMagnitude;
      velocityY = ((g - a) / 255.0) * maxMagnitude;
      console.log("" + r + "," + g + "," + b + "," + a + " -> " + velocityX + "," + velocityY);
      return {
        x: velocityX,
        y: velocityY
      };
    };

    VectorReader.prototype._threshold = function(value, threshold) {
      return value;
    };

    return VectorReader;

  })();

  window.VectorReader = VectorReader;

}).call(this);

/*
//@ sourceMappingURL=VectorReader.map
*/
