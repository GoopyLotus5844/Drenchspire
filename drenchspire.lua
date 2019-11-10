local colors = {{255, 0, 0}, {0, 255, 0}, {0, 0, 255}, {0, 255, 255}, {255, 0, 255}, {255, 255, 0}}

local screen = platform.window
local w = screen:width()
local h = screen:height()
local size = 20
local squareSize = 10
local keyBorder = 10
local keySpacing = 15
local grid = {}
local moves = 45
local state = 0 --0 playing, 1 win, 2 lose

function createGrid()
	for i = 1, size do
    	grid[i] = {}
    	for j = 1, size do
        	grid[i][j] = math.random(1, 6)
    	end
	end
end

function fill(x, y, target, replacement)
    if target == replacement then return
    elseif grid[x][y] ~= target then return
    else grid[x][y] = replacement end
    if x < size then fill(x + 1, y, target, replacement) end
    if y > 1 then fill(x, y - 1, target, replacement) end
    if x > 1 then fill(x - 1, y, target, replacement) end
    if y < size then fill(x, y + 1, target, replacement) end
    return
end

function checkWin()
    color = 0
    for x = 1, size do
        for y = 1, size do
            if color == 0 then color = grid[x][y]
            elseif grid[x][y] ~= color then return false end
        end
    end
    return true
end
            

function on.charIn(char)
    num = tonumber(char)
    if num ~= nil and num < 7 and num > 0 and grid[1][1] ~= num and state == 0 then
        moves = moves - 1
        fill(1, 1, grid[1][1], num)
        if checkWin() then state = 1
        elseif moves == 0 then state = 2 end
    elseif char == 'r' then
        state = 0
        createGrid()
        moves = 45
    end
    screen:invalidate()
end
    

function on.paint(gc)
    for x = 1, size do
        for y = 1, size do
            color = colors[grid[x][y]]
            gc:setColorRGB(color[1], color[2], color[3])
            gc:fillRect((w - size * squareSize) / 2 + (x - 1) * squareSize, (h - size * squareSize) / 2 + (y - 1) * squareSize, squareSize, squareSize)
        end
    end
    
    for x = 1, 6 do
        gc:setColorRGB(0, 0, 0)
        gc:drawString(tostring(x), keyBorder, keyBorder + (x - 1) * keySpacing + 3, "middle")
        gc:setColorRGB(colors[x][1], colors[x][2], colors[x][3])
        gc:fillRect(keyBorder + keySpacing, keyBorder + (x - 1) * keySpacing, squareSize, squareSize)
    end
    
    gc:setColorRGB(0, 0, 0)
    gc:drawString("Moves:", w - ((w - size * squareSize) / 2) + keySpacing / 2, h / 3, "bottom")
    gc:drawString(tostring(moves), w - ((w - size * squareSize) / 2) + keySpacing, h / 3, "top")
    gc:drawString("Reset?", w - ((w - size * squareSize) / 2) + keySpacing / 2, 2 * h / 3, "bottom")
    gc:drawString("R", w - ((w - size * squareSize) / 2) + keySpacing, 2 * h / 3, "top")
    
    gc:setFont("serif","r",30)
    if state == 1 then gc:drawString("You win", w / 2 - 50, h / 2, "middle")
    elseif state == 2 then gc:drawString("You lose", w / 2 - 50, h / 2, "middle") end
end

createGrid()
-- TI.SCRIPTAPP