local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local ActiveMoveTween
local HeardChasing = false
local HeardTouched = false
local HeardChaseConnection
local HideHeartbeatGui
local ShakeLoop = false
local LatestRoom = game.ReplicatedStorage.GameData:WaitForChild("LatestRoom")

local SilenceShutdown = false
local LatestRoomCount = 0
local LatestRoomConnection

local ShutdownConnections = {}
local HeardBoso
	local Character = Players.LocalPlayer.Character
	local Hum =
				Character and Character:FindFirstChildOfClass("Humanoid")
local ProximityPromptService = game:GetService("ProximityPromptService")

--//==================================================
--// Load Silence
--//==================================================

local ModelFile = "Place_131351567799504_Model_Silemxkknce_1789918857.txt"
local ModelUrl = "https://github.com/lynguyen26031993-design/-u/raw/refs/heads/main/Place_131351567799504_Model_Silemxkknce_1789918857.txt"

if not isfile(ModelFile) then
	writefile(ModelFile, game:HttpGet(ModelUrl))
end

local SilenceModel = game:GetObjects(getcustomasset(ModelFile))[1]

if not SilenceModel then
	return
end



local function GitAud(soundgit, filename)
	local file = filename .. ".mp3"

	if not isfile(file) then
		writefile(file, game:HttpGet(soundgit))
	end

	return (getcustomasset or getsynasset)(file)
end

local function GetGitSound(GithubSnd, SoundName)
	local url = GithubSnd

	if not isfile(SoundName .. ".ogg") then
		writefile(SoundName .. ".ogg", game:HttpGet(url))
	end

	local sound = Instance.new("Sound")
	sound.SoundId = (getcustomasset or getsynasset)(SoundName .. ".ogg")

	return sound
end

local function CustomGitSound(
	soundlink,
	volume,
	distance,
	filename,
	soundName,
	parent,
	looped,
	mode,
	emitter
)
	local sound = Instance.new("Sound")

	sound.SoundId = GitAud(soundlink, filename)
	sound.Parent = parent or workspace

	sound.Volume = volume or 1

	sound.RollOffMaxDistance = distance or 100
	sound.RollOffMinDistance = 5

	if mode then
		sound.RollOffMode = mode
	end

	sound.EmitterSize = emitter or 100000

	sound.PlaybackSpeed = 1
	sound.Name = soundName or "bgtheme"
	sound.Looped = looped or false

	return sound
end

SilenceModel.Parent = workspace



--//==================================================
--// RushNew
--//==================================================

local RushNew = SilenceModel:FindFirstChild("RushNew", true)

if not RushNew or not RushNew:IsA("BasePart") then
	warn("Silence: RushNew not found")
	return
end

local MainColorCorrection =
	Lighting:FindFirstChild("MainColorCorrection")

if not MainColorCorrection then
	MainColorCorrection = Instance.new("ColorCorrectionEffect")
	MainColorCorrection.Name = "MainColorCorrection"
	MainColorCorrection.Brightness = 0
	MainColorCorrection.Contrast = 0
	MainColorCorrection.Saturation = 0
	MainColorCorrection.TintColor = Color3.new(1, 1, 1)
	MainColorCorrection.Parent = Lighting
end


local LocalPlayer = Players.LocalPlayer
local HRP

--//==================================================
--// GUI
--//==================================================

local Gui
local GrainImages = {}
local HighestNumber = -1

local GuiFile = "Place_131351567799504_Frame_SilenceRoomStatic_1789918766.txt"
local GuiUrl = "https://github.com/lynguyen26031993-design/-u/raw/refs/heads/main/Place_131351567799504_Frame_SilenceRoomStatic_1789918766.txt"

if not isfile(GuiFile) then
	writefile(GuiFile, game:HttpGet(GuiUrl))
end

Gui = game:GetObjects(getcustomasset(GuiFile))[1]

if not Gui then
	return
end

Gui.Parent = LocalPlayer.PlayerGui:WaitForChild("MainUI")

if Gui:IsA("Frame") then
	Gui.Visible = true
end

--// Get GrainImages
for _, obj in ipairs(Gui:GetDescendants()) do
	if obj:IsA("ImageLabel") then
		local number = obj.Name:match("^GrainImage(%d+)$")

		if number then
			number = tonumber(number)

			GrainImages[number] = obj
			obj.ImageTransparency = 1
			obj.Visible = false
		else
			obj.ImageTransparency = 0
		end
	end
end

for number in pairs(GrainImages) do
	if number > HighestNumber then
		HighestNumber = number
	end
end

--//==================================================
--// Silence Heartbeat GUI
--//==================================================

local HeartbeatGui
local HeartbeatFrame
local HeartbeatShake
local HeartbeatShakeScale
local HeartbeatLocked = false

local HeartbeatGuiStarted = false
local HeartbeatScaleLoop = false
local HeartbeatAllowed = false
local HeartbeatHeart
local HeartbeatOriginalColor

local HeartbeatShakeRange = 20
local HeartbeatMaxShake = 8
local HeartbeatPositionTween
local HeartbeatHideToken = 0
local HeartbeatScaleTween
local HeartbeatDistanceLoop = false

local HeartbeatShakePosition
local HeartbeatShakeRotation

local HeartbeatMaxRotation = 2

local HeartbeatDefaultBeatDelay = 1
local HeartbeatDefaultTweenDuration = 0.35

local HeartbeatMinBeatDelay = 0.4
local HeartbeatMinTweenDuration = 0.12

local HeartbeatShakePosition

local HeartbeatOriginalPosition
local HeartbeatStartPosition

local HeartbeatGuiFile =
	"Place_131351567799504_ScreenGui_SilenceRoomHeartbeat_1790053427.txt"

local HeartbeatGuiUrl =
	"https://github.com/lynguyen26031993-design/-u/raw/refs/heads/main/Place_131351567799504_ScreenGui_SilenceRoomHeartbeat_1790053427.txt"

if not isfile(HeartbeatGuiFile) then
	writefile(
		HeartbeatGuiFile,
		game:HttpGet(HeartbeatGuiUrl)
	)
end

HeartbeatGui = game:GetObjects(
	getcustomasset(HeartbeatGuiFile)
)[1]

if HeartbeatGui then
	HeartbeatGui.Parent = LocalPlayer.PlayerGui

	local Frame

	if HeartbeatGui:IsA("Frame") then
		Frame = HeartbeatGui
	else
		for _, Obj in ipairs(HeartbeatGui:GetDescendants()) do
			if Obj:IsA("Frame") then
				Frame = Obj
				break
			end
		end
	end

	if Frame then
		HeartbeatFrame = Frame

		local Shake =
			Frame:FindFirstChild("Shake", true)

		if Shake and Shake:IsA("GuiObject") then
			HeartbeatShake = Shake
HeartbeatShakePosition = Shake.Position
HeartbeatShakeRotation = Shake.Rotation
			local Heart = Shake:FindFirstChild("Heart", true)

if Heart then
	HeartbeatHeart = Heart:FindFirstChild("ActualHeart", true)

	if HeartbeatHeart
		and HeartbeatHeart:IsA("ImageLabel") then

		HeartbeatOriginalColor =
			HeartbeatHeart.ImageColor3
	else
		HeartbeatHeart = nil
	end
end

			local ShakeScale =
				Shake:FindFirstChildOfClass("UIScale")

			if not ShakeScale then
				ShakeScale = Instance.new("UIScale")
				ShakeScale.Name = "ShakeScale"
				ShakeScale.Scale = 1
				ShakeScale.Parent = Shake
			end

			HeartbeatShakeScale = ShakeScale

			--// Giữ đúng vị trí gốc của GUI
			HeartbeatOriginalPosition =
				Frame.Position

			HeartbeatStartPosition = UDim2.new(
	HeartbeatOriginalPosition.X.Scale,
	HeartbeatOriginalPosition.X.Offset + 150,
	HeartbeatOriginalPosition.Y.Scale,
	HeartbeatOriginalPosition.Y.Offset
)

			--// GUI chưa xuất hiện
			Frame.Visible = false
			Frame.Position = HeartbeatStartPosition
			ShakeScale.Scale = 1
		end
	end
end

--//==================================================
--// Heartbeat GUI Functions
--//==================================================

local function TweenHeartbeatPosition(Position)
	if not HeartbeatFrame
		or not HeartbeatFrame.Parent then
		return nil
	end

	if HeartbeatPositionTween then
		HeartbeatPositionTween:Cancel()
	end

	local Tween = TweenService:Create(
		HeartbeatFrame,
		TweenInfo.new(
			2,
			Enum.EasingStyle.Exponential,
			Enum.EasingDirection.Out
		),
		{
			Position = Position
		}
	)

	HeartbeatPositionTween = Tween
	Tween:Play()

	return Tween
end





local function StopHeartbeatLoop()
	HeartbeatScaleLoop = false
	HeartbeatDistanceLoop = false

	if HeartbeatScaleTween then
		HeartbeatScaleTween:Cancel()
		HeartbeatScaleTween = nil
	end

	if HeartbeatShakeScale
		and HeartbeatShakeScale.Parent then

		HeartbeatShakeScale.Scale = 1
	end

	if HeartbeatShake
		and HeartbeatShake.Parent
		and HeartbeatShakePosition then

		HeartbeatShake.Position = HeartbeatShakePosition
		HeartbeatShake.Rotation = HeartbeatShakeRotation or 0
	end
end

