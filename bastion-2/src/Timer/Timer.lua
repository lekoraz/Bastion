local Tinkr, Bastion = ...

-- Create a new Timer class
---@class Timer
local Timer = {
    startTime = nil,
    resetAfterCombat = false,
    paused = false,
    pauseTime = 0
}
Timer.__index = Timer

-- Constructor
---@param type string
---@return Timer
function Timer:New(type)
    local self = setmetatable({}, Timer)
    self.startTime = nil
    self.type = type
    self.paused = false
    self.pauseTime = 0
    return self
end

-- Start the timer
---@return nil
function Timer:Start()
    self.startTime = GetTime()
    self.paused = false
    self.pauseTime = 0
end

-- Get the time since the timer was started
---@return number
function Timer:GetTime()
    if not self:IsRunning() then
        return 0
    end
    if self.paused then
        return self.pauseTime - self.startTime
    end
    return GetTime() - self.startTime
end

-- Check if the timer is running
---@return boolean
function Timer:IsRunning()
    return self.startTime ~= nil
end

-- Reset the timer
---@return nil
function Timer:Reset()
    self.startTime = nil
    self.paused = false
    self.pauseTime = 0
end

-- Pause the timer
---@return nil
function Timer:Pause()
    if self:IsRunning() and not self.paused then
        self.paused = true
        self.pauseTime = GetTime()
    end
end

-- Resume the timer
---@return nil
function Timer:Resume()
    if self:IsRunning() and self.paused then
        self.startTime = self.startTime + (GetTime() - self.pauseTime)
        self.paused = false
        self.pauseTime = 0
    end
end

return Timer
