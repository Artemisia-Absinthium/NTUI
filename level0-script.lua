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
						Special Level-0 scripting file
]]

Level0 = function ()
	Warning = Subview:extend {
		drawParent = false,
		onNew = function (self)
			the.sound.play("sounds/warning.ogg", "effect")
			TEsound.stop("music")
			self:add(Fill:new{x = 0, y = 0, width = the.app.width, height = the.app.height, fill = {0,0,0}})
			self:add(Text:new{x = 50, y = 150, width = the.app.width - 100, align = 'center', font = 30, text = lang.warning, tint = {1,1,1}})
			self:add(Text:new{x = 50, y = 220, width = the.app.width - 100, align = 'center', font = 22, text = lang.thisSceneCanHurt, tint = {1,1,1}})
			self.timer:after(5, function() the.app.view = Level0Game:new() end)
		end
	}
	
	Level0Game = View:extend {
		lifeBar = "<3 <3 <3",
		
		onNew = function (self)
			self.timeInlevel = 0
			self.bugged = false
			
			-- Savegame reinitialization
			the.config.data.game = {level = 0, bugBonus = false, controllerBonus = false, bugQuantityBonus = false, gunBonus = false, nbrCD = 0, HQintro = true}
			the.config:save()
			
			-- Objects
			self.Jumpy = Tile:extend {
				width = 50,
				height = 122,
				image = "images/level0/jumpy_mob.png",
				acceleration = {x = 0, y = 2000},
				onUpdate = function (self)
					-- Random jump
					if math.random(100) == 50 then self.velocity.y = -500 end
					
					-- Movements
					if the.view.HeroIntro.x < self.x then self.velocity.x = - 140
					else self.velocity.x = 140
					end
				end
			}

			self.Blob = Tile:extend {
				width = 80,
				height = 51,
				image = "images/level0/blob_mob.png",
				acceleration = {x = 0, y = 2000},
				onUpdate = function (self)	
					-- Movements
					if the.view.HeroIntro.x < self.x then self.velocity.x = - 50
					else self.velocity.x = 50
					end
				end
			}

			self.HeroIntro = Animation:new {
				x = 100,
				y = 0,
				width = 44,
				height = 96,
				image = "images/hero.png",
				sequences = { 
					left = { frames = { 8, 7, 6, 7}, fps = 5 }, 
					right = { frames = { 3, 2, 1, 2}, fps = 5 }
				},
				acceleration = {x = 0, y = 1000},
				canJump = true,
				life = 3,
				lastLife = 3,
				lastHurt = 0,
				randomX = 0,
				onUpdate = function (self, elapsed)
					self.lastHurt = self.lastHurt + elapsed
					-- Movements
					if the.keys:pressed(the.config.data.key.left) then
						self.velocity.x = - 250
						self:play("left")
					elseif the.keys:pressed(the.config.data.key.right) then
						self.velocity.x = 250
						self:play("right")
					else
						self.velocity.x = 0
						self:freeze()
					end
					
					-- Jump
					if the.keys:pressed(the.config.data.key.jump) and self.canJump then
						self.velocity.y = - 600
						self.canJump = false
						the.sound.play("sounds/level0_attack.ogg", "effect")
					end
					
					
					-- Blocking the player at the edges
					if self.x <= 0 then self.x = 0
					elseif self.x >= the.app.width - self.width then self.x = the.app.width - self.width
					end
					
					-- Random hurt
					if math.random(500) == 100 then
						self.life = self.life - 1
						the.view:flash({255,0,0})
						the.sound.play("sounds/level0_hurt.ogg", "effect")
					end
					
					-- Check if the player has been hurted
					if self.lastLife < self.life then
						the.sound.play("sounds/hurt.ogg", "effect")
					end
					self.lastLife = self.life
				end,
				
				onCollide = function (self, other, xOverlap, yOverlap)
					if the.view.landscape:contains(other) then
						self.canJump = true
					elseif the.view.enemies:contains(other) then
						if xOverlap < yOverlap then
							other:die()
							if other:instanceOf(the.view.Blob) then the.sound.play("sounds/blob_dead.ogg", "effect")
							else the.sound.play("sounds/bully_dead.ogg", "effect") end
						else
							if self.lastHurt > 1 then
								self.life = self.life - 1
								the.view:flash({255,0,0})
								the.sound.play("sounds/level0_hurt.ogg", "effect")
								self.lastHurt = 0
							end
						end
					end
				end
			}
			
			self.Decor = Tile:extend {
				height = 30,
				onCollide = function (self, other)
					self:displace(other)
					other.velocity.y = 0
				end
			}
		  
			-- Life bar
			life = Text:new {
				x = 10,
				y = 10,
				width = the.app.width - 20,
				text = the.view.lifeBar,
				font = {"ressources/text.ttf", 22},
				tint = {1,0.25,0},
				onUpdate = function (self)
					self.text = the.view.lifeBar
				end
			}
			
			-- Music
			the.sound.play("musics/level0.ogg", "music")
			-- We draw the landscape
			self:add(Fill:new{x = 0, y = 0, width = the.app.width, height = the.app.height, fill = {37,176,227}})
			self:add(Tile:new{x = 280, y = 40, scale = 0.6, image = "images/level0/cloud.png"})
			self:add(Tile:new{x = 150, y = 100, image = "images/level0/cloud.png"})
			self.landscape = Group:new()
			self.landscape:add(self.Decor:new{x = 0, y = the.app.height - 30, width = 700, image = "images/level0/top-grass.gif"})
			self.landscape:add(self.Decor:new{x = 400, y = 300, width = 210, image = "images/level0/platform.gif"})
			self.landscape:add(self.Decor:new{x = 580, y = 330, width = 90, image = "images/level0/platform.gif"})
			self.landscape:add(self.Decor:new{x = 640, y = 360, width = 90, image = "images/level0/platform.gif"})
			self.landscape:add(self.Decor:new{x = 700, y = the.app.height - 60, width = 30, image = "images/level0/top-left-grass.gif"})
			self.landscape:add(self.Decor:new{x = 730, y = the.app.height - 60, width = 30, image = "images/level0/top-grass.gif"})
			self.landscape:add(self.Decor:new{x = 760, y = the.app.height - 90, width = 300, image = "images/level0/top-grass.gif"})
			self.landscape:add(self.Decor:new{x = 760, y = the.app.height - 60, width = 300, height = 90, image = "images/level0/grass.gif"})
			-- We add the Hero
			self:add(self.HeroIntro)
			-- We add the enemies
			self.enemies = Group:new{}
			self.enemies:add(self.Jumpy:new{x = 300, y = 350})
			self.enemies:add(self.Blob:new{x = 600, y = 350})
			self.enemies:add(self.Blob:new{x = 620, y = 250})
			self:add(self.enemies)
			-- We add the life indicator and the decor
			self:add(self.landscape)
			self:add(self.Decor:new{x = 730, y = 200, width = 120, image = "images/level0/platform.gif"})
			self:add(self.Decor:new{x = 790, y = 170, width = 120, image = "images/level0/platform.gif"})
			self:add(self.Decor:new{x = 880, y = 140, width = 120, image = "images/level0/platform.gif"})
			self:add(self.Decor:new{x = 970, y = 110, width = 120, image = "images/level0/platform.gif"})
			self:add(life)
			
			-- Random player teleport
			self.timer:every(5, function()
				self.HeroIntro.x = math.random(0, 650)
			end)
		end,
		
		onUpdate = function (self,elapsed)
			self.timeInlevel = self.timeInlevel + elapsed
			-- Random spawn
			if math.random(500) == 50 then
				self.enemies:add(self.Blob:new{x = self.HeroIntro.x, y = - 50})
			end
			if math.random(500) == 100 then
				self.enemies:add(self.Jumpy:new{x = self.HeroIntro.x, y = - 50})
			end
		
			-- Run collisions
			self.landscape:collide(self.HeroIntro)
			self.landscape:collide(self.enemies)
			self.enemies:collide(self.HeroIntro)
			self.HeroIntro:collide(self.enemies)
			-- Life bar update
			if self.HeroIntro.life ~= nil then
				self.lifeBar = ""
				if self.HeroIntro.life >= 0 then
					for i = 1, self.HeroIntro.life do
						self.lifeBar = self.lifeBar .. "<3 "
					end
				else
					for i = -1, self.HeroIntro.life, -1 do
						self.lifeBar = self.lifeBar .. "<3 "
					end
				end
				self.lifeBar = self.lifeBar .. "  :  " .. self.HeroIntro.life .. lang.healPoint
			end
			
			-- End
			if (self.HeroIntro.life <= -3 or self.timeInlevel > 20) and not self.bugged then
				self.bugged = true
				the.sound.play("sounds/gameover.ogg", "effect")
				TEsound.stop("music", false)
				self.HeroIntro:die()
				self:add(Tile:new{x = 0, y = 0, image = "images/endscreen/gameover_b2.gif"})
				self.timer:after(5, function() the.app.view = Cutscene:new{scene = 0} end)
			end
		end
	}
	
	the.view.warning = Warning:new()
	the.view.warning:activate()
end