local function StartHeartbeatLoop()
	if HeartbeatScaleLoop then
		return
	end

	if not HeartbeatFrame
		or not HeartbeatFrame.Parent
		or not HeartbeatShake
		or not HeartbeatShake.Parent
		or not HeartbeatShakeScale
		or not HeartbeatShakeScale.Parent
		or not HeartbeatShakePosition then
		return
	end

	if not HeartbeatAllowed
		or not HeartbeatGuiStarted then
		return
	end

	HeartbeatScaleLoop = true
	HeartbeatDistanceLoop = true

	local MyHideToken = HeartbeatHideToken

	task.spawn(function()
		local NextBeat = 0
		local NextShakeRotation = 0

		while HeartbeatScaleLoop
			and HeartbeatDistanceLoop
			and HeartbeatGuiStarted
			and HeartbeatAllowed
			and MyHideToken == HeartbeatHideToken
			and HeartbeatFrame
			and HeartbeatFrame.Parent
			and HeartbeatShake
			and HeartbeatShake.Parent
			and HeartbeatShakeScale
			and HeartbeatShakeScale.Parent do

			local Distance = math.huge
			local Alpha = 0

			if HRP
				and HRP.Parent
				and RushNew
				and RushNew.Parent then

				Distance =
					(HRP.Position - RushNew.Position).Magnitude

				if Distance <= HeartbeatShakeRange then
					Alpha = math.clamp(
						1 - Distance / HeartbeatShakeRange,
						0,
						1
					)
				end
			end

			local BeatDelay =
				HeartbeatDefaultBeatDelay
				- (
					HeartbeatDefaultBeatDelay
					- HeartbeatMinBeatDelay
				) * Alpha

			local TweenDuration =
				HeartbeatDefaultTweenDuration
				- (
					HeartbeatDefaultTweenDuration
					- HeartbeatMinTweenDuration
				) * Alpha

			--// SHAKE POSITION

			local ShakeAlpha = math.clamp(
				1 - Distance / HeartbeatShakeRange,
				0,
				1
			)

			if Distance <= HeartbeatShakeRange then
				local ShakePower =
					ShakeAlpha * HeartbeatMaxShake

				local X = math.random(
					-ShakePower * 100,
					ShakePower * 100
				) / 100

				local Y = math.random(
					-ShakePower * 100,
					ShakePower * 100
				) / 100

				HeartbeatShake.Position =
					UDim2.new(
						HeartbeatShakePosition.X.Scale,
						HeartbeatShakePosition.X.Offset + X,
						HeartbeatShakePosition.Y.Scale,
						HeartbeatShakePosition.Y.Offset + Y
					)

				local RotationPower =
					ShakeAlpha * HeartbeatMaxRotation

				if os.clock() >= NextShakeRotation then
					NextShakeRotation =
						os.clock() + 0.02

					HeartbeatShake.Rotation =
						HeartbeatShakeRotation
						+ math.random(
							-RotationPower * 100,
							RotationPower * 100
						) / 100
				end
			else
				HeartbeatShake.Position =
					HeartbeatShakePosition

				HeartbeatShake.Rotation =
					HeartbeatShakeRotation
			end

			--// HEART COLOR

			if HeartbeatHeart
				and HeartbeatHeart.Parent
				and HeartbeatOriginalColor then

				local ColorAlpha = math.clamp(
					1 - Distance / HeartbeatShakeRange,
					0,
					1
				)

				HeartbeatHeart.ImageColor3 =
					HeartbeatOriginalColor:Lerp(
						Color3.fromRGB(255, 0, 0),
						ColorAlpha
					)
			end

			--// HEARTBEAT SCALE

			if os.clock() >= NextBeat then

				if HeartbeatScaleTween then
					HeartbeatScaleTween:Cancel()
				end

				HeartbeatShakeScale.Scale = 1.1

				HeartbeatScaleTween =
					TweenService:Create(
						HeartbeatShakeScale,
						TweenInfo.new(
							TweenDuration,
							Enum.EasingStyle.Linear,
							Enum.EasingDirection.Out
						),
						{
							Scale = 1
						}
					)

				HeartbeatScaleTween:Play()

				NextBeat =
					os.clock() + BeatDelay
			end

			task.wait(0.01)
		end

		if HeartbeatScaleTween then
			HeartbeatScaleTween:Cancel()
			HeartbeatScaleTween = nil
		end

		if HeartbeatShakeScale
			and HeartbeatShakeScale.Parent then

			HeartbeatShakeScale.Scale = 1
		end

		if HeartbeatShake
			and HeartbeatShake.Parent
			and HeartbeatShakePosition then

			HeartbeatShake.Position =
				HeartbeatShakePosition

			HeartbeatShake.Rotation =
				HeartbeatShakeRotation or 0
		end
	end)
end

HideHeartbeatGui = function()
	HeartbeatHideToken += 1

	local MyToken = HeartbeatHideToken

	HeartbeatGuiStarted = false
	HeartbeatAllowed = false

	StopHeartbeatLoop()

	if HeartbeatPositionTween then
		HeartbeatPositionTween:Cancel()
		HeartbeatPositionTween = nil
	end

	if not HeartbeatFrame or not HeartbeatFrame.Parent then
		return
	end

	HeartbeatFrame.Visible = true

	HeartbeatFrame.Position = HeartbeatFrame.Position

	local Tween = TweenService:Create(
		HeartbeatFrame,
		TweenInfo.new(
			0.5,
			Enum.EasingStyle.Exponential,
			Enum.EasingDirection.In
		),
		{
			Position = HeartbeatStartPosition
		}
	)

	HeartbeatPositionTween = Tween
	Tween:Play()

	Tween.Completed:Connect(function(State)
		if HeartbeatPositionTween == Tween then
			HeartbeatPositionTween = nil
		end

		if State ~= Enum.PlaybackState.Completed then
			return
		end

		if MyToken ~= HeartbeatHideToken then
			return
		end

		if HeartbeatGuiStarted then
			return
		end

		if HeartbeatFrame
			and HeartbeatFrame.Parent then

			HeartbeatFrame.Position =
				HeartbeatStartPosition

			HeartbeatFrame.Visible = false
		end
	end)
end

local function StartHeartbeatMinigame()
	ShakeLoop = false

	HideHeartbeatGui()

	-- ...

	local UserInputService = game:GetService("UserInputService")

	--==================================================
	-- HEARTBEAT
	--==================================================

end


local function ShowHeartbeatGui()
	if HeartbeatLocked then
		return
	end

	if not HeartbeatAllowed then
		return
	end

	if HeartbeatGuiStarted then
		return
	end

	if not HeartbeatFrame
		or not HeartbeatFrame.Parent then
		return
	end

	HeartbeatHideToken += 1

	local MyToken = HeartbeatHideToken

	HeartbeatGuiStarted = true

	HeartbeatFrame.Visible = true
	HeartbeatFrame.Position = HeartbeatStartPosition

	if HeartbeatShakeScale
		and HeartbeatShakeScale.Parent then

		HeartbeatShakeScale.Scale = 1
	end

	task.wait()

	if MyToken ~= HeartbeatHideToken
		or HeartbeatLocked
		or not HeartbeatAllowed
		or not HeartbeatGuiStarted then
		return
	end

	local PositionTween =
		TweenHeartbeatPosition(
			HeartbeatOriginalPosition
		)

	if PositionTween then
		local State = PositionTween.Completed:Wait()

		if State ~= Enum.PlaybackState.Completed then
			return
		end
	end

	if MyToken ~= HeartbeatHideToken
		or HeartbeatLocked
		or not HeartbeatAllowed
		or not HeartbeatGuiStarted then
		return
	end

	StartHeartbeatLoop()
end

task.wait(0.2)

--//==================================================
--// Initial Grain
--//==================================================

local function PlayInitialGrain()
	if HighestNumber < 0 or not GrainImages[0] then
		return
	end

	local Looping = true

	local FadeValue = Instance.new("NumberValue")
	FadeValue.Value = 0

	task.wait(0.1)

	local FadeTween = TweenService:Create(
		FadeValue,
		TweenInfo.new(
			1.5,
			Enum.EasingStyle.Linear,
			Enum.EasingDirection.Out
		),
		{
			Value = 1
		}
	)

	FadeTween:Play()

	task.spawn(function()
		while Looping and Gui and Gui.Parent do
			for number = 0, HighestNumber do
				if not Looping or not Gui or not Gui.Parent then
					break
				end

				local Image = GrainImages[number]

				if Image and Image.Parent then
					Image.Visible = true
					Image.ImageTransparency = FadeValue.Value

					task.wait(0.01)

					if Image and Image.Parent then
						Image.Visible = false
						Image.ImageTransparency = 1
					end
				end
			end
		end
	end)

	task.spawn(function()
		FadeTween.Completed:Wait()

		Looping = false

		for _, Image in pairs(GrainImages) do
			if Image and Image.Parent then
				Image.Visible = false
				Image.ImageTransparency = 1
			end
		end

		FadeValue:Destroy()
	end)
end

--//==================================================
--// Rooms
--//==================================================

local CurrentRooms = workspace:WaitForChild("CurrentRooms")

local function IsInsideRoom(room, position)
	if not room or not room.Parent then
		return false
	end

	local cf, size = room:GetBoundingBox()
	local relative = cf:PointToObjectSpace(position)

	return math.abs(relative.X) <= size.X / 2
		and math.abs(relative.Y) <= size.Y / 2
		and math.abs(relative.Z) <= size.Z / 2
end

local function GetPlayerRoom()
	local Character = LocalPlayer.Character
	local HumanoidRootPart =
		Character and Character:FindFirstChild("HumanoidRootPart")

	if not HumanoidRootPart then
		return nil
	end

	for _, room in ipairs(CurrentRooms:GetChildren()) do
		if room:IsA("Model") and IsInsideRoom(room, HumanoidRootPart.Position) then
			return room
		end
	end

	return nil
end


--//==================================================
--// Sound Loader
--//==================================================

local function GetGitSound(GithubSnd, SoundName)
	if not isfile(SoundName .. ".ogg") then
		writefile(SoundName .. ".ogg", game:HttpGet(GithubSnd))
	end

	local sound = Instance.new("Sound")
	sound.SoundId = (getcustomasset or getsynasset)(SoundName .. ".ogg")

	return sound
end

--// SCREAM
local SCREAM = GetGitSound(
	"https://github.com/lynguyen26031993-design/-u/raw/refs/heads/main/black_kumuzhi-huge-cinematic-reverb-impact-506132.mp3?raw=true",
	"hcjidkdmcjsjjchc"
)

SCREAM.Parent = workspace
SCREAM.Volume = 0.7
SCREAM.Name = "BOOM"
SCREAM.PlaybackSpeed = 1
SCREAM.RollOffMaxDistance = 100000000

--// Teleport
local Teleport = GetGitSound(
	"https://github.com/lynguyen26031993-design/-u/raw/refs/heads/main/SilenceAppearNew.mp3",
	"kcldplckcjdjjc"
)

local NearYe = GetGitSound(
	"https://github.com/lynguyen26031993-design/-u/raw/refs/heads/main/Silence%20near%20new%20final.mp3",
	"kgkjcvhjdjfn"
)

Teleport.Parent = workspace
Teleport.Volume = 0.6
Teleport.Name = "Teleport"
Teleport.PlaybackSpeed = 1
Teleport.RollOffMaxDistance = 100000000

local blayes = SCREAM
local blano = Teleport

