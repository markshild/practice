TrelloClone.Views.BoardsShow = Backbone.CompositeView.extend({

  template: JST['boards/show'],

  className: 'boards-show',

  initialize: function () {
    this.listenTo(this.model, 'sync', this.render);
    this.collection = this.model.lists();
    this.listenTo(this.collection, 'add', this.addList);
  },

  events: {
    "click .delete": "deleteBoard"
  },

  render: function () {
    var content = this.template({
      board: this.model
    });

    this.$el.html(content);
    this.renderLists();
    this.renderListForm();
    return this;
  },

  deleteBoard: function (event) {
    var $target = $(event.target);
    
  },

  addList: function (list) {
    var view = new TrelloClone.Views.ListsShow({
      model: list
    });
    this.addSubview('#lists', view);
  },

  renderLists: function () {
    this.model.lists().each(this.addList.bind(this));
    this.$('#lists').sortable();
  },

  renderListForm: function () {
    var view = new TrelloClone.Views.ListForm({
      collection: this.collection
    });
    this.addSubview('#list-form', view);
  }
});
