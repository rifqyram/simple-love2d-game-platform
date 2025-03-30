Player = {}

function Player:new(name, x, y, width, height)
    local obj = {
        name = name,
        spawnX = x,
        spawnY = y,
        x = x,
        y = y,
        width = width,
        height = height,
        vy = 0,
        gravity = 500,
        moveSpeed = 400,
        jumpForce = -300,
        isOnGround = false,
        direction = 'right',
        coyoteTime = 0.15,
        coyoteTimer = 0
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Player:draw()
    love.graphics.print(self.name, self.x, self.y - 20)
    love.graphics.rectangle('fill', math.floor(self.x), math.floor(self.y), self.width, self.height)
end

function Player:init(dt)
    self.isOnGround = false
    self.prevY = self.y
    self.vy = self.vy + self.gravity * dt
    self.y = self.y + self.vy * dt
end

function Player:jump()
    self.vy = self.jumpForce
    self.isOnGround = false
end

function Player:handleCoyoteJump(dt)
    if self.isOnGround then
        self.coyoteTimer = self.coyoteTime
    else
        self.coyoteTimer = self.coyoteTimer - dt
    end

    if self.coyoteTimer < 0 then
        self.coyoteTimer = 0
    end
end

function Player:moveLeft(dt)
    self.x = self.x - self.moveSpeed * dt
    self.direction = 'left'
end

function Player:moveRight(dt)
    self.x = self.x + self.moveSpeed * dt
    self.direction = 'right'
end

function Player:isLandingOn(obj)
    return self.vy > 0 and
        self.prevY + self.height <= obj.y and
        self.y + self.height >= obj.y and
        self.x + self.width > obj.x and
        self.x < obj.x + obj.width
end

function Player:isCollide(obj)
    return self.y + self.height > obj.y and
        self.y < obj.y + obj.height and
        self.x + self.width > obj.x and
        self.x < obj.x + obj.width
end

function Player:isHittingTopOf(obj)
    return self.vy < 0 and
        self.prevY >= obj.y + obj.height and
        self.y <= obj.y + obj.height and
        self.x + self.width > obj.x and
        self.x < obj.x + obj.width
end

function Player:isHittingSideOf(obj, direction)
    local tolerance = 5

    if direction == 'left' then
        return self.x < obj.x + tolerance and
            self.x + self.width > obj.x and
            self.y + self.height > obj.y and
            self.y < obj.y + obj.height
    elseif direction == 'right' then
        return self.x + self.width > obj.x + obj.width and
            self.x < obj.x + obj.width and
            self.y + self.height > obj.y and
            self.y < obj.y + obj.height
    end
    return false
end

function Player:handleVerticalCollision(obj)
    if self:isLandingOn(obj) then
        self.vy = 0
        self.y = obj.y - self.height
        self.isOnGround = true
    elseif self:isHittingTopOf(obj) then
        self.vy = 0
        self.y = obj.y + obj.height
    end
end

function Player:handleHorizontalCollision(obj)
    if self.direction == 'left' and self:isHittingSideOf(obj, 'right') then
        self.x = obj.x + obj.width
    end

    if self.direction == 'right' and self:isHittingSideOf(obj, 'left') then
        self.x = obj.x - self.width
    end
end

function Player:reset()
    self.x = self.spawnX
    self.y = self.spawnY
    self.vy = 0
    self.isOnGround = false
    self.coyoteTimer = 0
end

return Player
