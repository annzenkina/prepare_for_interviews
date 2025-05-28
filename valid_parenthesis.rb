def valid_parenthesis(str)
  brackets = {"(" => ")", "[" => "]", "{" => "}"}
  stack = []
  
  str.each_char do |char|
    if brackets.key?(char)
      stack.push(char)
    elsif !stack.empty? && brackets[stack.last] == char
      stack.pop
    else
      return false
    end
  end
  
  stack.empty?
end

puts ("True: #{valid_parenthesis("()")}")
puts ("True: #{valid_parenthesis("([])")}")
puts ("False: #{valid_parenthesis("([)]")}")
puts ("True: #{valid_parenthesis("({})")}")
puts ("True: #{valid_parenthesis("({[()]})")}")
puts ("False: #{valid_parenthesis("({[()]")}")