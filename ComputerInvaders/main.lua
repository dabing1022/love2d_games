function love.load()

	-- math random seed
	math.randomseed(os.time());
	
	-- load splash screen
	is_beginning = true;
	splash_screen = love.graphics.newImage("images/ComputerInvadersSplashScreen.png");
	score = 0;
	game_over = false;
	
	-- screen variables
	_W = 1024; 
	_H = 768;
	
	SCREEN_OFFSET_Y = 90;
	SCREEN_LEFT_OFFSET_X = 70; 
	SCREEN_RIGHT_OFFSET_X = _W - SCREEN_LEFT_OFFSET_X - 100;
	SCREEN_COLUMNS = 11;
	
	-- other global variables
	INIT = 0;
	LEFT = 1; 
	RIGHT = 2; 
	LEFT_DOWN = 3; 
	RIGHT_DOWN = 4;
	COLUMN_COUNT = 6; 
	ROW_COUNT = 6;
	COL_STEP = 0.5;
	ROW_STEP = 1.0;
	
	-- timer variables
	count = 0;
	update_delay = 1.0;
	
	-- image distplay variable
	blnOpen = true;
	
	-- enemyGroup variables
	enemyGroup = {};
	enemyGroup.offset_x = 10;
	enemyGroup.offset_y = 10;
	enemyGroup.enemy_width = 64;
	enemyGroup.enemy_height = 60;
	enemyGroup.leftmost_column = 0;
	enemyGroup.rightmost_column = 5;
	enemyGroup.move_direction = INIT;
	enemyGroup.is_at_lowest = false;
	enemyGroup.is_firable = true;
	enemyGroup.max_fireable = 7;
	enemyGroup.screen_column = 0;
	enemyGroup.screen_row = 0;
	
	-- player variables
	player = {};
	player.image = love.graphics.newImage("images/ci_player.png");
	player.width = 128;
	player.height = 44;
	player.x = 100;
	player.y = _H - player.height;
	player.is_firable = true;
	player.is_hit = false;
	player.lives = 4;
	player.max_fireable = 5;
	player.fire_cooldown = 0.33; -- 1/3 of a second
	
	-- enemy variables
	enemy = {};
	
	local xpos=0;
	local ypos=0;
	local num = -1;
	
	-- initialize enemy array
	for i=0,ROW_COUNT-1 do
		enemy[i] = {};
		for j=0,COLUMN_COUNT-1 do
			enemy[i][j] = {};
		end
	end
	
	-- initialize enemy array elements
	for i=0,COLUMN_COUNT-1 do
		-- enemy column 1
		num = num + 1;
		xpos = SCREEN_LEFT_OFFSET_X + (i*(enemyGroup.offset_x + enemyGroup.enemy_width));
		ypos = SCREEN_OFFSET_Y;
		enemy[i][0].x = xpos;
		enemy[i][0].y = SCREEN_OFFSET_Y + enemyGroup.offset_y;
		enemy[i][0].open_image = love.graphics.newImage("images/ci_enemy_top_open.png");
		enemy[i][0].closed_image = love.graphics.newImage("images/ci_enemy_top_closed.png");
		enemy[i][0].is_hit = false;
		enemy[i][0].fire_cooldown = 0.33;
		enemy[i][0].num = num;
		
		-- enemy column 2
		num = num + 1;
		ypos = ypos + enemyGroup.enemy_height + enemyGroup.offset_y;
		enemy[i][1].x = xpos;
		enemy[i][1].y = ypos;
		enemy[i][1].open_image = love.graphics.newImage("images/ci_enemy_top_open.png");
		enemy[i][1].closed_image =  love.graphics.newImage("images/ci_enemy_top_closed.png");
		enemy[i][1].is_hit = false;
		enemy[i][1].fire_cooldown = 0.33;
		enemy[i][1].num = num;
		
		-- enemy column 3
		num = num + 1;
		ypos = ypos + enemyGroup.enemy_height + enemyGroup.offset_y;
		enemy[i][2].x = xpos;
		enemy[i][2].y = ypos;
		enemy[i][2].open_image = love.graphics.newImage("images/ci_enemy_middle_open.png");
		enemy[i][2].closed_image = love.graphics.newImage("images/ci_enemy_middle_closed.png");
		enemy[i][2].is_hit = false;
		enemy[i][2].fire_cooldown = 0.33;
		enemy[i][2].num = num;
		
		-- enemy column 4
		num = num + 1;
		ypos = ypos + enemyGroup.enemy_height + enemyGroup.offset_y;
		enemy[i][3].x = xpos;
		enemy[i][3].y = ypos;
		enemy[i][3].open_image = love.graphics.newImage("images/ci_enemy_middle_open.png");
		enemy[i][3].closed_image = love.graphics.newImage("images/ci_enemy_middle_closed.png");
		enemy[i][3].is_hit = false;
		enemy[i][3].fire_cooldown = 0.33;
		enemy[i][3].num = num;
		
		-- enemy column 5
		num = num + 1;
		ypos = ypos + enemyGroup.enemy_height + enemyGroup.offset_y;
		enemy[i][4].x = xpos;
		enemy[i][4].y = ypos;
		enemy[i][4].open_image = love.graphics.newImage("images/ci_enemy_bottom_open.png");
		enemy[i][4].closed_image = love.graphics.newImage("images/ci_enemy_bottom_closed.png");
		enemy[i][4].is_hit = false;
		enemy[i][4].fire_cooldown = 0.33;
		enemy[i][4].num = num;
		
		-- enemy column 6
		num = num + 1;
		ypos = ypos + enemyGroup.enemy_height + enemyGroup.offset_y;
		enemy[i][5].x = xpos;
		enemy[i][5].y = ypos;
		enemy[i][5].open_image = love.graphics.newImage("images/ci_enemy_bottom_open.png");
		enemy[i][5].closed_image = love.graphics.newImage("images/ci_enemy_bottom_closed.png");
		enemy[i][5].is_hit = false;
		enemy[i][5].fire_cooldown = 0.33;
		enemy[i][5].num = num;
	end
	
	player_fire = {};
	player_fire.x = 0;
	player_fire.y = 0;
	player_fire.img = love.graphics.newImage("images/ci_bullet.png");
	player_fire.width = 10;
	player_fire.height = 30;
	
	enemy_fire = {};
	enemy_fire.x = 0;
	enemy_fire.y = 0;
	enemy_fire.img = love.graphics.newImage("images/ci_bullet.png");
	enemy_fire.width = 10;
	enemy_fire.height = 30;
	
