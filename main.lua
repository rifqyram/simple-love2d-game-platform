local player = require 'player'
local platform = require 'platform'

LevelMap = {
    "........................",
    "......#####.............",
    "........................",
    "..........###...........",
    "####################....",
}

TILE_ZIZE = 32
SCREEN_WIDTH = #LevelMap[1] * TILE_ZIZE
SCREEN_HEIGHT = #LevelMap * TILE_ZIZE

function love.load()
    Player = player:new('Budi', 10, 0, 32, 32)

    Platforms = {}
    for rowIndex, row in ipairs(LevelMap) do
        for col = 1, #row do
            local symbol = row:sub(col, col)
            if symbol == '#' then
                local x = (col - 1) * TILE_ZIZE
                local y = (rowIndex - 1) * TILE_ZIZE
                table.insert(Platforms, platform:new(x, y, TILE_ZIZE, TILE_ZIZE))
            end
        end
    end
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
        Player:handleVerticalCollision(p)

        if Player.direction == 'left' and Player:isHittingSideOf(p, 'right') then
            Player.x = p.x + p.width
        end

        if Player.direction == 'right' and Player:isHittingSideOf(p, 'left') then
            Player.x = p.x - Player.width
        end
    end

    if Player.isOnGround then
        Player.coyoteTimer = Player.coyoteTime
    else
        Player.coyoteTimer = Player.coyoteTimer - dt
    end

    if Player.coyoteTimer < 0 then
        Player.coyoteTimer = 0
    end
end

function love.keypressed(key)
    if key == 'space' and (Player.isOnGround or Player.coyoteTimer > 0) then
        Player:jump()
    end

    if key == 'r' then
        Player:reset()
    end

    if key == 'f11' then
        local isFullscreen = love.window.getFullscreen()
        love.window.setFullscreen(not isFullscreen, "desktop")
    end
end

function love.draw()
    love.graphics.print('FPS:' .. love.timer.getFPS(), 10, 10)

    Player:draw()

    for _, p in ipairs(Platforms) do
        p:draw()
    end
end
