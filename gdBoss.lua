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
					Game Design boss (Final boss) scripting file
]]

BossSignView = Subview:extend
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
			font = 30,
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
			the.bossGo = true
			the.view:deactivate()
		end
	end
}

Sienne = Animation:new
{
	width = 73,
	height = 95,
	image = 'images/sienne.png',
	
	runCollisions = function (self)
		the.view.map:subcollide(self)
		the.view.map:subdisplace(self)
		the.view.projectiles:collide(self)
		the.view.objects:collide(self)
	end,
	
	sequences = { 
		laugh = { frames = { 9, 10 }, fps = 5 },
		rightJumpShield = { frames = { 12 }, fps = 5 },
		leftJumpShield = { frames = { 13 }, fps = 5 },
		runRight = { frames = { 1, 2, 3, 4 }, fps = 5 },
		runLeft = { frames = { 5, 6, 7, 8 }, fps = 5 },
		jumpLeft = { frames = { 11 }, fps = 5 },
		jumpRight = { frames = { 14 }, fps = 5 },
		die = { frames = { 14, 5, 6, 9, 1, 3, 4 }, fps = 5 },
	},
	
	onNew = function (self,elapsed)
		the.bossGo = false
		self.jumpingTime = false
		self.cathulhuTime = true
		self.runningTime = false
		self.lastAttack = "cathulhuTime"
		self.timeRunning = 0
		self.nbrIteration = 0
		self.text = lang.sienne
		self.firstRun = true
		self.hited = false
		self.timeLastCat = 0
		self.nbrCat = 0
		self.timeFading = 0
		self.nbrHit = 0 
		self.firstJump = true
	end,
	
	
	onUpdate = function (self,elapsed)
		
		if self.x - the.hero.x > 0 then
			self.direction = "right"
		else
			self.direction = "left"
		end
		
		if the.bossGo then
			if self.jumpingTime then
				self.lastAttack = "jumpingTime"
				if self.firstJump then
					the.view:flash({178, 32, 32}, 0.5)
					self.y = 200 - self.height + 7
					self.x = math.random(800, 1000)
					self.firstJump = false
				elseif self.nbrHit >= 3 then
					self.jumpingTime = false
					self.nbrHit = 0
					self.firstJump = true
				elseif self.hited then
					if self.justHited then
						self.justHited = false
						self.nbrHit = self.nbrHit + 1
					end
					the.view:flash({178, 32, 32}, 0.5)
					self.y = 200 - self.height + 7
					self.x = math.random(800, 1000)
					self.hited = false
				elseif self.y < 200 then
					self.velocity.y = 400
					if self.x > 1250 then
						self.velocity.x = -100
						self:play('jumpRight')
					elseif self.x < 700 then
						self.velocity.x = 100
						self:play('jumpLeft')
					end
				elseif self.y > 450 - self.height - 5 or self.x < 700 then
					self.velocity.y = -200
					if self.x > 1250 then
						self.velocity.x = -100
						self:play('jumpRight')
					elseif self.x < 700 then
						self.velocity.x = 100
						self:play('jumpLeft')
					end
				end
				
			elseif self.cathulhuTime then
				self.lastAttack = "cathulhuTime"
				self.velocity.x = 0
				self.velocity.y = 0
				if self.y ~= 200 - self.height + 7 then
					the.view:flash({178, 32, 32}, 0.5)
					self.y = 200 - self.height + 7
					self.x = math.random(575, 1375)
				elseif self.y == 200 - self.height + 7 then
					self.velocity.y = 0
					self:play('laugh')
					self.timeLastCat = self.timeLastCat + elapsed
					
					if self.timeLastCat > 1 then
						the.view:add(Cathulhu:new{})
						self.timeLastCat = 0
						self.nbrCat = self.nbrCat + 1
					end
					
					if self.nbrCat > 10 then
						self.timeLastCat = 0
						self.nbrCat = 0
						self.cathulhuTime = false
					end
				end
			elseif self.runningTime then
				self.lastAttack = "runningTime"
				self.timeRunning = self.timeRunning + elapsed
				
				if self.firstRun then
					self.firstRun = false
					the.view:flash({178, 32, 32}, 0.5)
					self.y = 450 - self.height
					self.x = math.random(800, 1000)
					self:play('runRight')
					if the.bug.freeze or the.bug.lag then
						self.velocity.x = 250
					else
						self.velocity.x = 500
					end
				else
					if self.x > 1375 then
						self:play('runLeft')
						if the.bug.freeze or the.bug.lag then
							self.velocity.x = -250
						else
							self.velocity.x = -500
						end
					elseif self.x < 575 then
						self:play('runRight')
						if the.bug.freeze or the.bug.lag then
							self.velocity.x = 250
						else
							self.velocity.x = 500
						end
					end
				end
				
				if self.timeRunning > 8 then
					self.firstRun = true
					self.runningTime = false
					self.timeRunning = 0
				end
			else
				if self.nbrIteration >= 3 then
					if self.nbrIteration == 3 then
						self.nbrIteration = self.nbrIteration + 1
						the.view:fade({0, 0, 0}, 8)
					end
					self.velocity.x = 0
					self.velocity.y = 0
					self.width = 64
					self.height = 100
					self:play('die')
					self.timeFading = self.timeFading + elapsed
					if self.timeFading > 8 then			
						the.app.view = Cutscene:new{scene = 4} 
					end
				else
					if self.lastAttack == "cathulhuTime" then
						self.runningTime = true
					elseif self.lastAttack == "runningTime" then
						self.jumpingTime = true
					elseif self.lastAttack == "jumpingTime" then
						self.cathulhuTime = true
						self.nbrIteration = self.nbrIteration + 1
					end
				end
			end
			print(self.nbrIteration)
			self:runCollisions()
		else
			self:play('laugh')
			self.text = lang.sienne
			self:runCollisions()
		end
	end,
	
	onCollide = function (self, other, hOverlap, vOverlap )
		if the.bossGo then
			if self.jumpingTime and not self.hited then
				if other:instanceOf(Bullet) then
					other:die()
					self.justHited = true
					self.hited = true

				elseif other:instanceOf(Controller) then
					
				elseif other:instanceOf(Hero) and not the.bug.noCollide and not other.invincible then
					if vOverlap < hOverlap and self.velocity.y > 0 then 
						other.life = other.life - 10
						other.invincible = true
						the.hero.hit = true
					end
				end
			
			elseif self.runningTime and not other.invincible then
				if other:instanceOf(Hero) and not the.bug.noCollide and not other.invincible then
					other.life = other.life - 20
					other.invincible = true
					other.ejecting = true
					the.hero.hit = true
				end
			
			elseif other:instanceOf(Hero) then
			
			elseif vOverlap < hOverlap  then --- we hit ground
				self.velocity.y = 0
				self.acceleration.y = 0
				self.falling = false
			end
			
		elseif other:instanceOf(Hero) then
			the.actionButton = true
			if the.keys:justPressed(" ") then
				self.Subview = BossSignView:new{text = self.text}
				self.Subview:activate()
			end
		end
	end
}