end

function love.update(dt)
	if not game_over then
		-- Set the second counter
		count = count + dt;  		-- dt is in seconds
		
		-- Triggers every second
		if count > update_delay then
			-- Update blnOpen
			if blnOpen == false then
				blnOpen = true;
			else
				blnOpen = false;
			end
			
			-- update enemy positions
			updateEnemyXY();
			count = 0;
			enemy_hits = 0;
			
			-- check if game over
			for i=0,COLUMN_COUNT-1 do
				for j=0,ROW_COUNT-1 do
					if enemy[i][j].is_hit then
						enemy_hits = enemy_hits + 1;
					end
					
					if enemy[i][i].y >= (player.y + enemyGroup.enemy_height) then
						game_over = true;
						return;
					end
				end
			end
			
			if enemy_hits == 36 then
				game_over = true;
			end
			
			-- initiate enemy firing sequence
			if enemyGroup.is_firable and not game_over then
				local col = math.floor(math.random()* 10) % 6;
				enemy_fire_init(col)
			end
		end

		if love.keyboard.isDown("left") then
			player.x = player.x - 3;
			if player.x <= 0 then
				player.x = 0;
			end
		elseif love.keyboard.isDown("right") then
			player.x = player.x + 3;
			if player.x >= (_W - player.width) then
				player.x = _W - player.width;
			end
		end 
		
		if love.keyboard.isDown(" ") and player.is_firable == true and not game_over then
			player_fire_init()
			player.is_firable = false;
		end
		
		if player.is_firable == false and not game_over then
			player_firing()
		end
		
		if enemyGroup.is_firable == false and not game_over then
			enemy_firing()
		end
	end
