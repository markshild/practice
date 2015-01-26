(function () {
  if (typeof Snakey === "undefined") {
    window.Snakey = {};
  }

  var Snake = Snakey.Snake = function (board) {
    this.dir = "S";
    this.board = board
    this.segments = [[3,3], [2,3]];

    this.segments.forEach( function (s) {
      this.board.grid[s[0]][s[1]] = "S";
    }.bind(this));

    this.head = new Coord(this.segments[0]);
  };

  Snake.prototype.move = function () {


    var add = this.head.plus(this.dir);

    if (this.board.offBoard(add) || this.board.grid[add[0]][add[1]] === "S") {
      alert("You Lose Fool!... U should try again!");
      window.location.reload();
    }

    if (this.board.grid[add[0]][add[1]] !== "A") {
      var erase = this.segments.pop();
      this.board.grid[erase[0]][erase[1]] = ".";
    }

    this.segments.unshift(add);
    this.board.grid[add[0]][add[1]] = "S";

  };

  Snake.prototype.turn = function (dir) {
    this.dir = dir;
  };

  Snake.prototype.occupies = function (pos) {

  };

  var Coord = Snakey.Coord = function (pos) {
    this.pos = pos;
  };

  Coord.prototype.plus = function (dir) {

    if (dir === "N") {
      this.pos = [this.pos[0] - 1, this.pos[1]];
    } else if (dir === "E") {
      this.pos = [this.pos[0], this.pos[1] + 1];
    } else if (dir === "S") {
      this.pos = [this.pos[0] + 1, this.pos[1]];
    } else {
      this.pos = [this.pos[0], this.pos[1] - 1];
    }

    return this.pos;
  };

  var Board = Snakey.Board = function (dim) {

    this.dim = dim
    this.grid = []

    for (var i = 0; i < dim; i++) {
      this.grid[i] = [];
      for (j = 0; j < dim; j++) {
        this.grid[i][j] = ".";
      }
    }

    this.snake = new Snake(this);
  };

  Board.prototype.offBoard = function(pos) {
    if (pos[0] < 0 || pos[0] > (this.dim - 1)) {
      return true;
    }

    if (pos[1] < 0 || pos[1] > (this.dim - 1)) {
      return true;
    }

    return false;
  };

  Board.prototype.addApple = function () {
    var test = true;
    while (test) {
      var x = Math.floor(Math.random()*this.dim);
      var y = Math.floor(Math.random()*this.dim);
      if (this.grid[x][y] !== "S") {
        this.grid[x][y] = "A";
        test = false;
      }
    }
  }

  Board.prototype.render = function () {

    for (var i = 0; i < this.dim; i++) {
      for (var j = 0; j < this.dim; j++) {
        var index = (10 * i) + j;
        $thisLi = $($("li")[index]);
        $thisLi.removeClass();
        if (this.grid[i][j] === "A") {
          $thisLi.addClass("apple");
        } else if (this.grid[i][j] === "S") {
          $thisLi.addClass("snake");
        }
      }
    }
  };

})();
