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
					General map scripting file
]]

--Identification of global variables
the.nerdBulletattackPower = 15
the.spawnID = 0
the.zombie = { life = 15, attackPower = 10}
the.nerd = { life = 20 }
the.bully = { life = 30, attackPower = 10}
the.multCD = 1
the.hero = { x = 0, y = 0, attackPower = 10, Maxlife = 150, orientation = "right", currentFrame = 0, hit = false}
the.controllerOver = true
the.gun = { right = false, left = false }
the.bug = { freeze = false, happening = false, glitch = false, noCollide = false, lag = false, life = false, selected = 1, name = "Freeze", time = 0, level = 0, levelMax = 50, glitchPower = 16, duration = 3}
the.teleporter = {x ={0,0,0,0,0,0,0,0,0,0,0}, y = {0,0,0,0,0,0,0,0,0,0,0}}
the.teleportation = {now = false, x =0, y = 0}
the.block = true
the.spawnTime = false
Wall = Fill:new
{
	visible = false
}

Event = Fill:new
{
	visible = false,
	
	runCollisions = function (self)
		the.view.objects:collide(self)
	end,
	
	onUpdate = function (self,elapsed)
		self:runCollisions()
	end,
	
	onCollide = function (self, other, hOverlap, vOverlap )
		if other:instanceOf(Hero) then
			the.spawnTime = true
		end
	end
}

TimerSpawn = Fill:new
{
	visible = false,
	time = 0,
	onNew = function (self)
		self.nbrEnnemies = 0
		
		if self.monster == "z" then
			self.maxSpawn = 10
		else
			self.maxSpawn = 5
		end
		
	end,
	
	onUpdate = function (self,elapsed)
		self.time = self.time + elapsed
		if the.spawnTime and self.time > 2 then
			self.time = 0
			if self.monster == "z" then
				the.view:add(Zombie:new{x = self.x, y = self.y})
			elseif self.monster == "n" then
				the.view:add(Nerd:new{x = self.x, y = self.y})
			elseif self.monster == "b" then
				the.view:add(Bully:new{x = self.x, y = self.y})
			end
			self.nbrEnnemies = self.nbrEnnemies + 1
		end
		
		if self.nbrEnnemies == self.maxSpawn then
			if self.maxSpawn == 10 then
				the.block = false
			end
			self:die()
		end
	end
}

Block = Animation:new 
{
	width = 300, 
	height = 50,
	paused = false,
	image = "images/block.png",
	sequences = { 
		move = {frames = {1, 2, 3, 4}, fps = 20, loops = false }
	},
	
	runCollisions = function (self)
		the.view.objects:collide(self)
	end,
	
	onNew = function (self)
		the.block = true
		the.spawnTime = false
	end,
	
	onUpdate = function (self,elapsed)
		if not the.block then
			self:play('move')
			if self.currentFrame == 4 then
				self.solid = false
				self:die()
			end
		else
			self:runCollisions()
			self.solid = true
			self:freeze(1)
		end
	end,
	
	onCollide = function (self, other, hOverlap, vOverlap )
		self:displace(other)
		if other:instanceOf(Hero) or other:instanceOf(Zombie) then
			other.canJump = true
		end
	end
	
}

ScienceDoor = Animation:new 
{
	width = 50, 
	height = 300,
	paused = false,
	image = "images/scienceDoor.png",
	sequences = { 
		closed = {frames = {1}, fps = 20, loops = false },
		move = {frames = {1, 2, 3, 4}, fps = 20, loops = false }
	},
	
	onNew = function (self)
		the.block = true
		the.spawnTime = false
	end,
	
	runCollisions = function (self)
		the.view.objects:collide(self)
	end,
	
	onUpdate = function (self,elapsed)
		if not the.block then
			self:play('move')
			if self.currentFrame == 4 then
				self.solid = false
				self:die()
			end
		else
			self:runCollisions()
			self.solid = true
			self:play('closed')
		end
	end,
	
	onCollide = function (self, other, hOverlap, vOverlap )
		self:displace(other)
	end
	
}

