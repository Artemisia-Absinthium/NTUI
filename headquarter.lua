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
						headquarter view File
]]
the.config.data.game.bugBonus = false
the.config.data.game.controllerBonus = false
the.config.data.game.bugQuantityBonus = false
the.config.data.game.gunBonus = false
the.bonus = ""
the.level = 2
HeadquartersView = View:extend 
{
	onNew = function (self)
		self:loadLayers('mapHQ.lua')
		self.focus = the.HqHero
		self:clampTo(self.map)
		the.view:flash({0, 0, 0}, 5)
		the.sound.play({"musics/headquarters.mp3"}, "music")
		self.hud = Group:new{translateScale = {x = 0, y = 0}}
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
		self.cdIndicator = Tile:new {
			x = the.app.width - 80,
			y = 5,
			image = "images/hud/cd.png"
		}
		
		self.cdCounter = Text:new {
			x = the.view.cdIndicator.x,
			y = the.view.cdIndicator.y - 8,
			width = 60,
			align = "center",
			font = {"ressources/title.otf", 17},
			tint = {0.95,0.95,0.95},
			onUpdate = function(self, elapsed)
				self.text = the.config.data.game.nbrCD
			end
		}
		self.hud:add(self.cdIndicator)
		self.hud:add(self.cdCounter)
		self.hud:add(self.actionButton)
		self:add(self.hud)
	end,

	onUpdate = function (self)
		if the.config.data.game.HQintro then
			self.Subview = SignView:new{text = lang.HQintro}
			self.Subview:activate()
			the.config.data.game.HQintro = false
			the.config:save()
		end
		
		if the.keys:justPressed("escape") then
			the.view.pause = PauseMenu:new()
			the.view.pause:activate()
		end
	end
}
	
