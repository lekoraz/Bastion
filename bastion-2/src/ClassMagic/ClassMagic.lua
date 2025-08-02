---@class ClassMagic
local ClassMagic = {}
ClassMagic.__index = ClassMagic

---@param Class table
---@param key string
---@return any
function ClassMagic:Resolve(Class, key)
    if Class[key] or Class[key] == false then
        return Class[key]
    end

    local function callGetter(getter)
        local result = { getter(self) }
        if #result > 1 then
            return result
        end
        return result[1]
    end

    local getterName = 'Get' .. key:sub(1, 1):upper() .. key:sub(2)
    if Class[getterName] then
        return callGetter(Class[getterName])
    end

    getterName = 'Get' .. key:upper()
    if Class[getterName] then
        return callGetter(Class[getterName])
    end

    getterName = 'Is' .. key:upper()
    if Class[getterName] then
        return callGetter(Class[getterName])
    end

    return Class[key]
end

return ClassMagic
