local player = require 'player'
local platform = require 'platform'
local coin = require 'coin'
local enemy = require 'enemy'

LevelMap = {
    "P.......C...............",
    "......#####.............",
    "...........C............",
    "..........###......E....",
    "########################",
}

TILE_SIZE = 32
LEVEL_WIDTH = #LevelMap[1] * TILE_SIZE
LEVEL_HEIGHT = #LevelMap * TILE_SIZE

SCREEN_WIDTH = love.graphics.getWidth()
SCREEN_HEIGHT = love.graphics.getHeight()

OFFSET_X = (SCREEN_WIDTH - LEVEL_WIDTH) / 2
OFFSET_Y = (SCREEN_HEIGHT - LEVEL_HEIGHT) / 2

Score = 0

function love.load()
    local playerSpawnX = 0
    local playerSpawnY = 0

    Platforms = {}
    Coins = {}
    Enemies = {}

    for rowIndex, row in ipairs(LevelMap) do
        for col = 1, #row do
            local symbol = row:sub(col, col)
            local x = (col - 1) * TILE_SIZE + OFFSET_X
            local y = (rowIndex - 1) * TILE_SIZE + OFFSET_Y

            if symbol == '#' then
                table.insert(Platforms, platform:new(x, y, TILE_SIZE, TILE_SIZE))
            elseif symbol == 'P' then
                playerSpawnX = x
                playerSpawnY = y
            elseif symbol == 'C' then
                table.insert(Coins, coin:new(x, y + 24, TILE_SIZE / 2, TILE_SIZE / 2))
            elseif symbol == 'E' then
                table.insert(Enemies, enemy:new(x, y, TILE_SIZE, TILE_SIZE))
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
    if Player.y > SCREEN_HEIGHT + 200 then
        Player:reset()
    end

    for i, c in ipairs(Coins) do
        if Player:isCollide(c) then
            Score = Score + 1
            table.remove(Coins, i)
        end
    end

    if Player.isAttacking then
        Player.attackTimer = Player.attackTimer - dt
        if Player.attackTimer <= 0 then
            Player.isAttacking = false
            Player.attackBox = nil
        end
    end

    for enemyIndex, e in ipairs(Enemies) do
        e:update(dt, Platforms)

        if Player:isCollide(e) then
            Player:reset()
        end

        if Player.isAttacking and e:hitBy(Player.attackBox) then
            table.remove(Enemies, enemyIndex)
        end
    end
end

function love.keypressed(key)
    if key == 'space' and (Player.isOnGround or Player.coyoteTimer > 0) then
        Player:jump()
    end

    if key == 'j' then
        Player:attack()
    end

    if key == 'r' then
        Player:reset()
    end
end

function love.draw()
    love.graphics.print('FPS:' .. tostring(love.timer.getFPS()), 10, 10)
    love.graphics.print('Score:' .. tostring(Score), 10, 30)

    love.graphics.setColor(0, 1, 0, 0.2)
    love.graphics.rectangle("line", OFFSET_X, OFFSET_Y, LEVEL_WIDTH, LEVEL_HEIGHT)
    love.graphics.setColor(1, 1, 1)

    Player:draw()

    if Player.isAttacking and Player.attackBox ~= nil then
        local b = Player.attackBox
        local cx = b.x + b.width / 2
        local cy = b.y + b.height / 2
        local angle = (Player.direction == 'right') and math.rad(45) or math.rad(-45)

        love.graphics.push()
        love.graphics.translate(cx, cy)
        love.graphics.rotate(angle)
        love.graphics.setColor(1, 0, 0, 0.4)
        love.graphics.rectangle('fill', -b.width / 2, -b.height / 2, b.width, b.height)
        love.graphics.pop()

        love.graphics.setColor(1, 1, 1)
    end

    for _, p in ipairs(Platforms) do p:draw() end
    for _, c in ipairs(Coins) do c:draw() end
    for _, e in ipairs(Enemies) do e:draw() end
end
