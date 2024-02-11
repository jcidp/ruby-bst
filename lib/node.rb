# frozen_string_literal: true

# Nodes for a BST
class Node
  include Comparable
  attr_accessor :data, :left, :right

  def <=>(other)
    data <=> other.data
  end

  def initialize(data)
    self.data = data
    self.left = nil
    self.right = nil
  end
end
