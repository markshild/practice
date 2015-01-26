def range(st,fin)
  return [] if fin < st
  range(st, fin-1) << fin
end

def sumrec(array)
  return 0 if array.empty?
  array.first + sumrec(array[1..-1])
end

def sumit(array)
  i = 0
  sum = 0
  until i == array.length
    sum += array[i]
    i += 1
  end
  sum
end

def recexp1(n,exp)
  return 1 if exp == 0
  n * recexp1(n,exp-1)
end

def dup(array)
  if array.is_a?(Array)
    array.each do |el|
      dup(el)
    end
  else
    return array
  end
end

def fib(n)
  return [1] if n == 1
  return [1,1] if n == 2
  fibs = fib(n-1)
  fibs << fibs.last + fibs[-2]
end

def bsearch(array, target)
  return nil if array.empty?

  mid = array.length/2
  case target <=> array[mid]
  when -1
    bsearch(array.take(mid), target)
  when 0
    mid
  when 1
    answer = bsearch(array.drop(mid+1), target)
    answer.nil? ? nil : mid + answer + 1
  end
end

def make_change(num, coins = [25,10,5,1])
  return [] if num == 0
  return nil if coins.all? {|coin| coin > target}
  best = nil
  coins.each do |coin|
    return make_change(num, coins[1..-1]) if coin > num

    poss = (make_change(rem,coins)

    poss << coin

    best = poss if best.nil? || poss.length < best.length
  end
  end

  best
end

def subsets(set)
  return [[]] if set.empty?
  sets = subsets(set[0...-1]).dup
  set[0...-1].each do |el|
     dups = el.dup
     dups << set.last
     sets << dups
  end
end
