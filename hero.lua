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
					Hero's objects scripting file
]]
--Hero main short range weapon 
Controller = Animation:new
{
	--general properties
	width = 80, height = 22,
	paused = false,
	image = "images/levelRessources/controller.png",
	visible = false,
	currentOv = 8,
	--animations
	sequences = { 
		left = { frames = { 7, 8, 9}, fps = 15 }, 
		right = { frames = { 2, 3, 4}, fps = 15 }, 
	},
	
	onNew = function (self)
		--Get the power of wapon, depend of buyed bonuses	
		if the.config.data.game.controllerBonus then
			self.attackPower = 15
		else
			self.attackPower = 10
		end
		--get his orientation from the hero object
		self.orientation = the.hero.orientation
	end,
	
	runCollisions = function (self)
		the.view.objects:collide(self)	
	end,
	
	onUpdate = function (self, elapsed)
		--update his position
		self.y = the.hero.y + 36
		if self.orientation == "right" then
			self.x = the.hero.x + 44
		else
			self.x = the.hero.x - self.width
		end
		--update his state
		if the.hero.hit then
			self:freeze(1)
			self:die()
			the.controllerOver = true
		end
		if self.currentFrame == 7 or self.currentFrame == 2 then
			self.currentOv = 8
		elseif self.currentFrame == 8 or self.currentFrame == 3 then
			self.currentOv = 2 * 8 
		elseif self.currentFrame == 9 or self.currentFrame == 4 then
			self.currentOv = 2 * 8
		end
		
		if the.hero.currentFrame == 14 then
			self.visible = true
			self:play('right')
			if self.currentFrame == 4 then
				self:die()
				the.controllerOver = true
				self:freeze(1)
			end
		elseif the.hero.currentFrame == 19 then
			self.visible = true
			self:play('left')
			if self.currentFrame == 9 then
				self:die()
				the.controllerOver = true
				self:freeze(1)
			end
		end
		self:runCollisions()
	end,
	--Function called when the object collide with an other one
	onCollide = function (self, other, hOverlap, vOverlap )
		--final boss
		if other:instanceOf(Sienne) then
			if the.hero.x - other.x > 0 then
				if  the.hero.x - other.x < other.width + self.currentOv +5 and not other.hitByController then
					other.hited = true
					self.justHited = true
				other.nbrHit = other.nbrHit + 1
				end
			else
				if  other.x - self.x < self.currentOv and not other.hitByController then
					other.hited = true
					other.nbrHit = other.nbrHit + 1
				end
			end
		--General ennemies 
		elseif other:instanceOf(Nerd) or other:instanceOf(Zombie) or other:instanceOf(Bully)then
			if the.hero.x - other.x > 0 then
				if  the.hero.x - other.x < other.width + self.currentOv +5 and not other.hitByController then
					other.life = other.life - self.attackPower
					other.hitByController = true
				end
			else
				if  other.x - self.x < self.currentOv and not other.hitByController then
					other.life = other.life - self.attackPower
					other.hitByController = true
				end
			end
		end
	end
}
--Hero long distance weapon
Gun = Animation:new
{
	--general properties
	width = 30, height = 51,
	paused = false,
	visible = false,
	shoot = true,
	played = false,
	image = "images/levelRessources/gun.png",
	
	--animations
	sequences = { 
		left = { frames = { 4, 9, 10, 11, 12}, fps = 20, loops = false}, 
		right = { frames = { 4, 5, 6, 7, 8}, fps = 20, loops = false}, 
	},
	
	onUpdate = function (self, elapsed)
		--update his y position and sound effect
		self.y = the.hero.y + 18
		if not self.played then
			the.sound.play("sounds/gun.ogg", "effect")
			self.played = true
		end
		
		--update his x position and state depending of his orientation when created
		if the.gun.right then
			self.x = the.hero.x + 44
			self.visible = true
			self:play('right')
			
			if self.currentFrame == 7 and self.shoot then
				the.view.projectiles:add(Bullet
				:new{x = self.x + self.width, y = self.y + 6, RightDirected = true})
				self.shoot = false
			end
			if self.currentFrame == 8 then
				the.gun.right = false
			end
		elseif the.gun.left then
			self.x = the.hero.x - self.width
			self.visible = true
			self:play('left')
			if self.currentFrame == 11 and self.shoot then
				the.view.projectiles:add(Bullet:new{x = self.x, y = self.y + 6, RightDirected = false})
				self.shoot = false
			end
			if self.currentFrame == 12 then
				the.gun.left = false
				
			end
		else
			self.visible = false
			self:die()
		end
	end,
	
}
--Hero main object
Hero = Animation:new
{
	-- Local variable of the Hero object
	width = 44, height = 96,
	paused = false,
	attacking = false,
	image = "images/hero.png",
	invincible = false,
	kick = false,
	onAir = true,
	canJump = false,
	canAttack = true,
	wait = true,
	ejecting = false,
	smoothBack = false,
	ejectRight = true,
	orientation = "right",
	life = the.hero.Maxlife,
	nbrCD = the.config.data.game.nbrCD, -- CHANGEMENT
	timeInvincible = 0,
	timeEjecting = 0,
	timeLastAttack = 0,
	attackPower = the.hero.attackPower,
	normalAcceleration = { x = 0, y = 600},
	onWall = false,
	posSelect = true,
	bullyEjectX = 0,
	currentBugAdd = 1,
	timeBugAttack = 0,
	nothHealed = true,
	--The Hero animations sequences
	sequences = { 
		left = { frames = { 7, 6, 7, 8}, fps = 8 }, 
		right = { frames = { 2, 1, 2, 3}, fps = 8 },
		jumpLeftUp = { frames = { 48}, fps = 5 },
		jumpLeftDown = { frames = { 49}, fps = 5 },
		jumpRightUp = { frames = { 46}, fps = 5 },
		jumpRightDown = { frames = { 47}, fps = 5 },
		leftKick = { frames = { 16, 17, 18, 19}, fps = 30, loops = false},
		rightKick = { frames = { 11, 12, 13, 14}, fps = 30, loops = false },
		
		leftShoot = { frames = { 26, 27, 28, 29}, fps = 20, loops = false },
		rightShoot = { frames = { 21, 22, 23, 24}, fps = 20, loops = false },
		
		bugAttack = { frames = {  31, 32, 33}, fps = 20, loops = false },
		
		waitLeft = { frames = { 42, 42, 41, 41}, fps = 8 },
		waitRight = { frames = { 37, 37, 36, 36,}, fps = 8 },
		
		leftHit = { frames = { 8, 40, 7, 40, 6, 40, 7, 40}, fps = 10},
		rightHit = { frames = { 3, 40, 2, 40, 1, 40, 2, 40}, fps = 10},
		jumpHitLeft = { frames = { 7, 40 }, fps = 10},
		jumpHitRight = { frames = { 2, 40}, fps = 10},
		
		waitLeftHit = { frames = {  42, 42, 40, 41, 41, 40}, fps = 10 },
		waitRightHit = { frames = { 37, 37, 40, 36, 36, 40}, fps = 10},
		
		die = {frames = { 1, 4, 15, 23, 1, 4, 15, 23, 1, 4, 15, 23, 1, 4, 15, 23, 3}, fps = 5},
	},

	--Collision function
	runCollisions = function (self)
		the.view.map:subcollide(self)
		the.view.map:subdisplace(self)
		the.view.objects:collide(self)
		the.view.projectiles:collide(self)
	end,
	
	--Function called at the end of each animations sequences
	onEndSequence = function (self)
		if not the.controllerOver then
			self.paused = true
		else
			if self.attacking then
				self.attacking = false
				self.timeLastAttack = 0
			end
			self.bugAttack = false
			self.kick = false
			self.paused = false
			self.smoothBack = true
		end
	end,
	--Function called when the object his created
	onNew = function (self)
		the.death = false
		--give some properties depending of buyed bonuses
		if the.config.data.game.bugBonus then
			the.bug.levelMax = 75
		else
			the.bug.levelMax = 50
		end
		
		if the.config.data.game.bugBonus then
			the.bug.duration = 5
		else
			the.bug.duration = 3
		end
		
		if the.config.data.game.bugBonus then
			the.bug.glitchPower = 16
		else
			the.bug.glitchPower = 11
		end
	end,
	--Function called at each object update
	onUpdate = function (self, elapsed)
		self.nbrCD = the.config.data.game.nbrCD
		-- Player death screens ---------------------
		local endScreen = math.random(2)
		
		if the.bug.life and self.notHealed then
			self.notHealed = false
			if the.config.data.game.bugBonus then
				self.life = self.life + 50
			else
				self.life = self.life + 75
			end
			
			if self.life > 150 then
				self.life = 150
			end
			the.view:flash({0,255,0})
		elseif not the.bug.life then
			self.notHealed = true
		end
		
		if self.life <= 0 then
			-- Damage death
			self.width = 30
			self.height = 70
			the.death = true
			self:play("die")
			the.sound.play("sounds/gameover.ogg", "effect")
			TEsound.stop("music", false)
			if self.currentFrame == 3 then
				self:die()
				if endScreen == 1 then
					the.view.hud:add(Fill:new{x = 0, y = 0, width = the.app.width, height = the.app.height, fill = {0,0,0}})
					the.view.hud:add(Text:new{x = 0, y = 180, width = the.app.width, align = "center", font = {"ressources/text.ttf",20},  tint = {1,1,1}, text = lang.gameOverDamage1})
					the.view.hud:add(Text:new{x = 0, y = 250, width = the.app.width, align = "center", font = {"ressources/title.otf",26}, text = "GAME OVER"})
					the.view.hud:add(Text:new{x = 30, y = the.app.height - 30,  width = 400, font = {"ressources/text.ttf",15}, tint = {1,1,1}, text = lang.escapeToClose})
				elseif endScreen == 2 then
					the.view.hud:add(Tile:new{x = 0, y = 0, image = "images/endscreen/gameover_d2.jpg"})
					the.view.hud:add(Fill:new{x = 500, y = 300, width = 500, height = 150, fill = {0,0,0,80}})
					the.view.hud:add(Text:new{x = 520, y = 320, width = 460, align = "center", font = {"ressources/text.ttf",25}, text = lang.gameOverDamage2})
					the.view.hud:add(Text:new{x = 30, y = the.app.height - 30,  width = 400, font = {"ressources/text.ttf",15}, tint = {1,1,1}, text = lang.escapeToClose})
				end
			end
		elseif the.bug.level >= the.bug.levelMax then
			-- Bug death
			if not the.death then
				the.sound.play("sounds/gameover.ogg", "effect")
				the.death = true
			end
			self:die()
			if endScreen == 1 then
				the.view.hud:add(Fill:new{x = 0, y = 0, width = the.app.width, height = the.app.height, fill = {56,48,87}})
				the.view.hud:add(Tile:new{x = the.app.width / 2 - 60, y = 50, image = "images/endscreen/gameover_b1.png"})
				the.view.hud:add(Text:new{x = 265, y = 200, width = 200, align = "right", font = {"ressources/text.ttf",20}, text = lang.gameOverBug1Start})
				the.view.hud:add(TextInput:new {
					x = 490, y = 200,
					font = {"ressources/text.ttf", 20},
					text = "[ <-- " .. lang.enterYourName .. "]",
				})
				the.view.hud:add(Text:new{x = 25, y = 300, width = the.app.width - 50, align = "center", font = {"ressources/text.ttf",20}, text = lang.gameOverBug1End})
				the.view.hud:add(Text:new{x = 30, y = the.app.height - 30,  width = 400, font = {"ressources/text.ttf",15}, tint = {1,1,1}, text = lang.escapeToClose})
			elseif endScreen == 2 then
				the.view.hud:add(Tile:new{x = 0, y = 0, image = "images/endscreen/gameover_b2.gif"})
				the.view.hud:add(Text:new{x = 30, y = the.app.height - 30,  width = 400, font = {"ressources/text.ttf",15}, tint = {1,1,1}, text = lang.escapeToClose})
			end
			---------------------------------------------
		
		else
			--some test for map objects and boss script interactions
			if the.teleportation.now then
				the.view:flash({0, 0, 255})
				self.x = the.teleportation.x
				self.y = the.teleportation.y - 50
				the.teleportation.now = false
			elseif the.minigameHit then
				the.minigameHit = false
				self.life = self.life - 10
				self.invincible = true
				the.hero.hit = true
			end
			
			self.timeLastAttack = self.timeLastAttack + elapsed
			the.hero.orientation = self.orientation
			the.hero.x = self.x
			the.hero.y = self.y
			
			--bug state update
			if not (the.keys:pressed(the.config.data.key.bug) or the.mouse:pressed("m")) or the.bug.happening then
				self.timeBugAttack = 0
			elseif self.timeBugAttack > 0.1 then
				the.bug.happening = true
				the.bug.level = the.bug.level + self.currentBugAdd
			end
			
			--invincible time when hit update
			if self.invincible then
				self.timeInvincible = self.timeInvincible + elapsed
				self.canAttack = false	
				if self.timeInvincible > 1.5 then
					self.invincible = false
					the.hero.hit = false
					self.timeInvincible = 0
					self.canAttack = true
				end	
			end
			--special update for smooth animation when attacking
			if the.controllerOver then
				self.paused = false
				if self.smoothBack then
					self.smoothBack = false
					if self.orientation == 'left' then
						self:play('waitLeft')
					else
						self:play('waitRight')
					end
				end
			end
			--actions to do when ejecting by bully or final boss
			if self.ejecting then
				if self.posSelect then
					if self.x - self.bullyEjectX >= 0 then
						self.ejectRight = true
					else
						self.ejectRight = false
					end
					self.posSelect = false
				end
				self.velocity.y = -100
				self.timeEjecting = self.timeEjecting + elapsed
				if self.ejectRight then
					self.velocity.x = 200
				else
					self.velocity.x = -200
				end
				if self.timeEjecting > 1 then
					self.timeEjecting = 0
					self.ejecting = false
					self.acceleration.x = 0
					self.velocity.y = 0
					self.posSelect = true
				end
			end
			--Getting user input
			--change the current bug
			if (the.keys:justPressed(the.config.data.key.changeBug) or the.mouse:justPressed("wu", "wd", "x1", "x2")) and not the.bug.happening then
				the.bug.selected = the.bug.selected + 1
				--updating the bug state
				if the.bug.selected == 1 then
					the.bug.name = "Freeze"
					self.currentBugAdd = 5
				elseif the.bug.selected == 2 then
					the.bug.name = "Glitch"
					self.currentBugAdd = 10
				elseif the.bug.selected == 3 then
					the.bug.name = "No_Collide"
					self.currentBugAdd = 5
				elseif the.bug.selected == 4 then
					the.bug.name = "Lag"
					self.currentBugAdd = 5
				elseif the.bug.selected == 5 then
					the.bug.name = "Life++"
					self.currentBugAdd = 20
				elseif the.bug.selected == 6 then
					the.bug.selected = 1
					the.bug.name = "Freeze"
					self.currentBugAdd = 5
				end
				--jump
			elseif the.keys:pressed(the.config.data.key.jump) and self.canJump then
				self.velocity.y = -450
				self.onAir = true
				self.canJump = false
				the.sound.play("sounds/jump.ogg", "effect")
			--go left
			elseif the.keys:pressed(the.config.data.key.left) then
				if not self.ejecting and not self.bugAttack then
					self.velocity.x = -200
				end
				self.orientation = 'left'
				--choose the right animation sequences to play
				if not self.attacking then
					if self.invincible then
						if self.onAir then
							self:play('jumpHitLeft')
						else
							self:play('leftHit')
						end
					else
						if self.onAir then
							if self.velocity.y < 0 then
								self:play('jumpLeftUp')
							else
								self:play('jumpLeftDown')
							end
						else
							self:play('left')
						end
					end
				end;
			--go right
			elseif the.keys:pressed(the.config.data.key.right) then
				if not self.ejecting and not self.bugAttack then
					self.velocity.x = 200
				end
				self.orientation = 'right'
				--choose the right animation sequences to play
				if not self.attacking then
					if self.invincible then
						if self.onAir then
							self:play('jumpHitRight')
						else
							self:play('rightHit')
						end
					else
						if self.onAir then
							if self.velocity.y < 0 then
								self:play('jumpRightUp')
							else
								self:play('jumpRightDown')
							end
						else
							self:play('right')
						end
					end
				end
				
			else 
				if not self.ejecting then
					self.velocity.x = 0
				end
				--choose the right animation sequences to play when player don't move
				if self.onAir and not self.attacking then
					if self.orientation == 'right' then
						if self.velocity.y < 0 then
							self:play('jumpRightUp')
						else
							self:play('jumpRightDown')
						end
					else
						if self.velocity.y < 0 then
							self:play('jumpLeftUp')
						else
							self:play('jumpLeftDown')
						end
					end
				elseif not self.attacking and not self.invincible then
					if self.orientation == 'left' then
						self:play('waitLeft')
					else
						self:play('waitRight')
					end
				elseif self.invincible then
					if self.orientation == 'left' then
						self:play('waitLeftHit')
					else
						self:play('waitRightHit')
					end
				end
			end;
			--Getting player attack update
			if self.canAttack and not self.attacking then
				--bug attack
				if (the.keys:pressed(the.config.data.key.bug) or the.mouse:pressed("m")) and not the.bug.happening and not self.onAir and the.config.data.game.level > 1 then
					self:play('bugAttack')
					self.velocity.x = 0
					self.attacking = true
					self.bugAttack = true
					self.timeBugAttack = self.timeBugAttack + elapsed
				elseif self.timeLastAttack > 0.03 then	
					--controller attack
					if the.keys:justPressed(the.config.data.key.attack) or the.mouse:justPressed("l") then
						self.attacking = true
						if self.orientation == 'left' then
							self:play('leftKick')
							the.hero.currentFrame = self.currentFrame
							the.view.projectiles:add(Controller:new{})
							the.controllerOver = false
						else
							self:play('rightKick')
							the.hero.currentFrame = self.currentFrame
							the.view.projectiles:add(Controller:new{})
							the.controllerOver = false
						end
						the.sound.play("sounds/punch.ogg", "effect")
					--Gun attack
					elseif (the.keys:justPressed(the.config.data.key.shoot) or the.mouse:justPressed("r")) and the.config.data.game.nbrCD > 0 then
						the.config.data.game.nbrCD = the.config.data.game.nbrCD - 1
						self.attacking = true
						the.view:add(Gun:new{})
						if self.orientation == 'left' then
							the.hero.currentFrame = self.currentFrame
							self:play('leftShoot')
							the.view:add(Gun:new{})
							the.gun.left = true
						else
							the.hero.currentFrame = self.currentFrame
							self:play('rightShoot')
							the.view:add(Gun:new{})
							the.gun.right = true
						end
					end
				end
			end
		end
		--y and x velocity update and variables update
		if self.velocity.y > 500 then
			self.velocity.y	= 500
		end
		self.canJump = false
		the.actionButton = false
		self:runCollisions()
		self.acceleration.x = self.normalAcceleration.x
		self.acceleration.y = self.normalAcceleration.y
	end,
	--Function called when the hero collide an object
	onCollide = function (self, other, hOverlap, vOverlap )
		if other:instanceOf(Event) or other:instanceOf(TimerSpawn) or other:instanceOf(Nerd) or other:instanceOf(BulletNerd) or other:instanceOf(BossTransfert) or other:instanceOf(catBall) then
			--nothing to avoid getting stuck in invisible object for scripted time or ennemies
		elseif other:instanceOf(Sienne) then
			--update the eject direction of the final boss
			self.bullyEjectX = other.x
		elseif other:instanceOf(Sign) or other:instanceOf(Teleporter) then
			--Make the action button visible
			the.actionButton = true
		elseif other:instanceOf(SpawnerActivator) then
			--update the ennemies spawn
			the.spawnID = other.id
		elseif other:instanceOf(Zombie) then
			--Geting hero reaction after collided with a fanboy
			if not self.invincible and other.hit and not the.bug.noCollide then
				self.life = self.life - other.attackPower
				self.invincible = true
				the.hero.hit = true
				the.sound.play("sounds/herotouch.ogg", "effect")
			end
			
		elseif other:instanceOf(Bully) then
			--Geting hero reaction after collided with a bully
			if other.run and hOverlap > 20 then
					other.stunt = true
					the.sound.play("sounds/herotouch.ogg", "effect")
					
				if not self.invincible and not the.bug.noCollide then
					self.life = self.life - other.attackPower
					self.invincible = true
					the.hero.hit = true
					self.ejecting = true
					self.bullyEjectX = other.x
				end
			end
		
		else
			--Geting hero reaction after encounter a wall
			if other:instanceOf(Wall) then
				if self.velocity.x > 0 and other.x - self.x > 0 then
					self.velocity.x = 0
				elseif self.velocity.x < 0 and other.x - self.x < 0 then
					self.velocity.x = 0
				end
			--Geting hero reaction after collided with ground or ceiling
			elseif vOverlap < hOverlap and self.velocity.y < 0 then --- we hit ceiling
				self.velocity.y = 0 
				self.acceleration.y = 0
			 
			elseif vOverlap < hOverlap and self.velocity.y > 0 then --- we hit ground
				self.canJump = true
				self.onAir = false
				self.velocity.y = 0
				self.acceleration.y = 0
			end
		end
	end
}
