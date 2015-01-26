Pokedex.RootView.prototype.renderPokemonDetail = function (pokemon) {
  var $ul = $("<ul>").addClass('detail')
  var $img = $('<img>').attr('src', pokemon.get('image_url'));
  $ul.append($img);

  Object.keys(pokemon.attributes).forEach(function (attr) {
    var $prop = null;
    if (attr === 'image_url') {
      return;
    } else {
      $prop = $('<li>').html(pokemon.get(attr));
    }
    $ul.append($prop);
  });
  $newUl = $('<ul>').addClass('toys')
  $ul.append($newUl);
  var that = this;
  pokemon.fetch({
    success: function() {
      pokemon.toys().each( function (toy) {
        that.addToyToList(toy);
      })
      that.renderToysList(pokemon.toys())
    }
  });

  this.$pokeDetail.append($ul);
};

Pokedex.RootView.prototype.selectPokemonFromList = function (event) {
  var $target = $(event.target);
  var currentID = $target.data('id');
  var pokemon = this.pokes.get(currentID);
  this.renderPokemonDetail(pokemon);


};
