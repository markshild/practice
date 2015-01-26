def is_prime?(num)
  (2..num/2).each do |n|
    if num % n == 0
      return false
    end
  end
  true
end

def primes(count)
  return [] if count == 0
  return [2] if count == 1
  prime = [2]
  i=3
  until prime.length == count
    prime << i if is_prime?(i)
    i+=1
  end
  prime
end

# the "calls itself recursively" spec may say that there is no method
# named "and_call_original" if you are using an older version of
# rspec. You may ignore this failure.
def factorials_rec(num)
  return [] if num == 0
  return [1] if num == 1
  x = factorials_rec(num-1)
  x << x.last*num
  x
end

class Array
  def dups
    x = Hash.new {|hash,key| hash[key] = []}
    self.each_with_index do |el,ind|
      x[el].concat([ind])
    end
    x.keep_if {|key, value| value.length > 1}
    x
  end
end

class String
  def symmetric_substrings
    strings = []
    arr = self.split('')
    arr.each_index do |ind1|
      arr.each_index do |ind2|
        next if ind2<= ind1
        x = self[ind1..ind2]
        strings << x if x == x.reverse
      end
    end
    strings
  end
end

class Array
  def merge_sort(&prc)
    prc ||= Proc.new {|left,right| left <=> right }

    return self if count < 2
    
    mid = self.length/2

    left = self.take(mid)
    right = self.drop(mid)

    merge(left.merge_sort(&prc),right.merge_sort(&prc),&prc)

  end

  def merge(left,right,&prc)
    final = []
    until left.empty? || right.empty?
      case prc.call(left.first,right.first)
      when -1
        final << left.shift
      when 0
        final << left.shift
      when 1
        final << right.shift
      end

    end
    final + left + right

  end
end
