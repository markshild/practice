Pokedex.Views = (Pokedex.Views || {});

Pokedex.Views.PokemonForm = Backbone.View.extend({
  events: {
    "submit form": "savePokemon"
  },

  render: function () {
    var content = JST['pokemonForm']();

    this.$el.html(content);
  },

  savePokemon: function (event) {
    event.preventDefault();
    var pokemon = $(event.currentTarget).serializeJSON()['pokemon']

    this.model.save(
      pokemon,
      {success: function(poke) {
        this.collection.add(poke);
        this.collection.trigger('refresh');
        Backbone.history.navigate("pokemon/" + poke.id, {trigger: true});
      }.bind(this)}
    )

    // console.log($(event.currentTarget).serializeJSON());
  }
});
