local input = require("pixovr.textinput")
local overseer = require("overseer")
local u = require("pixovr.utils")

local M = {}

-- Constants
local TASK_NAME = "RunSystemTest"
local DEFAULT_COMPONENTS = { "default" }

-- Type definitions
---@alias Lifecycle string "local" | "dev" | "staging" | "prod"
---@alias TestFileType string "cucumber" | "go"

-- Helper functions
---@param cmd string The command to run
---@param name? string Optional task name override
---@param components? table Optional components override
---@return nil
local function run_task(cmd, name, components)
  local task = overseer.new_task({
    cmd = cmd,
    name = name or TASK_NAME,
    components = components or DEFAULT_COMPONENTS,
  })
  task:start()
end
---@param required_type string The required filetype
---@return boolean
local function validate_filetype(required_type)
  local filetype = vim.bo.filetype
  if filetype ~= required_type then
    u.notify(TASK_NAME .. ":", "the current file is not supported", "warn")
    return false
  end
  return true
end

---@return string|nil
local function get_all_line_tags()
  local row = vim.api.nvim_win_get_cursor(0)[1] - 1
  local line = vim.api.nvim_buf_get_lines(0, row, row + 1, true)[1]
  line = line:gsub("^%s+", ""):gsub("%s+$", "") -- trim

  if not line:match("^@") then
    u.notify(TASK_NAME .. ":", "Only works with tags (@)", "warn")
    return
  end
  local tags = line:gsub("@", "")
  return (tags:gsub("%s+", ","))
end
---@param tags string|nil The tags to filter tests
---@param lifecycle Lifecycle The lifecycle stage
---@param is_debug boolean Whether to run in debug mode
---@param components? table Optional components override
---@return nil
local function run_system_test(tags, lifecycle, is_debug, components)
  if not tags then
    u.notify(TASK_NAME .. ":", "No tags found", "warn")
    return
  end

  local cmd = string.format(
    "go test -failfast -v --godog.random --godog.tags=%s -l %s%s",
    tags,
    lifecycle,
    is_debug and " --debug" or ""
  )

  u.info("running system test with tags: " .. tags)
  run_task(cmd, nil, components)
end

-- Cucumber test functions
function M.system_test_local()
  if not validate_filetype("cucumber") then
    return
  end
  run_system_test(get_all_line_tags(), "local", false)
end

function M.system_test_local_with_debug()
  if not validate_filetype("cucumber") then
    return
  end
  run_system_test(get_all_line_tags(), "local", true, {
    "default",
    { "on_complete_dispose", statuses = { "SUCCESS" }, timeout = 900 },
    { "open_output", focus = true, on_start = "always" },
  })
end

function M.system_test_lifecycle()
  if not validate_filetype("cucumber") then
    return
  end
  input.selectLifecycle(function(lifecycle)
    run_system_test(get_all_line_tags(), lifecycle, false)
  end)
end

-- Ginkgo functions
function M.ginkgo_bootstrap()
  if not validate_filetype("go") then
    return
  end
  local dir = vim.fn.expand("%:p:h")
  run_task("cd " .. dir .. " && ginkgo bookstrap", "Ginkgo Bootstrap")
end

function M.ginkgo_generate()
  if not validate_filetype("go") then
    return
  end
  local dir = vim.fn.expand("%:p:h")
  input.trigger_input(function(filename)
    run_task("cd " .. dir .. " && ginkgo generate " .. filename, "Ginkgo Generate")
  end)
end

return M
