Submarine = Class{}

image = love.graphics.newImage('submarine.png')
quad = love.graphics.newQuad(3, 126, 1018, 772, image:getWidth(), image:getHeight())

function Submarine:init(world)
    self.width = 101.8
    self.height = 77.2
    self.rotation = 0
    self.right = true -- facing right as default
    self.body = love.physics.newBody(world, VIRTUAL_WIDTH - self.width / 2, VIRTUAL_HEIGHT / 2 - self.height / 2, 'dynamic')
    self.shape = love.physics.newRectangleShape(self.width, self.height)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setRestitution(1)
    self.fixture:setGroupIndex(-1)
    -- self.fixture:setDensity(1)
    self.body:setMass(1)
    self.body:setLinearDamping(0.5)
end

function Submarine:update(dt, move)
    if move == 'up' then
        self.body:applyForce(0, -70)
    end
    if move == 'down' then
        self.body:applyForce(0, 70)
    end
    if move == 'right' then
        self.body:applyForce(70, 0)
    end
    if move == 'left' then
        self.body:applyForce(-70, 0)
    end
    -- cam:setPosition(self.body:getX(), self.body:getY())
end

function Submarine:render()
    -- love.graphics.rectangle('fill', self.body:getX(), self.body:getY(), self.width, self.height)
    -- love.graphics.translate(math.floor(self.prevX - self.body:getX()), math.floor(self.prevY - self.body:getY()))
    love.graphics.draw(image, quad, self.body:getX(), self.body:getY(), self.rotation, 0.1)
    love.graphics.print(tostring(self.body:getX()), VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 2)
end
