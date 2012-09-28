function love.load()
	-- Screen Width and Height
	_W = 1024; _H = 768;
	
	-- Constants
	ENEMY_TOP 		= 1;
	ENEMY_MIDDLE 	= 2;
	ENEMY_BOTTOM 	= 3;
	
	MOVE_DX = 45;
	MOVE_DY = 80;
	
	-- Global Variables
	
	blnOpen = true;
	
	player_x = _W * 0.5;
	player_y = _H - 44;
	
	count = 0;
	update_delay = 1;
	
	move_x_factor = 0;
	move_y_factor = 0;
	enemy_num = 36;
	move_instance = 0;
	
	fire = { _x = player_x + 60, _y = _H - 75, is_fired = true, image = love.graphics.newImage("images/si_fire.png") };
	
	-- Enemy Array
	enemy = {}; enemy[0] = {}; enemy[1] = {}; enemy[2] = {}; enemy[3] = {}; enemy[4] = {}; enemy[5] = {};

	enemy[0][0] = { is_hit = false, player_type = ENEMY_TOP };	
	enemy[0][1] = { is_hit = false, player_type = ENEMY_TOP };
	enemy[0][2] = { is_hit = false, player_type = ENEMY_MIDDLE };
	enemy[0][3] = { is_hit = false, player_type = ENEMY_MIDDLE };
	enemy[0][4] = { is_hit = false, player_type = ENEMY_BOTTOM };
	enemy[0][5] = { is_hit = false, player_type = ENEMY_BOTTOM };

	enemy[1][0] = { is_hit = false, player_type = ENEMY_TOP };
	enemy[1][1] = { is_hit = false, player_type = ENEMY_TOP };
	enemy[1][2] = { is_hit = false, player_type = ENEMY_MIDDLE };
	enemy[1][3] = { is_hit = false, player_type = ENEMY_MIDDLE };
	enemy[1][4] = { is_hit = false, player_type = ENEMY_BOTTOM };
	enemy[1][5] = { is_hit = false, player_type = ENEMY_BOTTOM };
	
	enemy[2][0] = { is_hit = false, player_type = ENEMY_TOP };
	enemy[2][1] = { is_hit = false, player_type = ENEMY_TOP };
	enemy[2][2] = { is_hit = false, player_type = ENEMY_MIDDLE };
	enemy[2][3] = { is_hit = false, player_type = ENEMY_MIDDLE };
	enemy[2][4] = { is_hit = false, player_type = ENEMY_BOTTOM };
	enemy[2][5] = { is_hit = false, player_type = ENEMY_BOTTOM };

	enemy[3][0] = { is_hit = false, player_type = ENEMY_TOP };	
	enemy[3][1] = { is_hit = false, player_type = ENEMY_TOP };
	enemy[3][2] = { is_hit = false, player_type = ENEMY_MIDDLE };
	enemy[3][3] = { is_hit = false, player_type = ENEMY_MIDDLE };
	enemy[3][4] = { is_hit = false, player_type = ENEMY_BOTTOM };
	enemy[3][5] = { is_hit = false, player_type = ENEMY_BOTTOM };

	enemy[4][0] = { is_hit = false, player_type = ENEMY_TOP };
	enemy[4][1] = { is_hit = false, player_type = ENEMY_TOP };
	enemy[4][2] = { is_hit = false, player_type = ENEMY_MIDDLE };
	enemy[4][3] = { is_hit = false, player_type = ENEMY_MIDDLE };
	enemy[4][4] = { is_hit = false, player_type = ENEMY_BOTTOM };
	enemy[4][5] = { is_hit = false, player_type = ENEMY_BOTTOM };

	enemy[5][0] = { is_hit = false, player_type = ENEMY_TOP };	
	enemy[5][1] = { is_hit = false, player_type = ENEMY_TOP };
	enemy[5][2] = { is_hit = false, player_type = ENEMY_MIDDLE };
	enemy[5][3] = { is_hit = false, player_type = ENEMY_MIDDLE };
	enemy[5][4] = { is_hit = false, player_type = ENEMY_BOTTOM };
	enemy[5][5] = { is_hit = false, player_type = ENEMY_BOTTOM };

	-- Load Player and Enamies Graphics
	si_player 			= love.graphics.newImage("images/si_player_0000.png");
	si_top_open 		= love.graphics.newImage("images/si_enemy_0005.png");
	si_top_closed 		= love.graphics.newImage("images/si_enemy_0004.png");
	si_middle_open 		= love.graphics.newImage("images/si_enemy_0003.png");
	si_middle_closed 	= love.graphics.newImage("images/si_enemy_0002.png");
	si_bottom_open 		= love.graphics.newImage("images/si_enemy_0001.png");
	si_bottom_closed 	= love.graphics.newImage("images/si_enemy_0000.png");
	
end

function love.update(dt)
	
	-- Set the second counter
	count = count + dt;  		-- dt is in seconds
	
	if enemy_num < 13 then
		update_delay = update_delay - 0.5;
	end
	
	-- Triggers every second
	if count > update_delay then
		
		-- Update blnOpen
		if blnOpen == false then
			blnOpen = true;
		else
			blnOpen = false;
		end
		
		count = 0;
	end

	if love.keyboard.isDown("left") then
		player_x = player_x - 3;
	elseif love.keyboard.isDown("right") then
		player_x = player_x + 3;
    end 
	
	if love.keyboard.isDown(" ") then
		print("Spacebar is down");
	end
end

function love.draw()

	_x = 0; _y = 0;
	local x_offset = 90;
	local y_offset = 80;
	
	local screen_x_offset = 100;
	local screen_y_offset = 50;
		
	-- Render Player
	love.graphics.draw(si_player, player_x, player_y);
	
	if fire.is_fired then
		love.graphics.draw(fire.image, fire._x, fire._y);
	end
	
	-- Render Enemies
	for j=0,5 do
		for i=0,5 do
			if blnOpen == true then
				if enemy[i][j].player_type == ENEMY_TOP then
					love.graphics.draw(si_top_open,    _x + screen_x_offset + move_x_factor, _y + screen_y_offset + move_y_factor);
				elseif enemy[i][j].player_type == ENEMY_MIDDLE then
					love.graphics.draw(si_middle_open, _x + screen_x_offset + move_x_factor, _y + screen_y_offset + move_y_factor);
				elseif enemy[i][j].player_type == ENEMY_BOTTOM then
					love.graphics.draw(si_bottom_open, _x + screen_x_offset + move_x_factor, _y + screen_y_offset + move_y_factor);
				end
			else
				if enemy[i][j].player_type == ENEMY_TOP then
					love.graphics.draw(si_top_closed,    _x + screen_x_offset + move_x_factor, _y + screen_y_offset + move_y_factor);
				elseif enemy[i][j].player_type == ENEMY_MIDDLE then
					love.graphics.draw(si_middle_closed, _x + screen_x_offset + move_x_factor, _y + screen_y_offset + move_y_factor);
				elseif enemy[i][j].player_type == ENEMY_BOTTOM then
					love.graphics.draw(si_bottom_closed, _x + screen_x_offset + move_x_factor, _y + screen_y_offset + move_y_factor);
				end
			end
			
			_x = _x + x_offset;
		end
		
		_x = 0;
		_y = _y + y_offset;
	end
end

function check_collision(ax1,ay1,aw,ah, bx1,by1,bw,bh)

  local ax2,ay2,bx2,by2 = ax1 + aw, ay1 + ah, bx1 + bw, by1 + bh
  return ax1 < bx2 and ax2 > bx1 and ay1 < by2 and ay2 > by1
end
