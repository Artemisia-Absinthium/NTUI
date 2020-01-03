--[[		NEVER TRUST USER'S INPUT non-released v0.1 alpha
	--------------------------------------------------------------------
					This file is part of N.T.U.I.

    N.T.U.I. is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Foobar is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with N.T.U.I.  If not, see <http://www.gnu.org/licenses/>.
    --------------------------------------------------------------------
    				A work made by SeaSharp's Team !
    --------------------------------------------------------------------
					Mini Game Scripting Files
]]

Coffee = Subview:extend
{
	time = 0,
	drawParent = false,
	nbrCup = 0,
	aliveCup = 0,
	lifeBar = "<3 <3 <3 <3 <3",
	started = false,

	Coffee = Tile:extend
	{
		width = 40,
		height = 44,
		image = "images/minigames/coffee.png",
		touch = false,
		acceleration = {x = 0, y = 150},

		onNew = function (self)
			--self.x = math.random(10, the.app.width - self.width - 10)
			self.x = math.random(the.view.Player.x - 350, the.view.Player.x + 350)
			self.y = - self.height
			self.direction = math.random(2)
			the.view.nbrCup = the.view.nbrCup + 1
			the.view.aliveCup = the.view.aliveCup + 1
			self.acceleration.y = 150 + the.view.nbrCup * 25
		end,

		onUpdate = function (self,elapsed)
			-- Cup rotation
			if self.direction == 1 then
				self.rotation = self.rotation + 0.02
			else
				self.rotation = self.rotation - 0.02
			end
			-- Cup death
			if self.y > the.app.height then
				the.view.aliveCup = the.view.aliveCup - 1
				self:die()
			end
		end
	},

	Player = Tile:new
	{
		x = 1024/2,
		y = 478,
		height = 98,
		width = 72,
		life = 5,
		image = 'images/minigames/coffeeplayer.png',
		canJump = false,
		acceleration = { x = 0, y = 1500},

		onUpdate = function (self)
			if the.keys:pressed(the.config.data.key.left) then
				self.velocity.x = -250
			elseif the.keys:pressed(the.config.data.key.right) then
				self.velocity.x = 250
			else
				self.velocity.x = 0
			end

			if the.keys:pressed(the.config.data.key.jump) and self.canJump then
				self.velocity.y = -700
				self.canJump = false
			end

			if self.y >= 478 and self.velocity.y > 0 then
				self.y = 478
				self.velocity.y = 0
				self.canJump = true
			end

			-- Blocking the player at the edges
			if self.x <= 0 then self.x = 0
			elseif self.x >= the.app.width - self.width then self.x = the.app.width - self.width
			end

			-- Player death
			if self.life == 0 then
				the.view:deactivate()
				the.minigameHit = true
			end

		end,

		onCollide = function (self,other)
			if other:instanceOf(the.view.Coffee) then
				self.life = self.life - 1
				the.view:flash({200,0,0}, 0.5)
				the.view.aliveCup = the.view.aliveCup - 1
				other:die()
			end
		end
	},

	Title = Text:extend {
		x = 20,
		y = 150,
		width = 984,
		align = "center",
		font = {"ressources/title.otf", 35},
		text = lang.seaSharpCupsAreEvil,
		tint = {0.92,0,0.29},
		onNew = function (self)
			SubTitle = Text:new {
				x = 20,
				y = self.y + 200,
				width = 984,
				align = "center",
				font = {"ressources/title.otf", 25},
				text = lang.spaceToContinue,
				tint = {0.26,0,0.08}
			}
			the.view.title:add(SubTitle)
		end
	},	

	onNew = function (self)
		math.randomseed(os.time())
		self.cups = Group:new()


		self.life = Text:new {
			x = 20,
			y = 20,
			width = the.app.width - 20,
			text = the.view.lifeBar,
			font = {"ressources/text.ttf", 20},
			tint = {0.8,0.11,0.11},
			onUpdate = function (self)
				self.text = the.view.lifeBar
			end
		}

		self:add(Fill:new
			{
				x = 0,
				y = 0,
				width = 1024,
				height = 576,
				fill = {111,78,55}
			}
		)
		self:add(self.life)
		self:add(self.cups)
		self:add(self.Player)
		-- Adding the Win text
		self.WinText = Text:new {
				x = 20,
				y = 250,
				width = 984,
				align = "center",
				font = {"ressources/title.otf", 25},
				text = lang.youWin .. "\n" .. lang.spaceToContinue,
				tint = {0.10,0.07,0.05},
				visible = false
			}
		self.title = Group:new()
		self.title:add(self.Title:new{})
		self:add(self.title)
		self:add(self.WinText)
	end,

	onUpdate = function (self,elapsed)
		if self.started then
			-- Win
			if self.nbrCup >= 100 then
				the.view.minigame = Breakout:new()
				if self.aliveCup == 0  then
					self.WinText.visible = true
					if the.keys:pressed(" ") then
						the.bossLevel = the.bossLevel + 1
						the.view:deactivate()
					end
				end

			-- Else add a new cup
			elseif self.time >= -0.0095*(self.nbrCup) + 1 then
				self.cups:add(self.Coffee:new{})
				self.time = 0
			else
				self.time = self.time + elapsed
			end
			self.Player:collide(self.cups)

			-- Life bar update
			the.view.lifeBar = ""
			for i = 1, self.Player.life do
				the.view.lifeBar = the.view.lifeBar .. "<3 "
			end
		elseif the.keys:pressed(" ") then
			self.title:die()
			self.started = true
		end
		
		-- Pause menu opening
		if the.keys:justPressed("escape") then
			the.view.pause = PauseMenu:new()
			the.view.pause:activate()
		end
	end
}

