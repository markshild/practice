Pokedex.Views = {}

Pokedex.Views.PokemonIndex = Backbone.View.extend({
  events: {
    'click li': 'selectPokemonFromList'
  },

  initialize: function () {
    this.collection = new Pokedex.Collections.Pokemon();

    this.listenTo(this.collection, 'refresh', this.render)
  },

  addPokemonToList: function (pokemon) {
    var content = JST['pokemonListItem']({pokemon: pokemon});

    this.$el.append(content);
  },

  refreshPokemon: function (options, callback) {
    this.collection.fetch({
      success: function () {
        this.render();
        callback && callback();
      }.bind(this)
    })
  },

  render: function () {
    console.log("hey!")
    this.$el.empty();
    this.collection.each( function(pokemon) {
      this.addPokemonToList(pokemon);
    }.bind(this))
  },

  selectPokemonFromList: function (event) {
    var $target = $(event.target);

    var pokeId = $target.data('id');

    Backbone.history.navigate("pokemon/" + pokeId, {trigger: true})

  }
});

Pokedex.Views.PokemonDetail = Backbone.View.extend({
  events: {
    "click li": "selectToyFromList"
  },

  refreshPokemon: function (options, callback) {
    this.model.fetch({
      success: function () {
        this.render();
        callback && callback();
      }.bind(this)
    });

  },

  render: function () {
    var content = JST['pokemonDetail']({ pokemon: this.model });

    this.$el.html(content);

    this.model.toys().each( function(toy) {
      var content = JST['toyListItem']({ toy: toy });
      this.$el.append(content);
    }.bind(this))

  },

  selectToyFromList: function (event) {
    var $target = $(event.target);

    var toyId = $target.data('id');
    var pokeId = $target.data('pokemon-id');

    Backbone.history.navigate("pokemon/" + pokeId + "/toys/" + toyId, {trigger: true})
  }
});

Pokedex.Views.ToyDetail = Backbone.View.extend({
  render: function () {
    var content = JST['toyDetail']({ toy: this.model, pokes: this.collection });

    this.$el.html(content);
  }
});


// $(function () {
//   var pokemonIndex = new Pokedex.Views.PokemonIndex();
//   pokemonIndex.refreshPokemon();
//   $("#pokedex .pokemon-list").html(pokemonIndex.$el);
// });
