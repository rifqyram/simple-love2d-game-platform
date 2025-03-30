Enemy = {}

function Enemy:new(x, y, width, height)
    local obj = {
        x = x,
        y = y,
        width = width,
        height = height,
        speed = 60,
        direction = 'right',
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Enemy:draw()
    love.graphics.setColor(237 / 255, 59 / 255, 0)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
    love.graphics.print('Monster', self.x, self.y - 20)
    love.graphics.setColor(1, 1, 1)
end

function Enemy:checkWallCollision(platforms)
    for _, p in ipairs(platforms) do
        local tolerance = 5
        if self.direction == 'left' and
            self.x <= p.x + p.width and
            self.x + self.width > p.x and
            self.y + self.height > p.y and
            self.y < p.y + p.height then
            self:flipDirection()
        elseif self.direction == 'right' and
            self.x + self.width >= p.x and
            self.x < p.x + p.width and
            self.y + self.height > p.y and
            self.y < p.y + p.height then
            self:flipDirection()
        end
    end
end

function Enemy:checkGround(platforms)
    local checkX = self.x + (self.direction == 'right' and self.width or -1)
    local checkY = self.y + self.height + 1

    local hasGround = false
    for _, p in ipairs(platforms) do
        if checkX >= p.x and checkX <= p.x + p.width and
            checkY >= p.y and checkY <= p.y + p.height then
            hasGround = true
            break
        end
    end

    if not hasGround then
        self:flipDirection()
    end
end

function Enemy:move(dt)
    if self.direction == 'left' then
        self.x = self.x - self.speed * dt
    elseif self.direction == 'right' then
        self.x = self.x + self.speed * dt
    end
end

function Enemy:flipDirection()
    if self.direction == 'left' then
        self.direction = 'right'
    else
        self.direction = 'left'
    end
end

function Enemy:hitBy(hitBox)
    return self.y + self.height > hitBox.y and
        self.y < hitBox.y + hitBox.height and
        self.x + self.width > hitBox.x and
        self.x < hitBox.x + hitBox.width
end

function Enemy:update(dt, platforms)
    self:move(dt)
    self:checkGround(platforms)
    self:checkWallCollision(platforms)
end

return Enemy
