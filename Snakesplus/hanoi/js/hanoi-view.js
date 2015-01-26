(function () {
  if (typeof Hanoi === "undefined") {
    window.Hanoi = {};
  }

  var View = Hanoi.View = function (game, $el) {
    this.game = game;
    this.$el = $el;
    this.bindEvents();
    this.clickedTower = -1;
  };

  View.prototype.bindEvents = function () {
    var that = this;

    this.$el.on("click", "ul", function(event) {
      var $target = $(this);
      var num = $target.data("num").num;

      that.clickTower(num);
      if (that.game.isWon()) {
        alert("You Win!");
        window.location.reload();
      }
    });
  };

  View.prototype.clickTower = function (num) {
    var array = [".one", ".two", ".three"];

    if (this.clickedTower === -1) {
      $(array[num]).toggleClass("clicked");
      this.clickedTower = num;
    } else {
      // do move
      if (this.game.move(this.clickedTower, num)) {
        this.render();
      } else {
        alert("Invalid Move!");
      }
      $(array[this.clickedTower]).toggleClass("clicked");
      this.clickedTower = -1;
    }
  };

  View.prototype.render = function () {
    var towers = this.game.towers;
    var that = this;
    var array = [".one", ".two", ".three"];

    $("li").remove();

    console.log(towers);

    for (var i= 0; i < towers.length; i++ ) {

      if (towers[i].length !== 0) {

        var $currentTower = $(array[i]);

        for (var j = 2; j > -1; j--) {

          var $newLi = $("<li>");
          if (towers[i][j] === 1) {
            $newLi.addClass("small");
          } else if (towers[i][j] === 2) {
            $newLi.addClass("medium");
          } else if (towers[i][j] === 3) {
            $newLi.addClass("large");
          } else {
            $newLi.addClass("empty");
          }

          console.log($newLi);
          $currentTower.append($newLi);

        }

      }
    }

  };

})();