Teleporter = Animation:new 
{
	width = 50, 
	height = 50,
	paused = false,
	image = "images/teleporteur.png",
	color = 0,
	id = 1,
	target = { x = 0, y = 0},
	onNew = function (self)
		local color = self.color
		the.teleporter.x[self.id] = self.x
		the.teleporter.y[self.id] = self.y
		self.sequences = { 
			move = { frames = { 1 + (color * 4) , 2 + (color * 4), 3 + (color * 4), 4 + (color * 4)}, fps = 10}
		}
	end,
	
	onUpdate = function (self,elapsed)
		self.target.x = the.teleporter.x[self.idTarget]
		self.target.y = the.teleporter.y[self.idTarget]
		self:play('move')
	end,
	
	runCollisions = function (self)
		the.view.objects:collide(self)
	end,
	
	onCollide = function (self, other, hOverlap, vOverlap )
		if other:instanceOf(Hero) and the.keys:justPressed(" ") then
			the.sound.play("sounds/tel.ogg", "effect")
			the.teleportation.x = self.target.x
			the.teleportation.y = self.target.y
			the.teleportation.now = true
		end
	end
}

CutsceneTransfert3 = Fill:new
{
	visible = false,
	collided = false,
	time = 0,
	runCollisions = function (self)
		the.view.objects:collide(self)
	end,
	
	onUpdate = function (self,elapsed)
		self:runCollisions()
		
		if self.collided then
			self.time = self.time + elapsed
			if self.time > 1 then
					the.app.view = Cutscene:new{scene = 3}
			end
		end
	end,
	
	onCollide = function (self, other, hOverlap, vOverlap )
		if other:instanceOf(Hero) and not self.collided then
			the.view:fade({0, 0, 0}, 1)
			self.collided = true
		end
	end
}

CutsceneTransfert2 = Fill:new
{
	visible = false,
	collided = false,
	time = 0,
	runCollisions = function (self)
		the.view.objects:collide(self)
	end,
	
	onUpdate = function (self,elapsed)
		self:runCollisions()
		
		if self.collided then
			self.time = self.time + elapsed
			if self.time > 1 then
					the.app.view = Cutscene:new{scene = 2}
			end
		end
	end,
	
	onCollide = function (self, other, hOverlap, vOverlap )
		if other:instanceOf(Hero) and not self.collided then
			the.view:fade({0, 0, 0}, 1)
			self.collided = true
		end
	end
}

BossTransfert = Fill:new
{
	visible = false,
	collided = false,
	time = 0,
	runCollisions = function (self)
		the.view.objects:collide(self)
	end,
	
	onUpdate = function (self,elapsed)
		self:runCollisions()
		
		if self.collided then
			self.time = self.time + elapsed
			if self.time > 1 then
				if self.cutscene == "nil" then
					the.app.view = InGameView:new{mapfile = self.map} 
				else
					the.app.view = Cutscene:new{scene = self.cutscene}
				end
			end
		end
	end,
	
	onCollide = function (self, other, hOverlap, vOverlap )
		if other:instanceOf(Hero) and not self.collided then
			the.view:fade({0, 0, 0}, 1)
			self.collided = true
		end
	end
}

Sign = Fill:new
{
	visible = false,
	
	runCollisions = function (self)
		the.view.objects:collide(self)
	end,
		
	onNew = function (self)
		if lang.lang == "fr" then
			self.text = self.fr
		else
			self.text = self.ang
		end
	end,
	
	onCollide = function (self, other, hOverlap, vOverlap )
		if other:instanceOf(Hero) and the.keys:justPressed(" ") then
			self.Subview = SignView:new{text = self.text}
			self.Subview:activate()
		end
	end
}

