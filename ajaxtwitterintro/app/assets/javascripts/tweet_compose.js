$.TweetCompose = function (el) {
  this.$el = $(el);
  this.$el.on('submit', this.submit.bind(this));
  this.$el.on('input', 'textarea', this.charCount.bind(this));
  this.$el.on('click', 'a.add-mentioned-user', this.addMentionedUser.bind(this));
  this.$el.on('click', '.single-mention', this.removeMentionedUser.bind(this));
};

$.TweetCompose.prototype.submit = function (event) {
   event.preventDefault();
   var that = this;
   var tweet = this.$el.find("textarea").val();
   var formData = $(event.currentTarget).serialize();
   this.$el.find(":input").prop("disabled", true);

   console.log(formData);
   $.ajax({
     url: "/tweets",
     dataType: "json",
     type: "POST",
     data: formData,
     success: function(tweetJSON) {
       that.handleSuccess(tweetJSON);
     }
   })
};

$.TweetCompose.prototype.clearInput = function(){
  this.$el.find(":input").empty();
  this.$el.find(".mentioned-users").empty();
}

$.TweetCompose.prototype.handleSuccess = function(tweetJSON){
  console.log(tweetJSON);
  this.clearInput();
  this.$el.find(":input").prop("disabled", false);
  var newli = $("<li>").html(JSON.stringify(tweetJSON))
  $(this.$el.data("tweets-ul")).prepend(newli);

}

$.TweetCompose.prototype.charCount = function(event){

  var tweetLength = $(event.currentTarget).val().length;

  this.$el.find("chars-left").html((tweetLength) + "/140");
}

$.TweetCompose.prototype.addMentionedUser = function(event){
  event.preventDefault();
  var selected = this.$el.find("script").html();
  console.log(selected);
  this.$el.find(".mentioned-users").append(selected);
}

$.TweetCompose.prototype.removeMentionedUser = function(event){
  event.preventDefault();
  if ($(event.target).prop('tagName') === "A") {
    $(event.currentTarget).remove();
  }

}

$.fn.tweetCompose = function () {
  return this.each(function () {
    new $.TweetCompose(this);
  });
};

$(function () {
  $(".tweet-compose").tweetCompose();
});
