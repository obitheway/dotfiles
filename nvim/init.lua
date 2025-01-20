-- Ensure packer is installed
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({
      "git",
      "clone",
      "https://github.com/wbthomason/packer.nvim",
      install_path,
    })
    vim.cmd([[packadd packer.nvim]])
  end
end

ensure_packer()

-- Plugin setup using packer
require("packer").startup(function(use)
  -- Packer can manage itself
  use "wbthomason/packer.nvim"
  
  -- alpha-vim
  use {
	  'goolord/alpha-nvim',
	  requires = { 'nvim-tree/nvim-web-devicons' },
	  config = function ()
		  require'alpha'.setup(require'alpha.themes.startify'.config)
	  end
  }

  -- nvim-cmp - completions engin
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/nvim-cmp'

  -- git-gutter
  use 'airblade/vim-gitgutter'

  -- Add NvimTree plugin
  use {
    'nvim-tree/nvim-tree.lua',
    requires = {'nvim-tree/nvim-web-devicons'}, --These don't seem 2 be loadingOptional: for icons
    config = function()
      -- NvimTree configuration
      require('nvim-tree').setup({
        -- Disable netrw at the very start
        disable_netrw = true,
        hijack_netrw = true,
        view = {
          width = 30,  -- Set file tree width
          side = "left",  -- Position file tree on the left
        },
        git = {
          enable = true,
          ignore = false,
        },
      })
    end
  }

    -- Set up nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
        -- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
  })

  -- To use git you need to install the plugin petertriho/cmp-git and uncomment lines below
  -- Set configuration for specific filetype.
  --[[ cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'git' },
    }, {
      { name = 'buffer' },
    })
 })
 require("cmp_git").setup() ]]-- 

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    }),
    matching = { disallow_symbol_nonprefix_matching = false }
  })

  -- LSP support (using nvim-lspconfig)
  use "neovim/nvim-lspconfig"
  
  -- Syntax highlighting for specific languages using treesitter
  use "nvim-treesitter/nvim-treesitter"
  
  -- Correct colorscheme (Aura Dark) from daltonmenezes repository
  use {
    "daltonmenezes/aura-theme",
    rtp = "packages/neovim",  -- Specify runtime path for the Aura theme
    config = function()
      vim.cmd("colorscheme aura-dark") -- Set Aura Dark as the colorscheme (or any other Aura theme)
    end
  }

  -- File Explorer (NerdTree-like)
  use "preservim/nerdtree"
  
  -- Git integration
  use "tpope/vim-fugitive"
  
  -- Statusline (modern)
  use "nvim-lualine/lualine.nvim"
end)

-- Treesitter setup for syntax highlighting for Nix, Rust, and Python
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "nix", "rust", "python" },  -- Only install for specific languages
  highlight = {
    enable = true,            -- Enable syntax highlighting
    additional_vim_regex_highlighting = false,
  },
}

-- Statusline setup using lualine
require('lualine').setup {
  options = {
    theme = 'auto', -- Set to a theme of your choice (Aura Dark can be used here as well)
  },
  sections = {
    lualine_b = {'branch'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  }
}

-- Keybinding to toggle NvimTree
vim.api.nvim_set_keymap('n', '<Leader>e', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

-- General Neovim Settings
vim.opt.number = true               -- Show line numbers
vim.opt.relativenumber = true       -- Show relative line numbers
vim.opt.cursorline = true           -- Highlight the current line
vim.opt.termguicolors = true        -- Enable true color support