SignView = Subview:extend
{
	onNew = function(self)
		self.background = Fill:new
		{
			x = (1024-800)/2,
			y = (576-300)/2,
			width = 800 ,
			height = 300 ,
			fill = {0, 0, 0, 240}
		}
			
		self.ViewText = Text:new
		{
			x = (1024-800)/2 + 20,
			y = (576-300)/2 + 20,
			width = 800 - 40,
			height = 300 - 30,
			text = self.text,
			font = 20,
			align = "center",
			onNew = function (self)
				self:centerAround(1024/2, 576/2)
			end
		}
			
		self.exitText = Text:new
		{
			x = (1024-800)/2 + 20,
			y = (576-300)/2 +260,
			width = 800,
			height = 10,
			text = lang.escapeToClose,
			font = 10
		}
		self:add(self.background)
		self:add(self.ViewText)
		self:add(self.exitText)		
	end,
		
	onUpdate = function(self, elapsed)	
		if the.keys:justPressed('escape') then
			the.view:deactivate()
		end
	end
}

cdGained = Text:new
{
	nbrCD = 2,
	tint = {0,0,0},
	width = 50,
	time = 0,
	font = {"ressources/title.otf", 10},
	onNew = function (self)
		self.text = "+ " ..self.nbrCD .." CD's"
		self.velocity.y = - 10
		
	end,
	
	onUpdate = function (self, elapsed)
		self.time = self.time + elapsed
		
		if self.time > 1 then
			self:die()
		end
	end
}

Spawner = Fill:extend
{
	width = 32,
	height = 32,
	fill = {255, 255, 255, 255},
	border = {255, 255, 255, 255},
	id = 0,
	visible = false,
	activate = true,
}

SpawnerActivator = Spawner:extend
{
}

BullySpawner = Spawner:extend
{
	onUpdate = function (self)
		if the.spawnID == self.id and self.activate then
			the.view:add(Bully:new{x = self.x, y = self.y})
			self.activate = false
		end
	end
}

ZombieSpawner = Spawner:extend
{
	onUpdate = function (self)
		if the.spawnID == self.id and self.activate then
			the.view:add(Zombie:new{x = self.x, y = self.y})
			self.activate = false
		end
	end
}

NerdSpawner = Spawner:extend
{
	onUpdate = function (self)
		if the.spawnID == self.id and self.activate then
			the.view:add(Nerd:new{x = self.x, y = self.y})
			self.activate = false
		end
	end
}

