local M = {}

function M.notify(title, msg, level)
  if not level then level = "info" end
  vim.notify(msg, vim.log.levels[level:upper()], { title = title })
end

function M.info(msg)
  M.notify("Pixovr", msg, "info")
end

function M.warn(msg)
  M.notify("Pixovr", msg, "warn")
end

function M.error(msg)
  M.notify("Pixovr", msg, "error")
end

--- Validate whether the plugins are installed
---@param plugins table List of plugins
---@return boolean
function M.validatePlugins(plugins)
  local valid = true
  for _, plugin in ipairs(plugins) do
    if not pcall(require, plugin) then
      valid = false
    end
  end
  return valid
end

return M
