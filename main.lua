Class = require 'class'

atlas = love.graphics.newImage('kenney_fishpack/Tilesheet/fishTilesheet.png')
image = love.graphics.newImage('submarine.png')
quad = love.graphics.newQuad(3, 126, 1018, 772, image:getWidth(), image:getHeight())
sky = love.graphics.newImage('sky.png')
sm_font = love.graphics.newFont('Nunito-Black.ttf', 20)
md_font = love.graphics.newFont('Nunito-Black.ttf', 28)
bg_font = love.graphics.newFont('Nunito-Black.ttf', 36)

gameState = 'start'

require 'Submarine'
require 'Trash'
require 'Element'

function timer(secs)
    local time_minutes  = math.floor((secs % 3600) / 60)
    local time_seconds  = math.floor(secs % 60)
    if (time_minutes < 10) then
        time_minutes = "0" .. time_minutes
    end
    if (time_seconds < 10) then
        time_seconds = "0" .. time_seconds
    end
    return time_minutes .. ":" .. time_seconds
end

function love.conf(t)
	t.console = true
end

function dump(o)
    if type(o) == 'table' then
       local s = '{ '
       for k,v in pairs(o) do
          if type(k) ~= 'number' then k = '"'..k..'"' end
          s = s .. '['..k..'] = ' .. dump(v) .. ','
       end
       return s .. '} '
    else
       return tostring(o)
    end
 end

