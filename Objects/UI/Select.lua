---@class Select
local Select = Class:extend()

---@param x number The x position
---@param y number The y position
---@param width number The width
---@param height number The height
---@param options table<any> Table of options
---@param value any The starting value
---@param name string The name of the Select
---@param description string The description of the Select
function Select:new(x, y, width, height, options, value, name, description)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.options = options
    self.selected = value or options[1].option
    self.expanded = false
    self.name = name
    self.hovered = false
    self.description = description
end

function Select:update()
    self.hovered = CursorX > self.x and CursorX < self.x + self.width and CursorY > self.y and CursorY < self.y + self.height

    if self.hovered then 
        cursorText = self.description
    end

    if Input:pressed("MouseLeft") then
        if self.expanded then
            for i, option in ipairs(self.options) do
                local optionY = self.y + (i * self.height)
                if CursorX >= self.x and CursorX <= self.x + self.width and CursorY >= optionY and CursorY <= optionY + self.height then
                    self.selected = option.option
                    if option.func then option.func() end
                    self.expanded = false
                    break
                end
            end
        end
        if self.hovered then
            self.expanded = not self.expanded
        else
            self.expanded = false -- close it when you click outside of the selections
        end
    end
end

function Select:draw()
    -- Draw the main select box
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
    love.graphics.printf(self.selected, self.x + 10, self.y + 10, self.width - 20, "center")

    -- Draw the dropdown menu
    if self.expanded then
        for i, option in ipairs(self.options) do
            local optionY = self.y + (i * self.height)
            love.graphics.rectangle("line", self.x, optionY, self.width, self.height)
            love.graphics.printf(option.option, self.x + 10, optionY + 10, self.width - 20, "center")
        end
    end
end

function Select:giveValue()
    return self.selected
end

return Select
