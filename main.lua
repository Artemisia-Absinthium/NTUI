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
]]

version = "1.2"
require 'zoetrope'
require 'TEsound'


the.config = Storage:new
{
	filename = "userprefs.dat",
}

the.config:load(true)


-- Test d'existence des prefs
if next(the.config.data) == nil then
	the.config.data = {lang = "Français", fullscreen = false, effects = true, music = true, key = {left = "left", right = "right", jump = "up", attack = "kp0", shoot = "down", bug = "rctrl", changeBug = "rshift", screenshot = "f12"}, nbScreenshot = 0, game = {level = 0, bugBonus = false, controllerBonus = false, bugQuantityBonus = false, gunBonus = false, nbrCD = 0, HQintro = true} }
elseif the.config.data.game.HQintro == nil then the.config.data.game.HQintro = true
end
the.config:save()


-- Chargement des locales (à améliorer)
if the.config.data.lang == "Français" then require 'lang.french'
elseif the.config.data.lang == "English" then require 'lang.english'
else require 'lang.english'
end


-- Gestion des paramètres son
the.sound = {
	--[[
	   the.sound.play: play a sound wile checking the preference file
	   @param file: relative path of the sound file (string). After function calling, music table file path can be found back in the.music global variable
	   @param tag: a string that describe the type of sound : "music" or "effect". To repeat a sound ceaselessly, use {"effect", "looping"}. To stop looping, use the.sound.stopLooping()
	   @return nothing
	]]--
	play = function (file, tag)
		if the.config.data.sound ~= 3 then
			if type(tag) == "table" then
				if searchTable(tag, "effect") ~= nil and the.config.data.effects then
					if searchTable(tag, "looping") ~= nil then
						TEsound.playLooping(file, tag)
					else
						TEsound.play(file, tag)
					end
				
				elseif searchTable(tag, "music") ~= nil then
					TEsound.stop("music", false)
					the.music = file
					if the.config.data.music then
						TEsound.play(file, "music")
					end
				end
			elseif type(tag) == "string" then
				if tag == "effect" and the.config.data.effects then TEsound.play(file, "effect") end
				if tag == "music" then
					TEsound.stop("music", false)
					the.music = file
					if the.config.data.music then
						TEsound.playLooping(file, "music")
					end
				end
			end
		end
	end,
	--[[
	   the.sound.stopLooping: stop a looping sound
	   @param wait: true if the sound must finish before stoping looping, false otherwise
	   @return nothing
	]]--
	stopLooping = function (wait)
		TEsound.stop("looping", wait)
	end
}

-- Loading game files
require 'menu'
require 'headquarter'
require 'options'
require 'credits'
require 'keys'
require 'objects'
require 'game'
require 'hero'
require 'minigames'
require 'csBoss'
require 'gdBoss'
require 'level0-script'
require 'cutscene'

the.app = App:new
{
	name = "Never Trust User's Input - " .. version,
	onRun = function (self)
		self.view = Menu:new()
		-- fullscreen option applying
		if the.config.data.fullscreen then self:enterFullscreen() end
		-- music volume
		TEsound.volume("music", 0.65)
	end,
	
	onUpdate = function (self)
		-- F11 fullscreen switcher
		if the.keys:justPressed("f11") then self:toggleFullscreen() end
		-- Screenshot
		if the.keys:justPressed(the.config.data.key.screenshot) then
			self:saveScreenshot("screenshot" .. the.config.data.nbScreenshot .. ".jpg")
			the.config.data.nbScreenshot = the.config.data.nbScreenshot + 1
			the.config:save()
		end
		-- Sound cache cleaning
		TEsound.cleanup()
	end
}
