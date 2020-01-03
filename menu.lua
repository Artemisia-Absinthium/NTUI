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
						Menu description file
]]

MenuButton = Button:extend
{
	onNew = function (self)
		self.background = Tile:new{ x = 0, y = 0, image = 'images/buttons/buttonClose.png' }
		self.label = Text:new{ x = 0, y = 63, align = "center", width = 63, height = 30, text = self.label, tint = {0,0,0} }
	end,

	onMouseEnter = function (self)
		self.background.image = 'images/buttons/buttonOpen.png'
	end,
	
	onMouseExit = function (self)
		self.background.image = 'images/buttons/buttonClose.png'
	end,
}

ReturnButton = Button:extend
{
	onNew = function (self)
		self.background = Tile:new{ x = 0, y = 0, image = 'images/buttons/retour.gif' }
		self.label = Text:new{ x = 0, y = 23, align = "center", width = 49, height = 30, text = lang.menuReturn, tint = {0,0,0} }
	end
}

PauseButtonMenu = Button:extend
{
	onNew = function (self)
		self.background = Tile:new{ x = 0, y = 0, image = 'images/buttons/pausebutton.gif' }
		self.label = Text:new{ x = 0, y = 126, align = "center", width = 126, text = self.label, tint = {0,0,0} }
	end
}

--[[
   
   name: validationWindow
   @param text: the text to show in the window
   @param func: the function to execute if "YES" is clicked
   @return nothing
   
]]--
function validationWindow (description, func)
	ValidationView = Subview:extend
	{
		description = description,
		onNew = function(self)
			self:add(Tile:new
			{
				x = (1024 - 375)/2, 
				y = (576 - 200)/2, 
				image = 'images/misc/validationBox.png' 
			})
		
			self:add(Text:new
			{
				x = (1024 - 375)/2 + 102, 
				y = (576 - 200)/2 + 26,
				width = 261,
				height = 105,
				text = self.description,
				wordWrap = true,
				font = 14,
				tint = {0,0,0},
				align = 'center',
				onNew = function (self)
					self:centerAround( (1024 - 375)/2 + 232, (576 - 200)/2 + 60 )
				end
			})
			
			self:add(Button:new
			{
				x = (1024 - 375)/2 + 150, 
				y = (576 - 200)/2 + 110, 
				background = Tile:new{
					x = 0, 
					y = 0, 
					image = "images/buttons/button3d.png"
				},
				
				label = Text:new{
					x = 9,
					y = 12,
					align = "center",
					width = 63,
					height = 55,
					text = lang.yes,
					tint = {0,0,0}
				},
				
				onMouseDown = function (self)
					func()
				end,
			})
		
			self:add(Button:new
			{
				x = (1024 - 375)/2 + 270, 
				y = (576 - 200)/2 + 110,
				background = Tile:new{
					x = 0, 
					y = 0, 
					image = 'images/buttons/button3d.png',
				},
				label = Text:new{
					x = 9,
					y = 12,
					align = "center",
					width = 63,
					height = 55,
					text = lang.no,
					tint = {0,0,0} 
				},
				onMouseDown = function (self)
					the.view:deactivate()
				end,
			})
		end,
		
		onUpdate = function(self, elapsed)
			if the.keys:justPressed('escape') then
				the.view:deactivate()
			end
		end
	}
	
	the.view.confirm = ValidationView:new()
	the.view.confirm:activate()
end

