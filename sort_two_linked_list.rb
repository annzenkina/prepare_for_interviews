class ListNode
  attr_accessor :value, :next

  def initialize(value = 0)
    @value = value
    @next = nil
  end
end

class LinkedList
  attr_accessor :head

  def initialize(head = nil)
    @head = head
  end

  def append(value)
    new_node = ListNode.new(value)

    if @head.nil?
      @head = new_node
      return
    end

    current = @head
    current = current.next while current.next
    current.next = new_node
  end

  def sort_list
    return if @head.nil? || @head.next.nil?
    
    # Example of slow and fast pointer technique:
    # Let's say we have a list: 1 -> 2 -> 3 -> 4 -> 5
    # 
    # Initial state:
    # slow = 1, fast = 2
    # 
    # First iteration:
    # slow moves to 2, fast moves to 4
    # 
    # Second iteration:
    # slow moves to 3, fast moves to nil (end of list)
    # 
    # Now slow is at the middle (3)
    
    # Initialize pointers
    slow = @head        # Will move one step at a time
    fast = @head.next   # Will move two steps at a time
    
    # Keep moving until fast reaches the end
    while fast && fast.next
      slow = slow.next      # Move slow one step
      fast = fast.next.next # Move fast two steps
    end
    
    # At this point:
    # - slow is at the middle of the list
    # - fast has reached the end
    # 
    # Example result:
    # Original: 1 -> 2 -> 3 -> 4 -> 5
    # After split:
    # Left:  1 -> 2 -> 3
    # Right: 4 -> 5
    
    # Create two separate lists by breaking the connection
    right_head = slow.next
    slow.next = nil  # Break the connection at the middle
    
    # Recursively sort both halves
    left = sort_list_recursive(@head)
    right = sort_list_recursive(right_head)
    
    # Merge the sorted halves
    @head = merge_sorted_lists(left, right)
  end

  private

  def sort_list_recursive(head)
    return head if head.nil? || head.next.nil?
    
    # Same slow and fast pointer technique for recursive calls
    slow = head
    fast = head.next
    
    while fast && fast.next
      slow = slow.next
      fast = fast.next.next
    end
    
    right_head = slow.next
    slow.next = nil
    
    left = sort_list_recursive(head)
    right = sort_list_recursive(right_head)
    
    merge_sorted_lists(left, right)
  end

  def merge_sorted_lists(l1, l2)
    dummy = ListNode.new
    current = dummy
    
    while l1 && l2
      if l1.value <= l2.value
        current.next = l1
        l1 = l1.next
      else
        current.next = l2
        l2 = l2.next
      end
      current = current.next
    end
    
    # Append remaining nodes
    current.next = l1 if l1
    current.next = l2 if l2
    
    dummy.next
  end

  def print_list
    current = @head
    while current.next
      print "#{current.value} -> "
      current = current.next
    end
    print "#{current.value}\n"
  end
end

def merge_two_lists(list1, list2)
  merged_list = LinkedList.new()
  current1 = list1.head
  current2 = list2.head

  while current1 && current2
      merged_list.append(current1.value)
      merged_list.append(current2.value)
      current1 = current1.next
      current2 = current2.next
  end
  if !current1 || current2
    while current2
      merged_list.append(current2.value)
      current2 = current2.next
    end
  elsif !current2 || current1
    while current1
      merged_list.append(current1.value)
      current1 = current1.next
    end
  end

  merged_list.sort_list
  merged_list.print_list
  
end

# Test the implementation with a clear example
list1 = LinkedList.new()
list1.append(1)
list1.append(4)
list1.append(2)
list1.append(5)
list1.append(7)
print "Original list: "
list1.print_list
list1.sort_list
print "Sorted list: "
list1.print_list

list2 = LinkedList.new()
list2.append(1)
list2.append(3)
list2.append(5)
list2.append(6)
print "Second list: "
list2.print_list  

print "Merged and sorted result: "
merge_two_lists(list1, list2)

# list 1: 1 -> 2 -> 4
# list 2: 1 -> 3 -> 5

# output: 1 -> 1 -> 2 -> 3 -> 4 -> 5


