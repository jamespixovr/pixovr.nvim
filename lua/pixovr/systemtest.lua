local overseer = require 'overseer'
local u = require("pixovr.utils")
local input = require("pixovr.textinput")

local name = "RunSystemTest"

local M = {}

local function run_system_test(tags, lifecycle)
  if not tags then
    u.notify(name .. ":", "No tags found", "warn")
    return
  end
  local user_cmd = "go test -failfast -v --godog.random --godog.tags=" .. tags .. " -l " .. lifecycle
  u.info("running system test with tags: " .. tags)
  local task = overseer.new_task({
    cmd = user_cmd,
    name = name,
    components = { 'default' }
  })
  task:start()
  -- overseer.toggle()
end

--- Collect all the tags from the current line
---@return string|nil
local function getAllLineTags()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  row, col = row - 1, col

  local line = vim.api.nvim_buf_get_lines(0, row, row + 1, true)[1]
  line = line:gsub('^%s+', '') -- lstrip
  line = line:gsub('%s+$', '') -- rstrip

  if not line:match("^@") then
    u.notify(name .. ":", "Only works with tags (@)", "warn")
    return
  end

  -- remove @ from the line
  line = line:gsub("@", "")
  line = line:gsub("%s+", ",")

  return line
end

--- Validate if the filetype is cucumber
---@return boolean
local function isCucumberFileType()
  local filetype = vim.bo.filetype
  if filetype ~= "cucumber" then
    u.notify(name .. ":", "the current file is not supported", "warn")
    return false
  end

  return true
end

local function isGolangFile()
  local filetype = vim.bo.filetype
  if filetype ~= "go" then
    u.notify(name .. ":", "the current file is not supported", "warn")
    return false
  end

  return true
end

M.systemTestLocal = function()
  if not isCucumberFileType() then
    return
  end

  local lifecycle = "local"

  local line = getAllLineTags()

  run_system_test(line, lifecycle)
end


M.systemTestLifecycle = function()
  if not isCucumberFileType() then
    return
  end

  local function callback_fn(lifecycle)
    local line = getAllLineTags()
    run_system_test(line, lifecycle)
  end

  input.selectLifecycle(callback_fn)
end

M.ginkgoBookstrap = function()
  if not isGolangFile() then
    return
  end

  local dir = vim.fn.expand('%:p:h')

  local user_cmd = "cd " .. dir .. " && ginkgo bookstrap"

  local task = overseer.new_task({
    cmd = user_cmd,
    name = name,
    components = { 'default' }
  })
  task:start()
end

M.ginkgoGenerate = function()
  if not isGolangFile() then
    return
  end

  local dir = vim.fn.expand('%:p:h')

  local function callback_fn(fileName)
    local user_cmd = "cd " .. dir .. " && ginkgo generate" .. " " .. fileName
    local task = overseer.new_task({
      cmd = user_cmd,
      name = name,
      components = { 'default' }
    })
    task:start()
  end

  input.trigger_input(callback_fn)
end

return M
