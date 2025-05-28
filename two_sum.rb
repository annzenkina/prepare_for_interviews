def two_sum(nums, target)
  # Create a dictionary where numbers are both keys and values
  num_dict = {}
  nums.each_with_index do |num, index|
    num_dict[num] = index
  end
  
  # Array to store all pairs
  pairs = []
  
  # Iterate through the array once
  nums.each_with_index do |num, index|
    complement = target - num
    
    # Check if complement exists in dictionary and it's not the same index
    if num_dict.key?(complement) && num_dict[complement] != index
      # Add the pair if we haven't added it before (to avoid duplicates)
      pair = [index, num_dict[complement]].sort
      pairs << pair unless pairs.include?(pair)
    end
  end
  
  pairs
end

# Test cases
nums = [2, 7, 11, 15, 3, 6]
target = 9
puts "Input: nums = #{nums}, target = #{target}"
puts "Output: #{two_sum(nums, target)}"  # Expected: [[0, 1], [4, 5]]

# Additional test case
nums2 = [3, 2, 4, 1, 5]
target2 = 6
puts "\nInput: nums = #{nums2}, target = #{target2}"
puts "Output: #{two_sum(nums2, target2)}"  # Expected: [[1, 2], [0, 4]]

# Test case with duplicate numbers
nums3 = [3, 3, 4, 2, 1]
target3 = 6
puts "\nInput: nums = #{nums3}, target = #{target3}"
puts "Output: #{two_sum(nums3, target3)}"  # Expected: [[0, 1]]

# Test case with ?
nums4 = [5, 1, 1, 1, 5]
target4 = 6
puts "\nInput: nums = #{nums4}, target = #{target4}"
puts "Output: #{two_sum(nums4, target4)}"  # Expected: [[0, 1]]
