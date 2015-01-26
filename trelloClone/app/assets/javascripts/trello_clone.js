window.TrelloClone = {
  Models: {},
  Collections: {},
  Views: {},
  Routers: {},
  initialize: function(el) {
    this.$el = $(el);
    new TrelloClone.Routers.Router({$el: this.$el});
    Backbone.history.start();
  }
};