Zombie = Animation:new 
{

	width = 42, height = 90,
	paused = false,
	image = 'images/zombie.png',
	life = the.zombie.life,
	kick = false,
	attackPower = the.zombie.attackPower,
	nbrCD = 0,
	normalAcceleration = { x = 0, y = 600},
	direction = "right",
	hit = false,
	attacking = false,
	
	sequences = { 
		left = { frames = { 13, 12, 13, 11}, fps = 5 }, 
		right = { frames = { 1, 2, 1, 3}, fps = 5 },
		leftKick = { frames = { 16, 17, 18, 19, 20}, fps = 5, loops = false },
		rightKick = { frames = { 6, 7, 8, 9, 10}, fps = 5, loops = false },
		glitch = { frames = { 6, 13, 12, 3, 2, 8, 19}, fps = 20},
		dieRight = { frames = { 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 7, 4, 4, 5, 5, 6, 7}, fps = 6, loops = false },
		dieLeft = { frames = { 8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 7, 11, 11, 12, 12, 13, 13, 14 }, fps = 6, loops = false },
	},
	
	onEndSequence = function (self)
		self.kick = false
	end,
	
	runCollisions = function (self)
		the.view.map:subcollide(self)
		the.view.map:subdisplace(self)
		the.view.objects:collide(self)
		the.view.projectiles:collide(self)
	end,
	
	onNew = function (self)
		self.nbrCD = math.random(1, 2)
		self.hited = false
		self.hitByController = false
		self.timeEjecting = 0
	end,
	
	onUpdate = function (self, elapsed)
		if the.bug.freeze then
			self.velocity.x = 0
			self.velocity.y = 0
			self.hit = false
			if self.direction == "left" then
				self:play('left')
			else
				self:play('right')
			end
		elseif the.bug.glitch then
			self.velocity.x = 0
			self.velocity.y = 0
			self.hit = false
			self.width = 50
			self.height = 78
			self:play('glitch')
			if not self.hited then
				self.life = self.life - the.bug.glitchPower
				self.hited = true
			end
		elseif self.life <= 0 then
			self.width = 74 
			self.height = 94
			self.image = 'images/levelRessources/zombieDeath.png'
			self.velocity.x = 0
			self.velocity.y = 0
			if self.direction == "right" then
				self:play('dieRight')
			else
				self:play('dieLeft')
			end
			
			if self.currentFrame == 7 or self.currentFrame == 14 then
				self.visible = false
				the.config.data.game.nbrCD = the.config.data.game.nbrCD + self.nbrCD
				the.view:add(cdGained:new{x = self.x, y = self.y, nbrCD = self.nbrCD})
				self:die()
			end
			
		elseif self.hitByController	and self.life > 0 then
			self.velocity.y = -100
			self.normalAcceleration.y = 0
			if self.x - the.hero.x < 0 then
				self.velocity.x = -300
			else
				self.velocity.x = 300
			end
			self.timeEjecting = self.timeEjecting + elapsed
	
			if self.timeEjecting > 1 then
				self.normalAcceleration.y = 600
				self.timeEjecting = 0
				self.hitByController = false
				self.acceleration.x = 0
				self.velocity.y = 0
			end
		else
			self.hited = false
			self.width = 42
			self.height = 90
			if not self.kick and self.life > 0 then
				if math.abs(self.y-the.hero.y) >= 50 then
					if self.x-the.hero.x < -50 then
						self.direction = "right"
					elseif self.x-the.hero.x > 50 then
						self.direction = "left"
					end
				elseif self.x-the.hero.x < 0 then
					self.direction = "right"
				else
					self.direction = "left"
				end
			end
			
			if not self.kick and math.abs(self.x-the.hero.x)<=20 and math.abs(self.y-the.hero.y) <= 50 then
				self.kick = true
			
			elseif self.direction == "right" and not self.kick then
				if the.bug.lag then
					self.velocity.x = -50
				else				
					self.velocity.x = 50
				end
				self:play('right')
			
			elseif not self.kick then
				if the.bug.lag then
					self.velocity.x = 50
				else				
					self.velocity.x = -50
				end
				self:play('left')
			
			end
			
			if self.currentFrame == 19 or self.currentFrame == 20 or self.currentFrame == 9 or self.currentFrame == 10 then
					self.hit = true
			else
					self.hit = false
			end
			
			if self.kick then
			
				if self.direction == "left" then
					self:play('leftKick')
					self.velocity.x = 0
				else
					self:play('rightKick')
					self.velocity.x = 0	
				end
			end
			
		end
		
		self:runCollisions()
		self.acceleration.x = self.normalAcceleration.x
		self.acceleration.y = self.normalAcceleration.y
    end,

	onCollide = function (self, other, hOverlap, vOverlap )
		if self.life > 0 then
			if other:instanceOf(Sign) or other:instanceOf(TimerSpawn) or other:instanceOf(SpawnerActivator) or other:instanceOf(Event) or other:instanceOf(Hero) or other:instanceOf(Teleporter) then
			
			elseif vOverlap < hOverlap and self.velocity.y < 0 then --- we hit ceiling
				self.velocity.y = 0 
				self.acceleration.y = 0
				 
			elseif vOverlap < hOverlap and self.velocity.y > 0 then --- we hit ground
				self.velocity.y = 0
				 
			end
		end
	end
}

