-- You probably always want to set this in your vim file
vim.opt.background = 'dark'
vim.g.colors_name = 'plana'
package.loaded['plana'] = nil
require('lush')(require('plana'))

