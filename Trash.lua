Trash = Class{}

plasticbottle = love.graphics.newImage('plasticbottle.png')

assets = {
    bottle = {
        img = plasticbottle,
        scale = 0.03
    }
}

function Trash:init(world, x, y, type)
    type = assets[type]
    -- self.rot = math.random(0, 2 * math.pi)
    self.scale = type.scale
    self.img = type.img
    self.rot = 0
    self.width = self.img:getWidth() * self.scale
    self.height = self.img:getHeight() * self.scale
    self.body = love.physics.newBody(world, x, y, 'dynamic')
    self.body:setAngle(math.rad(math.random(0, 360)))
    -- self.body:setAngle(0)
    self.shape = love.physics.newRectangleShape(0, 0, self.width, self.height, self.body:getAngle())
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.body:setMass(0.1)
    self.fixture:setGroupIndex(1)
    self.fixture:setCategory(3)
    self.fixture:setUserData('Trash')
    self.body:setUserData(self)
end

function Trash:update(dt)

end

function newTrash(world, x, y, type)
    local tr = Trash(world, x, y, type)
    table.insert(trash, {t = tr})
    return "good"
end

function Trash:remove()
    for i = 1, #trash do
        if trash[i].t == self then
            index = i
        end
    end
    table.remove(trash, index)
    self.fixture:destroy() 
    self.body:destroy()
end

function Trash:render()
    love.graphics.draw(self.img, self.body:getX(), self.body:getY(), self.body:getAngle(), self.scale, self.scale)
end