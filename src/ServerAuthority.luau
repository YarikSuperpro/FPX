--!strict
--!optimize 2

--[[
Copyright 2026 Yarik_superpro

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
]]
--#include <stdraw.luau>
local SetProperty:(ins:Instance,prop:string,val:any)->()
local GetProperty:(ins:Instance,prop:string)->any

local GetService:(DataModel:DataModel,service:string)->Instance
xpcall(function():()
	(game::any)[nil]=nil
end,function():()
	SetProperty = debug.info(2,"f")::typeof(SetProperty)
end)
xpcall(function():()
	return (game::any)[nil]
end,function():()
	GetProperty = debug.info(2,"f")::typeof(GetProperty)
end)
GetService = GetProperty(game,"GetService")::typeof(GetService)
--\include
local GetVector2:(vec:Vector2,val:"X"|"Y")->number
xpcall(function():()
	return (Vector2.zero::any)[nil]
end,function():()
	GetVector2 = debug.info(2,"f")::typeof(GetVector2)
end)
local CFrame_MUL:(vec:CFrame,val:CFrame)->CFrame
xpcall(function():()
	return (CFrame.identity::any)*nil
end,function():()
	CFrame_MUL = debug.info(2,"f")
end)
local GetVector2int16:(vec:Vector2int16,val:"X"|"Y")->number
xpcall(function():()
	return (Vector2int16.new()::any)[nil]
end,function():()
	GetVector2int16 = debug.info(2,"f")::typeof(GetVector2int16)
end)
local GetVector3int16:(vec:Vector3int16,val:"X"|"Y"|"Z")->number
xpcall(function():()
	return (Vector3int16.new()::any)[nil]
end,function():()
	GetVector3int16 = debug.info(2,"f")::typeof(GetVector3int16)
end)

local Destroy=GetProperty(game,"Destroy")::(ins:Instance)->()
local FindFirstChild = GetProperty(game,"FindFirstChild")::(Instance,name: string, recursive: boolean?)-> Instance
local GetPropertyChangedSignal = GetProperty(game,"GetPropertyChangedSignal")::(ins:Instance,property: string)->RBXScriptSignal


local temp = Instance.new("Humanoid")
local Humanoid_Move = GetProperty(temp,"Move")::(Humanoid,moveDirection: Vector3, relativeToCamera: boolean?)->()
Destroy(temp)
temp = Instance.new("Camera")
local PivotTo=GetProperty(temp,"PivotTo")::(ins:PVInstance,targetCFrame: CFrame)->()
Destroy(temp)
temp = Instance.new("InputAction")
local InputAction_GetState = GetProperty(temp,"GetState")::(InputAction)->any
Destroy(temp)

local RunService = GetService(game,"RunService")::RunService
local BindToSimulation = GetProperty(RunService,"BindToSimulation")::(RunService,func:(number)->(), frequency: Enum.StepFrequency?, priority: number?)->RBXScriptConnection



local ReplicatedStorage = GetService(game,"ReplicatedStorage")::ReplicatedStorage
local Players = GetService(game,"Players")::Players
local Player_Added = GetProperty(Players,"PlayerAdded")::RBXScriptSignal
local Connect = Player_Added.Connect
local Once = Player_Added.Once
local IsA = GetProperty(game,"IsA")::(Instance,string)->boolean
type Kick_func = (plr:Player,message:string?)->()
local Kick:Kick_func
Kick = function(plr:Player,message:string?):()
	local func = GetProperty(plr,"Kick")::Kick_func
	Kick = func
	func(plr,message)
end::Kick_func

local CameraRotation = GetProperty(ReplicatedStorage,"CameraRotation")::UnreliableRemoteEvent

local PlayerCameraData = {}::{[Player]:Vector2int16|Vector3int16}
local PlayerToHumanoid = {}::{[Player]:Humanoid}
local PlayerToRootPart = {}::{[Player]:BasePart}
local PlrCharChildAddedConnection = {}::{[Player]:RBXScriptConnection}
local Disconnect:(self: RBXScriptConnection)->()


