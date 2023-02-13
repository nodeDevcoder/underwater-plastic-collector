Submarine = Class{}


function Submarine:init(world)
    self.width = 101.8
    self.height = 77.2
    self.rotation = 0
    self.right = true -- facing right as default
    self.body = love.physics.newBody(world, VIRTUAL_WIDTH - self.width / 2, VIRTUAL_HEIGHT / 2 - self.height / 2, 'dynamic')
    self.shape = love.physics.newRectangleShape(self.width/2, self.height/2, self.width, self.height)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setRestitution(0)
    self.fixture:setCategory(3)
    self.fixture:setGroupIndex(1)
    self.body:setMass(1)
    self.body:setLinearDamping(0.5)
    self.fixture:setUserData('Sub')
    self.player = {
        score = 0,
        timer = 120
    }

end

function Submarine:update(dt, move)
    if move == 'up' and self.body:getY() > 165 - self.height then
        self.body:applyForce(0, -100)
    end
    if move == 'down' then
        self.body:applyForce(0, 100)
    end
    if move == 'right' then
        self.right = true
        self.body:applyForce(100, 0)
    end
    if move == 'left' then
        self.right = false
        self.body:applyForce(-100, 0)
    end
    dx, dy = self.body:getLinearVelocity()
    if (self.body:getY() < 165 - self.height and dy < 0) then
        self.body:setLinearVelocity(0.8 * dx, 0.5)
    end
    self.player.timer = self.player.timer - dt
end

function Submarine:render()
    -- love.graphics.rectangle('fill', self.body:getX(), self.body:getY(), self.width, self.height)
    -- love.graphics.translate(math.floor(self.prevX - self.body:getX()), math.floor(self.prevY - self.body:getY()))
    if (self.right) then
        love.graphics.draw(image, quad, self.body:getX(), self.body:getY(), self.rotation, 0.1)
    else 
        love.graphics.draw(image, quad, self.body:getX(), self.body:getY(), self.rotation, -0.1, 0.1, 10 * self.width, 0)
    end

end
