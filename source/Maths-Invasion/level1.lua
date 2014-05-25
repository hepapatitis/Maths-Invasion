-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local spawnQuestion -- Reference for the timer

--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5
local questionTable = {}
local question_indicator = {}
local score = 0;
local max_level = 4;
local button_width = 50;
local button_height = 64;
local button_margin = 10;
	
function scene:create( event )

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	local sceneGroup = self.view
	local keyboardGroup = display.newGroup()
	local questionGroup = display.newGroup()

	-- create a grey rectangle as the backdrop
	local background = display.newRect( 0, 0, screenW, screenH )
	background.anchorX = 0
	background.anchorY = 0
	background:setFillColor( .5 )
	
	-- create number input display
	local user_input = display.newText( "", halfW, 70, "Arial", 30 )
	local score_text = display.newText( "0", 160, 500, "Arial", 30 )
	
	-- create buttons
	local function createButton( num, x, y )
		local b = display.newImageRect( "button-"..num..".png", button_width, button_height )
		b.x, b.y = x, y
		b.num = num
		
		return b
	end
	
	local function createRemoveButton( x, y )
		local b = display.newImageRect( "button-x.png", 25, 32 )
		b.x, b.y = x, y
		
		return b
	end
	
	local function createEnterButton( x, y )
		local b = display.newImageRect( "button-enter.png", 125, 32 )
		b.x, b.y = x, y
		
		return b
	end
	
	local function btn_listener(event)
		print(event.name.." occured by" .. event.target.num)
		user_input.text = user_input.text .. event.target.num;
		return true
	end
	
	local function btn_x_listener(event)
		user_input.text = "";
		return true
	end
	
	local function btn_enter_listener(event)
		-- Check Answer
		for key,value in pairs(questionTable) do
			if questionTable[key].answer == tonumber(user_input.text) then
				questionTable[key]:removeSelf()
				table.remove(questionTable, key)
				score = score + 3;
				score_text.text = score;
			end
		end
		user_input.text = "";
		refresh_question_indicator()
		return true
	end

	local centre_x = screenW * 0.5;
	local centre_y = screenH * 0.5;

	local button_1 = createButton( 1, centre_x - button_margin - button_width, centre_y + button_margin + button_height )
	local button_2 = createButton( 2, centre_x                               , centre_y + button_margin + button_height )
	local button_3 = createButton( 3, centre_x + button_margin + button_width, centre_y + button_margin + button_height )
	local button_4 = createButton( 4, centre_x - button_margin - button_width, centre_y )
	local button_5 = createButton( 5, centre_x                               , centre_y )
	local button_6 = createButton( 6, centre_x + button_margin + button_width, centre_y )
	local button_7 = createButton( 7, centre_x - button_margin - button_width, centre_y - button_margin - button_height )
	local button_8 = createButton( 8, centre_x                               , centre_y - button_margin - button_height )
	local button_9 = createButton( 9, centre_x + button_margin + button_width, centre_y - button_margin - button_height )
	local button_0 = createButton( 0, centre_x - button_margin - button_width, centre_y + ( button_margin + button_height ) * 2 )
	local button_x = createRemoveButton( 265, 352 )
	local button_enter = createEnterButton( halfW, 450 )
	
	-- Create Question Indicator
	for i = 1, 10, 1 do
		question_indicator[i] = display.newRoundedRect( 20, (((i-1)*40) + (i*5)), 35, 40, 5 )
		question_indicator[i]:setFillColor( 1 )
		questionGroup:insert(question_indicator[i])
	end
	
	button_1:addEventListener("tap", btn_listener)
	button_2:addEventListener("tap", btn_listener)
	button_3:addEventListener("tap", btn_listener)
	button_4:addEventListener("tap", btn_listener)
	button_5:addEventListener("tap", btn_listener)
	button_6:addEventListener("tap", btn_listener)
	button_7:addEventListener("tap", btn_listener)
	button_8:addEventListener("tap", btn_listener)
	button_9:addEventListener("tap", btn_listener)
	button_0:addEventListener("tap", btn_listener)
	button_x:addEventListener("tap", btn_x_listener)
	button_enter:addEventListener("tap", btn_enter_listener)
	
	keyboardGroup:insert( button_1 )
	keyboardGroup:insert( button_2 )
	keyboardGroup:insert( button_3 )
	keyboardGroup:insert( button_4 )
	keyboardGroup:insert( button_5 )
	keyboardGroup:insert( button_6 )
	keyboardGroup:insert( button_7 )
	keyboardGroup:insert( button_8 )
	keyboardGroup:insert( button_9 )
	keyboardGroup:insert( button_0 )
	
	-- all display objects must be inserted into group
	sceneGroup:insert( background )
	sceneGroup:insert( user_input )
	sceneGroup:insert( score_text )
end


function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
		
		-- Let the game begin
		spawnQuestion = function()
			local level = math.random(max_level)
			local a = math.random(10)
			local b = math.random(10)
			local question = display.newText( "", 160, 40, "Arial", 30 )
			question.x = 100 + math.random(200)
			question.y = 40 + math.random(300)
			
			if level == 0 then
				question.answer = a+b
				question.text = a .. "+" .. b
			elseif level == 1 then
				if a < b then
					question.answer = b-a
					question.text = b .. "-" .. a
				else
					question.answer = a-b
					question.text = a .. "-" .. b
				end
			elseif level == 2 then
				question.answer = a*b
				question.text = a .. "*" .. b
			else
				question.answer = b
				question.text = (a*b) .. "/" .. a
			end
			
			table.insert(questionTable, question)
			
			refresh_question_indicator();
		end
		
		
		
		-- Timer Startooo
		timer.performWithDelay(5000, spawnQuestion, 0)
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
		timer.cancel(spawnQuestion)
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
	
end

function scene:destroy( event )

	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	local sceneGroup = self.view
	
	package.loaded[physics] = nil
	physics = nil
end

function refresh_question_indicator()
	local total_question = #questionTable;
	for i = 1, 10, 1 do
		if i <= total_question then
			question_indicator[i]:setFillColor( 0 )
		else
			question_indicator[i]:setFillColor( 1 )
		end
	end
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene