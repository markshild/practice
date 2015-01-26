Pokedex.Router = Backbone.Router.extend({
  routes: {
    "": "pokemonIndex",
    "pokemon/:id": "pokemonDetail",
    "pokemon/:pokemonId/toys/:toyId": "toyDetail"
  },

  pokemonDetail: function (id, callback) {
    var renderSelf = function () {
      var pokemon = this._pokemonIndex.collection.get(id);

      var pokemonDetail = new Pokedex.Views.PokemonDetail({
        model: pokemon
      });
      this._pokemonDetail = pokemonDetail;

      $("#pokedex .pokemon-detail").html(pokemonDetail.$el);
      pokemonDetail.refreshPokemon({}, callback);

    }.bind(this);

    if (this._pokemonIndex) {
      renderSelf();
    } else {
      this.pokemonIndex(renderSelf);
    }
  },

  pokemonIndex: function (callback) {
    var pokemonIndex = new Pokedex.Views.PokemonIndex();
    pokemonIndex.refreshPokemon({}, callback);

    this._pokemonIndex = pokemonIndex;
    this.pokemonForm();
    $("#pokedex .pokemon-list").html(pokemonIndex.$el);
  },

  toyDetail: function (pokemonId, toyId) {
    var renderSelf = function () {
      var toy = this._pokemonDetail.model.toys().get(toyId);
      var toyDetail = new Pokedex.Views.ToyDetail({ model: toy, collection: this._pokemonIndex.collection });

      $("#pokedex .toy-detail").html(toyDetail.$el);
      console.log(toyDetail);
      toyDetail.render();
    }.bind(this);

    if (this._pokemonDetail) {
      renderSelf();
    } else {
      this.pokemonDetail(pokemonId, renderSelf);
    }
  },

  pokemonForm: function () {
    var formView = new Pokedex.Views.PokemonForm({
      model: new Pokedex.Models.Pokemon(),
      collection: this._pokemonIndex.collection
    });

    formView.render();

    $('#pokedex .pokemon-form').html(formView.$el);
  }
});


$(function () {
  new Pokedex.Router();
  Backbone.history.start();
});
