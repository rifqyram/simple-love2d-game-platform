SCREEN_WIDTH = 1024
SCREEN_HEIGHT = 576

function love.conf(t)
    t.window.title = "Simple 2D Platformer"
    t.window.width = SCREEN_WIDTH
    t.window.height = SCREEN_HEIGHT
    t.window.vsync = true
    t.window.fullscreen = false
    t.console = true
end