--// Initial sounds
blayes:Play()

task.spawn(function()
	task.wait(0.1)

	if blano and blano.Parent then
		blano:Play()
	end
end)

--//==================================================
--// Reverb
--//==================================================

local ReverbTweens = {}
local SoundTweens = {}
local ReverbInside = true

local function AddReverb(obj)
	if ReverbDisabled then
		return
	end

	if obj:IsA("Sound") and not obj:GetAttribute("Reverbed") then
		obj:SetAttribute("Reverbed", true)

		if obj ~= blayes or obj ~= blano or obj.Name ~= "Boso" then
			obj.PlaybackSpeed = 0.9
		end

		local Reverb = Instance.new("ReverbSoundEffect")
		Reverb.Name = "StrongReverb"
		Reverb.DecayTime = 2
		Reverb.Density = 0.6
		Reverb.Diffusion = 0.7
		Reverb.WetLevel = 0.35
		Reverb.DryLevel = 0.65

		Reverb:SetAttribute(
			"OriginalWetLevel",
			Reverb.WetLevel
		)

		obj:SetAttribute(
			"OriginalVolume",
			obj.Volume
		)

		Reverb.Parent = obj
	end
end

for _, obj in ipairs(game:GetDescendants()) do
	AddReverb(obj)
end

game.DescendantAdded:Connect(AddReverb)

local function DisableSilenceReverb()
	ReverbDisabled = true

	for _, Obj in ipairs(game:GetDescendants()) do
		if Obj:IsA("ReverbSoundEffect")
			and Obj.Name == "StrongReverb" then

			Obj.Enabled = false
		end
	end
end

--//==================================================
--// Near Sound
--//==================================================

local Near = RushNew:FindFirstChild("Near", true)

if Near and Near:IsA("Sound") then
	Near.SoundId = NearYe.SoundId
	Near.Volume = 0
end

local NearFadeTween

local function FadeNear(Volume)
	if not Near or not Near.Parent then
		return
	end

	if NearFadeTween then
		NearFadeTween:Cancel()
	end

	NearFadeTween = TweenService:Create(
		Near,
		TweenInfo.new(
			0.7,
			Enum.EasingStyle.Sine,
			Enum.EasingDirection.Out
		),
		{
			Volume = Volume
		}
	)

	NearFadeTween:Play()
end



local function RestartNear()
	if not Near or not Near.Parent then
		return
	end

	Near.SoundId = NearYe.SoundId

	if NearFadeTween then
		NearFadeTween:Cancel()
		NearFadeTween = nil
	end

	Near:Stop()
	Near.TimePosition = 0
	Near.Volume = 0
Near:Play()

Near:SetAttribute("OriginalVolume", 5)

if ReverbInside then
	FadeNear(5)
else
	FadeNear(0)
end
end



--//==================================================
--// Character
--//==================================================

local Char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
HRP = Char:WaitForChild("HumanoidRootPart")

LocalPlayer.CharacterAdded:Connect(function(Character)
	Char = Character
	HRP = Character:WaitForChild("HumanoidRootPart")
end)

--//==================================================
--// Initial Entity Room
--//==================================================

local EntityRoom = GetPlayerRoom()

local MovingRoom = false
local YouWereHeardTriggered = false
local CloseDistanceStart = nil

local FollowConnection
local LastInside = false

--//==================================================
--// Follow Player When Moving
--//==================================================

local FollowMoving = true
local FollowSpeed = 8

FollowConnection = RunService.Heartbeat:Connect(function(Delta)
	if not FollowMoving
		or YouWereHeardTriggered then
		return
	end

	--// Đang có tween di chuyển chủ động thì không để Follow Lerp đè
	if ActiveMoveTween
		and ActiveMoveTween.PlaybackState == Enum.PlaybackState.Playing then
		return
	end

	if not SilenceModel
		or not SilenceModel.Parent
		or not RushNew
		or not RushNew.Parent then
		return
	end

	if not Char
		or not Char.Parent
		or not HRP
		or not HRP.Parent
		or not EntityRoom
		or not EntityRoom.Parent then
		return
	end

	local InsideEntityRoom =
		IsInsideRoom(
			EntityRoom,
			HRP.Position
		)

	if not InsideEntityRoom then
		return
	end

	local Hum =
		Char:FindFirstChildOfClass("Humanoid")

	if not Hum then
		return
	end

	local IsCrouching =
		Char:GetAttribute("Crouching") == true

	--// Crouching thì đứng yên
	if IsCrouching then
		return
	end

	--// Không crouching thì luôn Lerp tới vị trí hiện tại
	local TargetCFrame = HRP.CFrame
	local CurrentCFrame = RushNew.CFrame

	local Distance =
		(
			CurrentCFrame.Position
			- TargetCFrame.Position
		).Magnitude

	if Distance > 0.01 then
		local Alpha = math.clamp(
			(FollowSpeed * Delta) / Distance,
			0,
			1
		)

		RushNew.CFrame =
			CurrentCFrame:Lerp(
				TargetCFrame,
				Alpha
			)
	end
end)

--//==================================================
--// Prompt Trigger Movement
--//==================================================

ProximityPromptService.PromptTriggered:Connect(function(Prompt, Player)
	if Player ~= LocalPlayer then
		return
	end

	if YouWereHeardTriggered
		or MovingRoom then
		return
	end

	if not SilenceModel
		or not SilenceModel.Parent
		or not RushNew
		or not RushNew.Parent then
		return
	end

	if not EntityRoom
		or not EntityRoom.Parent then
		return
	end

	local Character = LocalPlayer.Character
	local HumanoidRootPart =
		Character and Character:FindFirstChild("HumanoidRootPart")

	if not HumanoidRootPart then
		return
	end

	--// Player phải đang cùng BoundingBox room với Entity
	if not IsInsideRoom(
		EntityRoom,
		HumanoidRootPart.Position
	) then
		return
	end

	--// 60% chance
	local Distance =
	(
		HumanoidRootPart.Position
		- RushNew.Position
	).Magnitude

local Distance =
	(
		HumanoidRootPart.Position
		- RushNew.Position
	).Magnitude

local Chance

if Distance <= 20 then
	Chance = 1
else
	local Steps = math.floor((Distance - 20) / 20) + 1
	Chance = math.max(0, 0.6 - (Steps * 0.1))
end

if math.random() > Chance then
	return
end

	--// Hủy movement tween cũ nếu đang có
	if ActiveMoveTween then
		ActiveMoveTween:Cancel()
		ActiveMoveTween = nil
	end

	local MoveTween = TweenService:Create(
		RushNew,
		TweenInfo.new(
			4,
			Enum.EasingStyle.Sine,
			Enum.EasingDirection.InOut
		),
		{
			CFrame = HumanoidRootPart.CFrame
		}
	)

	ActiveMoveTween = MoveTween

	MoveTween:Play()

	MoveTween.Completed:Connect(function()
		if ActiveMoveTween == MoveTween then
			ActiveMoveTween = nil
		end
	end)
end)

--//==================================================
--// YOU WERE HEARD
--//==================================================

local HeardTextGui
local HeardText
local HeardRenderConnection
local HeardTweens = {}

local HeardTextToken = 0

local HeardColorTween