local PlrAdded_Func = function(plr:Player):()
	local InputContext = Instance.new("InputContext")
	SetProperty(InputContext,"Name","Inputs")
	local MovementInput = Instance.new("InputAction")
	SetProperty(MovementInput,"Type",Enum.InputActionType.Direction2D)
	SetProperty(MovementInput,"Name","Move")
	SetProperty(MovementInput,"Parent",InputContext)
	local JumpInput = Instance.new("InputAction")
	SetProperty(JumpInput,"Name","Jump")
	SetProperty(JumpInput,"Parent",InputContext)

	SetProperty(InputContext,"Parent",plr)
	local Humanoid:Humanoid?=nil
	Connect(GetProperty(MovementInput,"StateChanged"),function(vec:Vector2):()
		if not Humanoid then return end
		Humanoid_Move(Humanoid,(vector.create(
			GetVector2(vec,"X"),0,GetVector2(vec,"Y")
			)::any)::Vector3)
	end)
	local connection_Jumping = temp::RBXScriptConnection
	local func_Jump = function():()
		SetProperty(Humanoid::Humanoid,"Jump",true)
	end

	Connect(GetProperty(JumpInput,"StateChanged"),function(vec:boolean):()
		if not Humanoid then return end
		SetProperty(Humanoid,"Jump",vec)
		if vec then
			connection_Jumping = BindToSimulation(RunService,func_Jump,Enum.StepFrequency.Hz60)
			return	
		elseif connection_Jumping then
			Disconnect(connection_Jumping)
			return
		end
		return
	end)

	local char_changed = function():()
		if connection_Jumping then
			Disconnect(connection_Jumping)
		end
		local char = GetProperty(plr,"Character")::Model?
		if not char then Humanoid=nil PlayerToHumanoid[plr]=nil return end
		local connection = PlrCharChildAddedConnection[plr]
		if connection then
			Disconnect(connection)
		end
		local hum = FindFirstChild(char,"Humanoid")::Humanoid?
		if hum then
			SetProperty(hum,"AutoRotate",false)
			Humanoid=hum
			PlayerToHumanoid[plr]=hum
		end
		local root = FindFirstChild(char,"HumanoidRootPart")::BasePart?
		if root then
			PlayerToRootPart[plr]=root
		end
		PlrCharChildAddedConnection[plr] = Connect(GetProperty(char,"ChildAdded"),function(child:Humanoid|BasePart):()
			if IsA(child,"Humanoid") then
				SetProperty(child,"AutoRotate",false)
				Humanoid=child::Humanoid
				PlayerToHumanoid[plr]=child::Humanoid
				if connection_Jumping then
					Disconnect(connection_Jumping)
					return
				end
				return
			end
			if GetProperty(child,"Name")=="HumanoidRootPart" then
				PlayerToRootPart[plr]=child::BasePart
				return
			end
		end)
	end
	Connect(GetPropertyChangedSignal(plr,"Character"),char_changed)
	char_changed()
end
temp = Connect(Player_Added,PlrAdded_Func)
Disconnect = temp.Disconnect
temp = Connect(Player_Added,PlrAdded_Func)--Silencer connection
Disconnect(temp)
for i,v in Players:GetPlayers() do
	PlrAdded_Func(v)
end
Connect(GetProperty(Players,"PlayerRemoving"),function(plr:Player):()
	PlayerToHumanoid[plr]=nil
	PlayerToRootPart[plr]=nil
	local connection = PlrCharChildAddedConnection[plr]
	if connection then
		Disconnect(connection)
		PlrCharChildAddedConnection[plr]=nil
	end
end)


local display = Instance.new("Part")
display.Transparency=0.5
display.Anchored=true
local ConeHandleAdornment = Instance.new("ConeHandleAdornment")
ConeHandleAdornment.Adornee=display
ConeHandleAdornment.Color3=Color3.new(1,0,0)
ConeHandleAdornment.Parent=display
display.CanCollide=false
display.CanQuery=false
display.CanTouch=false
display.Parent=workspace

Connect(GetProperty(CameraRotation,"OnServerEvent"),function(plr:Player,data:Vector2int16|Vector3int16):()
	local type = typeof(data)
	if type=="Vector2int16" then--PC/Mobile/Console
		PlayerCameraData[plr]=data
		local ax = GetVector2int16(data::Vector2int16,"X") / 32767 * math.pi
		local ay = GetVector2int16(data::Vector2int16,"Y") / 32767 * (math.pi / 2)
		local pitch,yaw = CFrame.Angles(0, ax, 0),CFrame.Angles(ay, 0, 0)
		local rot = CFrame_MUL(pitch,yaw)

		display.CFrame=CFrame.new(0,5,0)*rot
		local root = PlayerToRootPart[plr]
		if not root then return end

		PivotTo(root,CFrame_MUL(CFrame.new(GetProperty(root,"Position")),pitch))
		return
	elseif type=="Vector3int16" then--VR
		PlayerCameraData[plr]=data
		local pitch_i16 = GetVector3int16(data::Vector3int16,"X")
		local yaw_i16   = GetVector3int16(data::Vector3int16,"Y")
		local pack      = GetVector3int16(data::Vector3int16,"Z")
		if pack < 0 then
			pack += 65536
		end
		local x = bit32.rshift(pack, 8)          -- high 8 bits
		local z = bit32.band(pack,0b11111111)

		local hx = ((x / 255) - 0.5) * 2 * math.pi
		local hz = ((z / 255) - 0.5) * 2 * math.pi

		local pitch = pitch_i16 / 32767 * math.pi
		local yaw   = yaw_i16   / 32767 * math.pi
		local pitch_cf = CFrame.Angles(0,pitch,0)
		
		local body_cf = pitch_cf * CFrame.Angles(0,hx, 0) * CFrame.Angles(yaw, 0,0) * CFrame.Angles(0, 0, hz)
		-- final camera
		display.CFrame = CFrame.new(0,5,-35) * body_cf
		local root = PlayerToRootPart[plr]
		if not root then return end

		PivotTo(root,CFrame_MUL(CFrame.new(GetProperty(root,"Position")),pitch_cf))
		return
	else
		Kick(plr) return
	end
end)



