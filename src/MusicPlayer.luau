--[[

Module by nonNamedUser on github :D
https://github.com/nonNamedUser

Module source:
https://github.com/nonNamedUser/musicplayermodule/

By using this you agree to the LICENSE!

MIT License

Copyright (c) 2024 caspergtag

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

Use:

local module=require(module localization)

local new=module.new()

local sound=Instance.new("Sound", workspace)

new:setSound(sound)

new:AddSound(1848354536) -- e.g. Relaxed Scene

new:Play()

------------------

to pause do

new:Pause()

------------------

to stop do

new:Stop()

------------------

to remove a sound from the list do

new:RemoveSound(soundId)

(IF IT'S PLAYING IT WILL STILL PLAY TO THE END)


]]

local music = {}

music.__index=music

export type music={
	new: () -> music
}

function music.new()
	local self=setmetatable({}, music.__index)
	
	self.list={}
	self.index=1
	self.indexType="playlist"
	self.Sound=""
	self.EndedAddedToSound=false
	self.PausedOrStopped=false
	
	self.playing=false
	
	function self:setIndexType(indexType:string)
		local ind=""
		if indexType=="playlist" then
			ind=indexType
		else
			ind=self.indexType
		end
		
		self.indexType=ind
	end
	
	function self:AddSound(id)
		id=tostring(id)

		id=string.lower(id)

		if string.find(id,'rbxassetid://') then
			table.insert(self.list,id)
		elseif tonumber(id) then
			table.insert(self.list,"rbxassetid://"..id)
		end
	end
	
	function self:RemoveSound(id)
		id=tostring(id)

		id=string.lower(id)

		if string.find(id,'rbxassetid://') then
			local z=table.find(self.list,id)
			if z then
				table.remove(self.list,z)
			end
		elseif tonumber(id) then
			local z=table.find(self.list,"rbxassetid://"..id)
			if z then
				table.remove(self.list,z)
			end
		end
	end
	
	function self.manageIndex()
		local id
		if self.list[self.index] then
			id=self.list[self.index]
		end
		if self.list[self.index+1] then
			self.index+=1
		else
			self.index=1
		end
		
		if id~=nil then return id else
			return self.manageIndex()
		end
	end
	
	function self:setSound(sound:Sound)
		if self.Sound~="" then return end
		self.Sound=sound
	end
	
	function self.resetIndex()
		self.index=1
	end
	
	function self:Pause()
		if self.Sound=="" then
			print('Please set a sound!')
			return
		end
		self.PausedOrStopped=true
		self.playing=false
		self.Sound:Pause()
	end
	function self:Stop()
		if self.Sound=="" then
			print('Please set a sound!')
			return
		end
		self.PausedOrStopped=true
		self.playing=false
		self.Sound:Stop()
	end
	function self:Play()
		if self.Sound=="" then
			print('Please set a sound!')
			return
		end
		self.playing=true
		
		local index
		
		if self.PausedOrStopped==false then
			index=self.manageIndex()
		else
			self.PausedOrStopped=false
			index=self.Sound.SoundId
		end
		
		self.Sound.TimePosition=0
		self.Sound.SoundId=index
		
		self.Sound:Play()
		
		if self.EndedAddedToSound then return end
		
		self.EndedAddedToSound=true
		
		self.Sound.Ended:Connect(function()
			if self.playing==true then
				if self.Sound=="" then return end
				print(self.index)
				self.playing=true

				local index=self.manageIndex()

				self.Sound.TimePosition=0
				self.Sound.SoundId=index

				self.Sound:Play()
			end
		end)
	end
	
	return self
end


return music