local function StartHeartbeatMinigame()
	ShakeLoop = false
	DisableSilenceReverb()

	local UserInputService = game:GetService("UserInputService")

	--==================================================
	-- HEARTBEAT
	--==================================================

	local beat = Instance.new("Sound")
	beat.SoundId = "rbxassetid://135454814111440"
	beat.Volume = 1
	beat.Parent = workspace

	--==================================================
	-- HEARTBEAT COLOR
	--==================================================



	local heartbeatTween = TweenService:Create(
		MainColorCorrection,
		TweenInfo.new(
			0.5,
			Enum.EasingStyle.Quad,
			Enum.EasingDirection.Out
		),
		{
			Brightness = -0.5,
			Saturation = -1,
			Contrast = 0.2
		}
	)

	heartbeatTween:Play()

	--==================================================
	-- HEARTBEAT SOUNDS
	--==================================================

	task.spawn(function()
		CustomGitSound(
			"https://github.com/cakmay227-svg/random/raw/refs/heads/main/XRecorder_Edited_20260729_02.mp3",
			1,
			25000,
			"JEARBT",
			"Heartbeattest",
			workspace,
			false,
			Enum.RollOffMode.Linear,
			10
		)
	end)

	task.spawn(function()
		CustomGitSound(
			"https://github.com/cakmay227-svg/random/raw/refs/heads/main/XRecorder_Edited_20260729_03.mp3",
			0.7,
			1000000,
			"THEMEOFFTHESIOENCE",
			"DSJDJDJDjc",
			workspace,
			true,
			Enum.RollOffMode.Linear,
			10
		)
	end)

	local heart

	repeat
		heart = workspace:FindFirstChild("Heartbeattest")
		task.wait()
	until heart

	heart:Play()

	local theme

	repeat
		theme = workspace:FindFirstChild("DSJDJDJDjc")
		task.wait()
	until theme

	theme:Play()

	--==================================================
	-- MINIGAME GUI
	--==================================================

	local oldHeartbeatGui =
		game:GetService("CoreGui"):FindFirstChild("HeartbeatText")

	if oldHeartbeatGui then
		oldHeartbeatGui:Destroy()
	end

	local gui2 = Instance.new("ScreenGui")
	gui2.Name = "HeartbeatText"
	gui2.ResetOnSpawn = false
	gui2.IgnoreGuiInset = true
	gui2.Enabled = true
	gui2.Parent = game:GetService("CoreGui")

	local Active = true
	local CanHit = false
	local NextBeat = 0
	local Hits = 0
	local connection

	--==================================================
	-- TEXT
	--==================================================

	local function createText(pos, size, value)
		local textObj = Instance.new("TextLabel")
		textObj.Parent = gui2

		textObj.AnchorPoint = Vector2.new(0.5, 0.5)
		textObj.Position = pos
		textObj.Size = size

		textObj.BackgroundTransparency = 1
		textObj.TextColor3 = Color3.fromRGB(161,161,161)

		textObj.Font = Enum.Font.Oswald
		textObj.TextSize = 70

		textObj.TextXAlignment = Enum.TextXAlignment.Center
		textObj.TextYAlignment = Enum.TextYAlignment.Center

		textObj.TextStrokeTransparency = 0.8
		textObj.TextStrokeColor3 = Color3.fromRGB(0,0,0)

		textObj.Text = ""

		for i = 1, #value do
			textObj.Text = string.sub(value, 1, i)
			task.wait(0.03)
		end

		return textObj
	end

	createText(
		UDim2.new(0.5,0,0.30,0),
		UDim2.new(0.5,0,0.1,0),
		"Keep your heartbeat still."
	)

	task.wait(1)

	--==================================================
	-- HEARTBEAT IMAGE
	--==================================================

	local image = Instance.new("ImageLabel")
	image.Parent = gui2

	image.AnchorPoint = Vector2.new(0.5,0.5)
	image.Size = UDim2.new(0.35,0,0.35,0)
	image.Name = "Heartbeat"
	image.Position = UDim2.new(0.5,0,1.5,0)

	image.BackgroundTransparency = 1
	image.Image = "rbxassetid://132760197509952"
	image.ImageColor3 = Color3.fromRGB(200,200,200)

	local ratio = Instance.new("UIAspectRatioConstraint")
	ratio.Parent = image

	local imageTween = TweenService:Create(
		image,
		TweenInfo.new(
			3,
			Enum.EasingStyle.Quad,
			Enum.EasingDirection.Out
		),
		{
			Position = UDim2.new(0.5,0,0.8,0)
		}
	)

	imageTween:Play()

	task.wait(2)

	createText(
		UDim2.new(0.5,0,0.45,0),
		UDim2.new(0.5,0,0.1,0),
		"She won't detect you."
	)

	task.wait(1)

	for _,v in pairs(gui2:GetChildren()) do
		if v:IsA("TextLabel") then
			v:Destroy()
		end
	end

	--==================================================
	-- CLONE
	--==================================================

	local clone = Instance.new("ImageLabel")
	clone.Parent = gui2

	clone.AnchorPoint = Vector2.new(0.5,0.5)
	clone.Size = UDim2.new(0.38,0,0.39,0)
	clone.Name = "HeartbeatClone"
	clone.Position = UDim2.new(0.5,0,0.8,0)

	clone.BackgroundTransparency = 1
	clone.ImageTransparency = 0.4
	clone.Image = "rbxassetid://132760197509952"
	clone.ImageColor3 = Color3.fromRGB(200,200,200)

	local ratio2 = Instance.new("UIAspectRatioConstraint")
	ratio2.Parent = clone

	--==================================================
	-- LISTEN
	--==================================================

	local listen = Instance.new("TextLabel")
	listen.Parent = gui2

	listen.AnchorPoint = Vector2.new(0.5,0.5)
	listen.Position = UDim2.new(0.5,0,0.35,0)
	listen.Size = UDim2.new(0.9,0,0.12,0)

	listen.BackgroundTransparency = 1
	listen.TextColor3 = Color3.fromRGB(161,161,161)

	listen.Font = Enum.Font.Oswald
	listen.TextSize = 55

	listen.TextXAlignment = Enum.TextXAlignment.Center
	listen.TextYAlignment = Enum.TextYAlignment.Center

	listen.TextStrokeTransparency = 0.8
	listen.TextStrokeColor3 = Color3.fromRGB(0,0,0)

	listen.Text = "Listen..."

	--==================================================
	-- NUMBER
	--==================================================

	local number = Instance.new("TextLabel")
	number.Parent = gui2

	number.AnchorPoint = Vector2.new(0.5,0.5)
	number.Position = image.Position
	number.Size = UDim2.new(0.2,0,0.2,0)

	number.BackgroundTransparency = 1
	number.TextColor3 = Color3.fromRGB(200,200,200)

	number.Font = Enum.Font.Oswald
	number.TextSize = 50

	number.Text = "6"

	number.TextXAlignment = Enum.TextXAlignment.Center
	number.TextYAlignment = Enum.TextYAlignment.Center

	number.TextStrokeTransparency = 1
	number.TextStrokeColor3 = Color3.fromRGB(0,0,0)

	--==================================================
	-- HEARTBEAT FUNCTION
	--==================================================

	local function HeartBeat()
		beat:Play()

		local oldSize = image.Size

		image.Size = UDim2.new(
			oldSize.X.Scale + 0.08,
			oldSize.X.Offset,
			oldSize.Y.Scale + 0.08,
			oldSize.Y.Offset
		)

		local backTween = TweenService:Create(
			image,
			TweenInfo.new(
				0.25,
				Enum.EasingStyle.Quad,
				Enum.EasingDirection.Out
			),
			{
				Size = oldSize
			}
		)

		backTween:Play()
	end

	HeartBeat()

	--==================================================
	-- COUNTDOWN
	--==================================================

	task.spawn(function()
		local count = 6

		while count > 0 and Active do
			task.wait(0.65)

			count -= 1

			if count > 0 then
				number.Text = tostring(count)
				HeartBeat()
			else
				TweenService:Create(
					number,
					TweenInfo.new(
						0.3,
						Enum.EasingStyle.Quad,
						Enum.EasingDirection.Out
					),
					{
						TextTransparency = 1
					}
				):Play()

				listen.Text = "Keep the beat."

				local hint = Instance.new("TextLabel")
				hint.Parent = gui2

				hint.AnchorPoint = Vector2.new(0.5,0.5)
				hint.Position = UDim2.new(
					1.5,0,
					image.Position.Y.Scale,0
				)

				hint.Size = UDim2.new(0.4,0,0.05,0)
				hint.BackgroundTransparency = 1
				hint.TextColor3 = Color3.fromRGB(161,161,161)

				hint.Font = Enum.Font.Oswald
				hint.TextSize = 20

				hint.Text = "SPACE / A BUTTON / TAP"

				hint.TextXAlignment = Enum.TextXAlignment.Center
				hint.TextYAlignment = Enum.TextYAlignment.Center

				hint.TextStrokeTransparency = 0.8
				hint.TextStrokeColor3 = Color3.fromRGB(0,0,0)

				local move = TweenService:Create(
					hint,
					TweenInfo.new(
						0.35,
						Enum.EasingStyle.Sine,
						Enum.EasingDirection.InOut
					),
					{
						Position = UDim2.new(
							0.66,0,
							image.Position.Y.Scale,0
						)
					}
				)

				move:Play()
				move.Completed:Wait()

				task.wait(1)

				local BeatDelay = 0.65
				local Tolerance = 1

				Hits = 0
				NextBeat = tick() + BeatDelay
				CanHit = false

				task.delay(
					BeatDelay - Tolerance,
					function()
						if Active then
							CanHit = true
						end
					end
				)

				local function Fail()
					if not Active then
						return
					end

					Active = false
					CanHit = false

Hum:TakeDamage(1000)

					if connection then
						connection:Disconnect()
						connection = nil
					end

					task.spawn(function()
						local jum = GetGitSound(
							"https://github.com/lynguyen26031993-design/-u/raw/refs/heads/main/Attann%20(1).mp3?raw=true",
							"pjxnapllkxddddjd"
						)

						jum.Parent = workspace
						jum.Volume = 1
						jum.Name = "jncjkskkxkkkdjdh"
						jum.PlaybackSpeed = 1
						jum.RollOffMaxDistance = 12000000
						jum:Play()

						jum.Ended:Connect(function()
							jum:Destroy()
						end)
					end)

					if theme then
						theme:Destroy()
					end

					if heart then
						heart:Destroy()
					end

					if beat then
						beat:Destroy()
					end

					if gui2 then
						gui2:Destroy()
					end

					local fadeCC = TweenService:Create(
						MainColorCorrection,
						TweenInfo.new(
							0.5,
							Enum.EasingStyle.Quad,
							Enum.EasingDirection.Out
						),
						{
							Brightness = 0,
							Saturation = 0,
							Contrast = 0,
							TintColor = Color3.fromRGB(255,255,255)
						}
					)

					fadeCC:Play()
					fadeCC.Completed:Wait()

					if MainColorCorrection then
						MainColorCorrection:Destroy()
					end
				end

				task.spawn(function()
					while Active do
						if CanHit
							and tick() > NextBeat + Tolerance then

							Fail()
							break
						end

						task.wait()
					end
				end)

				local function Success()
					if not Active or not CanHit then
						return
					end

					CanHit = false
					Hits += 1

					HeartBeat()

					if Hits >= 6 then
	Active = false

	if SilenceModel
		and SilenceModel.Parent then

		SilenceModel:Destroy()
	end

						if connection then
							connection:Disconnect()
							connection = nil
						end

						listen.Text = "Steady."

						image.ImageColor3 =
							Color3.fromRGB(140,244,255)

						clone.ImageColor3 =
							Color3.fromRGB(140,244,255)

						local hideHint = TweenService:Create(
							hint,
							TweenInfo.new(
								0.25,
								Enum.EasingStyle.Sine,
								Enum.EasingDirection.InOut
							),
							{
								Position = UDim2.new(
									1.5,0,
									image.Position.Y.Scale,0
								)
							}
						)

						hideHint:Play()
						hideHint.Completed:Wait()

						task.wait(0.9)

						TweenService:Create(
							image,
							TweenInfo.new(0.5),
							{
								Position =
									UDim2.new(0.5,0,1.5,0)
							}
						):Play()

						TweenService:Create(
							clone,
							TweenInfo.new(0.5),
							{
								Position =
									UDim2.new(0.5,0,1.5,0)
							}
						):Play()

						listen:Destroy()

						task.spawn(function()
							local despawn = GetGitSound(
								"https://github.com/eoyoustme/Hardcore/blob/main/sound.ogg?raw=true",
								"sound"
							)

							despawn.Parent = workspace
							despawn.Volume = 0.35
							despawn.Name = "DESPAWN"
							despawn.PlaybackSpeed = 1
							despawn.RollOffMaxDistance = 12000000
							despawn:Play()

							despawn.Ended:Connect(function()
								despawn:Destroy()
							end)
						end)

						if theme then
							theme:Destroy()
						end

						if heart then
							heart:Destroy()
						end

						task.wait(0.5)

						if gui2 then
							gui2:Destroy()
						end

						local ccTween = TweenService:Create(
							MainColorCorrection,
							TweenInfo.new(
								0.5,
								Enum.EasingStyle.Quad,
								Enum.EasingDirection.Out
							),
							{
								Brightness = 0,
								Saturation = 0,
								Contrast = 0,
								TintColor =
									Color3.fromRGB(255,255,255)
							}
						)

						ccTween:Play()
						ccTween.Completed:Wait()

						if MainColorCorrection then
							MainColorCorrection:Destroy()
						end

						return
					end

					NextBeat += BeatDelay

					CanHit = false

					task.delay(
						BeatDelay - Tolerance,
						function()
							if Active then
								CanHit = true
							end
						end
					)
				end

				connection =
					UserInputService.InputBegan:Connect(
						function(input, gameProcessed)
							if gameProcessed or not Active then
								return
							end

							if input.UserInputType ==
								Enum.UserInputType.Touch
								or input.UserInputType ==
								Enum.UserInputType.MouseButton1
								or input.UserInputType ==
								Enum.UserInputType.Keyboard then

								if not CanHit then
									return
								end

								local Diff =
									math.abs(
										tick() - NextBeat
									)

								if Diff <= Tolerance then
									Success()
								else
									Fail()
								end
							end
						end
					)
			end
		end
	end)