IshmaelView = Subview:extend
{
	
	onNew = function(self)
		
		
		self.randomText = lang.ismaelSpeech[ math.random(#lang.ismaelSpeech) ] 
		self.background = Fill:new
		{
			x = (1024-800)/2,
			y = (576-300)/2,
			width = 800 ,
			height = 300 ,
			fill = {0, 0, 0, 240}
		}
		
		self.ishmaelText = Text:new
		{
			x = (1024-800)/2 + 20,
			y = (576-300)/2 + 20,
			width = 800 - 40,
			height = 300 - 30,
			text = self.randomText,
			wordWrap = true,
			align = "center",
			
			font = 30,
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
		self:add(self.exitText)
		self:add(self.ishmaelText)		
	end,
	
	onUpdate = function(self, elapsed)
		if the.keys:justPressed('escape') then
			self.randomText = lang.ismaelSpeech[ math.random(#lang.ismaelSpeech) ]
			the.view:deactivate()
		end
	end
}

MerylView = Subview:extend
{
	onNew = function(self)
		self:add(Tile:new {
			x = 1024 - 80,
			y = 5,
			image = "images/hud/cd.png"
		})
		
		self:add(Text:new {
			x = 1024 - 80,
			y = 5 - 8,
			width = 60,
			align = "center",
			font = {"ressources/title.otf", 17},
			tint = {0.95,0.95,0.95},
			onUpdate = function(self, elapsed)
				self.text = the.config.data.game.nbrCD
			end
		})
		self:add(Tile:new{ x = (1024 - 900)/2,
		y = (576 - 400)/2,
		image = 'images/HQ/merylMenu.png' 
		})
		
		self:add(Text:new
		{
			x = (1024 - 900)/2 + (900-448)/5,
			y = (576 - 400)/2 + 70,
			width = 720,
			height = 200,
			align = "center",
			text = lang.shopText,
			font = 20,
			tint = {0,0,0}
		})
		
		self.button1 = Button:new{
			x = (1024 - 900)/2 + ((900-448)/5)*3 + 112*2,
			y = (576 - 400)/2 + 144,
			background = Tile:new{ 
				x = 0,
				y = 0,
				image = 'images/HQ/controllerBonusBW.png',
				
				onUpdate = function(self, elapsed)
					if the.config.data.game.controllerBonus then
						self.image = 'images/HQ/controllerBonus.png'
					else
						self.image = 'images/HQ/controllerBonusBW.png'
					end
				end
			},
			label = Text:new{ 
				x = - 7,
				y = 115,
				align = "center",
				width = 126,
				text = lang.controllerBonusDescription,
				tint = {0,0,0}
			},

			onMouseDown = function (self)
				if the.config.data.game.nbrCD >= 100 and not the.config.data.game.controllerBonus then
					the.bonus = "controllerBonus"
					validationWindow(lang.confirmation, function () if the.bonus == "bugBonus" then the.config.data.game.bugBonus = true elseif the.bonus == "controllerBonus" then the.config.data.game.controllerBonus = true elseif the.bonus == "bugQuantityBonus" then the.config.data.game.bugQuantityBonus = true elseif the.bonus == "gunBonus" then the.config.data.game.gunBonus = true end the.config.data.game.nbrCD = the.config.data.game.nbrCD - 100 the.view:deactivate() the.config:save()end )
				end
			end,
			
			
		}
	
		self.button2 = Button:new{
			x = (1024 - 900)/2 + ((900-448)/5)*2 + 112,
			y = (576 - 400)/2 + 144,
			background = Tile:new{
				x = 0,
				y = 0,
				image = 'images/HQ/bugBonusBW.png',
				
				onUpdate = function(self, elapsed)
					if the.config.data.game.bugBonus then
						self.image = 'images/HQ/bugBonus.png'
					else
						self.image = 'images/HQ/bugBonusBW.png'
					end
				end
			},
			label = Text:new{ 
				x = - 7,
				y = 115,
				align = "center",
				width = 126,
				text = lang.bugBonusDescription,
				tint = {0,0,0}
			},

			onMouseDown = function (self)
				if the.config.data.game.nbrCD >= 100 and not the.config.data.game.bugBonus then
					the.bonus = "bugBonus"
					validationWindow(lang.confirmation, function () if the.bonus == "bugBonus" then the.config.data.game.bugBonus = true elseif the.bonus == "controllerBonus" then the.config.data.game.controllerBonus = true elseif the.bonus == "bugQuantityBonus" then the.config.data.game.bugQuantityBonus = true elseif the.bonus == "gunBonus" then the.config.data.game.gunBonus = true end the.config.data.game.nbrCD = the.config.data.game.nbrCD - 100 the.view:deactivate() the.config:save()end )
				end
			end,
		}
		
		self.button3 = Button:new{
			x = (1024 - 900)/2 + ((900-448)/5)*4 + 112*3,
			y = (576 - 400)/2 + 144,
			background = Tile:new{
				x = 0,
				y = 0,
				image = 'images/HQ/gunBonusBW.png',
				
				onUpdate = function(self, elapsed)
					if the.config.data.game.gunBonus then
						self.image = 'images/HQ/gunBonus.png'
					else
						self.image = 'images/HQ/gunBonusBW.png'
					end
				end
			},
			label = Text:new{ 
				x = - 7,
				y = 115,
				align = "center",
				width = 126,
				text = lang.gunBonusDescription,
				tint = {0,0,0}
			},

			onMouseDown = function (self)
				if the.config.data.game.nbrCD >= 100 and not the.config.data.game.gunBonus then
					the.bonus = "gunBonus"
					validationWindow(lang.confirmation, function () if the.bonus == "bugBonus" then the.config.data.game.bugBonus = true elseif the.bonus == "controllerBonus" then the.config.data.game.controllerBonus = true elseif the.bonus == "bugQuantityBonus" then the.config.data.game.bugQuantityBonus = true elseif the.bonus == "gunBonus" then the.config.data.game.gunBonus = true end the.config.data.game.nbrCD = the.config.data.game.nbrCD - 100 the.view:deactivate() the.config:save()end )
				end
			end,
		}
		
		self.button4 = Button:new{
			x = (1024 - 900)/2 + (900-448)/5,
			y = (576 - 400)/2 + 144,
			background = Tile:new{
				x = 0,
				y = 0,
				image = 'images/HQ/bugQuantityBonus.png',
				
				onUpdate = function(self, elapsed)
					if the.config.data.game.bugQuantityBonus then
						self.image = 'images/HQ/bugQuantityBonus.png'
					else
						self.image = 'images/HQ/bugQuantityBonusBW.png'
					end
				end
			},
			label = Text:new{ 
				x = - 7,
				y = 115,
				align = "center",
				width = 126,
				text = lang.bugQuantityBonusDescription,
				tint = {0,0,0}
			},

			onMouseDown = function (self)
				if the.config.data.game.nbrCD >= 100 and not the.config.data.game.bugQuantityBonus then
					the.bonus = "bugQuantityBonus"
					validationWindow(lang.confirmation, function () if the.bonus == "bugBonus" then the.config.data.game.bugBonus = true elseif the.bonus == "controllerBonus" then the.config.data.game.controllerBonus = true elseif the.bonus == "bugQuantityBonus" then the.config.data.game.bugQuantityBonus = true elseif the.bonus == "gunBonus" then the.config.data.game.gunBonus = true end the.config.data.game.nbrCD = the.config.data.game.nbrCD - 100 the.view:deactivate() the.config:save()end )
				end
			end,
		}
		
		self:add(Button:new{
			x = (1024 - 900)/2 + 10,
			y = (576 - 400)/2 + 350,
			background = Tile:new{
				x = 0,
				y = 0,
				image = 'images/buttons/retour.gif' 
				},
				
			label = Text:new{ 
				x = 0, 
				y = 23, 
				align = "center", 
				width = 49, 
				height = 30, 
				text = "Return", 
				tint = {0,0,0} 
				},
				
			onMouseDown = function (self)
				the.view:deactivate()
			end
			})
		
		self.buttons = Group:new{translateScale = {x = 0, y = 0}}
		self.buttons:add(self.button1)
		self.buttons:add(self.button2)
		self.buttons:add(self.button3)
		self.buttons:add(self.button4)
		self:add(self.buttons)
	end,
	
	onUpdate = function (self)
		if the.keys:justPressed("escape") then the.view:deactivate() end
	end
}

LevelSelectView = Subview:extend
{
	onNew = function (self)
		the.fadding = false
		the.fade = 0
		self:add(Tile:new{ 
			x = 0,
			y = 0,
			image = 'images/HQ/map.png' 
		})
		
		self:add( Text:new
		{
			x = (1024-800)/2 + 20,
			y = 576 - 30,
			width = 800,
			height = 10,
			text = lang.escapeToClose,
			font = 10
		})
		
		self:add(Button:new{ 
			x = 100,
			y = 300,
			background = Tile:new{ 
				x = 0,
				y = 0,
				image = 'images/HQ/level1.png',
				fadetime = 0,
				onUpdate = function (self, elapsed)
					if the.config.data.game.level > 1 then
						self.image = 'images/HQ/level1BW.png'
					elseif the.config.data.game.level == 1 then
						self.image = 'images/HQ/level1.png'
					else
						self.image = 'images/HQ/levelinc.png'
					end
					if the.fade == 1 then
						self.fadetime = self.fadetime + elapsed
						if self.fadetime > 2 then
							the.app.view = InGameView:new{mapfile = 'level1.lua'} 
						end
					end
				end
			},
		
			onMouseDown = function (self)
				if the.config.data.game.level >= 1 then
					the.view:fade({0, 0, 0}, 2)
					the.fadding = true
					the.fade = 1
				end
			end
		})
		
		self:add(Button:new{ 
			x = 540,
			y = 190,
			background = Tile:new{ 
				x = 0,
				y = 0,
				image = 'images/HQ/level2.png',
				fadetime = 0,
				onUpdate = function(self, elapsed)
					if the.config.data.game.level > 2 then
						self.image = 'images/HQ/level2BW.png'
					elseif the.config.data.game.level == 2 then
						self.image = 'images/HQ/level2.png'
					else
						self.image = 'images/HQ/levelinc.png'
					end
					if the.fade == 2 then
						self.fadetime = self.fadetime + elapsed
						if self.fadetime > 2 then
							the.app.view = InGameView:new{mapfile = 'level2.lua'} 
						end
					end
				end
			},
		
			onMouseDown = function (self)
				if the.config.data.game.level >= 2 then
					the.view:fade({0, 0, 0}, 2)
					the.fadding = true
					the.fade = 2
				end
			end
		})
		
		self:add(Button:new{ 
			x = 300,
			y = 119,
			background = Tile:new{ 
				x = 0,
				y = 0,
				image = 'images/HQ/level3.png',
				fadetime = 0,
				onUpdate = function(self, elapsed)
					if the.config.data.game.level > 3 then
						self.image = 'images/HQ/level3BW.png'
					elseif the.config.data.game.level == 3 then
						self.image = 'images/HQ/level3.png'
					else
						self.image = 'images/HQ/levelinc.png'
					end
					if the.fade == 3 then
						self.fadetime = self.fadetime + elapsed
						if self.fadetime > 2 then
							the.app.view = InGameView:new{mapfile = 'level3.lua'} 
						end
					end
				end
			},
		
			onMouseDown = function (self)
				if the.config.data.game.level >= 3 then
					the.view:fade({0, 0, 0}, 2)
					the.fadding = true
					the.fade = 3
				end
			end
		})
		
		self:add(Button:new{ 
			x = 775,
			y = 300,
			background = Tile:new{ 
				x = 0,
				y = 0,
				image = 'images/HQ/level3.png',
				fadetime = 0,
				onUpdate = function(self, elapsed)
					if the.config.data.game.level > 4 then
						self.image = 'images/HQ/level4BW.png'
					elseif the.config.data.game.level == 4 then
						self.image = 'images/HQ/level4.png'
					else
						self.image = 'images/HQ/levelinc.png'
					end
					if the.fade == 4 then
						self.fadetime = self.fadetime + elapsed
						if self.fadetime > 2 then
							the.app.view = InGameView:new{mapfile = 'level4.lua'} 
						end
					end
				end
			},
		
			onMouseDown = function (self)
				if the.config.data.game.level >= 4 then
					the.view:fade({0, 0, 0}, 2)
					the.fadding = true
					the.fade = 4
				end
			end
		})
	end,

	onUpdate = function (self)
		if the.keys:justPressed("escape") and not the.fadding then the.view:deactivate() end
	end
}

bookChapterView = Subview:extend
{	
	onNew = function (self)
		the.chapter = self.currentChapter
		the.page = 1
		self:add(Tile:new
		{ 
			x = 0,
			y = 0,
			image = 'images/book/chapter1_1.png',
			onUpdate = function (self, elapsed)
				self.image = the.chapter.i[the.page]
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
				
		self:add(Text:new
		{
			x = 15,
			y = 576 - 148,
			width = 994,
			height = 300 - 30,
			align = "center",
			font = 20,
			
			onUpdate = function(self)
					self.text = the.chapter.t[the.page]
			end
		})
				
		self:add(Text:new
		{
			x = 160,
			y = 20,
			width = 1020,
			height = 300 - 30,
			text = lang.escapeToClose,
			font = 14,	
			tint = {0, 0, 0},
		})
				
		self:add(Text:new
		{
			x = 160,
			y = 40,
			width = 1020,
			height = 300 - 30,
			text = lang.howToBook,
			font = 14,
			tint = {0, 0, 0},
		})
	end,
		
	onUpdate = function (self,elapsed)
		if the.keys:justPressed("escape") then 
			the.view:deactivate()
		elseif the.keys:justPressed("right") and the.page < #the.chapter.i then
			the.page = the.page + 1
		elseif the.keys:justPressed("left") and the.page > 1 then
			the.page = the.page - 1
		end
	end
}

BookView = Subview:extend
{ 
	chapter1 = {
		i = {"images/book/chapter1_1.png","images/book/chapter1_2.png"},
		t = {lang.bookchapter1[1],lang.bookchapter1[2]} 
	},
	chapter2 = {
		i = {"images/book/chapter2_1.png","images/book/chapter2_2.png"},
		t = {lang.bookchapter2[1],lang.bookchapter2[2]} 
	},
	chapter3 = {
		i = {"images/book/chapter3_1.png","images/book/chapter3_2.png"},
		t = {lang.bookchapter3[1],lang.bookchapter3[2]} 
	},
	onNew = function (self)
		self:add(Tile:new{ 
			x = 0,
			y = 0,
			image = 'images/book/book.png'
		})
		
		self:add(Text:new{
			x = 190,
			y = 80,
			width = 285,
			height = 500,
			font = 40,
			align = "center",
			text = lang.bookTitle
		})
		
		self:add(Button:new{
			chapter = self.chapter1,
			x = 540,
			y = 40,
			background = Tile:new{ 
				x = 0,
				y = 0,
				image = 'images/book/bookChapter.png',

			},
			label = Text:new{ 
				x = 0,
				y = 30,
				align = "center",
				width = 300,
				height = 80,
				font = 30,
				text = lang.book1,
				tint = {0,0,0}
			},

			onMouseDown = function (self)
				the.view.book = bookChapterView:new{currentChapter = self.chapter}
				the.view.book:activate()
			end,
		})
		
		self:add(Button:new{
			chapter = self.chapter2,
			x = 540,
			y = 220,
			background = Tile:new{ 
				x = 0,
				y = 0,
				image = 'images/book/bookChapter.png',

			},
			label = Text:new{ 
				x = 0,
				y = 30,
				align = "center",
				width = 300,
				height = 80,
				font = 30,
				text = lang.book2,
				tint = {0,0,0}
			},

			onMouseDown = function (self)
				the.view.book = bookChapterView:new{currentChapter = self.chapter}
				the.view.book:activate()
			end,
		})
		
		self:add(Button:new{
			chapter = self.chapter3,
			x = 540,
			y = 400,
			background = Tile:new{ 
				x = 0,
				y = 0,
				image = 'images/book/bookChapter.png',

			},
			label = Text:new{ 
				x = 0,
				y = 30,
				align = "center",
				width = 300,
				height = 80,
				font = 30,
				text = lang.book3,
				tint = {0,0,0}
			},

			onMouseDown = function (self)
				the.view.book = bookChapterView:new{currentChapter = self.chapter}
				the.view.book:activate()
			end,
		})
		
	end,
	
	onUpdate = function (self)
		if the.keys:justPressed("escape") then 
			the.view:deactivate() 
		end
	end
}

Ishmael = Animation:new
{
	width = 400,
	height = 400,
	image = "images/ishmael.png",
	sequences = { 
		movement = { frames = { 1, 1, 2, 2, 2}, fps = 10 }, 
	},
	
	runCollisions = function (self)
		the.view.objects:collide(self)
	end,
	
	onNew = function (self)
		self.Subview = IshmaelView:new{}
	end,
	
	onUpdate = function (self, elapsed)
		self:play('movement')
	end,
	
	onCollide = function (self, other, hOverlap, vOverlap )
		if other:instanceOf(HqHero) and the.keys:justPressed(" ") then
			self.Subview:activate()
		end
	end
}

Meryl = Animation:new
{
	width = 400,
	height = 400,
	image = "images/meryl.png",
	sequences = { 
		movement = { frames = { 1, 1, 1, 2, 3, 2, 3, 2, 3}, fps = 10 }, 
	},
	runCollisions = function (self)
		the.view.objects:collide(self)
	end,
	
	onNew = function (self)
		self.Subview = MerylView:new{}
	end,
	
	onUpdate = function (self, elapsed)
		self:play('movement')
		self:runCollisions()
	end,
	
	onCollide = function (self, other, hOverlap, vOverlap )
		if other:instanceOf(HqHero) and the.keys:justPressed(" ") then
				self.Subview:activate()
		end
	end
}

HqHero = Animation:new
{
	width = 176,
	height = 384,
	image = "images/hqHero.png",
	orientation = "right",
	sequences = { 
		left = { frames = {  7, 6, 7, 8}, fps = 5 },
		right = { frames = { 2, 1, 2, 3}, fps = 5 },
		waitLeft = { frames = { 4, 4, 5, 5}, fps = 5 },
		waitRight = { frames = { 9, 9, 10, 10}, fps = 5 },
	},
	
	runCollisions = function (self)
		the.view.objects:collide(self)
	end,
	
	onUpdate = function (self, elapsed)
		if the.keys:pressed(the.config.data.key.left) and self.x > 15 then
			self:play('left')
			self.orientation = "left"
			self.velocity.x = - 300
		elseif the.keys:pressed(the.config.data.key.right) and self.x < 55*49 - self.width then
			self:play('right')
			self.orientation = "right"
			self.velocity.x = 300
		elseif self.orientation == "right" then
			self:play('waitLeft')
			self.velocity.x = 0
		else
			self:play('waitRight')
			self.velocity.x = 0
		end
		the.actionButton = false
		self:runCollisions()
		
	end,
	
	onCollide = function (self, other, hOverlap, vOverlap )
		if other:instanceOf(Ishmael) or other:instanceOf(Meryl) or other:instanceOf(Book) or other:instanceOf(LevelSelect) or other:instanceOf(Door) then
			the.actionButton = true
		end
	end
}

Book = Tile:new
{
	width = 200,
	height = 200,
	image = "images/table.png",
	
	runCollisions = function (self)
		the.view.objects:collide(self)
	end,
	
	onNew = function (self)
		self.Subview = BookView:new{}
	end,
	
	onUpdate = function (self, elapsed)
		self:runCollisions()
	end,
	
	onCollide = function (self, other, hOverlap, vOverlap )
		if other:instanceOf(HqHero) and the.keys:justPressed(" ") then
				self.Subview:activate()
		end
	end
}

LevelSelect = Tile:new
{
	width = 300,
	height = 150,
	image = "images/mapwall.png",
	
	runCollisions = function (self)
		the.view.objects:collide(self)
	end,
	
	onNew = function (self)
		self.Subview = LevelSelectView:new{}
	end,
	
	onUpdate = function (self, elapsed)
		self:runCollisions()
	end,
	
	onCollide = function (self, other, hOverlap, vOverlap )
		if other:instanceOf(HqHero) and the.keys:justPressed(" ") then
				self.Subview:activate()
		end
	end
}

Door = Fill:new{

	runCollisions = function (self)
		the.view.objects:collide(self)
	end,
	
	onNew = function (self)
		self.visible = false
	end,
	
	onUpdate = function (self, elapsed)
		self:runCollisions()
	end,
	
	onCollide = function (self, other, hOverlap, vOverlap )
		if other:instanceOf(HqHero) and the.keys:justPressed(" ") then
			validationWindow(lang.askQuit, function () the.config:save() the.app.quit() end)
		end
	end
}