Breakout = Subview:extend
{
	drawParent = false,
	nbrBricks = 0,

	Player = Animation:new {
		x = 455,
		y = 500,
		width = 114,
		height = 32,
		image = "images/minigames/breakoutplayer.png",
		velocity = {x = 0, y = 0},
		sequences =
		{
			right = { frames = {1, 2, 3, 4}, fps = 8 },
			left = { frames = {4, 3, 2, 1}, fps = 8 }
		},

		onUpdate = function (self)
			-- Moves
			if the.keys:pressed(the.config.data.key.right) then
				self.velocity.x = the.view.Ball.velocity.tot
				self:play("right")
			elseif the.keys:pressed(the.config.data.key.left) then
				self.velocity.x = -the.view.Ball.velocity.tot
				self:play("left")
			else
				self.velocity.x = 0
				self:freeze()
			end

			-- Blocking the player at the edges
			if self.x <= 0 then self.x = 0
			elseif self.x >= the.app.width - self.width then self.x = the.app.width - self.width
			end

			-- Collision detection
			self:collide(the.view.Ball)
		end,

		onCollide = function (self, other)
			-- x Trajectory modification by colliding the player
			other.velocity.x = (self.x - other.x + (self.width - other.width) / 2) * -6.5
			if other.velocity.x > other.velocity.tot - 50 then other.velocity.x = other.velocity.tot - 50 end
			-- y velocity adaptation to keep the same total velocity: v.y² = v² - v.x²
			local vy = math.sqrt(other.velocity.tot * other.velocity.tot - other.velocity.x * other.velocity.x)
			if vy > 0 then other.velocity.y = - vy
			elseif vy < 0 then other.velocity.y = vy
			else vy = - 5
			end
		end
	},

	Ball = Tile:new {
		x = 502,
		y = 480,
		height = 20,
		width = 20,
		image = "images/minigames/ball.png",
		velocity = {x = 0, y = 0, tot = 300},
		stopped = true,
		gridSize = 120,

		onUpdate = function (self)
			-- Ball rotation
			if not self.stopped then
				self.rotation = self.rotation + 0.02
			else
				self.x = the.view.Player.x + 47
			end

			-- Start
			if the.keys:pressed(the.config.data.key.jump) and self.stopped then
				self.velocity = {x = 50, y = -400}
				self.velocity.tot = math.sqrt(self.velocity.x * self.velocity.x + self.velocity.y * self.velocity.y)
				the.view.title:die()
				self.stopped = false
			end

			-- Collision detection
			self:collide(the.view.bricks)
			self:collide(the.view.Player)

			-- Blocking the ball at the edges
			if self.x >= the.app.width - 20 then
				self.x = the.app.width - 20
				self.velocity.x = - self.velocity.x
			elseif self.x <= 0 then
				self.x = 0
				self.velocity.x = - self.velocity.x
			end
			if self.y >= the.app.height then
				the.view:deactivate()
				the.minigameHit = true
			elseif self.y <= 0 then
				self.y = 0
				self.velocity.y = - self.velocity.y
			end
		end,

		onCollide = function (self, other, xOverlap, yOverlap)
				other:displace(self)
				if xOverlap < yOverlap then
					self.velocity.x = -self.velocity.x
				else
					self.velocity.y = - self.velocity.y
				end
		end
	},

	Brick = Tile:extend {
		width = 60,
		height = 50,
		touched = false,

		onNew = function (self)
			the.view.nbrBricks = the.view.nbrBricks + 1
		end,

		onUpdate = function (self)
			-- Destruction animation
			if self.touched then
				self.scale = self.scale - 0.1
				if self.scale <= NEARLY_ZERO then
					the.view.nbrBricks = the.view.nbrBricks - 1
					self:die()
				end
			end
		end,

		onCollide = function (self, other)
			self.touched = true
			other.velocity.x = other.velocity.x + 5
			other.velocity.y = other.velocity.y + 5
			other.velocity.tot = other.velocity.tot + 5
		end
	},

	Title = Text:extend {
		x = 20,
		y = 250,
		width = 984,
		align = "center",
		font = {"ressources/title.otf", 35},
		text = "Sea Sharp fans are watching you!",
		tint = {0.92,0,0.29},
		onNew = function (self)
			SubTitle = Text:new {
				x = 20,
				y = self.y + 70,
				width = 984,
				align = "center",
				font = {"ressources/title.otf", 25},
				text = "Press Jump to start",
				tint = {0.26,0,0.08}
			}
			the.view.title:add(SubTitle)
		end
	},

	onNew = function (self)
		self:add(Fill:new{x = 0, y = 0, width = the.app.width, height = the.app.height, fill = {150,0,50}})
		self:add(Tile:new{x = 0, y = 532, width = the.app.width, image = "images/minigames/breakoutbg.gif"})
		self:add(self.Player)
		self.bricks = Group:new()
		self.title = Group:new()
		self.title:add(self.Title:new{})
		for i = 74, 900, 75 do
			self.bricks:add(self.Brick:new{x = i, y = 30, image = "images/minigames/brick1.png"})
			self.bricks:add(self.Brick:new{x = i, y = 110, image = "images/minigames/brick2.png"})
			self.bricks:add(self.Brick:new{x = i, y = 190, image = "images/minigames/brick3.png"})
		end
		self:add(self.Ball)
		self:add(self.bricks)
		self:add(self.title)

		-- Adding the Win text
		self.WinText = Text:new {
				x = 20,
				y = 250,
				width = 984,
				align = "center",
				font = {"ressources/title.otf", 25},
				text = lang.youWin .. "\n" .. lang.spaceToContinue,
				tint = {0.26,0,0.08},
				visible = false
			}
		self:add(self.WinText)
	end,

	onUpdate = function (self)
		-- Win
		if self.nbrBricks == 0 then
			self.WinText.visible = true
			the.view.Ball:die()
			if the.keys:pressed(" ") then
				the.bossLevel = the.bossLevel + 1
				the.view:deactivate()
			end
		end
		
		-- Pause menu opening
		if the.keys:justPressed("escape") then
			the.view.pause = PauseMenu:new()
			the.view.pause:activate()
		end
	end
}

