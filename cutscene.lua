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
				Cutscene scripting file
]]
function Set (list)
  local set = {}
  for _, l in ipairs(list) do set[l] = true end
  return set
end

Cutscene = View:extend
{
	
	
	Level0Scene = {
		i = {
			"images/cutscene/cutscene1_1.png",
			"images/cutscene/cutscene1_2.png",
			"images/cutscene/cutscene1_3.png",
			"images/cutscene/cutscene1_4.png",
			"images/cutscene/cutsceneblack.png",
			"images/cutscene/cutscene1_4.png",
			"images/cutscene/cutscene1_5.png",
			"images/cutscene/cutscene1_4.png", 
			"images/cutscene/cutscene1_6.png" 
		},
		t = {lang.Level0Scene}
	},
	
	csBoss = {
		i = {
			"images/cutscene/cutscene2_1.png",
			"images/cutscene/cutscene2_2.png",
			"images/cutscene/cutscene2_3.png",
			"images/cutscene/cutsceneblack.png",
			"images/cutscene/cutscene1_5.png",
			"images/cutscene/cutsceneblack.png",
			"images/cutscene/cutscene1_5.png",
			"images/cutscene/cutscene1_4.png",
		},
		t = {lang.csBoss}
	},
	
	GameDesign = {
		i = {
			"images/cutscene/cutscene4_1.png",
			"images/cutscene/cutscene4_2.png",
			"images/cutscene/cutscene4_3.png",
			"images/cutscene/cutsceneblack.png",
			"images/cutscene/cutscene1_4.png"
		},
		t = {lang.GameDesign} 
	},
	
	Aragorn = {
		i = {
			"images/cutscene/cutscene3_1.png",
			"images/cutscene/cutscene3_2.png",
			"images/cutscene/cutscene3_3.png",
			"images/cutscene/cutscene3_4.png",
			"images/cutscene/cutsceneblack.png",
			"images/cutscene/cutscene1_5.png",
			"images/cutscene/cutscene1_4.png",
		},
		t = {lang.Aragorn} 
	},
	
	finalBoss = {
		i = {
			"images/cutscene/cutscene5_1.png",
			"images/cutscene/cutscene5_2.png",
			"images/cutscene/cutscene5_3.png",
			"images/cutscene/cutscene5_4.png",
			"images/cutscene/cutscene5_5.png",
			"images/cutscene/cutsceneblack.png",
			"images/cutscene/ending.png",
		},
		t = {lang.finalBoss} 
	},

	onNew = function (self)
	the.sound.play("musics/cutscene.mp3", "music")
	the.view:flash({0, 0, 0}, 2)
		the.page = 1
		if self.scene == 0 then
			the.sceneTab = self.Level0Scene
			self.length = #lang.Level0Scene
			the.items = Set { 3, 6, 12, 13, 14, 16, 18, 21}	
		elseif self.scene == 1 then
			the.sceneTab = self.csBoss
			self.length = #lang.csBoss
			the.items = Set { 7, 11, 14, 15, 18, 19, 23}	
		elseif self.scene == 2 then
			the.sceneTab = self.GameDesign
			self.length = #lang.GameDesign
			the.items = Set { 25, 28, 30, 31}	
		elseif self.scene == 3 then
			the.sceneTab = self.Aragorn
			self.length = #lang.Aragorn
			the.items = Set { 4, 6, 7, 13, 14, 21}
		elseif self.scene == 4 then
			the.sceneTab = self.finalBoss
			self.length = #lang.finalBoss
			the.items = Set { 4, 11, 17, 20, 24, 25}	
		end
		
		self:add(Tile:new{ 
			x = 0,
			y = 0,
			image = the.sceneTab.i[the.page],
			
			onNew = function (self)
				self.j = 1			
			end,
			
			onUpdate = function (self, elapsed)
				self.image = the.sceneTab.i[self.j]
				if the.keys:justPressed(" ") and the.items[the.page] then
					self.j = self.j + 1
				end
			end
		})
		
		self:add(Fill:new
		{
			x = 0,
			y = 576 - 150,
			width = 1024 ,
			height = 300 ,
			fill = {0, 0, 0}
		})
		
		self:add(Text:new{
			x = 15,
			y = 576 - 135,
			width = 994,
			height = 300 - 30,
			align = "center",
			font = 20,
			text = the.sceneTab.t[1][the.page],
			
			onUpdate = function(self)
				self.text = the.sceneTab.t[1][the.page]
				self:centerAround( 1024/2, 576-(150/2))
			end
		})
		
		self:add(Text:new{
			x = 10,
			y = 562,
			width = 1024,
			height = 10,
			font = 10,
			text = lang.spaceToContinue
		})
		
		
	end,
	
	onUpdate = function (self,update)
		if the.keys:justPressed(" ") then 
			if the.page == self.length then
				if self.scene == 0 and the.config.data.game.level < 1 then
					the.config.data.game.level = the.config.data.game.level + 1
				elseif self.scene == 1 and the.config.data.game.level < 2 then
					the.config.data.game.level = the.config.data.game.level + 1
				elseif self.scene == 2 and the.config.data.game.level < 4 then
					the.config.data.game.level = the.config.data.game.level + 1
				elseif self.scene == 3 and the.config.data.game.level < 3 then
					the.config.data.game.level = the.config.data.game.level + 1
				elseif self.scene == 4 and the.config.data.game.level < 5 then
					the.config.data.game.level = the.config.data.game.level + 1
				end
				
				if self.scene == 0 then
					the.config:save()
					the.app.view = InGameView:new{mapfile = 'level1.lua'} 
				elseif self.scene == 4 then
					the.config:save()
					the.app.view = Credits:new()
				else
					the.config:save()
					the.app.view = HeadquartersView:new()
				end
			else	
				the.page = the.page + 1
			end
		end
	end
}