end

function love.draw()
	if not game_over then
		love.graphics.print("Score: " .. score, 10, 10);
		-- draw player	
		love.graphics.draw(player.image, player.x, player.y);
		
		if player.is_firable == false then
			love.graphics.draw(player_fire.img, player_fire.x, player_fire.y);
		end
		
		if enemyGroup.is_firable == false then
			love.graphics.draw(enemy_fire.img, enemy_fire.x, enemy_fire.y);
		end
		-- draw enemy
		for i=0,COLUMN_COUNT-1 do
			for j=0,ROW_COUNT-1 do
				if not enemy[i][j].is_hit then 
					if blnOpen then
						love.graphics.draw(enemy[i][j].open_image, enemy[i][j].x, enemy[i][j].y);
					else
						love.graphics.draw(enemy[i][j].closed_image, enemy[i][j].x, enemy[i][j].y);
					end
				end
			end
		end
	else
		if score == 36 then
			love.graphics.print("GAME OVER, You have a perfect score of: " .. score .. "!", (_W * 0.5) - 75, _H * 0.5)
		else
			love.graphics.print("GAME OVER, Your score is: " .. score, (_W * 0.5) - 75, _H * 0.5)
		end
	end
end

function getLeftmostColumn()

	if not game_over then
	
	local leftmost_column = 0;
	
	for i=0,COLUMN_COUNT-1 do
		if enemy[i][0].is_hit and enemy[i][1].is_hit and enemy[i][2].is_hit and 
		   enemy[i][3].is_hit and enemy[i][4].is_hit and enemy[i][5].is_hit then
			leftmost_column = leftmost_column + 1;
		else
			return leftmost_column;
		end
	end
	
	return leftmost_column;
	
	end
end

function getRightmostColumn()

	if not game_over then
	
	local rightmost_column = 5;
	
	for i=COLUMN_COUNT-1,0,-1 do
		if enemy[i][0].is_hit and enemy[i][1].is_hit and enemy[i][2].is_hit and 
		   enemy[i][3].is_hit and enemy[i][4].is_hit and enemy[i][5].is_hit then
			rightmost_colum = rightmost_column - 1;
		else
			return rightmost_column;
		end
	end
	
	return rightmost_column;
	
	end
end

function nextMoveDirection()
	if not game_over then
	
	local leftmost_column = getLeftmostColumn();
	local rightmost_column = getRightmostColumn();
	
	if enemyGroup.move_direction == INIT then
		enemyGroup.move_direction = RIGHT;
		return RIGHT;
	elseif enemyGroup.move_direction == LEFT and enemy[leftmost_column][0].x <= SCREEN_LEFT_OFFSET_X then
		enemyGroup.move_direction = LEFT_DOWN;
		return LEFT_DOWN;
	elseif enemyGroup.move_direction == LEFT and not (enemy[leftmost_column][0].x <= SCREEN_LEFT_OFFSET_X) then
		enemyGroup.move_direction = LEFT;
		return LEFT;
	elseif enemyGroup.move_direction == RIGHT and not (enemy[rightmost_column][0].x >= SCREEN_RIGHT_OFFSET_X) then
		enemyGroup.move_direction = RIGHT;
		return RIGHT;
	elseif enemyGroup.move_direction == RIGHT and enemy[rightmost_column][0].x >= SCREEN_RIGHT_OFFSET_X then
		enemyGroup.move_direction = RIGHT_DOWN;
		return RIGHT_DOWN;
	elseif enemyGroup.move_direction == LEFT_DOWN then
		enemyGroup.move_direction = RIGHT;
		return RIGHT;
	elseif enemyGroup.move_direction == RIGHT_DOWN then
		enemyGroup.move_direction = LEFT;
		return LEFT;
	end
	
	end