Bully = Animation:new 
{
	width = 56, height = 92,
	paused = false,
	image = 'images/bully.png',
	life = the.bully.life,
	stunt = false,
	run = false,
	attackPower = the.bully.attackPower,
	nbrCD = 0,
	direction = "right",
	timeRunning = 0,
	timeStunt = 0,
	normalAcceleration = { x = 0, y = 600},
	
	sequences = { 
		left = { frames = { 1, 2, 1, 3}, fps = 5 }, 
		right = { frames = { 4, 5, 4, 6}, fps = 5 },
		leftRun = { frames = { 7, 8, 7, 9}, fps = 5 },
		rightRun = { frames = { 10, 11, 10, 12}, fps = 5 },
		stuntLeft = {frames = {13, 14, 15}, fps = 5},
		stuntRight = { frames = { 16, 17, 18}, fps = 5 },
		glitch = { frames = { 1, 5, 16, 14, 10, 3, 9, 15, 12, 15, 7, 3, 2, 1, 4}, fps = 20 },
		dieLeft = { frames = { 1, 2, 3, 4, 5, 6, 7, 8}, fps = 5 },
		dieRight = { frames = { 9, 10, 11, 12, 13, 14, 15, 16}, fps = 5 }
	},
	
	runCollisions = function (self)
		the.view.map:subcollide(self)
		the.view.map:subdisplace(self)
		the.view.objects:collide(self)
		the.view.projectiles:collide(self)
	end,
	
	onNew = function(self)
		self.nbrCD = math.random(3,4)
		self.dead = false
		self.hited = false
		self.hitByController = false
		self.timeEjecting = 0
	end,
	
	onUpdate = function (self, elapsed)
		if the.bug.freeze then
			self.velocity.x = 0
			self.velocity.y = 0
			self.run = false
			self.stunt = false
			if self.direction == "left" then
				self:play('left')
			else
				self:play('right')
			end
		elseif the.bug.glitch then
			self.velocity.x = 0
			self.velocity.y = 0
			self.run = false
			self.width =  45
			self.height = 100
			self:play('glitch')
			self.stunt = false
			if not self.hited then
				self.hited = true
				self.life = self.life - the.bug.glitchPower
			end
		elseif self.life <= 0 then
			self.image = 'images/levelRessources/bullyDeath.png'
			self.width = 88 
			self.height = 84
			self.run = false
			self.stunt = false
			self.velocity.x = 0
			
			if not self.dead then
				the.sound.play("sounds/bully_dead.ogg", "effect")
				self.dead = true
			end
			if self.direction == "right" then
				self:play('dieRight')
				if self.currentFrame == 16 then
					self:die()
					the.config.data.game.nbrCD = the.config.data.game.nbrCD + self.nbrCD
				the.view:add(cdGained:new{x = self.x, y = self.y, nbrCD = self.nbrCD})
				self:die()
				end
			else
				self:play('dieLeft')
				if self.currentFrame == 8 then
					self:die()
					the.config.data.game.nbrCD = the.config.data.game.nbrCD + self.nbrCD
				the.view:add(cdGained:new{x = self.x, y = self.y, nbrCD = self.nbrCD})
				self:die()
				end
			end

		elseif self.hitByController	and self.life > 0 then
			self.velocity.y = -100
			self.normalAcceleration.y = 0
			if self.x - the.hero.x < 0 then
				self.velocity.x = -300
			else
				self.velocity.x = 300
			end
			self.timeEjecting = self.timeEjecting + elapsed
	
			if self.timeEjecting > 1 then
				self.normalAcceleration.y = 600
				self.timeEjecting = 0
				self.hitByController = false
				self.acceleration.x = 0
				self.velocity.y = 0
			end
		else
			self.width =  56
			self.height = 92
			self.hited = false
			if self.stunt then
				self.velocity.x = 0
				self.run = false
				self.timeStunt = self.timeStunt + elapsed
				if self.direction == "right" then
					self:play('stuntRight')
				else
					self:play('stuntLeft')
				end
				
				if self.timeStunt > 2 then
					self.stunt = false
					self.timeStunt = 0
				end
			elseif self.run then
			
				if self.timeRunning > 2 then
					self.run = false
					self.timeRunning = 0
				else
					self.timeRunning = self.timeRunning + elapsed
				end
					
				if self.direction == "right" then
					self:play('rightRun')
					if the.bug.lag then
						self.velocity.x = -100
					else				
						self.velocity.x = 250
					end
							
				else
					self:play('leftRun')
					if the.bug.lag then
						self.velocity.x = 100
					else				
						self.velocity.x = -250
					end
				end	
			else
			
				if math.abs(self.y-the.hero.y) >= 50 then
					if self.x-the.hero.x < -50 then
						self.direction = "right"
						if the.bug.lag then
							self.velocity.x = -100
						else				
							self.velocity.x = 100
						end
						self:play('right')
					elseif self.x-the.hero.x > 50 then
						self.direction = "left"
						if the.bug.lag then
							self.velocity.x = 100
						else				
							self.velocity.x = -100
						end
						self:play('left')
					end
					
				else
					if self.x-the.hero.x < 0 then
						self.direction = "right"
						if the.bug.lag then
							self.velocity.x = -100
						else				
							self.velocity.x = 100
						end
						self:play('right')
					else
						self.direction = "left"
						if the.bug.lag then
							self.velocity.x = 100
						else				
							self.velocity.x = -100
						end
						self:play('left')
					end
				end
				
				if math.abs(self.x-the.hero.x) < 400 and math.abs(self.y-the.hero.y) <= 10 then
					self.run = true
				end
				
			end
		end
		
		self:runCollisions()
		self.acceleration.x = self.normalAcceleration.x
		self.acceleration.y = self.normalAcceleration.y
   	end,
	
	onCollide = function (self, other, hOverlap, vOverlap )
		if other:instanceOf(Nerd) or other:instanceOf(SpawnerActivator) or other:instanceOf(BulletNerd) or other:instanceOf(Sign) or other:instanceOf(Zombie) or other:instanceOf(Hero) or other:instanceOf(TimerSpawn) or other:instanceOf(Event) or other:instanceOf(Teleporter) then
		
		elseif vOverlap < hOverlap and self.velocity.y < 0 then --- we hit ceiling
			self.velocity.y = 0 
			self.acceleration.y = 0
				 
		elseif vOverlap < hOverlap and self.velocity.y > 0 then --- we hit ground
			self.velocity.y = 0	
			if vOverlap > hOverlap and self.run then 
				self.stunt = true
			end
		end
	end
}

