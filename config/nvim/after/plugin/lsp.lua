local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
    -- see :help lsp-zero-keybindings to learn the available actions
    lsp_zero.default_keymaps({ buffer = bufnr })
    local opts = { buffer = bufnr, remap = false }

    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)


require('mason').setup({})
require('mason-lspconfig').setup({
    ensure_installed = {
        "ruff_lsp",
    },
    handlers = {
        lsp_zero.default_setup,
    },
})


--require 'lspconfig'.pylsp.setup {
    --settings = {
        --pylsp = {
            ----configurationSources = { 'flake8' },
            --plugins = {
                --flake8 = {
                    --enabled = false,
                --},
                --rope_autoimport = {
                    --enabled = true,
                --},
                --pylsp_mypy = {
                    --enabled = true, -- TODO: Enable this
                --},
                --pycodestyle = {
                    --enabled = true,
                    --ignore = {
                        --"E501",
                    --},
                    --conventions = {
                        --"pep8",
                    --}
                --},
                --mccabe = {
                    --enabled = false,
                --},
                --pyflakes = {
                    --enabled = false,
                --},
            --}
        --}
    --}
--}

require('lspconfig').ruff_lsp.setup {
    init_options = {
        settings = {
            -- Any extra CLI arguments for `ruff` go here.
            args = {
            },
        }
    }
}

lsp_zero.setup()
vim.diagnostic.config({
    virtual_text = true
})
