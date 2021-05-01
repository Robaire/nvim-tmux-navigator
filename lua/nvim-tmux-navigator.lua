
local bindings = {
    left = '<C-H>',
    down = '<C-J>',
    up = '<C-K>',
    right = '<C-L>',
    previous = '<C-\\>'
}

local function updateBindings(newBindings)
    if newBindings.left then bindings.left = newBindings.left end
    if newBindings.down then bindings.down = newBindings.down end
    if newBindings.up then bindings.up = newBindings.up end
    if newBindings.right then bindings.right = newBindings.right end
    if newBindings.previous then bindings.previous = newBindings.previous end
end

-- Must be global so it is seen by the remap
function tmuxAwareNavigate(direction)

    -- Check the direction to move
    if direction == 'p' then
        tmuxNavigate('p')
    else
        -- Check if we are moving out of the last pane
        -- Save the current window number
        local winNumber = vim.fn.winnr()

        -- Attempt to move to a new window
        vim.cmd('wincmd ' .. direction)

        -- Check if we actually moved
        if winNumber == vim.fn.winnr() then
            tmuxNavigate(direction)
        end
    end
end

local function tmuxNavigate(direction)

    -- Get the TMUX socket
    local sock = vim.fn.split(vim.fn.getenv('TMUX'), ',')[1]
    local pane = vim.fn.getenv('TMUX_PANE')
    
    -- Forward the move command to TMUX
    local cmd = 'tmux -S ' .. sock .. ' select-pane -t ' .. pane .. ' -' .. vim.fn.tr(direction, 'phjkl', 'lLDUR')
    local result = vim.fn.system(cmd)
end


local function setup(config)

    -- Check for user defined keymaps
    -- if config then
    --     if config.bindings then
    --         updateBindings(config.bindings)
    --     end
    -- end

    -- Check if NVIM is running in a TMUX environment
    if vim.fn.getenv('TMUX') == vim.NIL then

        -- Set the regular key bindings
        vim.api.nvim_set_keymap('n', bindings.left, ':wincmd h<CR>', {noremap = true, silent = true})
        vim.api.nvim_set_keymap('n', bindings.down, ':wincmd j<CR>', {noremap = true, silent = true})
        vim.api.nvim_set_keymap('n', bindings.up, ':wincmd k<CR>', {noremap = true, silent = true})
        vim.api.nvim_set_keymap('n', bindings.right, ':wincmd l<CR>', {noremap = true, silent = true})
    else

        -- Set the TMUX aware key bindings
        vim.api.nvim_set_keymap('n', bindings.left, ':lua tmuxAwareNavigate(\'h\')<CR>', {noremap = true, silent = true})
        vim.api.nvim_set_keymap('n', bindings.down, ':lua tmuxAwareNavigate(\'j\')<CR>', {noremap = true, silent = true})
        vim.api.nvim_set_keymap('n', bindings.up, ':lua tmuxAwareNavigate(\'k\')<CR>', {noremap = true, silent = true})
        vim.api.nvim_set_keymap('n', bindings.right, ':lua tmuxAwareNavigate(\'l\')<CR>', {noremap = true, silent = true})
        vim.api.nvim_set_keymap('n', bindings.previous, ':lua tmuxAwareNavigate(\'p\')<CR>', {noremap = true, silent = true})
    end
end

return {setup = setup}