end

function updateEnemyXY()
	if not game_over then
	
	local xpos = 0;
	local ypos = 0;
	local direction = 0;
	
	direction = nextMoveDirection();
	xpos = enemyGroup.offset_x + enemyGroup.enemy_width;
	ypos = enemyGroup.offset_y + enemyGroup.enemy_height;
	
	for i=0,COLUMN_COUNT-1 do
		for j=0,ROW_COUNT-1 do		
			if direction == LEFT then
				enemy[i][j].x = enemy[i][j].x - xpos;
			elseif direction == RIGHT then
				enemy[i][j].x = enemy[i][j].x + xpos;
			elseif direction == RIGHT_DOWN then
				enemy[i][j].y = enemy[i][j].y + ypos;
			elseif direction == LEFT_DOWN then
				enemy[i][j].y = enemy[i][j].y + ypos;
			end
		end
	end
	
	end
end

function player_fire_init()
	local xpos = player.x + (0.5 * player.width);
	local ypos = player.y - player.height;
	
	player_fire.x = xpos;
	player_fire.y = ypos;
end

function enemy_fire_init(colnum)
	if not game_over then
	
	local column, row = getFirableEnemy(colnum);
	
	if (column == nil) then
		return
	end
	
	local xpos = enemy[column][row].x + (0.5 * enemyGroup.enemy_width);
	local ypos = enemy[column][row].y + enemyGroup.enemy_height;
	
	enemy_fire.x = xpos;
	enemy_fire.y = ypos;
	
	enemyGroup.is_firable = false;
	end
end

function getFirableEnemy(colnum)

	if not game_over then
	for i=colnum, COLUMN_COUNT-1 do
		if (enemy[i][5].is_hit == false) then
			return i,5;
		elseif (enemy[i][4].is_hit == false) then
			return i,4;
		elseif (enemy[i][3].is_hit == false) then
			return i,3;
		elseif (enemy[i][2].is_hit == false) then
			return i,2;
		elseif (enemy[i][1].is_hit == false) then
			return i,1;
		elseif (enemy[i][0].is_hit == false) then
			return i,0;
		end
	end
	
	end
end

function player_firing()

	if not game_over then
	
	for i=0,COLUMN_COUNT-1 do
		for j=0,ROW_COUNT-1 do
			if collision(player_fire.x,player_fire.y, player_fire.width, player_fire.height,
					     enemy[i][j].x,enemy[i][j].y, enemyGroup.enemy_width, enemyGroup.enemy_height)
						 and enemy[i][j].is_hit == false then
				enemy[i][j].is_hit = true;
				player_fire.y = 0;
				player.is_firable = true;
				score = score + 1;
			end
		end
	end
	
	if player_fire.y > 0 then
		player_fire.y = player_fire.y - 3;
	else
		player.is_firable = true;
	end
	
	end
end

function enemy_firing()
	if not game_over then
	
	if collision(enemy_fire.x, enemy_fire.y, enemy_fire.width, enemy_fire.height,
				player.x, player.y, player.width, player.height) == true then
		game_over = true;
	end
	
	if enemy_fire.y < (player.y + 20) then
		enemy_fire.y = enemy_fire.y + .5;
	else
		enemyGroup.is_firable = true;
		enemy_fire.x = 0;
		enemy_fire.y = 0;
	end
	
	end
end

function collision(x1,y1,w1,h1,x2,y2,w2,h2)
	if x1 + w1 > x2 and x1 < (x2 + w2)  -- clip top
		and (y1 + h1) > y2 and y1 < (y2 + h2) then -- clip bottom
		return true;
	else
		return false;
	end
end