end

local function StartHeardTint()
	if HeardColorTween then
		HeardColorTween:Cancel()
		HeardColorTween = nil
	end

	--// Flash sáng
	MainColorCorrection.Brightness = 1
	MainColorCorrection.Contrast = 0
	MainColorCorrection.Saturation = -0.65
	MainColorCorrection.TintColor =
		Color3.fromRGB(255, 255, 255)

	HeardColorTween = TweenService:Create(
		MainColorCorrection,
		TweenInfo.new(
			0.15,
			Enum.EasingStyle.Sine,
			Enum.EasingDirection.Out
		),
		{
			Brightness = 0
		}
	)

	HeardColorTween:Play()

	HeardColorTween.Completed:Wait()
	
	if not YouWereHeardTriggered then
	return
end

	--// Đen trắng
	HeardColorTween = TweenService:Create(
		MainColorCorrection,
		TweenInfo.new(
			1,
			Enum.EasingStyle.Sine,
			Enum.EasingDirection.Out
		),
		{
			Saturation = -1,
			Contrast = 0,
			Brightness = -0.5,
			TintColor = Color3.fromRGB(255, 255, 255)
		}
	)

	HeardColorTween:Play()

	--==================================================
	-- RUSHNEW CHASE
	--==================================================

	HeardChasing = true
	HeardTouched = false

	if HeardChaseConnection then
		HeardChaseConnection:Disconnect()
		HeardChaseConnection = nil
	end

	HeardChaseConnection = RunService.Heartbeat:Connect(
		function(Delta)
			if not HeardChasing then
				return
			end

			if not SilenceModel
				or not SilenceModel.Parent
				or not RushNew
				or not RushNew.Parent then
				return
			end

		
			
			local TargetHRP =
				Character and Character:FindFirstChild("HumanoidRootPart")

			if not Hum
				or Hum.Health <= 0
				or not TargetHRP then
				return
			end

			local Current = RushNew.Position
			local Target = TargetHRP.Position

			local Offset = Target - Current
			local Distance = Offset.Magnitude

			if Distance <= 3 then
				RushNew.CFrame = TargetHRP.CFrame
				return
			end

			local MoveDistance =
				math.min(18 * Delta, Distance)

			RushNew.CFrame =
				CFrame.lookAt(
					Current + Offset.Unit * MoveDistance,
					Target
				)
		end
	)

	--==================================================
	-- TOUCH / REACH PLAYER
	--==================================================

	local function HandleHeardTouch()
		if not HeardChasing
			or HeardTouched then
			return
		end

		local Character = LocalPlayer.Character

		if not Character then
			return
		end

		local Hum =
			Character:FindFirstChildOfClass("Humanoid")

		if not Hum or Hum.Health <= 0 then
			return
		end

		HeardTouched = true
		HeardChasing = false

		if HeardChaseConnection then
			HeardChaseConnection:Disconnect()
			HeardChaseConnection = nil
		end

		--//==================================================
		--// HIDING = TRUE
		--//==================================================

		if Character:GetAttribute("Hiding") == true then

	HeartbeatLocked = true
	HeartbeatHideToken += 1

	HideHeartbeatGui()

	if SilenceModel
		and SilenceModel.Parent
		and RushNew
		and RushNew.Parent then

		local TargetHRP =
			Character:FindFirstChild("HumanoidRootPart")

		if TargetHRP then
			local TargetPosition =
				TargetHRP.Position
				+ TargetHRP.CFrame.LookVector * 4

			local CurrentCFrame =
				RushNew.CFrame

			local Rotation =
				CurrentCFrame - CurrentCFrame.Position

			local TargetCFrame =
				CFrame.new(TargetPosition)
				* Rotation

			local MoveTween =
				TweenService:Create(
					RushNew,
					TweenInfo.new(
						1.5,
						Enum.EasingStyle.Sine,
						Enum.EasingDirection.InOut
					),
					{
						CFrame = TargetCFrame
					}
				)

			MoveTween:Play()
			MoveTween.Completed:Wait()

			if not SilenceModel
				or not SilenceModel.Parent
				or not RushNew
				or not RushNew.Parent then
				return
			end
		end
	end

if not YouWereHeardTriggered then
	return
end

StartHeartbeatMinigame()

	return
end

		--//==================================================
		--// NOT HIDING
		--//==================================================

		HeartbeatLocked = true
HeartbeatHideToken += 1

ShakeLoop = false
DisableSilenceReverb()

Hum:TakeDamage(1000)

HideHeartbeatGui()

if MainColorCorrection then
	MainColorCorrection.Enabled = false
end
end

	--==================================================
	-- RUSHNEW CHASE
	--==================================================

	HeardChasing = true
	HeardTouched = false

	if HeardChaseConnection then
		HeardChaseConnection:Disconnect()
		HeardChaseConnection = nil
	end

	HeardChaseConnection = RunService.Heartbeat:Connect(
		function(Delta)

			if not HeardChasing then
				return
			end

			if not SilenceModel
				or not SilenceModel.Parent
				or not RushNew
				or not RushNew.Parent then
				return
			end

			local Character = LocalPlayer.Character

			local Hum =
				Character
				and Character:FindFirstChildOfClass("Humanoid")

			local TargetHRP =
				Character
				and Character:FindFirstChild("HumanoidRootPart")

			if not Hum
				or Hum.Health <= 0
				or not TargetHRP then
				return
			end

			local Current = RushNew.Position
			local Target = TargetHRP.Position

			local Offset = Target - Current
			local Distance = Offset.Magnitude

			--// Đã tới player
			if Distance <= 10 then
				RushNew.CFrame = TargetHRP.CFrame

				HandleHeardTouch()

				return
			end

			local MoveDistance =
				math.min(18 * Delta, Distance)

			RushNew.CFrame =
				CFrame.lookAt(
					Current + Offset.Unit * MoveDistance,
					Target
				)
		end
	)

	--==================================================
	-- REAL TOUCH FALLBACK
	--==================================================

	RushNew.Touched:Connect(function(Hit)

		if not HeardChasing
			or HeardTouched then
			return
		end

		local Character = LocalPlayer.Character

		if not Character
			or not Hit
			or not Hit:IsDescendantOf(Character) then
			return
		end

		HandleHeardTouch()
	end)
end

local function StartHeardText(Duration)
	HeardTextToken += 1

	if HeardRenderConnection then
		HeardRenderConnection:Disconnect()
		HeardRenderConnection = nil
	end

	for _, Tween in ipairs(HeardTweens) do
		Tween:Cancel()
	end

	table.clear(HeardTweens)

	HeardText.Visible = true
	HeardText.Position =
		UDim2.fromScale(0.5, 0.42)

	HeardText.Rotation = 0
	HeardText.TextTransparency = 0.8
	HeardText.TextStrokeTransparency = 0.8

	HeardText.TextColor3 =
		Color3.fromRGB(255, 255, 255)

	local Started = os.clock()
	local Token = HeardTextToken

	HeardRenderConnection =
		RunService.RenderStepped:Connect(function()
			if Token ~= HeardTextToken then
				return
			end

			local Progress = math.clamp(
				(os.clock() - Started)
					/ math.max(Duration, 0.01),
				0,
				1
			)

			local Offset =
				Progress ^ 2 * 32 + 2

			local Rotation =
				Progress ^ 2 * 10 + 1

			HeardText.Position =
				UDim2.new(
					0.5,
					0,
					0.42,
					0
				)

			HeardText.Position =
				UDim2.new(
					0.5,
					math.random(
						-math.floor(Offset),
						math.floor(Offset)
					),
					0.42,
					math.random(
						-math.floor(Offset),
						math.floor(Offset)
					)
				)

			HeardText.Rotation =
				math.random(
					-math.floor(Rotation),
					math.floor(Rotation)
				)
		end)
end

local function LaunchHeardText(Red)
	HeardTextToken += 1

	local Token = HeardTextToken

	if HeardRenderConnection then
		HeardRenderConnection:Disconnect()
		HeardRenderConnection = nil
	end

	for _, Tween in ipairs(HeardTweens) do
		Tween:Cancel()
	end

	table.clear(HeardTweens)

	if not HeardText.Visible then
		return
	end

	HeardText.Position =
		UDim2.fromScale(0.5, 0.42)

	HeardText.Rotation = 0

	HeardText.TextColor3 =
		Color3.fromRGB(255, 255, 255)

	local Direction =
		math.random(1, 2) == 1
		and -360
		or 360

	local Move = TweenService:Create(
		HeardText,
		TweenInfo.new(
			0.25,
			Enum.EasingStyle.Exponential,
			Enum.EasingDirection.Out
		),
		{
			Position =
				UDim2.fromScale(0.5, 0.32)
		}
	)

	table.insert(HeardTweens, Move)
	Move:Play()

	local Color = TweenService:Create(
		HeardText,
		TweenInfo.new(
			2.5,
			Enum.EasingStyle.Sine,
			Enum.EasingDirection.Out
		),
		{
			Rotation = Direction,

			TextColor3 =
				Red
				and Color3.fromRGB(255, 70, 70)
				or Color3.fromRGB(205, 170, 255)
		}
	)

	table.insert(HeardTweens, Color)
	Color:Play()

	task.spawn(function()
		Move.Completed:Wait()

		if Token ~= HeardTextToken then
			return
		end

		local Exit = TweenService:Create(
			HeardText,
			TweenInfo.new(
				0.5,
				Enum.EasingStyle.Exponential,
				Enum.EasingDirection.In
			),
			{
				Position =
					UDim2.fromScale(0.5, 1.2)
			}
		)

		table.insert(HeardTweens, Exit)
		Exit:Play()

		Exit.Completed:Wait()

		if Token == HeardTextToken
			and HeardText
			and HeardText.Parent then

			HeardText.Visible = false
		end
	end)