Nerd = Animation:new
{
	width = 54, height = 76,
	paused = false,
	image = 'images/nerd_mvt.png',
	nbrCD = 0,
	direction = "right",
	life = the.nerd.life,
	shoot = false,
	dead = false,
	timeLastShoot = 0,
	normalAcceleration = { x = 0, y = 0},
	sequences = { 
		left = { frames = { 3, 4 }, fps = 5 }, 
		right = { frames = { 1, 2}, fps = 5 },
		leftShoot = { frames = { 9, 10, 11, 12}, fps = 5},
		rightShoot = { frames = { 5, 6, 7, 8,}, fps = 5},
		glitch = { frames = { 3, 5, 1, 2, 10, 15, 3, 3, 6, 8}, fps = 20},
		die = { frames = { 1, 2, 3, 4, 5, 6, 7 }, fps = 5},
	},
	
	onNew = function (self)
		self.nbrCD = math.random(2, 3)
		self.hited = false
		self.hitByController = false
		self.timeEjecting = 0
	end,
	
	onEndSequence = function (self)
		self.shoot = false
	end,
	
	runCollisions = function (self)
		the.view.map:subcollide(self)
		the.view.map:subdisplace(self)
		the.view.objects:collide(self)
		the.view.projectiles:collide(self)
	end,
	
	onUpdate = function (self, elapsed)
	
		if the.bug.freeze then
			self.velocity.x = 0
			self.velocity.y = 0
			self.shoot = false
			if self.direction == "left" then
				self:play('left')
			else
				self:play('right')
			end
		elseif the.bug.glitch then
			self.velocity.x = 0
			self.velocity.y = 0
			self.hit = false
			self.width = 45
			self.height = 85
			self:play('glitch')
			if not self.hited then
				self.hited = true
				self.life = self.life - the.bug.glitchPower
			end
		elseif self.life <= 0 then
			if not self.dead then
				the.sound.play("sounds/nerd_dead.ogg", "effect")
				self.dead = true
			end
			self.image = 'images/levelRessources/nerdDeath.png'
			self.width = 98 
			self.height = 94
			self.velocity.x = 0
			self.velocity.y = 0
			self:play('die')
			if self.currentFrame == 7 then
				self.visible = false
				self:die()
				the.config.data.game.nbrCD = the.config.data.game.nbrCD + self.nbrCD
				the.view:add(cdGained:new{x = self.x, y = self.y, nbrCD = self.nbrCD})
				self:die()
			end
		elseif self.hitByController	and self.life > 0 then
			if self.x - the.hero.x < 0 then
				self.velocity.x = -300
			else
				self.velocity.x = 300
			end
			self.timeEjecting = self.timeEjecting + elapsed
	
			if self.timeEjecting > 1 then
				self.timeEjecting = 0
				self.hitByController = false
				self.acceleration.x = 0
				self.velocity.y = 0
			end
		else
			self.hited = false
			self.width = 54
			self.height = 76
			self.timeLastShoot = self.timeLastShoot + elapsed
			if not self.shoot then
				if math.abs(self.y-the.hero.y) >= 20 then
				
					if self.x-the.hero.x < -50 then
						self.direction = "right"
					elseif self.x-the.hero.x > 50 then
						self.direction = "left"
					end
					
				elseif self.x-the.hero.x < 0 then
					self.direction = "right"
				else
					self.direction = "left"
				end
					
			end
			
			if not self.shoot then
				if self.y-the.hero.y > 0 then
					if the.bug.lag then
						self.velocity.y = 50
					else				
						self.velocity.y = -50
					end 
				else
					if the.bug.lag then
						self.velocity.y = -50
					else				
						self.velocity.y = 50
					end 
				end
			end	
			
			if not self.shoot and math.abs(self.x-the.hero.x)<500 and math.abs(self.y-the.hero.y) <= 50 and self.timeLastShoot > 1.5 then
				self.shoot = true
				
			elseif not self.shoot then
			
				if self.direction == "right" then
					if math.abs(self.x-the.hero.x)> 100 then
						if the.bug.lag then
							self.velocity.x = -180
						else				
							self.velocity.x = 180
						end 
					end
					self:play('right')
					
				else
					if math.abs(self.x-the.hero.x)> 100 then
						if the.bug.lag then
							self.velocity.x = 180
						else				
							self.velocity.x = -180
						end 
					end
					self:play('left')
				end
			end
			
			if self.shoot and not the.bug.lag then
				self.velocity.x = 0
				if self.direction == "right" then
					self:play('rightShoot')
					
					if self.currentFrame == 8 then
						the.view.projectiles:add(BulletNerd:new{x = self.x + self.width, y = self.y + 18, RightDirected = true})
					end
				else
					self:play('leftShoot')
					if self.currentFrame == 12 then
						the.view.projectiles:add(BulletNerd:new{x = self.x, y = self.y + 18, RightDirected = false})
					end
				end
				
				if self.currentFrame == 12 or self.currentFrame == 8 then
					self.shoot = false
					self.timeLastShoot = 0
				end
			end 
		end
		
		self:runCollisions()
		self.acceleration.x = self.normalAcceleration.x
		self.acceleration.y = self.normalAcceleration.y
	end,
	
	onCollide = function (self, other, hOverlap, vOverlap )
		if other:instanceOf(Nerd) or other:instanceOf(SpawnerActivator) or other:instanceOf(BulletNerd) or other:instanceOf(Sign) or other:instanceOf(Zombie) or other:instanceOf(Hero) or other:instanceOf(TimerSpawn) or other:instanceOf(Event) or other:instanceOf(Teleporter) then
		
		end
	end
}

