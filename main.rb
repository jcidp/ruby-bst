# frozen_string_literal: true

require "./lib/bst"

tree = Tree.new(Array.new(15) { rand(1..100) })
tree.pretty_print
p tree.balanced?
p tree.level_order
p tree.preorder
p tree.postorder
p tree.inorder
arr = Array.new(15) { rand(101..200) }
arr.each { |e| tree.insert e }
tree.pretty_print
p tree.balanced?
tree.rebalance
tree.pretty_print
p tree.balanced?
p tree.level_order
p tree.preorder
p tree.postorder
p tree.inorder
