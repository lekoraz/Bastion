-- Create a new Config class
---@class Config
local Config = {}
Config.__index = Config

-- Constructor
---@return Config
function Config:New()
    local self = setmetatable({}, Config)
    self.configs = {}
    return self
end

-- Register a new config
---@param module string
---@param config table
---@return nil
function Config:Register(module, config)
    self.configs[module] = config
end

-- Get a config
---@param module string
---@return table | nil
function Config:Get(module)
    return self.configs[module]
end

return Config