Shooter = Subview:extend {
	lifeBar = "<3 <3 <3 <3 <3",
	lastSpawn = 0,
	nbrSpawn = 0,
	aliveEnemy = 0,
	started = false,
	
	player = Animation:new {
		x = 40,
		y = 288,
		height = 35,
		width = 115,
		image = "images/minigames/playershooter.png",
		sequences = {
			up = {frames = {1, 2, 3}, fps = 5},
			down = {frames = {3, 2, 1}, fps = 5}
		},
		velocity = {x = 0, y = 0},
		lastShot = 0,
		shootSpeed = 0.4,
		life = 5,
		lastMouseY = 288,
		cd = Animation:extend {
			width = 13,
			height = 10,
			image = "images/levelRessources/bullet.png",
			velocity = {x = 450, y = 0},
			sequences = {
				animation = { frames = {1, 2, 3, 4}, fps = 10 },
			},
			
			onUpdate = function (self, elapsed)
				self:play('animation')
			end,
			
			onCollide = function (self, other)
				other:die()
				self:die()
				the.view.aliveEnemy = the.view.aliveEnemy - 1
			end
		},
		onUpdate = function (self, elapsed)
			-- Keyboard moves
			if the.keys:pressed("up") then
				self.velocity.y = -300
				self:play("up")
			elseif the.keys:pressed("down") then
				self.velocity.y = 300
				self:play("down")
			else
				self.velocity.y = 0
				self:freeze()
			end
			
			-- Mouse moves (if the mouse position has changed since the last frame)
			if self.lastMouseY ~= the.mouse.y then
				self.y = the.mouse.y
				self.lastMouseY = the.mouse.y
			end
			
			-- Shots
			if self.lastShot >= self.shootSpeed then
				-- Keyboard shots
				if the.keys:pressed(the.config.data.key.shoot) then
					the.view.cds:add(self.cd:new{x = self.x + self.width, y = self.y + 13})				
				-- Mouse shots
				elseif the.mouse:pressed('l') or the.mouse:pressed('r') then
					the.view.cds:add(self.cd:new{x = self.x + self.width, y = self.y + 13})		
				end			
				self.lastShot = 0
			else
				self.lastShot = self.lastShot + elapsed
			end
			
			-- Blocking the player at the edges
			if self.y <= 40 then self.y = 40
			elseif self.y >= the.app.height - self.height then self.y = the.app.height - self.height
			end
			
			-- Pause menu opening
			if the.keys:justPressed("escape") then
				the.view.pause = PauseMenu:new()
				the.view.pause:activate()
			end
		end,
		
		onCollide = function (self, other)
			if other:instanceOf(the.view.Enemy) then
				other:die()
				the.view.aliveEnemy = the.view.aliveEnemy - 1
				self.life = self.life - 1
				the.view:flash({200,0,0}, 0.5)
			end
		end
	},
	
	Enemy = Text:extend {
		font = {"ressources/text.ttf", 26},
		velocity = {x = -200, y = 0},
		tint = {0.86,0.27,0.43},
		onNew = function (self)
			self.x = 1024
			self.y = math.random(53, 549)
			local randomText = math.random(4)
			if randomText == 1 then self.text = "other:Kick"
			elseif randomText == 2 then self.text = "$die=true"
			elseif randomText == 3 then self.text = "DELETE * WHERE name=Player"
			else self.text = "$ killall -q Player"
			end
			the.view.nbrSpawn = the.view.nbrSpawn + 1
			the.view.player.shootSpeed = the.view.player.shootSpeed - 0.0025
			self.velocity.x = self.velocity.x - 1.5 * the.view.nbrSpawn
			the.view.aliveEnemy = the.view.aliveEnemy + 1
			-- Hack to get the width of sprite
			self.width = string.len(self.text) * 15
			self.height = 25
		end,
		onUpdate = function (self)
			if self.x < - self.width then
				self:die()
				the.view.player.life = the.view.player.life - 1
				the.view.aliveEnemy = the.view.aliveEnemy - 1
				the.view:flash({200,0,0}, 0.5)
			end
		end
	},

	Title = Text:extend {
		x = 20,
		y = 250,
		width = 984,
		align = "center",
		font = {"ressources/title.otf", 35},
		text = "Sea Sharp will kick you!",
		tint = {0.71,0.33,0.43},
		onNew = function (self)
			SubTitle1 = Text:new {
				x = 20,
				y = self.y + 70,
				width = 984,
				align = "center",
				font = {"ressources/title.otf", 25},
				text = lang.spaceToContinue,
				tint = {0.68,0.33,0.71}
			}
			SubTitle2 = Text:new {
				x = 20,
				y = the.app.height - 100,
				font = {"ressources/text.ttf", 18},
				text = lang.controls .. ":\n" .. lang.keyboard .. ": " .. lang.up .. "/" .. lang.down .." " .. lang.toMove .. ", \"" .. the.config.data.key.shoot .. "\" " .. lang.toShoot .. "\n" .. lang.mouse .. lang.toMove .. ", " .. lang.leftClick .. " " .. lang.toShoot,
				tint = {0.68,0.33,0.71}
			}
			the.view.title:add(SubTitle1)
			the.view.title:add(SubTitle2)
		end
	},

	onNew = function (self)
		----- PARALLAX SCROLLING BACKGROUND GENERATION (wow ;) ) -----
		self.background = Group:new()
		
		-- Generic text class
		BgText = Text:extend {
			velocity = {x = - 700, y = 0},
			onUpdate = function (self)
				if self.x < - self.width then
					self.x = the.app.width
					self.y = math.random(53, 549)
				end
			end
		}
		
		-- We generate a new pseudo-random seed
		math.randomseed(os.time())
		
		-- We define the sprites to use
		BinaryText = BgText:extend {
			tint = {0.17,0.37,0.24},
			font = {"ressources/text.ttf",12},
			text = "",
			width = the.app.width,
			onNew = function (self)
				self.velocity.x = self.velocity.x / 3
				for i = 1, 144 do
					self.text = self.text .. (math.random(2) - 1)
				end
			end
		}
		
		CharacterText = BgText:extend {
			tint = {0.33, 0.71, 0.46},
			font = {"ressources/text.ttf",14},
			width = the.app.width,
			onNew = function (self)
				self.velocity.x = self.velocity.x / 2
				local randomText = math.random(5)
				if randomText == 1 then self.text = "ç@z$op¤j:A|hlbp^C¢rn@vß£//zŧmæ*   ...   µgji§_ł(th--gt)ĸ'ħ'ŋèđþø£¡<¢Ŧ°UoiMd$q~P:B#[cwF,Im*k*Y8RA2kPV,n/-7.;fgr%8yAn&?eq[/&&$)%EVAaFmV"
				elseif randomText == 2 then self.text = "7nP13%/uo{ZuKE.Mv4?}Lya58!y,9Jj?pQ'Tc>bG12_!=vx9_6]8,:U!55O0vµgji§_ł(th--gt)ĸ'ħ'ŋèđþø£¡<¢Ŧ°UoiMd$q~P:B#[cwF,Im*k*Y8RA2kPV,n/-7."
				elseif randomText == 3 then self.text = "@TiaxH@R($g}@TiaxH@*@fh'B0qq^{sORh,RvDO{6&lz'3vLL^I|t!}~qE.Mv4?}Lya58!y,9Jj?pQ'Tc>bG12_!=vx9_6](thgt)ĸ'ħ'ŋèđþø£¡<¢Ŧ°UoiM"
				elseif randomText == 4 then self.text = "sNr-BgjyO|f=+K)VR0ox2gKis<l&xFigS8|&UD=.fnn=4iJ$.(fy3FoPbKNzg?}BD<V'+:j(*0l1}7&XMvx,o0\~R`7^8gh6]`|U}A,mCV°UoiMd$q~P:B#[cwF,Im*th"
				else self.text = "A+#BD<V'+:j(*0l1}7&XMvx,o0\~R`7^8gh6]`|U}A,mCVlR,=d,-Yq=/ma#R=vyO|f=+K)VR0ox2gKis<l&xFigS8|&UD=.fnn=4iJ$.(fy3FoPbKNzg?}BD<V'+:j(*0!55O0"
				end
			end
		}
		
		HexaText = BgText:extend {
			tint = {0.33, 0.71, 0.46},
			font = {"ressources/text.ttf",18},
			width = the.app.width,
			onNew = function (self)
				local randomText = math.random(5)
				if randomText == 1 then self.text = "31363EB5F3939B363BB6E7DF0471D3C2   6F78C  1EDD779527CD435264        312DE4FFD61 50787   F367DAB30DBCA"
				elseif randomText == 2 then self.text = "B196D6A31BB20D84976D07DC911FABD29159F61070413E48D8AA4F0B7940B583313635F3939B363BB6E7DF0471D3C26C43"
				elseif randomText == 3 then self.text = "80A6D722D9469B46CF03F7472630C364E87BCE1E171C98F83C70B93EBAC52BC579408331363EB5F3939B363BB6E7DF0471"
				elseif randomText == 4 then self.text = "0B30E5577541049BD9B8DE7   .: -- # define {BDECF9DDB886795369D6646D3203313635F3939B363BB6E7DF} # --"
				else self.text = "1E68517B5547B29C7758728972A08B69DC24E70B073AC455651B3357CC8F0F80DC911FABD29159F670413E48D8AA4F0B7940B58331363EB5"
				end
			end
		}

		-- We add sprites to the group
			-- Background
		self.background:add(BinaryText:new{x = 0, y = 100})
		self.background:add(BinaryText:new{x = 150, y = 190})
		self.background:add(BinaryText:new{x = 500, y = 400})
		self.background:add(BinaryText:new{x = 800, y = 450})
			-- Middleground
		self.background:add(CharacterText:new{x = 0, y = 200})
		self.background:add(CharacterText:new{x = 50, y = 500})
		self.background:add(CharacterText:new{x = 500, y = 785})
		self.background:add(CharacterText:new{x = 0, y = 40})
			-- Foreground
		self.background:add(HexaText:new{x = 0, y = 300})
		self.background:add(HexaText:new{x = 100, y = 325})
	

		-- We add the background to the view
		self:add(Fill:new{x = 0, y = 0, height = the.app.height, width = the.app.width, fill = {0,0,0}})
		self:add(self.background)
		-------------------------------------------------------------
	
		life = Text:new {
			x = 10,
			y = 10,
			width = the.app.width - 20,
			text = the.view.lifeBar,
			font = {"ressources/text.ttf", 22},
			tint = {0.68,0.33,0.71},
			onUpdate = function (self)
				self.text = the.view.lifeBar
			end
		}
		self.enemies = Group:new()
		self.cds = Group:new()
		self:add(life)
		self:add(self.player)
		self:add(self.enemies)
		self:add(self.cds)
		self.title = Group:new()
		self.title:add(self.Title:new{})
		self:add(self.title)
	end,

	onUpdate = function (self, elapsed)
		-- Start
		if self.started then
			-- Win
			if self.nbrSpawn >= 100 then
				if self.aliveEnemy <= 0 then
					the.bossLevel = the.bossLevel + 1
					the.view:deactivate()
				end
			else
				-- Enemy spawn
				if self.lastSpawn > -0.017*self.nbrSpawn + 2 then
					self.enemies:add(self.Enemy:new{})
					self.lastSpawn = 0
				else self.lastSpawn = self.lastSpawn + elapsed
				end
			end

			-- Player death
			if self.player.life <= 0 then 
				the.view:deactivate()
				the.minigameHit = true
			end

			-- Life bar update
			self.lifeBar = ""
			for i = 1, self.player.life do
				self.lifeBar = self.lifeBar .. "<3 "
			end
			
			-- Player/Enemy collision detection
			self.enemies:collide(self.player)
			-- Projectile/Enemy collision detection
			self.enemies:collide(self.cds)
		elseif the.keys:pressed(" ") then
			self.started = true
			self.title:die()
		end
	end
}
