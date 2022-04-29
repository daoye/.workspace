local tree = {}
tree.open = function()
    require 'bufferline.state'.set_offset(51, 'FileExplorer')
    require 'nvim-tree'.find_file(true)
end


tree.toggle = function()
    require 'bufferline.state'.set_offset(51, 'FileExplorer')
    require 'nvim-tree'.toggle()
end

tree.close = function()
    require 'bufferline.state'.set_offset(0)
    require 'nvim-tree'.close()
end

return tree
