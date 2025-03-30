Coin = {}

function Coin:new(x, y, width, height)
    local obj = {
        x = x,
        y = y,
        r = 5,
        width = width,
        height = height
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Coin:draw()
    love.graphics.setColor(222 / 255, 137 / 255, 9 / 255)
    love.graphics.circle('fill', self.x, self.y, self.r)
    love.graphics.setColor(1, 1, 1)
end

return Coin
