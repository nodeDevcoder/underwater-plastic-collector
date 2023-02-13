Element = Class{}


elements = {
    sand = {
        x = 64 * 6,
        y = 0,
        width = 128,
        height = 64,
        friction = 0.7,
        grp = 1
    },
    water = {
        x = 64 * 17,
        y = 64 * 4,
        width = 64,
        height = 64,
        friction = 0,
        grp = -1
    }
}

function Element:init(world, type, x, y, stat) -- stat is dynamic or static
    self.body = love.physics.newBody(world, x, y, stat)
    self.shape = love.physics.newRectangleShape(32, 32, elements[type].width, elements[type].height)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setRestitution(0)
    self.fixture:setFriction(elements[type].friction)
    self.fixture:setGroupIndex(elements[type].grp)
    if (type == 'water') then
        self.fixture:setMask(3)
    end
    self.fixture:setUserData('Element')
    self.quad = love.graphics.newQuad(elements[type].x, elements[type].y, elements[type].width, elements[type].height, atlas:getDimensions())
end

-- function Element:update(dt)
    
-- end

function Element:render()
    love.graphics.draw(atlas, self.quad, self.body:getX(), self.body:getY())
end