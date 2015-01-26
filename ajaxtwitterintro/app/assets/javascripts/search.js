$.UsersSearch = function (el) {
  this.$el = $(el);
  this.$input = $('input');
  this.$ul = $('.users');
  this.$el.on('input', 'input', this.handleInput.bind(this));
};

$.UsersSearch.prototype.handleInput = function (event) {
  var that = this;
  $.ajax({
    url: "/users/search",
    type: 'GET',
    data: {
      query: $(event.currentTarget).val()
    },
    dataType : "json",
    success: function(results){
      that.renderResults(results);
    }
  })
}

$.UsersSearch.prototype.renderResults = function (results) {
  this.$ul.empty();
  var that = this
  results.forEach( function(result){
    console.log(result);
    var li = $("<li>").html("<a href=users/" + result.id + ">" + result.username + "</a>");
    var button = $("<button>").followToggle({
      userId: result.id,
      followState: result.followed ? "followed" : "unfollowed"
    });
    that.$ul.append(li, button);
  })
}


$.fn.usersSearch = function () {
  return this.each(function () {
    new $.UsersSearch(this);
  });
};

$(function () {
  $("div.users-search").usersSearch();
});
