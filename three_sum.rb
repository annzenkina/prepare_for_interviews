def three_sum(arr)
  result = []
  
  arr.each_with_index do |element_i, i|
    arr.each_with_index do |element_j, j|
      next if i == j
      
      target = -(element_i + element_j)
      if arr.include?(target)
        k = arr.index(target)
        if k != i && k != j
          triplet = [element_i, element_j, target].sort
          result << triplet unless result.include?(triplet)
        end
      end
    end
  end
  p result
  result
end

three_sum([0,0,0])