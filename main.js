// Generated by CoffeeScript 1.6.3
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  (function(doc, nav) {
    var Ball, detect, draw, initialize, _saveContextProperties,
      _this = this;
    Ball = (function() {
      function Ball(x, y, reader) {
        this.x = x;
        this.y = y;
        this.reader = reader;
        this._clamp = __bind(this._clamp, this);
        this.readOffset = __bind(this.readOffset, this);
        this.draw = __bind(this.draw, this);
        this.radius = 10;
      }

      Ball.prototype.draw = function(context) {
        context.beginPath();
        context.arc(this.x, this.y, this.radius, 0, 2 * Math.PI, false);
        context.strokeStyle = "red";
        return context.stroke();
      };

      Ball.prototype.readOffset = function(imageData) {
        var changed, nextX, nextY, velocity;
        velocity = this.reader.readVectorAt(this.x, this.y, imageData);
        nextX = this._clamp(this.x + velocity.x, 0, imageData.width - 1);
        nextY = this._clamp(this.y + velocity.y, 0, imageData.height - 1);
        changed = !(nextX === this.x && nextY === this.y);
        this.x = nextX;
        this.y = nextY;
        return changed;
      };

      Ball.prototype._clamp = function(value, min, max) {
        return Math.min(max, Math.max(min, value));
      };

      return Ball;

    })();
    detect = function() {
      return initialize();
    };
    initialize = function() {
      var i, numBalls;
      console.log("Starting");
      _this.canvas = doc.getElementById("balls");
      _this.width = canvas.width;
      _this.height = canvas.height;
      _this.context = canvas.getContext("2d");
      _this.reader = new VectorReader;
      numBalls = 0;
      _this.balls = (function() {
        var _i, _results;
        _results = [];
        for (i = _i = 0; 0 <= numBalls ? _i < numBalls : _i > numBalls; i = 0 <= numBalls ? ++_i : --_i) {
          _results.push(new Ball(Math.floor(Math.random() * width), Math.floor(Math.random() * height), this.reader));
        }
        return _results;
      }).call(_this);
      _this.dirty = true;
      _this.canvas.addEventListener('click', function(e) {
        if (e.shiftKey) {
          console.log("Adding");
          _this.balls.push(new Ball(e.offsetX, e.offsetY, _this.reader));
          return _this.dirty = true;
        } else {
          console.log("Marking as dirty");
          return _this.dirty = true;
        }
      });
      _this.canvas.addEventListener('mousemove', function(e) {
        var imageData, velocity, x, y;
        imageData = _this.context.getImageData(0, 0, _this.width, _this.height);
        x = e.offsetX;
        y = e.offsetY;
        velocity = _this.reader.readVectorAt(x, y, imageData);
        return console.log("" + x + "," + y + ": v.x: " + velocity.x + ", v.y: " + velocity.y);
      });
      draw();
      return console.log("Started");
    };
    draw = function() {
      var ball, dirty, imageData, radial, saved, _i, _j, _len, _len1, _ref, _ref1;
      if (_this.dirty) {
        saved = _saveContextProperties(_this.context);
        _this.context.fillStyle = "black";
        _this.context.fillRect(0, 0, _this.width, _this.height);
        _this.context.globalCompositeOperation = "lighter";
        _this.context.fillStyle = "rgba(0,0,0,255)";
        _this.context.fillRect(0, 0, _this.width / 2, _this.height);
        _this.context.fillStyle = "rgba(0,255,0,255)";
        _this.context.fillRect(_this.width / 2, 0, _this.width, _this.height);
        _this.context.fillStyle = "rgba(0,0,0,255)";
        _this.context.fillRect(0, 0, _this.width, _this.height / 2);
        _this.context.fillStyle = "rgba(255,0,0,255)";
        _this.context.fillRect(0, _this.height / 2, _this.width, _this.height);
        _this.context.globalCompositeOperation = "multiply";
        radial = _this.context.createRadialGradient((_this.width / 2) - 5, (_this.height / 2) - 5, 10, (_this.width / 2) - 5, (_this.height / 2) - 5, _this.height / 2);
        radial.addColorStop(0, "black");
        radial.addColorStop(0.99, "white");
        radial.addColorStop(1, "rgb(0, 0, 0)");
        _this.context.fillStyle = radial;
        _this.context.fillRect(0, 0, _this.width, _this.height);
        _this.context.globalCompositeOperation = "lighter";
        _ref = _this.balls;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          ball = _ref[_i];
          ball.draw(_this.context);
        }
        imageData = _this.context.getImageData(0, 0, _this.width, _this.height);
        _this.dirty = false;
        _ref1 = _this.balls;
        for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
          ball = _ref1[_j];
          dirty = ball.readOffset(imageData);
          _this.dirty = _this.dirty || dirty;
        }
        saved.restore();
      }
      return requestAnimationFrame(draw);
    };
    _saveContextProperties = function(context) {
      var fillStyle, globalCompositeOperation;
      globalCompositeOperation = context.globalCompositeOperation;
      fillStyle = context.fillStyle;
      return {
        restore: function() {
          _this.context.globalCompositeOperation = globalCompositeOperation;
          return _this.context.fillStyle = fillStyle;
        }
      };
    };
    return addEventListener("DOMContentLoaded", detect);
  })(document, navigator);

}).call(this);

/*
//@ sourceMappingURL=main.map
*/