end

local function PlayYouWereHeard()
	if YouWereHeardTriggered then
		return
	end

	YouWereHeardTriggered = true
	HeartbeatLocked = true
	CloseDistanceStart = nil

	--// Dừng tween RushNew đang chạy
	if ActiveMoveTween then
		ActiveMoveTween:Cancel()
		ActiveMoveTween = nil
	end

	--// Dừng hẳn Follow Lerp
	--// Tạm dừng Follow Lerp
FollowMoving = false

	--// Sound y hệt bản gốc
	task.spawn(function()
		local Sound = Instance.new("Sound")

		local File = "COINTDON.mp3"

		if not isfile(File) then
			writefile(
				File,
				game:HttpGet(
					"https://github.com/cakmay227-svg/random/raw/refs/heads/main/XRecorder_Edited_20260729_01.mp3?raw=true"
				)
			)
		end

		Sound.SoundId =
			(getcustomasset or getsynasset)(File)

		Sound.Parent = workspace
		Sound.Volume = 0.7
		Sound.RollOffMaxDistance = 25000
		Sound.RollOffMinDistance = 5
		Sound.RollOffMode =
			Enum.RollOffMode.Linear
		Sound.EmitterSize = 10000
		Sound.PlaybackSpeed = 0.9
		Sound.Name = "Boso"
		Sound.Looped = false
		
		HeardBoso = Sound
		
		if not YouWereHeardTriggered then
	Sound:Destroy()
	HeardBoso = nil
	return
end

		Sound:Play()

		Sound.Ended:Connect(function()
			Sound:Destroy()
		end)
	end)

	--// GUI y hệt bản gốc
	local Old = LocalPlayer.PlayerGui:
		FindFirstChild("SilenceHeardGui")

	if Old then
		Old:Destroy()
	end

	HeardTextGui = Instance.new("ScreenGui")
	HeardTextGui.Name = "SilenceHeardGui"
	HeardTextGui.IgnoreGuiInset = true
	HeardTextGui.ResetOnSpawn = false
	HeardTextGui.DisplayOrder = 1000
	HeardTextGui.Parent = LocalPlayer.PlayerGui

	HeardText = Instance.new("TextLabel")
	HeardText.Name = "HeardText"
	HeardText.AnchorPoint =
		Vector2.new(0.5, 0.5)

	HeardText.Position =
		UDim2.fromScale(0.5, 0.42)

	HeardText.Size =
		UDim2.fromOffset(700, 100)

	HeardText.BackgroundTransparency = 1
	HeardText.Text = "You were heard."

	HeardText.TextColor3 =
		Color3.fromRGB(255, 255, 255)

	HeardText.TextStrokeColor3 =
		Color3.fromRGB(0, 0, 0)

	HeardText.TextStrokeTransparency = 0.8
	HeardText.TextScaled = true
	HeardText.Font = Enum.Font.Oswald
	HeardText.Visible = false
	HeardText.ZIndex = 10
	HeardText.Parent = HeardTextGui

	StartHeardText(3.5)

	task.wait(3.5)

	if not YouWereHeardTriggered then
		return
	end

	LaunchHeardText(false)
	StartHeardTint()

	task.wait(0.5)
end

local function CancelYouWereHeard()
	if not YouWereHeardTriggered then
		return
	end

	YouWereHeardTriggered = false
	HeardChasing = false
	HeardTouched = false
	CloseDistanceStart = nil

	--// Tắt camera shake
	ShakeLoop = false

	--// Ngắt chase
	if HeardChaseConnection then
		HeardChaseConnection:Disconnect()
		HeardChaseConnection = nil
	end

	--// Hủy movement tween
	if ActiveMoveTween then
		ActiveMoveTween:Cancel()
		ActiveMoveTween = nil
	end

	--// Hủy color tween
	if HeardColorTween then
		HeardColorTween:Cancel()
		HeardColorTween = nil
	end

	--// Fade Boso PlaybackSpeed -> 0 rồi destroy
	if HeardBoso and HeardBoso.Parent then
		local Boso = HeardBoso

		local BosoTween = TweenService:Create(
			Boso,
			TweenInfo.new(
				0.5,
				Enum.EasingStyle.Sine,
				Enum.EasingDirection.Out
			),
			{
				PlaybackSpeed = 0
			}
		)

		BosoTween:Play()

		BosoTween.Completed:Connect(function()
			if Boso and Boso.Parent then
				Boso:Destroy()
			end

			if HeardBoso == Boso then
				HeardBoso = nil
			end
		end)
	else
		local Boso = workspace:FindFirstChild("Boso")

		if Boso and Boso:IsA("Sound") then
			local BosoTween = TweenService:Create(
				Boso,
				TweenInfo.new(
					0.5,
					Enum.EasingStyle.Sine,
					Enum.EasingDirection.Out
				),
				{
					PlaybackSpeed = 0
				}
			)

			BosoTween:Play()

			BosoTween.Completed:Connect(function()
				if Boso and Boso.Parent then
					Boso:Destroy()
				end
			end)
		end
	end

	HeardBoso = nil

	--// Hủy "You were heard."
	HeardTextToken += 1

	if HeardRenderConnection then
		HeardRenderConnection:Disconnect()
		HeardRenderConnection = nil
	end

	for _, Tween in ipairs(HeardTweens) do
		Tween:Cancel()
	end

	table.clear(HeardTweens)

	if HeardTextGui then
		HeardTextGui:Destroy()
		HeardTextGui = nil
		HeardText = nil
	end

	--// Heartbeat GUI hoạt động lại
	HeartbeatLocked = false
	HeartbeatHideToken += 1

	--// FollowConnection GỐC chạy lại
	FollowMoving = true

	--// Khôi phục màu
	if MainColorCorrection then
		TweenService:Create(
			MainColorCorrection,
			TweenInfo.new(
				0.5,
				Enum.EasingStyle.Sine,
				Enum.EasingDirection.Out
			),
			{
				Brightness = 0,
				Contrast = 0,
				Saturation = 0,
				TintColor = Color3.new(1, 1, 1)
			}
		):Play()
	end
end

task.spawn(function()
	while not SilenceShutdown
	and SilenceModel
	and SilenceModel.Parent do

		if YouWereHeardTriggered
			and HRP
			and HRP.Parent
			and EntityRoom
			and EntityRoom.Parent then

			local Inside =
				IsInsideRoom(
					EntityRoom,
					HRP.Position
				)

			if not Inside then
				CancelYouWereHeard()
			end
		end

		RunService.Heartbeat:Wait()
	end
end)

--//==================================================
--// Reverb Room Detection
--//==================================================

local LastReverbRoom = EntityRoom

local function GetRoomFromPosition(Position)
	for _, room in ipairs(CurrentRooms:GetChildren()) do
		if room:IsA("Model") and IsInsideRoom(room, Position) then
			return room
		end
	end

	return nil
end

local function UpdateEntityRoom()
	if not RushNew or not RushNew.Parent then
		return
	end

	local PlayerRoom = GetPlayerRoom()

	if not PlayerRoom then
		return
	end

	local EntityPositionRoom =
		GetRoomFromPosition(RushNew.Position)

	-- Entity đã teleport vào đúng room mà player đang đứng
	if EntityPositionRoom == PlayerRoom
		and EntityRoom ~= PlayerRoom then

		EntityRoom = PlayerRoom
		LastReverbRoom = PlayerRoom
	end
end

task.spawn(function()
	while SilenceModel
		and SilenceModel.Parent do

		UpdateEntityRoom()

		local Character = LocalPlayer.Character
		local HumanoidRootPart =
			Character and Character:FindFirstChild("HumanoidRootPart")

		if HumanoidRootPart
			and EntityRoom
			and EntityRoom.Parent then

			local Inside = IsInsideRoom(
				EntityRoom,
				HumanoidRootPart.Position
			)


--// Heartbeat GUI
if not HeartbeatLocked then
	if HeartbeatAllowed
		and HeartbeatGuiStarted then

		if Inside then
			if not HeartbeatScaleLoop then
				local Tween = TweenHeartbeatPosition(
					HeartbeatOriginalPosition
				)

				if Tween then
					Tween.Completed:Wait()
				end

				if HeartbeatAllowed
					and HeartbeatGuiStarted then

					StartHeartbeatLoop()
				end
			end
		else
			if HeartbeatScaleLoop then
				StopHeartbeatLoop()

				TweenHeartbeatPosition(
					HeartbeatStartPosition
				)
			end
		end
	end
end

		else
	if ReverbInside then
		ReverbInside = false
	end

	if HeartbeatGuiStarted and not HeartbeatLocked then
		HideHeartbeatGui()
	end
end

		RunService.Heartbeat:Wait()
	end
end)

task.spawn(function()
	local LastNearInside = false

	while SilenceModel
		and SilenceModel.Parent do

		local Character = LocalPlayer.Character
		local HumanoidRootPart =
			Character and Character:FindFirstChild("HumanoidRootPart")

		if HumanoidRootPart
			and EntityRoom
			and EntityRoom.Parent
			and Near
			and Near.Parent then

			local Inside = IsInsideRoom(
				EntityRoom,
				HumanoidRootPart.Position
			)

			if Inside ~= LastNearInside then
				LastNearInside = Inside

				if Inside then
					FadeNear(1)
				else
					FadeNear(0)
				end
			end
		end

		RunService.Heartbeat:Wait()
	end
end)

task.spawn(function()
	while SilenceModel
		and SilenceModel.Parent do

		local Character = LocalPlayer.Character
		local HumanoidRootPart =
			Character and Character:FindFirstChild("HumanoidRootPart")

		if HumanoidRootPart
			and EntityRoom
			and EntityRoom.Parent then

			local Inside = IsInsideRoom(
				EntityRoom,
				HumanoidRootPart.Position
			)

			if Inside ~= LastInside then
				LastInside = Inside

				if Inside then
					ShakeLoop = true
				else
					ShakeLoop = false
				end
			end
		else
			LastInside = false
			ShakeLoop = false
		end

		RunService.Heartbeat:Wait()
	end
end)

if not EntityRoom then
	warn("Silence: EntityRoom not found")
	return
end

--//==================================================
--// Floor
--//==================================================

local function GetFloor(room)
	if not room or not room.Parent then
		return nil
	end

	local Parts = room:FindFirstChild("Parts")
	local Floor = Parts and Parts:FindFirstChild("Floor")

	if Floor and Floor:IsA("BasePart") then
		return Floor
	end

	return nil
