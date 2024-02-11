# frozen_string_literal: true

require "./lib/node"

# My BST implementation
class Tree
  attr_accessor :root

  def initialize(array)
    clean_array = array.uniq.sort
    p clean_array
    self.root = build_tree(clean_array, 0, clean_array.length - 1)
  end

  def build_tree(array, start, last)
    return if start > last

    mid = (start + last) / 2
    node = Node.new(array[mid])
    node.left = build_tree(array, start, mid - 1)
    node.right = build_tree(array, mid + 1, last)
    node
  end

  def pretty_print(node = root, prefix = "", is_left = true)
    return p nil if node.nil?

    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def insert(value, node = root)
    return Node.new(value) if node.nil?

    node.left = insert(value, node.left) if value < node.data
    node.right = insert(value, node.right) if value > node.data
    node
  end

  def delete(value, node = root)
    if value == node.data
      new_node = delete_cases(node)
      return node.data == root.data ? self.root = new_node : new_node
    end

    node.left = delete(value, node.left) if value < node.data
    node.right = delete(value, node.right) if value > node.data
    node
  end

  def delete_cases(node)
    return if node.left.nil? && node.right.nil?
    return node.left if node.right.nil?
    return node.right if node.left.nil?

    delete_full_node(node)
  end

  def delete_full_node(node)
    new_node = next_biggest node
    delete(new_node.data, node)
    new_node.right = node.right
    new_node.left = node.left
    new_node
  end

  def next_biggest(node)
    node = node.right
    node = node.left until node.left.nil?
    node
  end

  def find(value, node = root)
    if node.nil? || value == node.data
      node
    elsif value < node.data
      find(value, node.left)
    else
      find(value, node.right)
    end
  end

  def level_order
    queue = []
    values = [] unless block_given?
    queue.push(root) unless root.nil?
    while queue.length.positive?
      node = queue.shift
      queue.push node.left unless node.left.nil?
      queue.push node.right unless node.right.nil?
      block_given? ? yield(node) : values.push(node.data)
    end
    values
  end

  def inorder(node = root, &block)
    return if node.nil?

    left = inorder(node.left, &block) || []
    mid = block&.call(node) || [node.data]
    right = inorder(node.right, &block) || []
    block_given? || left + mid + right
  end

  def preorder(node = root, &block)
    return if node.nil?

    left = block&.call(node) || [node.data]
    mid = preorder(node.left, &block) || []
    right = preorder(node.right, &block) || []
    block_given? || left + mid + right
  end

  def postorder(node = root, &block)
    return if node.nil?

    left = postorder(node.left, &block) || []
    mid = postorder(node.right, &block) || []
    right = block&.call(node) || [node.data]
    block_given? || left + mid + right
  end

  def height(node, h = 0)
    return h - 1 if node.nil?

    [height(node.left, h + 1), height(node.right, h + 1)].max
  end

  def depth(node, root = self.root, d = 0)
    return d if node.data == root.data

    if node.data < root.data
      depth(node, root.left, d + 1)
    else
      depth(node, root.right, d + 1)
    end
  end

  def balanced?(node = root)
    queue = []
    queue.push(root) unless root.nil?
    while queue.length.positive?
      node = queue.shift
      queue.push node.left unless node.left.nil?
      queue.push node.right unless node.right.nil?
      left = height(node.left)
      right = height(node.right)
      return false if (left - right).abs > 1
    end
    true
  end

  def rebalance
    array = inorder
    self.root = build_tree(array, 0, array.length - 1)
  end
end
