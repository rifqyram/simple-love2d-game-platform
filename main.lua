local player = require 'player'
local platform = require 'platform'
local coin = require 'coin'

LevelMap = {
    "........C...............",
    "......#####.............",
    "...........C............",
    "..........###...........",
    "####################....",
}

TILE_ZIZE = 32
SCREEN_WIDTH = #LevelMap[1] * TILE_ZIZE
SCREEN_HEIGHT = #LevelMap * TILE_ZIZE

Score = 0

function love.load()
    local playerSpawnX = 0
    local playerSpawnY = 0

    Platforms = {}
    Coins = {}

    for rowIndex, row in ipairs(LevelMap) do
        for col = 1, #row do
            local symbol = row:sub(col, col)
            local x = (col - 1) * TILE_ZIZE
            local y = (rowIndex - 1) * TILE_ZIZE

            if symbol == '#' then
                table.insert(Platforms, platform:new(x, y, TILE_ZIZE, TILE_ZIZE))
            elseif symbol == 'P' then
                playerSpawnX = x
                playerSpawnY = y
            elseif symbol == 'C' then
                table.insert(Coins, coin:new(x, y + 24, TILE_ZIZE / 2, TILE_ZIZE / 2))
            end
        end
    end

    Player = player:new('Budi', playerSpawnX, playerSpawnY, 32, 32)
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
        Player:handleHorizontalCollision(p)
    end

    Player:handleCoyoteJump(dt)

    for i, c in ipairs(Coins) do
        if Player:isCollide(c) then
            Score = Score + 1
            table.remove(Coins, i)
        end
    end
end

function love.keypressed(key)
    if key == 'space' and (Player.isOnGround or Player.coyoteTimer > 0) then
        Player:jump()
    end

    if key == 'r' then
        Player:reset()
    end
end

function love.draw()
    love.graphics.print('FPS:' .. tostring(love.timer.getFPS()), 10, 10)
    love.graphics.print('Score:' .. tostring(Score), 10, 30)

    Player:draw()

    for _, p in ipairs(Platforms) do
        p:draw()
    end

    for _, c in ipairs(Coins) do
        c:draw()
    end
end
