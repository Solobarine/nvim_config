set number
set mouse=a
set clipboard=unnamedplus
call plug#begin()
" Autocompletion
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Buffers
Plug 'akinsho/bufferline.nvim'

" Floating Terminal
Plug 'voldikss/vim-floaterm'

Plug 'neovim/nvim-lspconfig'
"Plug 'mhanberg/elixir.nvim'
Plug 'elixir-editors/vim-elixir'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'

Plug 'onsails/lspkind-nvim'
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'rafamadriz/friendly-snippets'
Plug 'pmizio/typescript-tools.nvim'

" Formatting
Plug 'jose-elias-alvarez/null-ls.nvim'
Plug 'nvimtools/none-ls.nvim'

Plug 'kdheepak/lazygit.nvim'

"Markdown Preview
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npx --yes yarn install' }

" Auto Complete Brackets
Plug 'windwp/nvim-autopairs'

" File Finders
Plug 'MunifTanjim/nui.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

Plug 'jwalton512/vim-blade'

" Multi Cursor
Plug 'mg979/vim-visual-multi', {'branch': 'master'}

" Tree Sitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Nerd Commenter
Plug 'preservim/nerdcommenter'

" Terminal
Plug 'akinsho/toggleterm.nvim', {'tag' : '*'}

" Icons
Plug 'nvim-tree/nvim-web-devicons'
Plug 'ryanoasis/vim-devicons'

" React Snippets
" Plug 'dsznajder/vscode-es7-javascript-react-snippets', { 'do': 'yarn install --frozen-lockfile && yarn compile' }

" Lualine
Plug 'nvim-lualine/lualine.nvim'

" TailwindCSS Tool
Plug 'luckasRanarison/tailwind-tools.nvim'

" File Manager
Plug 'nvim-neo-tree/neo-tree.nvim'

" Themes
Plug 'folke/tokyonight.nvim'
Plug 'EdenEast/nightfox.nvim'
Plug 'sainnhe/everforest'
call plug#end()

set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set nofoldenable

set termguicolors

" Coc Explorer
:nmap <space>e <Cmd>Neotree toggle<CR>

nnoremap <silent> <leader>gg :LazyGit<CR>

colorscheme everforest

filetype plugin on

" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>` <cmd>CocList floaterm<cr>

" Move Code Lines
nnoremap <A-Down> :m .+1<CR>==
nnoremap <A-Up> :m .-2<CR>==
inoremap <A-Down> <Esc>:m .+1<CR>==gi
inoremap <A-Up> <Esc>:m .-2<CR>==gi
vnoremap <A-Down> :m '>+1<CR>gv=gv
vnoremap <A-Up> :m '<-2<CR>gv=gv

nmap <C-s> <Plug>MarkdownPreview
nmap <M-s> <Plug>MarkdownPreviewStop
nmap <C-p> <Plug>MarkdownPreviewToggle

" Format Elixir code
" nnoremap <leader>j <cmd>lua vim.lsp.buf.format()<cr>
" autocmd BufWritePre * lua vim.lsp.buf.format()
" autocmd BufWritePre *.ex,*.exs lua vim.lsp.buf.format()

" Make text ittalics
highlight Comment        cterm=italic gui=italic
highlight Keyword        cterm=italic gui=italic
highlight Identifier     cterm=italic gui=italic
highlight Function       cterm=italic gui=italic
highlight Type           cterm=italic gui=italic
highlight Statement      cterm=italic gui=italic

if has('win32') || has('win64')
    set clipboard+=unnamedplus
    let g:clipboard = {
        \ 'name': 'win32yank',
        \ 'copy': {
        \ 'func': 'clip.exe',
        \ },
        \ 'paste': {
        \ 'func': 'powershell.exe Get-Clipboard',
        \ },
        \ 'cache': {
        \ 'func': 'powershell.exe Get-Clipboard -Format Text',
        \ },
        \ }
endif

autocmd FileType javascript,typescript,json,typescriptreact,javascriptreact let b:coc_enabled = 0

lua <<EOF
vim.diagnostic.config({
  float = {
    max_width = nil,
  },
})

-- Override float handler to enable wrap
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics,
  {
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = false,
  }
)

-- Override `vim.diagnostic.open_float` to enable line wrapping
vim.diagnostic.open_float = (function(original)
  return function(bufnr, opts)
    opts = opts or {}
    opts.wrap = true -- this tells nvim to wrap long lines
    opts.border = opts.border or "rounded"
    return original(bufnr, opts)
  end
end)(vim.diagnostic.open_float)

