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
						Key changing file
]]

KeyButton = Button:extend
{
	canType = false,
	onNew = function (self)
		self.background = Tile:new{ x = 0, y = 0, image = 'images/buttons/bouton.gif' }
		self.label = Text:new{ x = 0, y = 11, align = "center", width = 152, text = self.label, tint = {0,0,0} }
	end,
	
	onMouseUp = function (self)
		self.label.text = "???"
		self.canType = true
	end
}

keysChanging = Subview:extend
{
	fullscreen = false,
	drawParent = true,
	onNew = function(self)
		print(the.app.fullscreen)
		if the.app.fullscreen then
			self.fullscreen = true
			the.app:exitFullscreen()
		end
		
		self:add(Tile:new{ x = 132, y = 215, image = 'images/buttons/keys.gif' })
				
		-- Gauche
		self:add(KeyButton:new{
			x = 200,
			y = 250,
			label = lang.menuKeyLeft .. '"' .. the.config.data.key.left .. '"',
			onUpdate = function (self)
				if self.canType then
					local temp = the.keys:allPressed()
					if temp ~= nil then
						the.config.data.key.left = temp
						self.canType = false
						self.label.text = lang.menuKeyLeft .. '"' .. the.config.data.key.left .. '"'
					end
				end
			end
		})
		
		-- Droite
		self:add(KeyButton:new{
			x = 200,
			y = 300,
			label = lang.menuKeyRight .. '"' .. the.config.data.key.right .. '"',
			onUpdate = function (self)
				if self.canType then
					local temp = the.keys:allPressed()
					if temp ~= nil then
						the.config.data.key.right = temp
						self.canType = false
						self.label.text = lang.menuKeyRight .. '"' .. the.config.data.key.right .. '"'
					end
				end
			end
		})
		
		-- Saut
		self:add(KeyButton:new{
			x = 200,
			y = 350,
			label = lang.menuKeyJump .. '"' .. the.config.data.key.jump .. '"',
			onUpdate = function (self)
				if self.canType then
					local temp = the.keys:allPressed()
					if temp ~= nil then
						the.config.data.key.jump = temp
						self.canType = false
						self.label.text = lang.menuKeyJump .. '"' .. the.config.data.key.jump .. '"'
					end
				end
			end
		})
		
		-- Attaque
		self:add(KeyButton:new{
			x = 450,
			y = 250,
			label = lang.menuKeyAttack .. '"' .. the.config.data.key.attack .. '"',
			onUpdate = function (self)
				if self.canType then
					local temp = the.keys:allPressed()
					if temp ~= nil then
					the.config.data.key.attack = temp	
						self.canType = false
						self.label.text = lang.menuKeyAttack .. '"' .. the.config.data.key.attack .. '"'
					end
				end
			end
		})
		
		-- Tir
		self:add(KeyButton:new{
			x = 450,
			y = 300,
			label = lang.menuKeyShoot .. '"' .. the.config.data.key.shoot .. '"',
			onUpdate = function (self)
				if self.canType then
					local temp = the.keys:allPressed()
					if temp ~= nil then
					the.config.data.key.shoot = temp	
						self.canType = false
						self.label.text = lang.menuKeyShoot .. '"' .. the.config.data.key.shoot .. '"'
					end
				end
			end
		})
		
		-- Utiliser bug
		self:add(KeyButton:new{
			x = 450,
			y = 350,
			label = lang.menuKeyBug .. '"' .. the.config.data.key.bug .. '"',
			onUpdate = function (self)
				if self.canType then
					local temp = the.keys:allPressed()	
					if temp ~= nil then
						the.config.data.key.bug = temp
						self.canType = false
						self.label.text = lang.menuKeyBug .. '"' .. the.config.data.key.bug .. '"'
					end
				end
			end
		})
		
		-- Changer bug
		self:add(KeyButton:new{
			x = 450,
			y = 400,
			label = lang.menuKeyChangeBug .. '"' .. the.config.data.key.changeBug .. '"',
			onUpdate = function (self)
				if self.canType then
					local temp = the.keys:allPressed()	
					if temp ~= nil then
						the.config.data.key.changeBug = temp
						self.canType = false
						self.label.text = lang.menuKeyChangeBug .. '"' .. the.config.data.key.changeBug .. '"'
					end
				end
			end
		})
		
		-- Screenshot
		self:add(KeyButton:new{
			x = 450,
			y = 450,
			label = lang.menuScreenshot .. '"' .. the.config.data.key.screenshot .. '"',
			onUpdate = function (self)
				if self.canType then
					local temp = the.keys:allPressed()
					if temp ~= nil then
						the.config.data.key.screenshot = temp
						self.canType = false
						self.label.text = lang.menuScreenshot .. '"' .. the.config.data.key.screenshot .. '"'
					end
				end
			end
		})

		-- Retour
		self:add(ReturnButton:new{
			x = the.app.width - 179,
			y = the.app.height - 135,
			width = the.app.width,
			height = the.app.height,
			onMouseDown = function(self)
				the.view:deactivate()
			end
		})
	end,
	
	onUpdate = function (self)
		if the.keys:justPressed("escape") then
			the.view:deactivate()
		end
	end,
	
	onDeactivate = function (self)
		-- Restore fullscreen if any and save config
		the.config:save()
		if self.fullscreen then the.app:enterFullscreen() end
	end
}
