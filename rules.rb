def check_rules(rules)
  # Create a hash of sets to store connections
  connections = Hash.new { |h, k| h[k] = Set.new }
  
  # Build the connection graph
  rules.each do |from, to|
    connections[from].add(to)
    connections[to].add(from)
  end
  
  # Find all connected components
  visited = Set.new
  result = []
  
  connections.keys.each do |node|
    next if visited.include?(node)
    
    # Start a new component
    component = Set.new
    stack = [node]
    
    # Process the current component
    while current = stack.pop
      next if visited.include?(current)
      visited.add(current)
      component.add(current)
      
      # Add unvisited neighbors to stack
      connections[current].each do |neighbor|
        stack << neighbor unless visited.include?(neighbor)
      end
    end
    
    result << component.to_a.sort
  end
  
  result
end

rules1 = [
  ["A", "B"],
  ["B", "C"],
  ["C", "D"],
]

output = check_rules(rules1)
# output should be [["A","B","C","D"]]

rules2 = [
  ["A", "B"],
  ["C", "D"],
  ["D", "E"],
  ["F", "G"],
]
output = check_rules(rules1)
# output should be [["A","B"],["C","D""E"],["F","G"]]
