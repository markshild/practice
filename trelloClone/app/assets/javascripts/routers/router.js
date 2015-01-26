TrelloClone.Routers.Router = Backbone.Router.extend({
  routes: {
    '': "index",
    "boards/new" : "newBoard",
    "boards/:id": "showBoard"
  },

  initialize: function (options) {
    this.$el = options.$el;
    this.collection = new TrelloClone.Collections.Boards();
    this.collection.fetch();
  },

  index: function () {

    var indexView = new TrelloClone.Views.BoardsIndex({
      collection: this.collection
    });
    this._swapView(indexView);
  },

  newBoard: function () {
    var newView = new TrelloClone.Views.BoardsNew({
      collection: this.collection
    });
    this._swapView(newView);
  },

  showBoard: function (id) {
    var model = this.collection.getOrFetch(id);
    var showView = new TrelloClone.Views.BoardsShow({
      model: model
    });
    this._swapView(showView);
  },

  _swapView: function (view) {
    this.currentView && this.currentView.remove();
    this.currentView = view;
    this.$el.html(view.render().$el);
  }
});
