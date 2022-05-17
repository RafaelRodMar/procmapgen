require("vector2D")

function love.load()
    math.randomseed( os.time() )
    math.random() math.random() math.random()

    terrain20x20 = love.graphics.newImage("assets/img/MarchingSquares20x20.png")
    terrain2terrain20x20 = love.graphics.newImage("assets/img/marchingsquares2terrain20x20.png")
    terrain2terrain20x20rect = love.graphics.newImage("assets/img/marchingsquares2terrainrect20x20.png")
    --load font
    font = love.graphics.newFont("assets/fnt/sansation.ttf",25)
    love.graphics.setFont(font)

    gameWidth = 640
    gameHeight = 480
    boardSize = Vector2D:new(640,480)
    cellSize = Vector2D:new(20,20)
    boardSizeInTiles = Vector2D:new(0,0)
    board = {{}}

    love.window.setMode(gameWidth, gameHeight, {resizable=false, vsync=false})
    love.graphics.setBackgroundColor(1,1,1) --white

	boardSizeInTiles.x = boardSize.x / cellSize.x
    boardSizeInTiles.y = boardSize.y / cellSize.y

    --fill board with points. 80% more ground than water
    --generate the map dots (more 1 than 0)
	for i = 0, boardSizeInTiles.x + 1 do
		for j = 0, boardSizeInTiles.y + 1 do
			if math.random(0,100) < 80 then
				board[i + j * boardSizeInTiles.x] = 1
			else
				board[i + j * boardSizeInTiles.x] = 0
            end
        end
    end

    state = "dots"
end

function showMarchingSquaresline()
    --draw the line
	for i = 0, boardSizeInTiles.x do
		for j = 0, boardSizeInTiles.y do
			local x = i * cellSize.x
			local y = j * cellSize.y
			local a = Vector2D:new(x + cellSize.x * 0.5, y)
			local b = Vector2D:new(x + cellSize.x, y + cellSize.y * 0.5)
			local c = Vector2D:new(x + cellSize.x * 0.5, y + cellSize.y)
			local d = Vector2D:new(x, y + cellSize.y * 0.5)
			local state = board[i + j * boardSizeInTiles.x] * 8 + board[i + 1 + j * boardSizeInTiles.x] * 4 + board[i + 1 + (j + 1) * boardSizeInTiles.x] * 2 + board[i + (j + 1) * boardSizeInTiles.x]

			if state == 0 then
				--do nothing
                state = 0
            elseif state == 1 then
				love.graphics.line(c.x, c.y, d.x, d.y)
			elseif state == 2 then
				love.graphics.line(b.x, b.y, c.x, c.y)
            elseif state == 3 then
				love.graphics.line(b.x, b.y, d.x, d.y)
			elseif state == 4 then
				love.graphics.line(a.x, a.y, b.x, b.y)
            elseif state == 5 then
				love.graphics.line(a.x, a.y, d.x, d.y)
				love.graphics.line(b.x, b.y, c.x, c.y)
			elseif state == 6 then
				love.graphics.line(a.x, a.y, c.x, c.y)
            elseif state == 7 then
				love.graphics.line(a.x, a.y, d.x, d.y)
			elseif state == 8 then
				love.graphics.line(a.x, a.y, d.x, d.y)
            elseif state == 9 then
				love.graphics.line(a.x, a.y, c.x, c.y)
			elseif state == 10 then
				love.graphics.line(a.x, a.y, b.x, b.y)
				love.graphics.line(c.x, c.y, d.x, d.y)
            elseif state == 11 then
				love.graphics.line(a.x, a.y, b.x, b.y)
			elseif state == 12 then
				love.graphics.line(b.x, b.y, d.x, d.y)
            elseif state == 13 then
				love.graphics.line(b.x, b.y, c.x, c.y)
			elseif state == 14 then
				love.graphics.line(c.x, c.y, d.x, d.y)
            elseif state == 15 then
				--do nothing
            end
		end
	end
end

