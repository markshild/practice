TrelloClone.Views.CardForm = Backbone.LinkFormView.extend({
  formTemplate: JST['cards/new'],
  linkTemplate: JST['cards/form_link'],
  className: 'col-md-3',

  create: function (event) {
    event.preventDefault();
    this.collection.create({

      title: this.$('textarea').val(),
      list_id: this.collection.list.id
    }, { wait: true });
    this.$('textarea').val('');
  },

  render: function () {
    var content;
    if(this.formShowing) {
      content = this.formTemplate();
    } else {
      content = this.linkTemplate();
    }

    this.$el.html(content);
    this.delegateEvents();
    this.collection.trigger('resize');
    return this;
  }
});
