local M = {}

--- @class HMLSignsOptions
--- @field H? string Sign to use for the `H` line number
--- @field M? string Sign to use for the `M` line number
--- @field L? string Sign to use for the `L` line number

--- @class HMLOptions
--- @field signs? HMLSignsOptions
local options = {
  signs = {
    H = 'H',
    M = 'M',
    L = 'L',
  },
}

local state = {
  previous_statuscolumn = nil,
  enabled = false,
}

---Gets the line numbers for H, M, L, respectively
---@return { H: number, M: number, L: number }
function M.get()
  local scrolloff = vim.wo.scrolloff
  local last_line = vim.fn.line('$')

  local viewport_top = vim.fn.line('w0')
  local viewport_bottom = vim.fn.line('w$')
  local viewport_middle = math.floor((viewport_bottom - viewport_top) / 2 + viewport_top)

  local H = viewport_top + scrolloff
  if viewport_top == 1 then
    H = 1
  elseif H > viewport_middle then
    H = math.max(H, scrolloff)
  end

  local L = viewport_bottom - scrolloff
  if viewport_bottom >= last_line then
    L = last_line
  elseif L < viewport_middle then
    L = viewport_middle
  end

  return {
    H = H,
    M = math.max(viewport_middle, H),
    L = L,
  }
end

---@return string
function M.get_status_column()
  if not vim.o.number then
    return ''
  end

  local current_line = vim.fn.line('.')
  local lnum = vim.v.lnum

  -- NOTE: If the last line is visible, `L` will jump to that line regardless
  -- of `scrolloff`. Similarly, if the first line is visible, `H` will jump to
  -- the first line regardless of `scrolloff`

  local hml = M.get()

  local line_number
  -- Current line
  if lnum == current_line then
    line_number = tostring(lnum)
  elseif lnum == hml.H then
    line_number = options.signs.H
  elseif lnum == hml.M then
    line_number = options.signs.M
  elseif lnum == hml.L then
    line_number = options.signs.L
  else
    -- All other lines
    line_number = tostring(vim.o.relativenumber and vim.v.relnum or vim.v.lnum)
  end

  -- Don't draw line numbers on virtual/wrapped lines
  return vim.v.virtnum == 0 and line_number or ''
end

function M.enable()
  local sign_column = '%s'
  local line_number = '%=%{%v:lua.require("hml").get_status_column()%}'
  local fold_column = '%C'
  local padding = ' '

  state.previous_statuscolumn = vim.o.statuscolumn
  vim.o.statuscolumn = sign_column .. line_number .. fold_column .. padding

  state.enabled = true
end

function M.disable()
  vim.o.statuscolumn = state.previous_statuscolumn
  state.enabled = false
end

function M.toggle()
  if state.enabled then
    M.disable()
  else
    M.enable()
  end
end

---@param opts table?
function M.setup(opts)
  options = vim.tbl_deep_extend('force', options, opts or {})

  M.enable()
end

return M
