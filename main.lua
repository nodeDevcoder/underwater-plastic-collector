Class = require 'class'

require 'Submarine'
local gamera = require 'gamera'

function love.load() 
    love.window.setFullscreen(true)

    VIRTUAL_WIDTH = love.graphics.getWidth()
    VIRTUAL_HEIGHT = love.graphics.getHeight()

    math.randomseed(os.time())
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Submarine!!!')
    love.window.setMode(VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

    world = love.physics.newWorld(0, 0, false)
    love.physics.setMeter(10)
    sea = love.graphics.newCanvas(2 * VIRTUAL_WIDTH, 2 * VIRTUAL_HEIGHT + 150)
    sub = Submarine(world)
    lfbBody = love.physics.newBody(world, 0, 150, 'static') -- left boundary body
    lfbShape = love.physics.newEdgeShape(-sub.width/2, 0, -sub.width/2, VIRTUAL_HEIGHT * 2 + 150) --left boundary shape
    lfbFix = love.physics.newFixture(lfbBody, lfbShape)

    rtbBody = love.physics.newBody(world, 2 * VIRTUAL_WIDTH, 150, 'static') -- right boundary body
    rtbShape = love.physics.newEdgeShape(-sub.width/2, 0, -sub.width/2, VIRTUAL_HEIGHT * 2 + 150) -- right boundary shape
    rtbFix = love.physics.newFixture(rtbBody, rtbShape)
end

function love.update(dt)
    if love.keyboard.isDown('escape') then
        love.event.quit()
    end
    if love.keyboard.isDown('up', 'down', 'right', 'left') then
        if love.keyboard.isDown('up') then
            sub:update(dt, 'up')
        end
        if love.keyboard.isDown('down') then
            sub:update(dt, 'down')
        end
        if love.keyboard.isDown('right') then
            sub:update(dt, 'right')
        end
        if love.keyboard.isDown('left') then
            sub:update(dt, 'left')
        end
    else
        sub:update(dt, 'none')
    end
    world:update(dt)
end

function love.draw()
    -- love.graphics.rectangle()
    -- love.graphics.setBackgroundColor(255, 255, 255, 1)
    -- love.graphics.setColor(0, 0, 255, 0.6)
    -- love.graphics.rectangle('fill', sea:getX(), sea:getY(), 2 * VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
    -- love.graphics.setColor(255, 255, 255)
    love.graphics.setBackgroundColor(255, 255, 255)
    love.graphics.setCanvas(sea)
    love.graphics.push()
    if (sub.body:getX() + sub.width / 2 < VIRTUAL_WIDTH / 2) then
        love.graphics.translate(0, math.floor(-sub.body:getY() + VIRTUAL_HEIGHT / 2 - sub.height / 2 + 0.5))
    elseif (sub.body:getX() + sub.width / 2 > (2 * VIRTUAL_WIDTH) - (VIRTUAL_WIDTH / 2)) then
        love.graphics.translate(-VIRTUAL_WIDTH, math.floor(-sub.body:getY() + VIRTUAL_HEIGHT / 2 - sub.height / 2 + 0.5))
    else
        love.graphics.translate(-sub.body:getX() + VIRTUAL_WIDTH / 2 - sub.width / 2, -sub.body:getY() + VIRTUAL_HEIGHT / 2 - sub.height / 2)
    end
    love.graphics.clear()
    love.graphics.setColor(255, 255, 255)
    love.graphics.rectangle('fill', 0, 150, VIRTUAL_WIDTH * 2, 3)
    love.graphics.setColor(0.55, 0.71, 0.85, 1)
    love.graphics.rectangle('fill', 0, 150, 2 * VIRTUAL_WIDTH, 2 * VIRTUAL_HEIGHT)
    love.graphics.setColor(255, 255, 255)
    sub:render()
    love.graphics.pop()
    love.graphics.setCanvas()
    love.graphics.draw(sea)
end