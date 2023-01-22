idx = 0

class LinkedList
  class Node
    attr_accessor :next, :prev, :val, :idx

    def initialize(val:, idx:)
      self.val = val
      self.idx = idx
    end

    def to_s
      "#{self.val}|{#{self.idx}}"
    end
  end

  attr_accessor :lowest, :highest, :calories

  def initialize
    @calories = []
  end

  def add(x, idx)
    x = x.to_i
  
    # shortcut for adding the first element
    if @lowest == nil
      @lowest = @highest = Node.new(val: x, idx: idx)
      @calories[idx] = x
      return
    end

    node = @lowest
    prev_node = @lowest.prev
  
    is_new = @calories.length <= idx
    @calories[idx] = is_new ? x : @calories[idx] + x

    while node != nil
      if is_new
        if x < node.val
          new_node = Node.new(val: x, idx: idx)
          new_node.next = node
          new_node.prev = node.prev

          if node.prev.nil?
            @lowest = new_node
          else
            node.prev.next = new_node
          end
          node.prev = new_node

          return
        end
      elsif node.idx == idx
        node.val = @calories[idx]

        # linked list is in the right order
        return if node.next.nil? || node.val < node.next.val

        node.next.prev = node.prev unless node.next.nil?
        node.prev.next = node.next unless node.prev.nil?

        @lowest = node.next if node.prev.nil?

        prev_rebal_node = node.prev
        rebal_node = node.next

        while !rebal_node.nil?
          if node.val > rebal_node.val
            prev_rebal_node = rebal_node
            rebal_node = rebal_node.next
            next
          end
          
          # move node in the middle of the linked list
          if rebal_node.prev.nil?
            @lowest = node
          else
            rebal_node.prev.next = node
          end

          node.prev = rebal_node.prev
          node.next = rebal_node

          rebal_node.prev = node

          return
        end

        # move node to the end of the linked list
        prev_rebal_node.next = node
        node.prev = prev_rebal_node
        node.next = nil
        @highest = node

        return
      end

      prev_node = node
      node = node.next
    end

    # create node at the end of the linked list
    new_node = Node.new(val: x, idx: idx)
    prev_node.next = new_node
    new_node.prev = prev_node
    @highest = new_node
  end

  def sum(top:)
    acc = 0
    node = @highest

    for n in 1..top do
      acc += node.val
      
      node = node.prev
      return acc if node.nil?
    end

    return acc
  end

  def to_s(reverse=false)
    resp = '['
    n = reverse ? @lowest : @highest
    while n != nil
      resp += n.to_s + ','
      n = reverse ? n.next : n.prev
    end

    (resp[-1] == ',' ? resp.chop : resp) + ']'
  end
end

ll = LinkedList.new

File.foreach('aoc1_input.txt') do |x|
  if x.strip == ''
    idx += 1
    next
  else
    ll.add(x, idx)
  end
end

puts ll.to_s
puts "idx: #{ll.highest.idx}, calories: #{ll.highest.val}"
puts "top 3: #{ll.sum(top: 3)}"