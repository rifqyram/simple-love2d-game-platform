local player = require 'player'
local platform = require 'platform'

SCREEN_WIDTH = 1280
SCREEN_HEIGHT = 720

function love.load()
    Player = player:new('Budi', 10, 0, 100, 100)
    Platform = platform:new(10, 300, 500 - 100, 50)
end

function love.update(dt)
    Player:init(dt)

    if Player:isLandingOn(Platform) then
        Player.vy = 0
        Player.y = Platform.y - Player.height
        Player.isOnGround = true
    end

    if love.keyboard.isDown('a') then
        Player:moveLeft(dt)
        if Player:isHittingSideOf(Platform, 'right') then
            Player.x = Platform.x + Platform.width
        end
    end

    if love.keyboard.isDown('d') then
        Player:moveRight(dt)
        if Player:isHittingSideOf(Platform, 'left') then
            Player.x = Platform.x - Player.width
        end
    end
end

function love.keypressed(key)
    if key == 'space' and Player.isOnGround then
        Player:jump()
    end
end

function love.draw()
    love.graphics.print('FPS:' .. love.timer.getFPS(), 10, 10)

    Player:draw()
    Platform:draw()
end
