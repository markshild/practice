TrelloClone.Views.CardsShow = Backbone.CompositeView.extend({



  events: {
  },

  template: JST['cards/show'],

  className: 'card well well-sm card-display',

  initialize: function () {
    // this.collection = this.model.cards();
    this.listenTo(this.model, 'sync', this.render.bind(this));
  },

  render: function () {
    var content = this.template({
      card: this.model
    });
    this.$el.html(content);
    return this;
  },


});

// orderOptions: {
//   modelElement: '.card-display',
//   modelName: 'card',
//   subviewContainer: '.list-cards'
// },