-- On Attach Capabilities
local on_attach = function(_, bufnr)
  local bufmap = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
  end

  bufmap("n", "gd", vim.lsp.buf.definition, "Go to Definition")
  bufmap("n", "gD", vim.lsp.buf.declaration, "Go to Declaration")
  bufmap("n", "gi", vim.lsp.buf.implementation, "Go to Implementation")
  bufmap("n", "gr", vim.lsp.buf.references, "Find References")
  bufmap("n", "K", vim.lsp.buf.hover, "Hover Documentation")
  bufmap("n", "<C-k>", vim.lsp.buf.signature_help, "Signature Help")
  bufmap("n", "<leader>rn", vim.lsp.buf.rename, "Rename Symbol")
  bufmap("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
  bufmap("n", "<leader>f", function() vim.lsp.buf.format({ async = true }) end, "Format File")
  bufmap("n", "gl", vim.diagnostic.open_float, "Line Diagnostics")
  bufmap("n", "[d", vim.diagnostic.goto_prev, "Prev Diagnostic")
  bufmap("n", "]d", vim.diagnostic.goto_next, "Next Diagnostic")
end

require("config.diagnostics").setup()

require("bufferline").setup{}
require('lualine').setup()
require("nvim-autopairs").setup {}
require("toggleterm").setup{
open_mapping = [[<c-\>]],
shade_filetypes = {},
}

require'nvim-treesitter.configs'.setup {
	highlight = {
		enable = false,
		-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
		-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
		-- Using this option may slow down your editor, and you may see some duplicate highlights.
		-- Instead of true it can also be a list of languages
		additional_vim_regex_highlighting = false,
	},
}

local cmp = require("cmp")
local lspconfig = require("lspconfig")
local cmp_nvim_lsp = require("cmp_nvim_lsp")

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
 
cmp.setup({
  snippet= {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'path' },
  },
})

-- Elixir LSP Config
lspconfig.elixirls.setup({
  cmd = { "/home/solly/.elixir-ls/release/language_server.sh" },
  capabilities = cmp_nvim_lsp.default_capabilities(),
  settings = {
    elixirLS = {
      dialyzerEnabled = true,
      fetchDeps = true,
    }
  },
  on_attach = on_attach
})

-- Ruby LSP Config
lspconfig.ruby_lsp.setup({
on_attach = on_attach
})

-- Typescript LSP Config
require("typescript-tools").setup({
on_attach = on_attach
})

-- Python LSP Config
lspconfig.pylsp.setup({})

-- Golang LSP Config
lspconfig.gopls.setup({
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
      gofumpt = true,
    },
  },
})

-- PHP LSP Config
if vim.uv == nil then
  vim.uv = vim.loop
end

lspconfig.intelephense.setup({
  on_attach = on_attach,
  filetypes = { "php" },
})

-- Emmet Configuration
lspconfig.emmet_language_server.setup({
  filetypes = { "css", "eruby", "html", "javascript", "javascriptreact", "less", "sass", "scss", "pug", "typescriptreact" },
  on_attach = on_attach
})

-- TailwindCSS Configuration
require("tailwind-tools").setup({
  on_attach = on_attach
})

-- Setup null-ls for formatting and diagnostics
local null_ls = require("null-ls")
null_ls.setup({
  sources = {
    null_ls.builtins.formatting.prettier.with({
      filetypes = { "javascript", "typescript", "typescriptreact", "javascriptreact", "html", "json", "yaml", "markdown" }
    }),
    null_ls.builtins.diagnostics.eslint.with({
      condition = function(utils)
        return utils.root_has_file({ ".eslintrc.js", ".eslintrc.json" })
      end
    }),
  }
})

-- Format On Save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.ts", "*.tsx", "*.js", "*.jsx", "*.ex", "*.exs" },
  callback = function()
    vim.lsp.buf.format({
      async = false,
      filter = function(client)
        if vim.bo.filetype == "elixir" then
          return client.name == "elixirls"
        else
          return client.name == "null-ls"
        end
      end,
    })
  end,
})

-- Telescopr Config
require("telescope").setup{
defaults = {
	file_ignore_patterns = {
		"node_modules/",
	        "vendor/",
	        "%.bundle/",
	        "log/",
	        "tmp/",
	        "_build/",
	        "deps/",
	        "__pycache__/",
	        "%.venv/",
	        "env/",
	        "build/",
		}
	}
}