-- Définition du menu principal
Menu = View:extend {
	onNew = function (self)
		self:add(Tile:new{ x = 0, y = 0, image = 'images/misc/menubg.gif'})
		self:add(Tile:new{ x = 90, y = 70, image = 'images/misc/title.gif' })
		self:add(Tile:new{ x = 112, y = 240, image = 'images/buttons/menu.gif' })
		the.sound.play('musics/menu.mp3', 'music')
		
		-- Création des boutons d'après le modèle :
		-- Nouvelle partie
		local posY = 350
		self:add(MenuButton:new {
			x = 254,
			y = posY,
			width = self.width,
			height = self.height,
			label = lang.menuNewGame,
			onMouseDown = function(self)
				-- LANCER UNE NOUVELLE PARTIE
				if the.config.data.game.level > 0 then
					validationWindow(lang.attentionNewGame, Level0)
				else Level0()
				end
			end
		})
		
		-- Continue (if a game already exists)
		if the.config.data.game.level > 0 then
			self:add(MenuButton:new {
				x = 367,
				y = posY,
				width = self.width,
				height = self.height,
				label = lang.menuContinue,
				onMouseDown = function(self)
					-- OUVRIR LA MAP RÉFÉRENCÉE DANS LE FICHIER LASTMAP
					if the.config.data.game.level > 0 then
						the.app.view = HeadquartersView:new()
					else
						the.app.view = InGameView:new{mapfile = 'level0.lua'} 
					end
				end
			})
		end
		
				-- ARRETER	
		self:add(PauseButtonMenu:new{
			x = 367 + 100,
			y = posY+100,
			label = lang.menuHeadquarters,
			onMouseDown = function (self)
				the.app.view.mini = Shooter:new()
				the.view.mini:activate()
			end
		})
		
		
		
		-- Options
		self:add(MenuButton:new {
			x = 490,
			y = posY,
			width = self.width,
			height = self.height,
			label = lang.menuOptions,
			onMouseDown = function (self)
				-- OUVRIR LA VUE DES OPTIONS (optionsView)
				the.view.options = optionsView:new()
				the.view.options:activate()
			end
		})
		
		-- Crédits
		self:add(MenuButton:new {
			x = 613,
			y = posY,
			width = self.width,
			height = self.height,
			label = lang.menuCredits,
			onMouseDown = function (self)
				-- OUVRIR LA VUE DES CRÉDITS (creditsView)
				the.app.view = Credits:new()
			end
		})
		
		-- Quitter le jeu
		self:add(MenuButton:new {
			x = 736,
			y = posY,
			width = self.width,
			height = self.height,
			label = lang.menuQuit,
			onMouseDown = function (self)
				the.config:save()
				the.app.quit()
			end
		})
		
		-- Screenshots folder
		self:add(Button:new {
			x = 25,
			y = the.app.height - 120,
			background = Tile:new{x = 10, y = 0, image = "images/buttons/screen.png"},
			label = Text:new{x = 0, y = 63, width = 65, align = "center", text = "Open screenshot folder"},
			onMouseDown = function (self)
				if os.getenv("OS") ~= nil then os.execute("screendir.bat")
				else
					os.execute("xdg-open " .. love.filesystem.getSaveDirectory())
					os.execute("open " .. love.filesystem.getSaveDirectory())
				end
			end
		})
		
		the.config:load(true)
	end
}

-- Définition du menu de pause
PauseMenu = Subview:extend {
	onNew = function (self)
		local posY = 320
		local posX = 112
		self:add(Tile:new{x = posX, y = 240, image = 'images/buttons/pause.gif' })
				
		-- Changer de niveau
		self:add(PauseButtonMenu:new{
			x = posX + 100,
			y = posY,
			label = lang.menuHeadquarters,
			onMouseDown = function (self)
				the.app.view = HeadquartersView:new()
				the.config:load(true)
			end
		})
		
		-- Options
		self:add(PauseButtonMenu:new{
			x = posX + 341,
			y = posY,
			label = lang.menuOptions,
			onMouseDown = function (self)
				the.view.options = optionsView:new()
				the.view.options:activate()
			end
		})
		
		-- Retourner au menu
		self:add(PauseButtonMenu:new{
			x = posX + 582,
			y = posY,
			label = lang.menuQuit,
			onMouseDown = function(self)
				the.app.view = Menu:new()
			end
		})
		
		-- Reprendre le jeu
		self:add(ReturnButton:new{
			x = the.app.width - 179,
			y = the.app.height - 100,
			onMouseDown = function (self)
				the.view:deactivate()
			end
		})
	end,
	
	onUpdate = function (self)
		if the.keys:justPressed("escape") then the.view:deactivate() end
	end
}
