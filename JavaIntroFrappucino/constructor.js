var Cat = function (name, owner) {
  this.name = name;
  this.owner = owner;
}

Cat.prototype.cuteStatement = function () {
  console.log(this.owner + " loves " + this.name);


}

var garfield = new Cat("Garfield", "Jon");

garfield.cuteStatement();

var meowskers = new Cat("Mow", "Alberto");

Cat.prototype.cuteStatement = function () {
  console.log(this.owner + " hates " + this.name);


}

meowskers.cuteStatement();

meowskers.cuteStatement = function() {
  console.log('HBAEWBRAWEBREWR');
}

meowskers.cuteStatement();
garfield.cuteStatement();
