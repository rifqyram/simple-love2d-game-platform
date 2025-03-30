Platform = {}

function Platform:new(x, y, width, height)
    local obj = {
        x = x,
        y = y,
        width = width,
        height = height,
        color = { 0, 0, 1 },
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Platform:draw()
    love.graphics.setColor(self.color)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
    love.graphics.setColor(1, 1, 1)
end

return Platform