function love.load() 
    love.window.setFullscreen(true)

    VIRTUAL_WIDTH = love.graphics.getWidth()
    VIRTUAL_HEIGHT = love.graphics.getHeight()

    math.randomseed(os.time())
    math.random()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Submarine!!!')
    love.window.setMode(VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

    world = love.physics.newWorld(0, 0, false)
    love.physics.setMeter(10)
    function beginContact(a, b, coll)
        local types = {}
        types[a:getUserData()] = true
        types[b:getUserData()] = true        
        if types['Sub'] and types['Trash'] then
            pl = a:getUserData() == 'Trash' and a or b
            pl = pl:getBody():getUserData():remove()
            sub.player.score = sub.player.score + 1
        end
    end

    function endContact(a, b, coll)

    end

    function preSolve(a, b, coll)

    end

    function postSolve(a, b, coll, normalImpulse, tangentImpulse)

    end

    sea = love.graphics.newCanvas(2 * VIRTUAL_WIDTH, 2 * VIRTUAL_HEIGHT + 150)
    sub = Submarine(world)
    lfbBody = love.physics.newBody(world, 0, 0, 'static') -- left boundary body
    lfbShape = love.physics.newEdgeShape(0, 0, 0, VIRTUAL_HEIGHT * 2 + 150) --left boundary shape
    lfbFix = love.physics.newFixture(lfbBody, lfbShape)
    lfbFix:setGroupIndex(1)
    lfbFix:setUserData('Boundary')

    rtbBody = love.physics.newBody(world, 2 * VIRTUAL_WIDTH, 0, 'static') -- right boundary body
    rtbShape = love.physics.newEdgeShape(0, 0, 0, VIRTUAL_HEIGHT * 2 + 150) -- right boundary shape
    rtbFix = love.physics.newFixture(rtbBody, rtbShape)
    rtbFix:setGroupIndex(1)
    rtbFix:setUserData('Boundary')

    -- btmBody = love.physics.newBody(world, 0, 2 * VIRTUAL_HEIGHT + 150 - 2.5 * sub.height, 'static') -- bottom boundary body
    -- btmShape = love.physics.newEdgeShape(-sub.width/2, 0, 2 * VIRTUAL_WIDTH - sub.width/2, 0) -- bottom boundary shape
    -- btmFix = love.physics.newFixture(btmBody, btmShape)
    -- btmFix:setGroupIndex(1)
    -- btmFix:setUserData('Boundary')

    seaFloor = {}
    water = {}
    
    for i = 1, math.ceil(2 * VIRTUAL_WIDTH / 128) do -- floor
        table.insert(seaFloor, { element = Element(world, 'sand', (i - 1) * 128, 2 * VIRTUAL_HEIGHT - 64, 'static') })
    end

    for i = 1, math.ceil((2 * VIRTUAL_WIDTH) / 64 ) do -- columns
        table.insert(water, {row = {}})
        for k = 1, math.ceil(2 * VIRTUAL_HEIGHT / 64) do
            table.insert(water[i].row, { element = Element(world, 'water', (i - 1) * 64, 2 * VIRTUAL_HEIGHT + 150 - (k) * 64) })
        end
    end

    trash = {}

    for i = 1, 14 do
        local x = math.random(15, 2 * VIRTUAL_WIDTH - sub.width/2)
        local y = math.random(160, 2 * VIRTUAL_HEIGHT + 150 - 2.5 * sub.height)
        newTrash(world, x, y, 'bottle')
    end

    world:setCallbacks(beginContact, endContact, preSolve, postSolve)
end

function love.update(dt)
    if love.keyboard.isDown('escape') then
        love.event.quit()
    end
    if (gameState == 'start') then
        if love.keyboard.isDown('return') then
            gameState = 'play'
        end
    elseif (gameState == 'play') then
        
        if (sub.player.timer <= 0) then
            gameState = 'end'
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
        if #trash < 14 then
            local x = math.random(15, 2 * VIRTUAL_WIDTH - sub.width/2)
            local y = math.random(160, 2 * VIRTUAL_HEIGHT - 100)
            newTrash(world, x, y, 'bottle')
        end
        world:update(dt)
    elseif (gameState == 'end') then

    end
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
    pastTop = sub.body:getY() + sub.height/2 < VIRTUAL_HEIGHT/2 -- check sub is past top limit
    pastLeft = sub.body:getX() + sub.width / 2 < VIRTUAL_WIDTH / 2 --check sub is past left
    pastRight = sub.body:getX() + sub.width / 2 > (2 * VIRTUAL_WIDTH) - (VIRTUAL_WIDTH / 2) --check sub is past right
    pastBottom = sub.body:getY() + sub.height/2 > 2 * VIRTUAL_HEIGHT - VIRTUAL_HEIGHT/2 --check sub is past top
    camX = 0
    camY = 0
    if (pastRight) then
        camX = -VIRTUAL_WIDTH
    elseif (pastLeft) then
        camX = 0
    else 
        camX = math.floor(-sub.body:getX() + VIRTUAL_WIDTH / 2 - sub.width / 2 + 0.49)
    end
    if (pastBottom) then
        camY = -VIRTUAL_HEIGHT
    elseif (pastTop) then
        camY = 0
    else
        camY = math.floor(-sub.body:getY() + VIRTUAL_HEIGHT / 2 - sub.height / 2 + 0.49)
    end

    love.graphics.translate(camX, camY)
    love.graphics.clear()
    for i = 1, 2 * VIRTUAL_WIDTH/sky:getWidth() do
        love.graphics.draw(sky, (i - 1) * sky:getWidth(), 0, 0, 2, 0.5)
    end
    for i = 1, #water do
        for k = 1, #water[i].row do
            water[i].row[k].element:render()
        end
    end
    for i = 1, #seaFloor do
        seaFloor[i].element:render()
    end
    for i = #trash, 1, -1 do
        trash[i].t:render()
    end
    sub:render()
    love.graphics.pop()
    love.graphics.setCanvas()
    love.graphics.draw(sea)
    if (gameState == 'play') then
        love.graphics.setColor(0, 0, 0)
        love.graphics.setFont(sm_font)
        love.graphics.printf('Score: ' .. sub.player.score, 50, 50, 200, 'left')
        love.graphics.printf('Time: ' .. timer(sub.player.timer), 0, 50, VIRTUAL_WIDTH, 'center')
        love.graphics.setColor(1, 1, 1)
    end

    if (gameState == 'start') then
        love.graphics.setColor(0, 0, 0, 0.5)
        love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle('fill', VIRTUAL_WIDTH / 4, VIRTUAL_HEIGHT/4, VIRTUAL_WIDTH/2, VIRTUAL_HEIGHT/2, 30, 30)
        love.graphics.setColor(0, 0, 0)
        love.graphics.setFont(bg_font)
        love.graphics.printf('Welcome to Plastic Collector!', VIRTUAL_WIDTH/4, VIRTUAL_HEIGHT/4 + 50, VIRTUAL_WIDTH/2, 'center')
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(image, quad, VIRTUAL_WIDTH/2 + (0.1 * image:getWidth())/2, VIRTUAL_HEIGHT/2 - (0.15 * image:getHeight())/2, 0, -0.2, 0.2, image:getWidth() * 0.2, 0)
        love.graphics.setColor(0, 0, 0)
        love.graphics.setFont(md_font)
        love.graphics.printf('Press Enter to Play', VIRTUAL_WIDTH/4, VIRTUAL_HEIGHT/2 + 100, VIRTUAL_WIDTH/2, 'center')
        love.graphics.setColor(1, 1, 1)
    elseif (gameState == 'end') then
        love.graphics.setColor(0, 0, 0, 0.5)
        love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle('fill', VIRTUAL_WIDTH / 4, VIRTUAL_HEIGHT/4, VIRTUAL_WIDTH/2, VIRTUAL_HEIGHT/2, 30, 30)
        love.graphics.setColor(0, 0, 0)
        love.graphics.setFont(bg_font)
        love.graphics.printf('GREAT JOB!', VIRTUAL_WIDTH/4, VIRTUAL_HEIGHT/4 + 50, VIRTUAL_WIDTH/2, 'center')
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(image, quad, VIRTUAL_WIDTH/2 + (0.1 * image:getWidth())/2, VIRTUAL_HEIGHT/2 - (0.15 * image:getHeight())/2, 0, -0.2, 0.2, image:getWidth() * 0.2, 0)
        love.graphics.setColor(0, 0, 0)
        love.graphics.setFont(md_font)
        love.graphics.printf('You picked up: '.. sub.player.score .. ' pieces of trash!', VIRTUAL_WIDTH/4, VIRTUAL_HEIGHT/2 + 100, VIRTUAL_WIDTH/2, 'center')
        love.graphics.setColor(1, 1, 1)
    end

end