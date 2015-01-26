TrelloClone.Views.BoardsIndex = Backbone.View.extend({

  template: JST['boards/index'],

  className: 'boards-index',

  initialize: function () {
    this.listenTo(this.collection, 'sync delete', this.render);
  },

  events: {
    "click .delete": "deleteBoard"
  },

  render: function () {
    var content = this.template({
      boards: this.collection
    });

    this.$el.html(content);
    return this;
  },

  deleteBoard: function (event) {
    event.preventDefault();
    var $target = $(event.target);
    var id = $target.data('id');
    var modelDelete = this.collection.get(id);
    modelDelete.destroy();
    this.render();
  }


});
