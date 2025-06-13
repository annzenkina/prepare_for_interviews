def candies(children_ratings)
  candies = Array.new(children_ratings.length, 1)

  peak_index = 0

  children_ratings.each_with_index do |current_rating, index|
    if index != 0
      if current_rating > children_ratings[index - 1]
        candies[index] = candies[index - 1] + 1
      end
    end
    if index !=  children_ratings.length - 1
      if current_rating > children_ratings[index + 1]
        peak_index = index
        candies[index] += 1
      end
    end
  end
  sum = 0
  candies.each { |candy| sum += candy }
  puts candies.inspect
  sum
end

puts "Test Case 1: [1, 0, 2]"
puts "Solution should be: [2, 1, 2]"
puts "Total candies needed: #{candies([1, 0, 2])}"
puts "------------------------"
puts "Test Case 2: [1, 2, 2]"
puts "Solution should be: [1, 2, 1]"
puts "Total candies needed: #{candies([1, 2, 2])}"
puts "------------------------"
puts "Test Case 3: [1, 2, 3, 4]"
puts "Solution should be: [1, 2, 3, 4]"
puts "Total candies needed: #{candies([1, 2, 3, 4])}"
puts "------------------------"
puts "Test Case : [4, 3, 2, 1]"
puts "Solution should be: [4, 3, 2, 1]"
puts "Total candies needed: #{candies([4, 3, 2, 1])}"