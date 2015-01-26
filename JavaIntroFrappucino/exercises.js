Array.prototype.uniq = function() {
  var result = [] ;
  for (var i = 0; i < this.length; i++) {
    if (result.indexOf(this[i]) === -1) {
      result.push(this[i]);
    }
  }
  return result;
};

Array.prototype.twoSum = function() {
  var result = [] ;
  for (var i = 0; i < this.length; i++) {
    for (var j = i+1; j < this.length; j++) {
      if ((this[i] + this[j]) === 0) {
        result.push([i,j]);
      }
    }
  }
  return result;
}

  Array.prototype.transpose = function() {
    var result = [] ;
    for (var k = 0; k < this[0].length; k++){
      result.push([]);
    }
    for (var i = 0; i < this.length; i++){
      for (var j = 0; j < this[0].length; j++){
        result[j][i] = this[i][j];
      }
    }


    return result;
  }

Array.prototype.myEach = function (f) {

  for (i = 0; i < this.length; i++) {
    f(this[i]);
  }
};

Array.prototype.myMap = function (f) {
  var result = [];
  this.myEach( function(el) {
    result.push(f(el));
  });


  return result;
};

Array.prototype.myInject = function (start,f) {
  var result = start;
  this.myEach( function(el) {
    result = f(result, el);
  });


  return result;

};


Array.prototype.bubbleSort = function () {
  var sorted = false;
  while (sorted === false){
    sorted = true;
    for (var i = 0; i < this.length; i++) {
      for (var j = i+1; j < this.length; j++) {
        if (this[i] > this[j]){
          var temp = this[i];
          this[i] = this[j];
          this[j] = temp;
          sorted = false;
        }
      }
    }
  }
  return this
}

String.prototype.substrings = function() {
  var result = [] ;
  for (var i = 0; i < this.length; i++) {
    for (var j = i+1; j < this.length; j++) {
      result.push(this.substring(i,j))
    }
  }
  return result;
}

var range = function(start,end) {
  if (end < start) {
    return [];
  }
  return range(start, end - 1).concat(end);
}

var exp1 = function(num,exp) {
  if (exp === 0) { return 1;}
  return (num * exp1(num, exp -1));
};

var exp2 = function(num,exp) {
  if (exp === 0) { return 1;}
  if (exp === 1) { return num;}
  if (exp % 2 === 0) { return ((exp2(num, exp/2))*(exp2(num, exp/2)));}
  if (exp % 2 === 1) { return (num*(exp2(num, (exp-1)/2))*(exp2(num, (exp-1)/2)));}
}

var fibs = function(n) {
  if (n === 1) { return [1]}
  if (n === 2) { return [1,1]}
  return fibs(n-1).concat(fibs(n-1)[fibs(n-1).length - 1] + fibs(n-2)[fibs(n-2).length - 1])
}

Array.prototype.binarySearch = function (n) {
  var point = Math.floor(this.length/2);
  if (this[point] === n) { return point; }
  if (this.length === 1) { return nil; }
  if (n > this[point]) {
    return (point + (this.slice(point, this.length).binarySearch(n)));
  } else {
    return (this.slice(0, point)).binarySearch(n);
  }
}

var makeChange = function(change, coins) {
  if (change === 0) {
    return [];
    }
  if (change < coins.sort[1]) {
    return null;
    }
  coins.reverse()
  var bestChange = null;
  for (var i = 0; i < coins.length; i++) {
      if (coins[i] > change) { continue;}
       var remainder = change - coins[i];
       var bestRemainder = makeChange(remainder, coins.slice(i,coins.length));
       if (bestRemainder === null) {continue;}
       var thisChange = [coins[i]].concat(bestRemainder);
       if (bestChange === null || (thisChange.length < bestChange.length)) {
         bestChange = thisChange;

     }
  };

  return bestChange;

};

Array.prototype.subsets = function () {
  if (this.length === 0) {return [[]];}
  var piece = (this.slice(0, (this.length)-1).subsets());
  var that = this
  return piece.concat(
      piece.map(
        function(set) { return set.concat([life[life.length-1]]); }
    )
    );

};

console.log([1,2,3].subsets());
