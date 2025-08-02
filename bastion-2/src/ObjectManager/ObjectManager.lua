local Tinkr, Bastion = ...

---@class ObjectManager
---@field _lists table
---@field enemies List
---@field friends List
---@field activeEnemies List
---@field explosives List
local ObjectManager = {}
ObjectManager.__index = ObjectManager

function ObjectManager:New()
    local self = setmetatable({}, ObjectManager)

    self._lists = {}

    self.enemies = Bastion.List:New()
    self.friends = Bastion.List:New()
    self.activeEnemies = Bastion.List:New()
    self.explosives = Bastion.List:New()

    return self
end

-- Register a custom list with a callback
---@param name string
---@param cb function
---@return List | false
function ObjectManager:RegisterList(name, cb)
    if self._lists[name] then
        return false
    end

    self._lists[name] = {
        list = Bastion.List:New(),
        cb = cb
    }

    return self._lists[name].list
end

-- reset custom lists
---@return nil
function ObjectManager:ResetLists()
    for _, list in pairs(self._lists) do
        list.list:clear()
    end
end

-- Refresh custom lists
---@param object table
---@return nil
function ObjectManager:EnumLists(object)
    for _, list in pairs(self._lists) do
        local r = list.cb(object)
        if r then
            list.list:push(r)
        end
    end
end

-- Get a list
---@param name string
---@return List
function ObjectManager:GetList(name)
    return self._lists[name].list
end

-- Refresh all lists
---@return nil
function ObjectManager:Refresh()
    self.enemies:clear()
    self.friends:clear()
    self.activeEnemies:clear()
    self.explosives:clear()
    self:ResetLists()

    local objects = Objects()

    for _, object in pairs(objects) do
        self:EnumLists(object)

        if ({ [5] = true,[6] = true,[7] = true })[ObjectType(object)] then
            local unit = Bastion.UnitManager:GetObject(ObjectGUID(object))
            if not unit then
                unit = Bastion.Unit:New(object)
                Bastion.UnitManager:SetObject(unit)
            end

            if unit:GetID() == 120651 then
                self.explosives:push(unit)
            elseif unit:IsPlayer() and (unit:IsInParty() or unit == Bastion.UnitManager['player']) then
                self.friends:push(unit)
            elseif unit:IsEnemy() then
                self.enemies:push(unit)

                if unit:InCombatOdds() > 80 then
                    self.activeEnemies:push(unit)
                end
            end
        end
    end
end

return ObjectManager


-- -- Register a list of objects that are training dummies
-- local dummies = Bastion.ObjectManager:RegisterList('dummies', function(object)
--     if ObjectType(object) == 5 or ObjectType(object) == 6 then
--         local unit = Bastion.UnitManager:GetObject(ObjectGUID(object))

--         if not unit then
--             unit = Bastion.Unit:New(object)
--             Bastion.UnitManager:SetObject(unit)
--         end

--         if unit:GetID() == 198594 then
--             return unit
--         end
--     end
-- end)

-- dummies:each(function(dummy)
-- print(dummy:GetName())
-- end)