function showMarchingSquaresTiles()
	--draw the tiles
	for i = 0, boardSizeInTiles.x do
		for j = 0, boardSizeInTiles.y do
			local x = i * cellSize.x
			local y = j * cellSize.y
			local state = board[i + j * boardSizeInTiles.x] * 8 + board[i + 1 + j * boardSizeInTiles.x] * 4 + board[i + 1 + (j + 1) * boardSizeInTiles.x] * 2 + board[i + (j + 1) * boardSizeInTiles.x]

			local tilemapRow = math.floor( state / 4 )
			local tilemapCol = math.floor( state - tilemapRow * 4 )
            
			love.graphics.draw(terrain20x20, love.graphics.newQuad(tilemapCol * cellSize.x,tilemapRow * cellSize.y,20,20,terrain20x20:getWidth(), terrain20x20:getHeight()), x, y, math.rad(0), 1, 1, 0, 0, 0, 0)
        end
	end
end

--water and earth
function showMarchingSquaresTerrain()
	--draw the tiles
	for i = 0, boardSizeInTiles.x do
		for j = 0, boardSizeInTiles.y do
			local x = i * cellSize.x
			local y = j * cellSize.y
			local state = board[i + j * boardSizeInTiles.x] * 8 + board[i + 1 + j * boardSizeInTiles.x] * 4 + board[i + 1 + (j + 1) * boardSizeInTiles.x] * 2 + board[i + (j + 1) * boardSizeInTiles.x]

			local tilemapRow = math.floor( state / 4 )
			local tilemapCol = math.floor( state - tilemapRow * 4 )
			love.graphics.draw(terrain2terrain20x20, love.graphics.newQuad(tilemapCol * cellSize.x,tilemapRow * cellSize.y,20,20,terrain2terrain20x20:getWidth(), terrain2terrain20x20:getHeight()), x, y, math.rad(0), 1, 1, 0, 0, 0, 0)
        end
	end
end

--water and earth modified for better view
function showMarchingSquaresTerrainRect()
	--draw the tiles
	for i = 0, boardSizeInTiles.x do
		for j = 0, boardSizeInTiles.y do
			local x = i * cellSize.x
			local y = j * cellSize.y
			local state = board[i + j * boardSizeInTiles.x] * 8 + board[i + 1 + j * boardSizeInTiles.x] * 4 + board[i + 1 + (j + 1) * boardSizeInTiles.x] * 2 + board[i + (j + 1) * boardSizeInTiles.x]

			local tilemapRow = math.floor( state / 4 )
			local tilemapCol = math.floor( state - tilemapRow * 4 )
			love.graphics.draw(terrain2terrain20x20rect, love.graphics.newQuad(tilemapCol * cellSize.x,tilemapRow * cellSize.y,20,20,terrain2terrain20x20rect:getWidth(), terrain2terrain20x20rect:getHeight()), x, y, math.rad(0), 1, 1, 0, 0, 0, 0)
        end
	end
end

function love.keypressed(key)
    if key == "0" then state = "" end
    if key == "1" then state = "dots" end
    if key == "2" then state = "line" end
    if key == "3" then state = "tiles" end
    if key == "4" then state = "2terrain" end
    if key == "5" then state = "2terrainrect" end
end


function love.update(dt)
end

function love.draw()
    love.graphics.setBackgroundColor(1,1,1)
    love.graphics.setColor(1,1,1)
    if state == "dots" then
        --draw the dots
        for i = 0, boardSizeInTiles.x + 1 do
            for j = 0, boardSizeInTiles.y + 1 do
                if board[i + j * boardSizeInTiles.x] == 0 then
                    love.graphics.setColor(0,0,0)
                else
                    love.graphics.setColor(1,0,0)
                end

                love.graphics.points( i * cellSize.x, j * cellSize.y )
            end
        end
    end

    if state == "line" then
        love.graphics.setColor(0,0,0)
        showMarchingSquaresline()
    end

    if state == "tiles" then
        showMarchingSquaresTiles()
    end

    if state == "2terrain" then
        showMarchingSquaresTerrain()
    end

    if state == "2terrainrect" then
        showMarchingSquaresTerrainRect()
    end
end