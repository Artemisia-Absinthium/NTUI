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
						In-game view file
]]

InGameView = View:extend
{
    onNew = function (self)
		self.flashing = true
		-- Increasing the framerate by desactivating some useless sprites in the map 
		for _, spr in pairs(self.sprites) do
			if spr ~= the.hero and spr ~= self.objects and spr ~= self.projectiles and spr ~= self.map then
				spr.active = false
			end
		end
		-- Global variables reset
		the.hero = { x = 0, y = 0, attackPower = 20, Maxlife = 5, orientation = "right", currentFrame = 0, hit = false}
		the.bug = { freeze = false, happening = false, glitch = false, noCollide = false, lag = false, selected = 1, name = "Freeze", time = 0, level = 0, levelMax = 10, glitchPower = 11}
        self:loadLayers(self.mapfile)
		the.spawnID = 0
        self.focus = the.hero
        self:clampTo(self.map)
		the.view:flash({0, 0, 0}, 5)
		-- Background music
		self.firstSign = true
		if self.mapfile == "level3.lua" then
			the.sound.play({"musics/level3.mp3", "musics/level3-2.mp3"}, "music")
		elseif self.mapfile == "level4.lua" then
			the.sound.play({"musics/cutscene.mp3"}, "music")
		elseif self.mapfile == "level4_boss.lua" then
			the.sound.play({"musics/boss2.mp3"}, "music")
		elseif self.mapfile == "level1_boss.lua" then	
			the.sound.play("musics/boss1.mp3", "music")
		else the.sound.play({"musics/music1.mp3", "musics/music2.mp3", "musics/music3.mp3"}, "music")
		end
		-------------------
		self.projectiles = Group:new{}
		self:add(self.projectiles)
		
		-- HUD
		self.hud = Group:new{translateScale = {x = 0, y = 0}}
		
		-- Life
		self.lifeIndicator = Tile:new {
			x = the.app.width - 80,
			y = 20,
			image = "images/hud/life.png"
		}
		self.actionButton = Animation:new
		{
			width = 84,
			height = 54,
			image = "images/misc/actionButton.png",
			x = 1024/2 - 84/2,
			y = 576 - ( 54 + 25 ),
			sequences = { 
				ON = { frames = { 1, 2}, fps = 2 },
				OFF = { frames = { 2 }, fps = 1 },
			},
			onUpdate = function (self, elapsed)
				if the.actionButton then
					self:play('ON')
				else
					self:play('OFF')
				end
			end,
		}
		self.damageIndicator = Fill:new {
			x = 947,
			y = 29,
			width = 54,
			height = 0,
			tint = {0.86, 0.22, 0.22},
			onUpdate = function (self)
				-- Calcul en % de dégâts : 100% = 95px
				self.height = 95 - the.hero.life / Hero.life * 95
				if self.height > 95 then
					self.height = 95
				end
			end
		}
		
		-- CDs
		self.cdIndicator = Tile:new {
			x = the.app.width - 80,
			y = 150,
			image = "images/hud/cd.png"
		}
		
		self.cdCounter = Text:new {
			x = the.view.cdIndicator.x,
			y = the.view.cdIndicator.y - 8,
			width = 60,
			align = "center",
			font = {"ressources/title.otf", 17},
			tint = {0.95,0.95,0.95},
			text = the.config.data.game.nbrCD,
			
			onUpdate = function (self, elapsed)
				self.text = the.config.data.game.nbrCD
			end
		}
		
			-- Bugs
		self.bugBg = Tile:new {
			x = -80,
			y = -55,
			image = "images/hud/bug.png",
		}
		
		self.bugIndicator = Text:new {
			x = self.bugBg.x + 139,
			y = self.bugBg.y + 104,
			text = the.bug.name,
			font = {"ressources/text.ttf", 13},
			tint = {0.86, 0.22, 0.22},
			onUpdate = function (self)
				self.text = the.bug.name
			end
		}
		
		self.bugProgress = Text:new {
			x = self.bugBg.x + 139,
			y = self.bugBg.y + 128,
			text = ">",
			font = {"ressources/text.ttf", 12},
			tint = {0.86, 0.22, 0.22},
			onUpdate = function (self)
				self.text = the.view.bugLevel
			end
		}
		
		self.hud:add(self.lifeIndicator)
		self.hud:add(self.actionButton)
		self.hud:add(self.damageIndicator)
		self.hud:add(self.cdIndicator)
		self.hud:add(self.cdCounter)
		if the.config.data.game.level > 1 then
			self.hud:add(self.bugBg)
			self.hud:add(self.bugIndicator)
			self.hud:add(self.bugProgress)
		end
		self:add(self.hud)
    end,

	onUpdate = function (self, elapsed)
		if self.firstSign then
			if self.mapfile == "level1.lua" then
				self.Subview = SignView:new{text = lang.firstPlay }
				self.Subview:activate()
				self.firstSign = false
			elseif self.mapfile == "level2.lua" then
				self.Subview = SignView:new{text = lang.firstBugPlay }
				self.Subview:activate()
				self.firstSign = false
			end
		end
		self.bugLevel = ">"
		for i = 1, the.bug.level *14 /the.bug.levelMax do
			self.bugLevel = "="..self.bugLevel
		end 
		
		-- Pause menu opening
		if the.keys:justPressed("escape") then
			the.view.pause = PauseMenu:new()
			the.view.pause:activate()
		end
		
		if the.bug.happening then
			the.bug.time = the.bug.time + elapsed
			if the.bug.selected == 1 then
				the.bug.freeze = true
			elseif the.bug.selected == 2 then
				the.bug.glitch = true
			elseif the.bug.selected == 3 then
				the.bug.noCollide = true
			elseif the.bug.selected == 4 then
				the.bug.lag = true
			elseif the.bug.selected == 5 then
				the.bug.life = true
			end
			
			if the.bug.time > the.bug.duration - 0.5 then
				if not self.flashing then
					the.view:flash({0,0,255})
					self.flashing = true
				end
			elseif the.bug.time > the.bug.duration - 1 and self.flashing then
				the.view:flash({0,0,255})
				self.flashing = false
			end
			if the.bug.time > the.bug.duration then
				the.bug.time = 0
				the.bug.happening = false
				the.bug.freeze = false
				the.bug.glitch = false
				the.bug.noCollide = false
				the.bug.lag = false
				the.bug.life = false 
				the.view:flash({0,0,255})
			end
		end
	end
}
