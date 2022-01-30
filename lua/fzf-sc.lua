-- local utils = require"fzf-sc/utils"

local M = {}

function M.setup(user_settings)

	local settings = user_settings or {}

	M.search_plugin = settings.search_plugin or "fzf.vim"

	-- TODO
	-- Add user defined finders
	-- if settings.custom_finders ~= nil then
	-- 	for finder_name, finder_func in pairs(settings.custom_finders) do
	-- 		require"fzf-sc.finders"[finder_name] = finder_func
	-- 	end
	-- end

	M.register_command()
end

function M.register_command()
vim.cmd[[
function s:fzfsc_complete(arg,line,pos)
	let l:commands = luaeval("require'fzf-sc.cmd'.get_command_names()")
    return join(sort(commands), "\n")
endfunction

command! -nargs=* -complete=custom,s:fzfsc_complete FzfSC lua require('fzf-sc.cmd').load_command(<f-args>)
]]
end

return M