--[[
coffre = Tile:extend 
{
    image = 'ressources/gfx/coffre.png',
	nbrDisqueInside = 0 ;
	
	onNew = function (self)
		self.nbrDisqueInside = math.random(10,15),
	end,
	
	onUpdate = function (self, elapsed)
	
    end,
	
	onCollide = function (self, other)
		if other:instanceOf(Hero) then
			other.nbrDisque = other.nbrDisque + nbrDisqueInside
			self:die()
		end
	end
}

--]]

BulletNerd = Animation:new
{
	width = 14, height = 6,
	paused = false,
	image = 'images/levelRessources/nBullet.png',
	soonDead = false,
	RightDirected = true,
	sequences = {
		animationBulletRight = { frames = {2}, fps = 10 },
		animationBulletLeft = { frames = {1}, fps = 10 }
	},
	attackPower = the.nerdBulletattackPower,
	
	runCollisions = function (self)
		the.view.map:subcollide(self)
		the.view.map:subdisplace(self)
		the.view.objects:collide(self)
	end,
	
	onUpdate = function (self, elapsed)
		if the.bug.lag then
			self.soonDead = true
		end
		
		if not the.bug.lag and self.soonDead then
			self:die()
		end
		
		if self.RightDirected then
			self:play('animationBulletRight')
			if the.bug.lag then
				self.velocity.x = -300
			else			
				self.velocity.x = 300
			end 
		else 
			self:play('animationBulletLeft')
			if the.bug.lag then
				self.velocity.x = 300
			else			
				self.velocity.x = -300
			end 
		end
		self:runCollisions()
	end,
	
	onCollide = function (self, other, hOverlap, vOverlap )
		if other:instanceOf(SpawnerActivator) or other:instanceOf(Nerd) or other:instanceOf(Bully) or other:instanceOf(Zombie) or other:instanceOf(Sign) or other:instanceOf(TimerSpawn) or other:instanceOf(Event) then
		
		elseif other:instanceOf(Hero) and not the.bug.noCollide then
			if hOverlap >= self.width and self.y > the.hero.y + 3 then
				if not other.invincible then
					other.life = other.life - self.attackPower
					the.sound.play("sounds/herotouch.ogg", "effect")
					other.invincible = true
					the.hero.hit = true
				end
				self:die()
			end
		else
			self:die()
		end
	end
}

