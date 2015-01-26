
$.FollowToggle = function (el, options) {
  this.$el = $(el);
  this.userId = this.$el.data("user-id") || options.userId;
  this.followState = this.$el.data("initial-follow-state") || options.followState;
  this.render();
  this.$el.on('click', this.handleClick.bind(this));
};

$.FollowToggle.prototype.render = function () {
  // if (this.working){
  //   this.$el.prop("disabled", true);
  // }else{ this.$el.prop("disabled", false);}
  
  if (this.followState === "followed"){
    this.$el.html("Unfollow, you stanky ass!");
  } else {
    // this.$el.prop("disabled", false);
    this.$el.html("Follow, like a stalker!");
  }
};

$.FollowToggle.prototype.requestType = function(){
  if (this.followState === "followed"){
    return "DELETE";
  } else {
    return "POST";
  }
}

$.FollowToggle.prototype.handleClick = function(event){
  event.preventDefault();
  // if (this.working) {return;}
  // this.working = true;
  // this.render();
  this.$el.prop("disabled", true);
  var that = this;
  $.ajax({
    url: "/users/" + that.userId + "/follow",
    type: that.requestType(),
    dataType : "json",
    success: function(){
      that.followState = (that.followState === "followed") ? "unfollowed" : "followed";
      // that.working = false;
      that.$el.prop("disabled", false);
      that.render();

    }

  })
}

$.fn.followToggle = function (options) {
  return this.each(function () {
    new $.FollowToggle(this, options);
  });
};

$(function () {
  $("button.follow-toggle").followToggle();
});