end

local Floor = GetFloor(EntityRoom)

if not Floor then
	warn("Silence: Floor not found")
	return
end

--//==================================================
--// Silence BoundingBox data
--//==================================================

local BBoxCF, BBoxSize = SilenceModel:GetBoundingBox()
local ModelPivot = SilenceModel:GetPivot()
local BBoxOffset = ModelPivot:ToObjectSpace(BBoxCF)

--//==================================================
--// Move model so BBox bottom is X studs above floor
--//==================================================

local function TeleportToFloor(room, Height)
	if not room or not room.Parent then
		return false
	end

	local FloorPart = GetFloor(room)

	if not FloorPart then
		return false
	end

	local FloorTop = FloorPart.Size.Y / 2

	local CurrentPivot = SilenceModel:GetPivot()
	local X, Y, Z = CurrentPivot:ToOrientation()

	local TargetBBoxCF =
		FloorPart.CFrame
		* CFrame.new(
			0,
			FloorTop + Height + BBoxSize.Y / 2,
			0
		)
		* CFrame.Angles(X, Y, Z)

	SilenceModel:PivotTo(
		TargetBBoxCF * BBoxOffset:Inverse()
	)

	return true
end

--// Spawn light
do
	local PointLight = Instance.new("PointLight")
	PointLight.Name = "SilenceSpawnLight"
	PointLight.Color = Color3.new(1, 1, 1)
	PointLight.Brightness = 3
	PointLight.Range = 15
	PointLight.Parent = RushNew

	TweenService:Create(
		PointLight,
		TweenInfo.new(
			1,
			Enum.EasingStyle.Sine,
			Enum.EasingDirection.Out
		),
		{
			Range = 0
		}
	):Play()
end

--//==================================================
--// Face1
--//==================================================

local Face1

do
	local Attachment2 = RushNew:FindFirstChild("Attachment2", true)

	if Attachment2 then
		Face1 = Attachment2:FindFirstChild("Face1", true)

		if Face1 then
			Face1.Enabled = false
		end
	end
end

--//==================================================
--// Initial Spawn Position
--//==================================================

do
	local FloorCF = Floor.CFrame
	local FloorTop = Floor.Size.Y / 2

	local StartCFrame = RushNew.CFrame
	local X, Y, Z = StartCFrame:ToOrientation()

local FirstCFrame =
		FloorCF
		* CFrame.new(
			0,
			FloorTop + 10,
			0
		)
		* CFrame.Angles(X, Y, Z)
		
		RushNew.CFrame = FirstCFrame

	local TargetCFrame =
		FloorCF
		* CFrame.new(
			0,
			FloorTop + 5,
			0
		)
		* CFrame.Angles(X, Y, Z)
		
		

	TweenService:Create(
		RushNew,
		TweenInfo.new(
			2,
			Enum.EasingStyle.Sine,
			Enum.EasingDirection.Out
		),
		{
			CFrame = TargetCFrame
		}
	):Play()
end

--//==================================================
--// Initial Effect
--//==================================================

PlayInitialGrain()

--//==================================================
--// ColorCorrection
--//==================================================



--//==================================================
--// Grain State
--//==================================================

local InRoom = false
local GrainLooping = false
local GrainTweenID = 0

local function TweenGrain(Value)
	GrainTweenID += 1

	local MyID = GrainTweenID
	local Tweens = {}

	for _, Image in pairs(GrainImages) do
		if Image and Image.Parent then
			local Tween = TweenService:Create(
				Image,
				TweenInfo.new(
					0.7,
					Enum.EasingStyle.Sine,
					Enum.EasingDirection.Out
				),
				{
					ImageTransparency = Value
				}
			)

			table.insert(Tweens, Tween)
			Tween:Play()
		end
	end

	if #Tweens > 0 then
		Tweens[1].Completed:Wait()
	end

	if MyID ~= GrainTweenID then
		return
	end

	if Value == 1 and not InRoom then
		GrainLooping = false

		for _, Image in pairs(GrainImages) do
			if Image and Image.Parent then
				Image.Visible = false
				Image.ImageTransparency = 1
			end
		end
	end
end

local function StartGrainLoop()
	if GrainLooping then
		return
	end

	GrainLooping = true

	task.spawn(function()
		while GrainLooping
			and InRoom
			and Gui
			and Gui.Parent
			and SilenceModel
			and SilenceModel.Parent do

			for number = 0, HighestNumber do
				if not GrainLooping or not InRoom then
					break
				end

				local Image = GrainImages[number]

				if Image and Image.Parent then
					Image.Visible = true
					Image.ImageTransparency = 0.9

					task.wait(0.01)

					if Image and Image.Parent then
						Image.Visible = false
					end
				end
			end

			task.wait()
		end
	end)
end

--//==================================================
--// Flash Lights
--//==================================================

local function FlashLights(room)
	if not room or not room.Parent then
		return
	end

	for _, obj in ipairs(room:GetDescendants()) do
		if obj:IsA("Light") then
			local OriginalBrightness = obj.Brightness

			obj.Brightness = 4

			TweenService:Create(
				obj,
				TweenInfo.new(
					1.5,
					Enum.EasingStyle.Linear,
					Enum.EasingDirection.Out
				),
				{
					Brightness = OriginalBrightness
				}
			):Play()
		end
	end
end

local CameraShaker = require(game.ReplicatedStorage:WaitForChild("CameraShaker"))
local camera = workspace.CurrentCamera

local spawnShake = CameraShaker.new(
	Enum.RenderPriority.Camera.Value,
	function(shakeCf)
		camera.CFrame = camera.CFrame * shakeCf
	end
)

spawnShake:Start()

task.spawn(function()
	while true do
		if ShakeLoop then
			spawnShake:ShakeOnce(
				40,
				math.random(3, 8) / 10,
				10,
				5,
				0,
				0.8
			)

			task.wait(10)
		else
			task.wait(0.1)
		end
	end
end)

--//==================================================
--// Room Effect
--//==================================================

local EffectRoom

local function ApplyRoomEffect(room)
	if not room or not room.Parent then
		return
	end

	EffectRoom = room
	InRoom = true

	local Goal = {
		Brightness = -0.02,
		Contrast = 0.08,
		Saturation = -0.65,
		TintColor = Color3.fromRGB(
			205,
			205,
			205
		)
	}

	TweenService:Create(
		MainColorCorrection,
		TweenInfo.new(
			0.7,
			Enum.EasingStyle.Sine,
			Enum.EasingDirection.Out
		),
		Goal
	):Play()

	task.spawn(function()
		TweenGrain(0.9)
	end)

	StartGrainLoop()
end

--//==================================================
--// Leave Room Effect
--//==================================================

local function ClearRoomEffect()
	if not InRoom then
		return
	end

	InRoom = false

	TweenService:Create(
		MainColorCorrection,
		TweenInfo.new(
			0.7,
			Enum.EasingStyle.Sine,
			Enum.EasingDirection.Out
		),
		{
			Brightness = 0,
			Contrast = 0,
			Saturation = 0,
			TintColor = Color3.new(1, 1, 1)
		}
	):Play()

	task.spawn(function()
		TweenGrain(1)
	end)
end

--//==================================================
--// Arrival Effect
--//==================================================

local EffectCycle = 0

local function PlayArrivalEffect(room)
	if not room or not room.Parent then
		return
	end
	
		--// Reset Heartbeat cho cycle mới
	HideHeartbeatGui()
	
	local PointLight = Instance.new("PointLight")
	PointLight.Name = "SilenceSpawnLight"
	PointLight.Color = Color3.new(1, 1, 1)
	PointLight.Brightness = 3
	PointLight.Range = 15
	PointLight.Parent = RushNew

local wee = TweenService:Create(
		PointLight,
		TweenInfo.new(
			2,
			Enum.EasingStyle.Sine,
			Enum.EasingDirection.Out
		),
		{
			Range = 0
		}
	)
	
	wee:Play() 
	
	task.spawn(function() 
	wee.Completed:Wait() 
	PointLight:Destroy() 
	end) 

	EffectCycle += 1

	local MyCycle = EffectCycle

	InRoom = false
	GrainLooping = false

	--// Face1 OFF
	if Face1 and Face1.Parent then
		Face1.Enabled = false
	end
	
	if blayes then
	blayes:Play() 
	end

	--// Play teleport sound again
	if blano and blano.Parent then
		blano:Stop()
		blano.TimePosition = 0
		blano:Play()
	end

	--// Flash lights immediately
	FlashLights(room)

	task.spawn(function()
	while MyCycle == EffectCycle
		and blano
		and blano.Parent
		and SilenceModel
		and SilenceModel.Parent do

		if blano.TimePosition >= 1.6 then
			break
		end

		task.wait(0.03)
	end

	if MyCycle ~= EffectCycle then
		return
	end

	if not blano or not blano.Parent then
		return
	end
	
	HeartbeatAllowed = true

	--// Start Near sound at 1.6s
RestartNear()

--// Heartbeat GUI
HeartbeatAllowed = true

task.spawn(function() 
task.wait(0.3)
ShowHeartbeatGui()
end)

--// Face1 ON
if Face1 and Face1.Parent then
	Face1.Enabled = true
end

--// Apply effect using new room BoundingBox
ApplyRoomEffect(room)
end)
end

--//==================================================
--// Initial Room Effect
--//==================================================

task.spawn(function()
	task.wait(1.6)

	if blano
		and blano.Parent
		and SilenceModel
		and SilenceModel.Parent then

		HeartbeatAllowed = true
		
		task.spawn(function() 
		task.wait(0.3)
		ShowHeartbeatGui()
		end)

		if Face1 and Face1.Parent then
			Face1.Enabled = true
		end

		ApplyRoomEffect(EntityRoom)
	end
end)

--//==================================================
--// Find RoomExit
--//==================================================

local function GetRoomExit(room)
	if not room or not room.Parent then
		return nil
	end

	local RoomExit = room:FindFirstChild("RoomExit", true)

	if RoomExit and RoomExit:IsA("BasePart") then
		return RoomExit
	end

	return nil
end

--//==================================================
--// Tween RushNew to HRP
--//==================================================

