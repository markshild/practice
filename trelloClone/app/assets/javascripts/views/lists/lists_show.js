TrelloClone.Views.ListsShow = Backbone.CompositeView.extend({



  events: {
  },

  template: JST['lists/show'],

  className: 'list-display',

  initialize: function () {
    this.collection = this.model.cards();
    this.listenTo(this.model, 'sync', this.render);
    this.listenTo(this.collection, 'add', this.addCard);
  },

  render: function () {
    var content = this.template({
      list: this.model
    });
    this.$el.html(content);
    this.$el.data('list-id', this.model.id);

    this.renderCards();
    return this;
  },

  renderCards: function () {
    this.model.cards().each(this.addCard.bind(this));
    this.$('.list-cards').sortable({connectWith: '.list-cards'});
  },

  addCard: function (card) {
    var view = new TrelloClone.Views.CardsShow({
      model: card
    });
    this.addSubview('.list-cards', view);
  },

  receiveCard: function(event, ui) {
    var $cardDisplay = ui.item;
    cardId = $cardDisplay.data('card-id');
    var cardClone = new TrelloClone.Models.Card({
      id: cardId,
      list_id: this.model.id
    });
    cardClone.save();
    this.collection.add(cardClone, {silent: true});
    // this.saveCards(event);
  },

  removeCard: function(event, ui) {
    var $cardDisplay = ui.item,
    cardId = $cardDisplay.data('card-id'),
    cards = this.model.cards(),
    cardToRemove = cards.get(cardId),
    cardSubviews = this.subviews('.list-cards');
    cards.remove(cardToRemove);

    var subviewToRemove = _.findWhere(cardSubviews, {model: cardToRemove});
    cardSubviews.splice(cardSubviews.indexOf(subviewToRemove), 1);
  },

  // saveCards: function(event) {
  //   event.stopPropagation(); /
  //   this.saveOrds();
  // }
});

// orderOptions: {
//   modelElement: '.card-display',
//   modelName: 'card',
//   subviewContainer: '.list-cards'
// },
