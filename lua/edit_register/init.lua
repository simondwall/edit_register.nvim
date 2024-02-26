local nui_popup_ok, nui_popup = pcall(require, "nui.popup")
local nui_autocmd_ok, nui_autocmd = pcall(require, "nui.utils.autocmd")
if not nui_popup_ok or not nui_autocmd_ok then
    vim.notify("'edit_register.nvim' requires 'nui.nvim'", vim.log.levels.ERROR)
    return
end

local M = {}

local regs = {
    ['0'] = true, -- number registers
    ['1'] = true,
    ['2'] = true,
    ['3'] = true,
    ['4'] = true,
    ['5'] = true,
    ['6'] = true,
    ['7'] = true,
    ['8'] = true,
    ['9'] = true,
    ['a'] = true, -- letter registers
    ['b'] = true,
    ['c'] = true,
    ['d'] = true,
    ['e'] = true,
    ['f'] = true,
    ['g'] = true,
    ['h'] = true,
    ['i'] = true,
    ['j'] = true,
    ['k'] = true,
    ['l'] = true,
    ['m'] = true,
    ['n'] = true,
    ['o'] = true,
    ['p'] = true,
    ['q'] = true,
    ['r'] = true,
    ['s'] = true,
    ['t'] = true,
    ['u'] = true,
    ['v'] = true,
    ['w'] = true,
    ['x'] = true,
    ['y'] = true,
    ['z'] = true,
    ['"'] = true, -- unnamed register
    ['-'] = true, -- small delete register
    ['#'] = true, -- buffer register
    ['/'] = true, -- search register

}

--- Set the register to the content of the buffer
--- @param register string The register to set (the register is not checked)
--- @param bufnr number The buffer number to get the content from
local function set_register(register, bufnr)
    local content = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    vim.fn.setreg(register, content)
end

--- Setup edit_register.nvim
--- @param opts {} Options for edit_register.nvim
function M.setup(opts)
    M.opts = opts or {
        popup = {
            enter = true,
            border = {
                style = "rounded",
                text = {
                    top_align = "center",
                },
            },
            position = "50%",
            size = {
                width = "20%",
                height = "20%",
            },
        }
    }
end

--- Edit a specific register.
--- @param register string The register to edit
function M.reg(register)
    if M.opts == nil then
        vim.notify("edit_register.nvim is not setup", vim.log.levels.ERROR)
        vim.notify("call `require'edit_register'.setup({})`", vim.log.levels.INFO)
        return
    end

    if not regs[register] then
        vim.notify("register " .. register .. " is not writable or does not exist", vim.log.levels.ERROR)
        return
    end

    local content = vim.fn.getreg(register)
    content = string.gsub(content, "\n", "")

    local popup_opts = M.opts.popup
    popup_opts.border.text.top = "Register " .. register
    local popup = nui_popup(popup_opts)
    popup:mount()
    popup:on(nui_autocmd.event.BufLeave, function()
        popup:unmount()
    end)
    popup:map("n", "<esc>", function()
        popup:unmount()
    end)
    popup:map("n", "<cr>", function()
        set_register(register, popup.bufnr)
        popup:unmount()
    end)
    vim.api.nvim_buf_set_lines(popup.bufnr, 0, 1, false, { content })
end

return M
