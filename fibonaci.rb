def fibonacci_iterative(n)
  return 0 if n == 0
  return 1 if n == 1
  
  prev = 0
  curr = 1
  
  (2..n).each do |i|
    temp = curr
    curr = prev + curr
    prev = temp
  end
  
  curr
end

def fibonacci_recursive(n)
  return 0 if n == 0
  return 1 if n == 1
  fibonacci_recursive(n - 1) + fibonacci_recursive(n - 2)
end

# Example usage
puts "Iterative Fibonacci:"
(0..10).each do |n|
  puts "fibonacci(#{n}) = #{fibonacci_iterative(n)}"
end

puts "\nRecursive Fibonacci:"
(0..10).each do |n|
  puts "fibonacci(#{n}) = #{fibonacci_recursive(n)}"
end
