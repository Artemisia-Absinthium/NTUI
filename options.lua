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
						Option view Files
]]

optionsView = Subview:extend {
	onNew = function(self)
		self:add(Tile:new{ x = 112, y = 240, image = 'images/buttons/menu.gif' })
		self:add(Text:new{ x = 120, y = 485, align = 'center', width = the.app.width - 240, height = 25, text = lang.menuOptionsInfos, tint = {0,0,0} })

		-- Création des boutons d'options
		local posY = 350

		-- Music switch
		self:add(MenuButton:new{
			x = 254,
			y = posY,
			width = the.app.width,
			height = the.app.height,
			onUpdate = function (self)
				if the.config.data.music then self.label.text = lang.menuMusic .. " ON"
				else self.label.text = lang.menuMusic .. " OFF"
				end
			end,
			onMouseDown = function (self)
				the.config.data.music = not the.config.data.music
				if the.config.data.music then the.sound.play(the.music, "music")
				else TEsound.stop("music", false)
				end
			end
		})
		
		-- Effect sounds switch
		self:add(MenuButton:new{
			x = 367,
			y = posY,
			width = the.app.width,
			height = the.app.height,
			onMouseDown = function (self)
				the.config.data.effects = not the.config.data.effects
			end,
			onUpdate = function (self)
				if the.config.data.effects then self.label.text = lang.menuSoundEffects .. " ON"
				else self.label.text = lang.menuSoundEffects .. " OFF"
				end
			end,
		})
		
		-- Fullscreen switcher
		self:add(MenuButton:new{
			x = 490,
			y = posY,
			width = the.app.width,
			height = the.app.height,
			label = lang.menuSwitchFullscreen,
			onMouseDown = function (self)
				the.app:toggleFullscreen()
				if the.config.data.fullscreen ~= true and the.config.data.fullscreen ~= false then the.config.data.fullscreen = false
				else the.config.data.fullscreen = not the.config.data.fullscreen
				end
			end,
		})

		-- Changer les touches
		self:add(MenuButton:new{
			x = 613,
			y = posY,
			width = the.app.width,
			height = the.app.height,
			label = lang.menuKeysChoice,
			onMouseDown = function (self)
				keysChanging:new():activate()
			end
		})

		-- Changer la langue
		self:add(MenuButton:new{
			x = 736,
			y = posY,
			width = the.app.width,
			height = the.app.height,
			onMouseDown = function(self)
				if the.config.data.lang == "Français" then
					the.config.data.lang = "English"
				else
					the.config.data.lang = "Français"
				end
			end,
			onUpdate = function (self)
				self.label.text = lang.menuLanguage .. the.config.data.lang
			end
		})

		self:add(ReturnButton:new{
			x = the.app.width - 179,
			y = the.app.height - 100,
			width = the.app.width,
			height = the.app.height,
			onMouseDown = function(self)
				the.config:save()
				the.view:deactivate()
			end
		})

	end,
	
	onUpdate = function (self)
		if the.keys:justPressed("escape") then the.view:deactivate() end
	end
}
