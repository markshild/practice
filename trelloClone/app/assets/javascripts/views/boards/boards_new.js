TrelloClone.Views.BoardsNew = Backbone.View.extend({

  template: JST['boards/new'],

  className: 'boards-new',

  initialize: function () {

  },

  events: {
    "click .submit": "addBoard"
  },

  render: function () {
    var content = this.template({
      boards: this.collection
    });

    this.$el.html(content);
    return this;
  },

  addBoard: function (event) {
    event.preventDefault();
    var title = this.$('input').val();
    var newBoard = new TrelloClone.Models.Board({
      'title': title
    });
    newBoard.save({}, {
      success: function () {
        this.collection.add(newBoard);
        Backbone.history.navigate('', {trigger: true})
      }.bind(this)
    });
  }


});