Cathulhu = Animation:new
{
	width = 50,
	height = 50,
	image = 'images/levelRessources/cat.png',
	sequences = { 
		right = { frames = {1}, fps = 5},
		left = { frames = {2}, fps = 5},
	},
	
	onNew = function (self,elapsed)
		if math.random() > 0.5 then
			self.direction = "right"
		else
			self.direction = "left"
		end
		if self.direction == "right" then
			self.x = 0 - self.width
		else
			self.x = 2000
		end
		
		self.lunched = false
	end,
	
	onUpdate = function (self,elapsed)
		if self.y > 200 then
			self.velocity.y = - 200
		elseif self.y < 100 then
			self.velocity.y = 200
		end
		
		if self.direction == "right" then
			if the.bug.freeze or the.bug.lag then
				self.velocity.x = 300
			else
				self.velocity.x = 600
			end
			self:play ('right')
		else
			if the.bug.freeze or the.bug.lag then
				self.velocity.x = -300
			else
				self.velocity.x = -600
			end
			self:play ('left')
		end
		
		if math.abs( self.x - the.hero.x) < 55 then
			if not self.lunched then
				self.lunched = true
				the.view:add(catBall:new{ x = self.x + 10, y = self.y + 20, direction = self.direction})
			end
		end
		
		if self.x < 0 - self.width - 1 or self.x > 2000 then
			self:die()
		end
	end,

}

catBall = Tile:new
{
	width = 30,
	height = 30,
	rotation = 0,
	glitched = false,
	image = 'images/levelRessources/bomb.png',
	
	runCollisions = function (self)
		the.view.objects:collide(self)
	end,

	
	onUpdate = function (self,elapsed)
		if the.bug.glitch	then
			self.velocity.x = 0
			self.velocity.y = 0
			self.rotation = self.rotation + 10
			self.glitched = true
		else
			if self.glitched then
				self:die()
			end
			self.velocity.y = 450
			if self.direction == "right" then
				self.velocity.x = 150
			else
				self.velocity.x = -150
			end
			
			if self.y > 420 then
				self:die()
			end
			self:runCollisions()
		end
	end,
	
	onCollide = function (self, other, hOverlap, vOverlap )
		if other:instanceOf(Hero) and not other.invincible and vOverlap > 15 and not the.bug.noCollide then
			other.life = other.life - 10
			other.invincible = true
			the.hero.hit = true
			self:die()
		elseif other:instanceOf(Sienne) then
		
		end
	end
	
}