local function TweenToPlayer()
	if YouWereHeardTriggered then
		return nil
	end

	local Character = LocalPlayer.Character

	if not Character then
		return nil
	end

	local HumanoidRootPart =
		Character:FindFirstChild("HumanoidRootPart")

	if not HumanoidRootPart then
		return nil
	end

	if ActiveMoveTween then
		ActiveMoveTween:Cancel()
		ActiveMoveTween = nil
	end

	local Tween = TweenService:Create(
		RushNew,
		TweenInfo.new(
			7,
			Enum.EasingStyle.Sine,
			Enum.EasingDirection.InOut
		),
		{
			CFrame = HumanoidRootPart.CFrame
		}
	)

	ActiveMoveTween = Tween

	Tween.Completed:Connect(function()
		if ActiveMoveTween == Tween then
			ActiveMoveTween = nil
		end
	end)

	Tween:Play()

	return Tween
end

--//==================================================
--// YOU WERE HEARD DISTANCE DETECTOR
--//==================================================

task.spawn(function()
	while SilenceModel
		and SilenceModel.Parent
		and RushNew
		and RushNew.Parent do

		if YouWereHeardTriggered then
			break
		end

		if HRP and HRP.Parent then
			local Distance =
				(HRP.Position - RushNew.Position).Magnitude

			if Distance < 5 then
				if not CloseDistanceStart then
					CloseDistanceStart = os.clock()
				end

				if os.clock() - CloseDistanceStart >= 5 then
					PlayYouWereHeard()
					break
				end
			else
				CloseDistanceStart = nil
			end
		else
			CloseDistanceStart = nil
		end

		RunService.Heartbeat:Wait()
	end
end)

--//==================================================
--// Move To New Room
--//==================================================

local function MoveToNewRoom()
	if MovingRoom then
		return false
	end

	MovingRoom = true

	local OldRoom = EntityRoom

	if not OldRoom or not OldRoom.Parent then
		OldRoom = GetPlayerRoom()

		if not OldRoom then
			MovingRoom = false
			return false
		end

		EntityRoom = OldRoom
	end

	--// Pause room-follow tween state
	ClearRoomEffect()

	--// Wait before leaving room
	task.wait(math.random(2, 5))

	--// Find RoomExit
	local RoomExit = GetRoomExit(OldRoom)

	if RoomExit and RoomExit.Parent then
		local ExitTween = TweenService:Create(
			RushNew,
			TweenInfo.new(
				math.random(1, 4),
				Enum.EasingStyle.Sine,
				Enum.EasingDirection.InOut
			),
			{
				CFrame = RoomExit.CFrame
			}
		)

		ExitTween:Play()
		ExitTween.Completed:Wait()
	end

	--// Wait after reaching RoomExit
	task.wait(math.random(2, 4))

	--// Find player's current room
	local NewRoom = GetPlayerRoom()

	if not NewRoom then
		MovingRoom = false
		return false
	end

	--// Update entity room
EntityRoom = NewRoom
LastReverbRoom = NewRoom

local Character = LocalPlayer.Character
local HumanoidRootPart =
	Character and Character:FindFirstChild("HumanoidRootPart")

	--// Teleport entire entity to new room floor
	TeleportToFloor(NewRoom, 4)

	--// Check if player is still inside the new entity room
	local Character = LocalPlayer.Character
	local HumanoidRootPart =
		Character and Character:FindFirstChild("HumanoidRootPart")

	if HumanoidRootPart
		and IsInsideRoom(NewRoom, HumanoidRootPart.Position) then

		ShakeLoop = true
	else
		ShakeLoop = false
	end

	--// Play effects for the new room
	PlayArrivalEffect(NewRoom)

	--// Allow next room movement
	MovingRoom = false

	return true
end

task.spawn(function()
	while SilenceModel
		and SilenceModel.Parent do

		local Character = LocalPlayer.Character
		local HumanoidRootPart =
			Character and Character:FindFirstChild("HumanoidRootPart")

		if HumanoidRootPart
			and EntityRoom
			and EntityRoom.Parent then

			local Inside = IsInsideRoom(
				EntityRoom,
				HumanoidRootPart.Position
			)

			if Inside then
				ShakeLoop = true
			else
				ShakeLoop = false

				if not MovingRoom then
					task.spawn(function()
						MoveToNewRoom()
					end)
				end
			end
		else
			ShakeLoop = false
		end

		RunService.Heartbeat:Wait()
	end
end)

local LookStartTime = nil
local LookTriggered = false

task.spawn(function()
	while SilenceModel
		and SilenceModel.Parent
		and RushNew
		and RushNew.Parent do

		RunService.Heartbeat:Wait()

		if MovingRoom
			or YouWereHeardTriggered then

			LookStartTime = nil
			LookTriggered = false
			continue
		end

		local Character = LocalPlayer.Character
		local HumanoidRootPart =
			Character and Character:FindFirstChild("HumanoidRootPart")

		local Hum =
			Character and Character:FindFirstChildOfClass("Humanoid")

		if not HumanoidRootPart or not Hum then
			LookStartTime = nil
			LookTriggered = false
			continue
		end

		if not EntityRoom
			or not EntityRoom.Parent then

			EntityRoom = GetPlayerRoom()

			if not EntityRoom then
				LookStartTime = nil
				LookTriggered = false
				continue
			end
		end

		if not IsInsideRoom(
			EntityRoom,
			HumanoidRootPart.Position
		) then

			LookStartTime = nil
			LookTriggered = false
			continue
		end

		--// Nếu LookTween đang chạy mà player bắt đầu di chuyển
		if ActiveMoveTween
			and ActiveMoveTween.PlaybackState == Enum.PlaybackState.Playing then

			local IsCrouching =
				Character:GetAttribute("Crouching") == true

			local IsMoving =
				Hum.MoveDirection.Magnitude > 0

			if IsMoving and not IsCrouching then
				ActiveMoveTween:Cancel()
				ActiveMoveTween = nil

				LookStartTime = nil
				LookTriggered = false

				continue
			end
		end

		local ToEntity =
			RushNew.Position - HumanoidRootPart.Position

		if ToEntity.Magnitude <= 0.01 then
			LookStartTime = nil
			LookTriggered = false
			continue
		end

		local Direction =
			ToEntity.Unit

		local Dot =
			HumanoidRootPart.CFrame.LookVector:Dot(Direction)

		if Dot >= 0.8 then
			if not LookStartTime then
				LookStartTime = tick()
			end

			if not LookTriggered
				and tick() - LookStartTime >= 2 then

				LookTriggered = true

				if ActiveMoveTween then
					ActiveMoveTween:Cancel()
					ActiveMoveTween = nil
				end

				local MoveTween =
					TweenService:Create(
						RushNew,
						TweenInfo.new(
							7,
							Enum.EasingStyle.Sine,
							Enum.EasingDirection.InOut
						),
						{
							CFrame =
								HumanoidRootPart.CFrame
						}
					)

				ActiveMoveTween = MoveTween

				MoveTween:Play()

				MoveTween.Completed:Connect(function()
					if ActiveMoveTween == MoveTween then
						ActiveMoveTween = nil
					end
				end)
			end
		else
			LookStartTime = nil
			LookTriggered = false
		end
	end
end)

--//==================================================
--// SILENCE LIFETIME
--//==================================================

local function ShutdownSilence()
	if SilenceShutdown then
		return
	end

	SilenceShutdown = true

	--// Stop states
	YouWereHeardTriggered = false
	HeardChasing = false
	HeardTouched = false
	FollowMoving = false

	MovingRoom = true
	ShakeLoop = false

	HeartbeatLocked = true
	HeartbeatAllowed = false
	HeartbeatGuiStarted = false
	HeartbeatScaleLoop = false
	HeartbeatDistanceLoop = false

	InRoom = false
	GrainLooping = false

	--// Invalidate loops
	HeartbeatHideToken += 1
	HeardTextToken += 1
	GrainTweenID += 1
	EffectCycle += 1

	--// Cancel active tweens
	if ActiveMoveTween then
		ActiveMoveTween:Cancel()
		ActiveMoveTween = nil
	end

	if HeartbeatPositionTween then
		HeartbeatPositionTween:Cancel()
		HeartbeatPositionTween = nil
	end

	if HeartbeatScaleTween then
		HeartbeatScaleTween:Cancel()
		HeartbeatScaleTween = nil
	end

	if NearFadeTween then
		NearFadeTween:Cancel()
		NearFadeTween = nil
	end

	if HeardColorTween then
		HeardColorTween:Cancel()
		HeardColorTween = nil
	end

	--// Disconnect connections
	if FollowConnection then
		FollowConnection:Disconnect()
		FollowConnection = nil
	end

	if HeardChaseConnection then
		HeardChaseConnection:Disconnect()
		HeardChaseConnection = nil
	end

	if HeardRenderConnection then
		HeardRenderConnection:Disconnect()
		HeardRenderConnection = nil
	end

	if LatestRoomConnection then
		LatestRoomConnection:Disconnect()
		LatestRoomConnection = nil
	end

	--// Hide / destroy GUI
	if HideHeartbeatGui then
		pcall(HideHeartbeatGui)
	end

	if Gui and Gui.Parent then
		Gui:Destroy()
	end

	if HeartbeatGui and HeartbeatGui.Parent then
		HeartbeatGui:Destroy()
	end

	if HeardTextGui and HeardTextGui.Parent then
		HeardTextGui:Destroy()
	end

	HeardTextGui = nil
	HeardText = nil

	--// Destroy sounds created by Silence
	for _, Obj in ipairs({
		SCREAM,
		Teleport,
		NearYe,
		HeardBoso
	}) do
		if Obj and Obj.Parent then
			pcall(function()
				Obj:Stop()
				Obj:Destroy()
			end)
		end
	end

	SCREAM = nil
	Teleport = nil
	NearYe = nil
	HeardBoso = nil

	--// Reset CC
	if MainColorCorrection
		and MainColorCorrection.Parent then

		MainColorCorrection.Brightness = 0
		MainColorCorrection.Contrast = 0
		MainColorCorrection.Saturation = 0
		MainColorCorrection.TintColor =
			Color3.new(1, 1, 1)
	end

	--// Giữ entity lại 3 giây
	task.wait(3)

	if SilenceModel
		and SilenceModel.Parent then

		SilenceModel:Destroy()
	end
end

LatestRoomConnection =
	LatestRoom:GetPropertyChangedSignal("Value"):Connect(function()

		if SilenceShutdown then
			return
		end

		LatestRoomCount += 1

		if LatestRoomCount >= 5 then
			task.spawn(ShutdownSilence)
		end
	end)
	
	
