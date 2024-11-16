local EditorState = State()
local gridSpaceSize
local width
local height
local levelData
local selectedSpace
local cameraOffsetX = 0
local cameraOffsetY = 0
local selectedBlock


function EditorState:enter()
    gridSpaceSize = 50
    width = 256
    height = 10
    selectedSpace = 1

    blocks = {
        ["empty"] = {image = nil, color = {1,1,1,0}},
        ["ground"] = {image = nil, color = {102/255,70/255,0}},
        ["brick"] = {image = nil, color = {56/255,17/255,3/255}},
        ["question_block"] = {image = nil, color = {222/255,196/255,0}},
        ["hard_block"] = {image = nil, color = {1,115/255,0}},
        ["pipe"] = {image = nil, color = {0,1,0.2}},
    }


    levelData = {header = {width = width, height = height}, spaces = {}}

    for h = 1,height do
        for w = 1,width do
            table.insert(levelData.spaces, {x = w, y = h, tile = "empty"})
        end
    end

    love.filesystem.write("testData.lua", lume.serialize(levelData))



    --init UI shit

    EditorState:InitUiShit()


end

function EditorState:InitUiShit()
    local blockOptions = {}
    for blockName, _ in pairs(blocks) do
        table.insert(blockOptions, {
            option = blockName,
            func = function()
                selectedBlock = blockName
            end
        })
    end

    local functionOption = {
        {
            option = "Export Level",
            func = function()
                love.filesystem.write(os.time() .. ".lua", lume.serialize(levelData))
            end
        },
    }
    Select = {
        Objects.UI.Select(Project.GameWidth-100,0,100,30,blockOptions,"empty","Blocks"),
        Objects.UI.Select(Project.GameWidth-210,0,100,30,functionOption,"functions","Functions"),
    }
end


function EditorState:update(dt)
    local cursorX = CursorX + cameraOffsetX
    local cursorY = CursorY + cameraOffsetY

    for Index, Space in pairs(levelData.spaces) do
        local spaceLeft = Space.x * gridSpaceSize
        local spaceRight = (Space.x + 1) * gridSpaceSize
        local spaceTop = Space.y * gridSpaceSize
        local spaceBottom = (Space.y + 1) * gridSpaceSize

        if cursorX > spaceLeft and cursorX < spaceRight and cursorY > spaceTop and cursorY < spaceBottom then
            selectedSpace = Index
            if Input:down("MouseLeft") then
                levelData.spaces[selectedSpace].tile = selectedBlock
            end
        end
    end



    if Input:down("MouseMiddle") then
        if not cameraMoving then
            cameraMoving = {startX = CursorX, startY = CursorY}
        end

        local deltaX = cameraMoving.startX - CursorX
        local deltaY = cameraMoving.startY - CursorY

        cameraOffsetX = cameraOffsetX + deltaX
        cameraOffsetY = cameraOffsetY + deltaY

        cameraMoving.startX = CursorX
        cameraMoving.startY = CursorY
    else
        cameraMoving = nil
    end

    EditorState:updateUIShit()
end

function EditorState:updateUIShit()
    for Index,Select in pairs(Select) do
        Select:update()
    end
end

function EditorState:drawUIShit()
    for Index, Select in pairs(Select) do
        Select:draw()
    end
end

function EditorState:draw()

    for Index, Space in pairs(levelData.spaces) do
        local x = Space.x * gridSpaceSize - cameraOffsetX
        local y = Space.y * gridSpaceSize - cameraOffsetY
        local size = gridSpaceSize

        for TileName,Tile in pairs(blocks) do
            if TileName == Space.tile then
                if Tile.image then 
                    love.graphics.draw(Tile.image, x, y) 
                else
                    love.graphics.setColor(Tile.color)
                    love.graphics.rectangle("fill", x, y, size, size)
                end
            end
        end
        love.graphics.setColor(1,1,1)
        love.graphics.rectangle("line", x, y, size, size)

        if selectedSpace == Index then
            love.graphics.rectangle("fill", x, y, size, size)

        end
    end



    EditorState:drawUIShit()
end

return EditorState
