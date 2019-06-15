--[[
    cells states:
    0 to 8 cell with n mines in its neighbourhood
    -1 unrevealed cell
    -2 flagged cell
    -3 interogation cell
]]
Grid = {
    position = {x=0, y=0},  -- ;-;
    cellSize = 0,
    size = {w=0, h=0},
    grid = {}
}

function Grid:new(x, y, cellSize, width, height)
    self.position.x = x
    self.position.y = y
    self.cellSize = cellSize
    self.size.w = width
    self.size.h = height

    -- fill grid with -1s (ie unrevealed cells)
    for y=1, self.size.h do
        local line = {}
        for x=1, self.size.w do
            table.insert(line, -1)
        end
        table.insert(self.grid, line)
    end

    return self
end

function Grid:draw()
    for y=1, self.size.h do
        for x=1, self.size.w do
            if self.grid[y][x] == -1 then
                love.graphics.setColor(255, 255, 255)
                love.graphics.rectangle("fill", self.position.x + (x-1)*self.cellSize + x, self.position.y + (y-1)*self.cellSize + y, self.cellSize, self.cellSize)
            elseif self.grid[y][x] == -2 then
                love.graphics.setColor(255, 0, 0)
                love.graphics.rectangle("fill", self.position.x + (x-1)*self.cellSize + x, self.position.y + (y-1)*self.cellSize + y, self.cellSize, self.cellSize)
            elseif self.grid[y][x] == -3 then
                love.graphics.setColor(0, 255, 255)
                love.graphics.rectangle("fill", self.position.x + (x-1)*self.cellSize + x, self.position.y + (y-1)*self.cellSize + y, self.cellSize, self.cellSize)
            elseif self.grid[y][x] >= 0 and self.grid[y][x] <= 8 then
                love.graphics.setColor(0, 255, 0)
                love.graphics.rectangle("fill", self.position.x + (x-1)*self.cellSize + x, self.position.y + (y-1)*self.cellSize + y, self.cellSize, self.cellSize)
                love.graphics.setColor(0, 0, 0)
                love.graphics.print(self.grid[y][x], self.position.x + (x-1)*self.cellSize + x + self.cellSize/2, self.position.y + (y-1)*self.cellSize + y + self.cellSize/2)
            end
        end
    end
end

-- return the cell position in the grid according to its position on screen
function Grid:getCellCoordinates(x, y)
    local x0 = math.floor(self.position.x + x / self.cellSize + 1)
    local y0 = math.floor(self.position.x + y / self.cellSize + 1)
    if x0 >= 1 and y0 >= 1 and x0 <= self.size.w and y0 <= self.size.h then
        return x0, y0
    end
    return -1, -1
end

function Grid:markCell(x, y)
    if x0 >= 1 and y0 >= 1 and x0 <= self.size.w and y0 <= self.size.h then
        if self.grid[y][x] == -1 or self.grid[y][x] == -2 then
            self.grid[y][x] = self.grid[y][x] - 1
        elseif self.grid[y][x] == -3 then
            self.grid[y][x] = -1
        end
    end
end

function Grid:revealCell(x, y)
    -- TODO: request server
    return false
end