Bullet = Animation:new
{
	width = 13, height = 10,
	paused = false,
	touched = false,
	image = 'images/levelRessources/bullet.png',
	RightDirected = true,
	sequences = {
		animationBulletRight = { frames = {1, 2, 3, 4}, fps = 10 },
		animationBulletLeft = { frames = {5, 6, 7, 8}, fps = 10 }
	},
	
	onNew = function (self)
		if the.config.data.game.gunBonus then
			self.attackPower = 10
		else
			self.attackPower = 5
		end	
	end,
	
	runCollisions = function (self)
		the.view.map:subcollide(self)
		the.view.map:subdisplace(self)
		the.view.objects:collide(self)
	end,
	
	onUpdate = function (self, elapsed)
		if self.RightDirected then
			self:play('animationBulletRight')
			self.velocity.x = 300
		else
			self:play('animationBulletLeft')
			self.velocity.x = -300
		end
		self:runCollisions()
	end,
	
	onCollide = function (self, other, hOverlap, vOverlap )
		if other:instanceOf(SpawnerActivator) or other:instanceOf(Hero) or other:instanceOf(Sienne) or other:instanceOf(Sign) or other:instanceOf(TimerSpawn) or other:instanceOf(Event) then
		
		elseif other:instanceOf(Zombie) or other:instanceOf(Nerd) or other:instanceOf(Bully)then
			if other.life > 0 then
				if hOverlap >= self.width then 
					other.life = other.life - self.attackPower
					if not self.touched then
						the.sound.play("sounds/touch.ogg", "effect")
						self.touched = true
					end
					self:die()
				end
			end
		else
			self:die()
		end
	end
}
