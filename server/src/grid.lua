Grid = {
    size = {w=0, h=0},
    mines = 0,
    grid = {}
}

function Grid:new(width, height, mines)
    self.size.w = width
    self.size.h = height
    self.mines = mines

    -- fill grid with 0s (ie blank cells)
    for y=1, self.size.h do
        local line = {}
        for x=1, self.size.w do
            table.insert(line, 0)
        end
        table.insert(self.grid, line)
    end

    -- generate mines at random position
    math.randomseed(os.time())
    for m=1, self.mines do
        local x, y = math.random(1, self.size.w), math.random(1, self.size.h)
        while self:isMine(x, y) do  -- if there is already a mine at coordinates then regenerate coordinates
            x, y = math.random(1, self.size.w), math.random(1, self.size.h)
        end
        self.grid[y][x] = -1
    end

    -- fill blank cells with the number of cells in its neighbourhood
    for y=1, self.size.h do
        for x=1, self.size.w do
            if self.grid[y][x] ~= -1 then
                self.grid[y][x] = self:getMineNeighbours(x, y)
            end
        end
    end

    return self
end

function Grid:isMine(x, y)
    return self.grid[y][x] == -1
end

-- Counts mines in the neighbourhood of the cell
function Grid:getMineNeighbours(x, y)
    -- range used to prevent getting elements out of grid length
    local yRange = {y-1, y+1}
    if y == 1 then
        yRange[1] = 1
    elseif y == self.size.h then
        yRange[2] = self.size.h
    end

    local mineNeighbours = 0
    for i=yRange[1], yRange[2] do
        -- range used to prevent getting elements out of grid length
        local xRange = {x-1, x+1}
        if x == 1 then
            xRange[1] = 1
        elseif x == self.size.w then
            xRange[2] = self.size.w
        end

        for j=xRange[1], xRange[2] do
            if self.grid[i][j] == -1 and (i ~= y or j ~= x) then
                mineNeighbours = mineNeighbours + 1
            end
        end
    end
    return mineNeighbours
end
