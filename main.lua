local player = require 'player'
local platform = require 'platform'

SCREEN_WIDTH = 1280
SCREEN_HEIGHT = 720

function love.load()
    Player = player:new('Budi', 10, 0, 100, 100)

    Platforms = {
        platform:new(100, 300, 200, 30),
        platform:new(350, 250, 150, 30),
        platform:new(600, 200, 200, 30),
    }
end

function love.update(dt)
    Player:init(dt)

    if love.keyboard.isDown('a') then
        Player:moveLeft(dt)
    end

    if love.keyboard.isDown('d') then
        Player:moveRight(dt)
    end

    for _, p in ipairs(Platforms) do
        if Player:isLandingOn(p) then
            Player.vy = 0
            Player.y = p.y - Player.height
            Player.isOnGround = true
        end

        if Player.direction == 'left' and Player:isHittingSideOf(p, 'right') then
            Player.x = p.x + p.width
        end

        if Player.direction == 'right' and Player:isHittingSideOf(p, 'left') then
            Player.x = p.x - Player.width
        end
    end
end

function love.keypressed(key)
    if key == 'space' and Player.isOnGround then
        Player:jump()
    end

    if key == 'r' then
        Player:reset()
    end
end

function love.draw()
    love.graphics.print('FPS:' .. love.timer.getFPS(), 10, 10)

    Player:draw()

    for _, p in ipairs(Platforms) do
        p:draw()
    end
end
