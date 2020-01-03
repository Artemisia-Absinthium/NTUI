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
				Computer science boss (First Boss) scripting file
]]
require 'minigames'
csBossSignView = Subview:extend
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

BossSign = Fill:new {
	visible = false,

	onUpdate = function (self)
		the.view.objects:collide(self)
	end,

	onCollide = function (self,other)
		if other:instanceOf(Hero) then
			self.Subview = csBossSignView:new{text = lang.boss1}
			self.Subview:activate()
			self:die()
		end
	end

}

Screen = Animation:new 
{
	width = 100, 
	height = 50,
	paused = false,
	image = "images/boss/screen1.png",
	sequences = { 
		move = {frames = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}, fps = 20, loops = false }
	},
	
	onUpdate = function (self)
		self:play('move')
		if the.bossLevel == 1 then
			self.sequences.move.fps = 3
		elseif the.bossLevel == 2 then
			self.sequences.move.fps = 5
		elseif the.bossLevel == 3 then
			self.sequences.move.fps = 8
		elseif the.bossLevel == 4 then
			self.sequences.move.fps = 10
		end
	end
	
}

Amelia = Animation:new
{
	width = 113,
	height = 150,
	image = 'images/boss/AmeliaBoss.png',
	timeLastGame = 0,
	sequences = {
		move = { frames = {1,2}, fps = 5}
	},
	onNew = function (self)
		the.bossLevel = 1
	end,
	
	onUpdate = function (self,elapsed)
		if the.bossLevel == 1 then
			self.sequences.move.fps = 5
		elseif the.bossLevel == 2 then
			self.sequences.move.fps = 10
		elseif the.bossLevel == 3 then
			self.sequences.move.fps = 15
		elseif the.bossLevel == 4 then
			self.sequences.move.fps = 20
		end
		
		self:play('move')
		if the.bossLevel == 4 then
			the.view:fade({0, 0, 0}, 8)
			the.bossLevel = 5
		end
		self.timeLastGame = self.timeLastGame + elapsed
		if self.timeLastGame > 8 and not the.death then
			self.timeLastGame = 0
			if the.bossLevel == 1 then
				self.Subview = Coffee:new{}
				self.Subview:activate()
			elseif the.bossLevel == 2 then
				self.Subview = Breakout:new{}
				self.Subview:activate()
			elseif the.bossLevel == 3 then
				self.Subview = Shooter:new{}
				self.Subview:activate()
			elseif the.bossLevel == 5 then
				the.app.view = Cutscene:new{scene = 1}
			end
			
		end
	end
}

Willy = Animation:new
{
	width = 113,
	height = 150,
	image = 'images/boss/willyBoss.png',
	sequences = {
		move = { frames = {1,2}, fps = 5}
	},
	
	onUpdate = function (self,elapsed)
		if the.bossLevel == 1 then
			self.sequences.move.fps = 5
		elseif the.bossLevel == 2 then
			self.sequences.move.fps = 10
		elseif the.bossLevel == 3 then
			self.sequences.move.fps = 15
		elseif the.bossLevel == 4 then
			self.sequences.move.fps = 20
		end
		
		self:play('move')
	end
}