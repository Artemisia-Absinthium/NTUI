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
						Credits view file
]]

Credits = View:extend
{
	-- Paramètres ------------------------
		align = 750, -- Alignement du texte
		titleSize = 13, -- Taille des titres
		textSize = 16, -- Taille du texte
		lineSpace = 40, -- Espace entre chaque crédit
		titleSpace = 20, -- Espace crédit-titre
		speed = -30, -- Vitesse de défilement
	--------------------------------------
	
	
	onNew = function (self)
		
		the.sound.play("musics/credits.mp3", "music")
		self:add(Fill:new{ x = 0, y = 0, width = the.app.width, height = the.app.height, fill = {255, 255, 255}})
		self:add(Tile:new{x = 0, y = 0, image = 'images/misc/credits.gif'})
		
		CreditsText = Text:extend{x = self.align, width = the.app.width - self.align - 5, font = {"ressources/text.ttf", self.textSize}, tint = {0,0,0}, velocity = {x = 0, y = self.speed}}
		CreditsTitle = Text:extend{x = self.align-10, width = the.app.width - self.align - 5, font = {"ressources/title.otf", self.titleSize}, tint = {0,0,0}, velocity = {x = 0, y = self.speed}}
		
		self.title1 = CreditsTitle:extend{y = 400, text = lang.creditsPresent}
		self:add(self.title1:new{})
		local height = ({self.title1:getSize()}) [2]
		self.text1 = CreditsText:extend{y = self.title1.y + height + self.titleSpace, text = "Sea Sharp"}
		self:add(self.text1:new{})
		height = ({self.text1:getSize()}) [2]
		
		self.title2 = CreditsTitle:extend{y = self.text1.y + height + self.lineSpace, text = lang.creditsFramework}
		self:add(self.title2:new{})
		height = ({self.title2:getSize()}) [2]
		self.text2 = CreditsText:extend{y = self.title2.y + height + self.titleSpace, text = "Innov'Game 2013"}
		self:add(self.text2:new{})
		height = ({self.text2:getSize()}) [2]
		
		self.title3 = CreditsTitle:extend{y = self.text2.y + height + self.lineSpace, text = lang.creditsAmelia}
		self:add(self.title3:new{})
		height = ({self.title3:getSize()}) [2]
		self.text3 = CreditsText:extend{y = self.title3.y + height + self.titleSpace, text = "Amelia Chavot"}
		self:add(self.text3:new{})
		height = ({self.text3:getSize()}) [2]
		
		self.title4 = CreditsTitle:extend{y = self.text3.y + height + self.lineSpace, height = 200, text = lang.creditsWilliam}
		self:add(self.title4:new{})
		height = ({self.title4:getSize()}) [2]
		self.text4 = CreditsText:extend{y = self.title4.y + height + self.titleSpace, text = "William Hiver"}
		self:add(self.text4:new{})
		height = ({self.text4:getSize()}) [2]
		
		self.title5 = CreditsTitle:extend{y = self.text4.y + height + self.lineSpace, text = lang.creditsSarah}
		self:add(self.title5:new{})
		height = ({self.title5:getSize()}) [2]
		self.text5 = CreditsText:extend{y = self.title5.y + height + self.titleSpace, text = "Sarah Guinchard"}
		self:add(self.text5:new{})
		height = ({self.text5:getSize()}) [2]
		
		self.title6 = CreditsTitle:extend{y = self.text5.y + height + self.lineSpace, text = lang.creditsMusic}
		self:add(self.title6:new{})
		height = ({self.title6:getSize()}) [2]
		self.text6 = CreditsText:extend{y = self.title6.y + height + self.titleSpace, height = 400, text = lang.creditsMusicContent}
		self:add(self.text6:new{})
		height = ({self.text6:getSize()}) [2]
		
		self.title7 = CreditsTitle:extend{y = self.text6.y + height + self.lineSpace, text = lang.creditsLicence}
		self:add(self.title7:new{})
		height = ({self.title7:getSize()}) [2]
		self.text7 = CreditsText:extend{y = self.title7.y + height + self.titleSpace, height = 400, text = lang.creditsLicenceContent}
		self:add(self.text7:new{})
		height = ({self.text7:getSize()}) [2]
		
		self.title8 = CreditsTitle:extend{y = self.text7.y + height + self.lineSpace, text = lang.creditsThanksTitle}
		self:add(self.title8:new{})
		height = ({self.title7:getSize()}) [2]
		self.text8 = CreditsText:extend{y = self.title8.y + height + self.titleSpace, height = 400, text = lang.creditsThanks}
		self:add(self.text8:new{})
		height = ({self.text8:getSize()}) [2]
		
		
		self.text9 = Text:extend{x = self.align, y = self.text8.y + height + 60, width = the.app.width - self.align, height = 20, align = "center", font = {"ressources/title.otf", 20}, tint = {0,0,0}, text = lang.creditsYou, velocity = {x = 0, y = self.speed}}
		self:add(self.text9)
		height = ({self.text9:getSize()}) [2]
		
		self.text10 = CreditsText:new{y = self.text9.y + height + 50, align = "center", text = lang.creditsVarious}
		self:add(self.text10)

		-- Effets
		math.randomseed(os.time())
		glitch = Tile:new{x = 0, y = 0, image = 'images/misc/glitch.jpg', visible = false}
		bsod = Tile:new{x = 0, y = 0, image = 'images/endscreen/gameover_b2.gif', visible = false}
		effect = bsod
		self:add(bsod)
		self:add(glitch)
		
		self.timer:every(0.3, function()
			if math.random(2) == 2 then effect = glitch else effect = bsod end
			screen = math.random(7)
			if screen == 1 then
				effect.visible = true
				self.timer:after(math.random()/3, function() effect.visible = false end)
			end
		end)
		
		-- Retourner au menu
		self:add(ReturnButton:new{
			x = the.app.width - 90,
			y = the.app.height - 60,
			label = lang.menuQuit,
			onMouseDown = function(self)
				the.app.view = Menu:new()
			end
		})
	end,
	
	onUpdate = function (self)
		-- On bloque la fin des crédits
		if self.text9.y < 100 then
			self.text10.velocity.y = 0
			self.text9.velocity.y = 0
		end

	end
}
