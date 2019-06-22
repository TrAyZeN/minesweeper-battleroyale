Class = require "libs.hump.class"
--[[
    cells states:
    0 to 8 cell with n mines in its neighbourhood
    -1 unrevealed cell
    -2 flagged cell
    -3 interogation cell
]]
Grid = Class {
    init = function(self, x, y, cellSize, width, height)
        self.position = { x = x, y = y }
        self.cellSize = cellSize
        self.size = { w = width, h = height }
        self.flags = 0
        self.grid = {}

        -- fill grid with -1s (ie unrevealed cells)
        for y = 1, self.size.h do
            local line = {}
            for x = 1, self.size.w do
                table.insert(line, -1)
            end
            table.insert(self.grid, line)
        end
    end,
    position,
    cellSize,
    size,
    flags,
    grid
}

function Grid:draw()
    for y = 1, self.size.h do
        for x = 1, self.size.w do
            if self.grid[y][x] == -1 then
                love.graphics.setColor(255, 255, 255)
                love.graphics.rectangle("fill", self.position.x + (x - 1) * self.cellSize, self.position.y + (y - 1) * self.cellSize, self.cellSize, self.cellSize)
            elseif self.grid[y][x] == -2 then
                love.graphics.setColor(255, 0, 0)
                love.graphics.rectangle("fill", self.position.x + (x - 1) * self.cellSize, self.position.y + (y - 1) * self.cellSize, self.cellSize, self.cellSize)
            elseif self.grid[y][x] == -3 then
                love.graphics.setColor(0, 255, 255)
                love.graphics.rectangle("fill", self.position.x + (x - 1) * self.cellSize, self.position.y + (y - 1) * self.cellSize, self.cellSize, self.cellSize)
            elseif self.grid[y][x] >= 0 and self.grid[y][x] <= 8 then
                love.graphics.setColor(0, 255, 0)
                love.graphics.rectangle("fill", self.position.x + (x - 1) * self.cellSize, self.position.y + (y - 1) * self.cellSize, self.cellSize, self.cellSize)
                love.graphics.setColor(0, 0, 0)
                love.graphics.print(self.grid[y][x], self.position.x + (x - 1) * self.cellSize + self.cellSize / 3, self.position.y + (y - 1) * self.cellSize + self.cellSize / 5)
            end
        end
    end
end

--[[
    return the cell position in the grid according to its position on screen
    if the position on the screen is out of the grid then retrun -1, -1
]]
function Grid:getCellCoordinates(x, y)
    local x0 = self.position.x + math.floor(x / self.cellSize) + 1
    local y0 = self.position.y + math.floor(y / self.cellSize) + 1
    if x0 >= 1 and y0 >= 1 and x0 <= self.size.w and y0 <= self.size.h then
        return x0, y0
    end
    return -1, -1
end

--[[
    transforms the cell into flagged cell if the cell is unrevealed
    transforms the cell into interrogation if the cell is flagged
    transforms the cell into unrevealed if the cell is interrogation
]]
function Grid:markCell(x, y)
    if x >= 1 and y >= 1 and x <= self.size.w and y <= self.size.h then
        if self.grid[y][x] == -1 then
            self.grid[y][x] = -2
            self.flags = self.flags + 1
        elseif self.grid[y][x] == -2 then
            self.grid[y][x] = -3
            self.flags = self.flags - 1
        elseif self.grid[y][x] == -3 then
            self.grid[y][x] = -1
        end
    end
end

function Grid:getFlaggedCells()
    local flaggedCells = {}
    for y=1, self.size.h do
        for x=1, self.size.w do
            if self.grid[y][x] == -2 then
                table.insert(flaggedCells, { x = x, y = y })
            end
        end
    end
    return flaggedCells
end
