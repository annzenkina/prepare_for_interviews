# cache = LRUCache.new(capacity)
#
# cache.get(key)    # Returns the value if key exists, else -1
# cache.put(key, value)  # Insert or update the value for key. If the cache is full, evict the least recently used item.
#
# Requirements:
# - Must run in O(1) time for both get and put
# - Use a doubly linked list to track LRU order
# - Use a hash map to access nodes by key quickly
# - Capacity is fixed at initialization

class Node
  attr_accessor :key, :value, :next, :prev

  def initialize(key = nil, value = nil)
    @key = key
    @value = value
    @next = nil
    @prev = nil
  end
end

class LRUCache
  attr_reader :head, :tail, :current_capacity
  attr_accessor :max_capacity

  def initialize(max_capacity = 1)
    @head = nil
    @tail = nil
    @current_capacity = 0
    @max_capacity = max_capacity
    @cache = {}  # Hash map to store key -> node mappings
  end
  
  def get(key)
    if @cache[key]
      node = @cache[key]
      return node.value
      if @cache[key] != @head
        node.next = @head
        node.prev = nil
        @head.prev = node
        @head = node
      end  
      if @cache[key] == @tail
        @tail = @tail.prev
        @tail&.next = nil
      end
    else
      return "Key #{key} not found in cache"
    end
  end

  def log_out
    puts "head: #{@head&.key}, tail: #{@tail&.key}, max_capacity: #{@max_capacity}, current_capacity: #{@current_capacity}"
  end

  def put(key, value)
    if @cache[key]
      # Update existing node
      node = @cache[key]
      node.value = value
      # Move to head if not already there
      if node != @head
        # Remove from current position
        if node == @tail
          @tail = node.prev
          @tail&.next = nil
        else
          # this was hard! I should have make a picture
          node.prev.next = node.next
          node.next&.prev = node.prev
        end
        # Move to head
        node.next = @head
        node.prev = nil
        @head.prev = node
        @head = node
      end
    else
      # Create new node
      node = Node.new(key, value)
      @cache[key] = node
      
      if @current_capacity == @max_capacity
        @cache.delete(@tail&.key)
        @tail = @tail&.prev
        @tail&.next = nil
        @current_capacity -= 1
      end
      
      if @head.nil?
        @head = @tail = node
      else
        node.next = @head
        @head.prev = node
        @head = node
      end
      @current_capacity += 1
    end
    log_out
  end
end

# Test cases to verify O(1) operations
puts "\n=== Testing LRU Cache Operations ==="
cache = LRUCache.new(3)

puts "\n1. Basic put operations:"
puts "cache.put(1, 11)"
cache.put(1, 11)
puts "cache.put(2, 22)"
cache.put(2, 22)
puts "cache.put(3, 33)"
cache.put(3, 33)

puts "\n2. Update existing key (should move to head):"
puts "cache.put(1, 111)"
cache.put(1, 111)
puts "cache.get(1)"
puts "Calue for key 1: #{cache.get(1)}"

puts "\n3. Get existing key (should move to head):"
puts "cache.get(2)"
puts "Value for key 2: #{cache.get(2)}"

puts "\n4. Get non-existent key:"
puts "cache.get(5)"
puts "Value for key 5: #{cache.get(5)}"

puts "\n5. Put when cache is full (should evict LRU):"
puts "cache.put(4, 44)"
cache.put(4, 44)

puts "\n6. Get recently used key (should still be there):"
puts "cache.get(1)"
puts "Value for key 1: #{cache.get(1)}"

puts "\n7. Get least recently used key (should be evicted):"
puts "cache.get(3)"
puts "Value for key 3: #{cache.get(3)}"