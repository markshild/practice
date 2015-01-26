(function () {
  if (typeof Snakey === "undefined") {
    window.Snakey = {};
  }

  var View = Snakey.View = function ($el) {
    this.$el = $el;
    this.board = new Snakey.Board(10, $el);
    window.setInterval(function () {
      this.board.snake.move();
      this.board.render();
    }.bind(this), 300);
    window.setInterval(function() {
      this.board.addApple();
    }.bind(this), 5000);
    this.bindEvents();
  };

  View.prototype.bindEvents = function () {
    var that = this;

    $(window).on("keydown", this.handleKeyEvent.bind(this));
  };

  View.prototype.handleKeyEvent = function (event) {
    var dir = "";

    if (event.keyCode === 37) {
      dir = "W";
    } else if (event.keyCode === 38) {
      dir = "N";
    } else if (event.keyCode === 39) {
      dir = "E";
    } else if (event.keyCode === 40) {
      dir = "S";
    } else {
      return;
    }

    console.log(dir);

    this.board.snake.turn(dir);
  };

})();
