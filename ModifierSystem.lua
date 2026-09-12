local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LP = Players.LocalPlayer
local PlayerGui = LP:WaitForChild("PlayerGui")
local MainUI = PlayerGui:WaitForChild("MainUI")

local getasset = getcustomasset or getsynasset

if not getasset then
	return
end

local function LoadAsset(Url, FileName)
	local AssetFile = FileName

	local function TryLoad(File)
		if not isfile(File) then
			return nil
		end

		local Ok, Result = pcall(function()
			return game:GetObjects(getasset(File))
		end)

		if Ok and Result and #Result > 0 then
			return Result
		end

		return nil
	end

	local Objects = TryLoad(AssetFile)

	if Objects then
		return Objects
	end

	-- Không đè cache cũ.
	-- Nếu cache lỗi, tạo file dự phòng riêng.
	local BackupFile = "__safe_" .. FileName

	if not isfile(BackupFile) then
		local Ok, Data = pcall(function()
			return game:HttpGet(Url)
		end)

		if Ok and Data and #Data > 0 then
			pcall(function()
				writefile(BackupFile, Data)
			end)
		end
	end

	Objects = TryLoad(BackupFile)

	return Objects
end

local function GetGitSound(GithubSnd, SoundName)
	local File = SoundName .. ".mp3"

	if not isfile(File) then
		local Ok, Data = pcall(function()
			return game:HttpGet(GithubSnd)
		end)

		if Ok and Data then
			pcall(function()
				writefile(File, Data)
			end)
		end
	end

	if not isfile(File) then
		return nil
	end

	local Ok, Sound = pcall(function()
		local S = Instance.new("Sound")
		S.SoundId = getasset(File)
		return S
	end)

	if Ok then
		return Sound
	end

	return nil
end

local function FindFirstDescendant(Root, ClassName, Name)
	if not Root then
		return nil
	end

	for _, Object in ipairs(Root:GetDescendants()) do
		if (not ClassName or Object:IsA(ClassName))
			and (not Name or Object.Name == Name) then
			return Object
		end
	end

	return nil
end

local function FindGuiCandidate(Root)
	if not Root then
		return nil
	end

	local Candidates = {}

	if Root:IsA("GuiObject") then
		table.insert(Candidates, Root)
	end

	for _, Object in ipairs(Root:GetDescendants()) do
		if Object:IsA("GuiObject") then
			table.insert(Candidates, Object)
		end
	end

	local Best
	local BestScore = -1

	for _, Object in ipairs(Candidates) do
		local Score = 0

		if FindFirstDescendant(Object, nil, "Entry") then
			Score += 5
		end

		if FindFirstDescendant(Object, "TextBox", "Search") then
			Score += 5
		end

		if FindFirstDescendant(Object, "Frame", "Detail") then
			Score += 5
		end

		if FindFirstDescendant(Object, nil, "CloseButton") then
			Score += 2
		end

		if Score > BestScore then
			BestScore = Score
			Best = Object
		end
	end

	if BestScore > 0 then
		return Best
	end

	return nil
end

local function FindButton(Root)
	if not Root then
		return nil
	end

	if Root:IsA("TextButton") or Root:IsA("ImageButton") then
		return Root
	end

	for _, Object in ipairs(Root:GetDescendants()) do
		if Object:IsA("TextButton") or Object:IsA("ImageButton") then
			return Object
		end
	end

	return nil
end

----------------------------------------------------------------
-- BUTTON
----------------------------------------------------------------

local ButtonUrl =
	"https://raw.githubusercontent.com/lynguyen26031993-design/-u/refs/heads/main/Place_74871629393921_TextButton_ButtonCharms_1785943384.txt"

local ButtonFile =
	"Place_74871629393921_TextButton_ButtonCharms_1785943384.txt"

local ButtonObjects = LoadAsset(ButtonUrl, ButtonFile)

if not ButtonObjects then
	return
end

local ButtonModifiers

for _, Object in ipairs(ButtonObjects) do
	pcall(function()
		Object.Parent = MainUI
	end)

	local Button = FindButton(Object)

	if Button and not ButtonModifiers then
		ButtonModifiers = Button

		Button.Name = "ButtonModifiers"
		Button.Position = UDim2.new(
			0.0700000003,
			0,
			0.300000012,
			0
		)

		local Image = FindFirstDescendant(
			Button,
			"ImageLabel"
		)

		if Image then
			Image.Image = "rbxassetid://125464028645163"
			Image.ImageColor3 = Color3.fromRGB(255, 222, 189)
		end
	end
end

if not ButtonModifiers then
	return
end

----------------------------------------------------------------
-- SOUND
----------------------------------------------------------------

local Themebro = GetGitSound(
	"https://github.com/lynguyen26031993-design/-u/raw/refs/heads/main/marketplace%20making%202.mp3",
	"jcklppsokjcjjsnbsjfjd"
)

if not Themebro then
	return
end

local breaking3 = Instance.new("Sound")

breaking3.SoundId = Themebro.SoundId
breaking3.PlaybackSpeed = 1
breaking3.Parent = workspace
breaking3.Looped = true
breaking3.Name = "ThemeModifier"
breaking3.RollOffMaxDistance = 1000000000
breaking3.Volume = 2.5

local BreakingStarted = false
local BreakingOriginalVolume = breaking3.Volume

local RoomSound
local RoomSoundOriginalVolume

----------------------------------------------------------------
-- CONFIGS
----------------------------------------------------------------

local PrimeConfig = {
	CardDesc = "Still Ripper but drank 100 cans of Blue Monster",
	CardTitle = "Prime Ripper",

	TemplateColor = Color3.fromRGB(
		100,
		100,
		255
	),

	TextColor = Color3.fromRGB(
		77,
		154,
		255
	),

	CardAvatarVisible = false,

	CardMeta = "Added by Guestly (The Owner)",

	IconImage = "rbxassetid://136590378823025",

	NoBanner = false,

	BannerImg = "rbxassetid://136590378823025",

	EffectRowCount = 2,

	EffectRows = {
		[1] = {
			Name = "EffectRow",
			Text = "Custom entity: Prime Ripper"
		},

		[2] = {
			Name = "MoreChaoticEffect",
			Text = "More chaotic"
		}
	}
}

local Desist = {
	CardDesc = "Cease's Brother fr",
	CardTitle = "Desist",

	TemplateColor = Color3.fromRGB(
		255,
		115,
		0
	),

	TextColor = Color3.fromRGB(
		255,
		196,
		120
	),

	CardAvatarVisible = false,

	CardMeta = "Added by Guestly (The Owner)",

	IconImage = "rbxassetid://128419609980634",

	NoBanner = false,

	BannerImg = "rbxassetid://128419609980634",

	EffectRowCount = 2,

	EffectRows = {
		[1] = {
			Name = "EffectRow",
			Text = "Custom entity: Desist"
		},

		[2] = {
			Name = "MoreChaoticEffect",
			Text = "More chaotic"
		}
	}
}

local Configs = {
	{
		Name = "PrimeConfig",
		Config = PrimeConfig
	},

	{
		Name = "Desist",
		Config = Desist
	}
}

table.sort(Configs, function(a, b)
	return a.Name < b.Name
end)

----------------------------------------------------------------
-- MODIFIER UI
----------------------------------------------------------------

local ModifierUrl =
	"https://github.com/PAKKALCKKWKKJXIODKRBFHHAUJCJJJSNDJ/piuyqykpcbbejsjbxhdkkksiaokdjhhsjsjhh/raw/refs/heads/main/Place_6839171747_Frame_Modifirrssjj_1787887445.txt"

local ModifierFile =
	"Place_6839171747_Frame_Modifirrssjj_1787887445.txt"

local Objects = LoadAsset(
	ModifierUrl,
	ModifierFile
)

if not Objects then
	breaking3:Destroy()
	return
end

local ModifierUI

for _, Object in ipairs(Objects) do
	pcall(function()
		Object.Parent = MainUI
	end)

	if not ModifierUI then
		ModifierUI = FindGuiCandidate(Object)
	end
end

if not ModifierUI then
	breaking3:Destroy()
	return
end

ModifierUI.Name = "Modifierrsssss"
ModifierUI.Visible = false

----------------------------------------------------------------
-- MODIFIERS KS
----------------------------------------------------------------

local ModifierFile =
	"Place_6839171747_Frame_ModifiersKs_1788583482.txt"

local ModifierUrl =
	"https://github.com/PAKKALCKKWKKJXIODKRBFHHAUJCJJJSNDJ/HAXRHCHHCHCHJSJSLKKKJDPQOIJXHBS/raw/refs/heads/main/Place_6839171747_Frame_ModifiersKs_1788583482.txt"

local ModifierObjects = LoadAsset(
	ModifierUrl,
	ModifierFile
)

local ModifiersKs
local ModifierTemplate

if ModifierObjects then
	for _, Object in ipairs(ModifierObjects) do
		pcall(function()
			Object.Parent = MainUI
		end)

		if not ModifiersKs and Object:IsA("Frame") then
			ModifiersKs = Object
		end

		if not ModifiersKs then
			local Found = FindGuiCandidate(Object)

			if Found and Found:IsA("Frame") then
				ModifiersKs = Found
			end
		end
	end
end

if ModifiersKs then
	ModifiersKs.Visible = false

	ModifierTemplate =
		ModifiersKs:FindFirstChild(
			"Template",
			true
		)

	if ModifierTemplate
		and ModifierTemplate:IsA("TextButton") then

		ModifierTemplate.Visible = false
	end
end

----------------------------------------------------------------
-- STATES
----------------------------------------------------------------

local AddedModifiers = {}
local ModifierTemplates = {}

local OriginalTemplateUsed = false

local DetailOpened = false
local DetailTweening = false

local CurrentConfigData
local CurrentState

----------------------------------------------------------------
-- MODIFIERS KS UPDATE
----------------------------------------------------------------

local function UpdateModifiersKs()
	if not ModifiersKs then
		return
	end

	local Count = 0

	for _, State in pairs(AddedModifiers) do
		if State.Added then
			Count += 1
		end
	end

	ModifiersKs.Visible = Count > 0

	local Desc = ModifiersKs:FindFirstChild(
		"Desc",
		true
	)

	if Desc and Desc:IsA("TextLabel") then
		Desc.Text =
			tostring(Count)
			.. " MODIFIERS ACTIVATED"
	end
end

----------------------------------------------------------------
-- SETUP ENTRY
----------------------------------------------------------------

local function SetupEntry(
	RootObject,
	Entry,
	ConfigData
)

	local Config = ConfigData.Config

	local State = {
		Added = false,
		Template = nil,
		Entry = Entry
	}

	AddedModifiers[
		ConfigData.Name
	] = State

	Entry.Visible = true

	local CardDesc =
		Entry:FindFirstChild(
			"CardDesc",
			true
		)

	if CardDesc and CardDesc:IsA("TextLabel") then
		CardDesc.Text =
			Config.CardDesc or ""
	end

	local CardTitle =
		Entry:FindFirstChild(
			"CardTitle",
			true
		)

	if CardTitle and CardTitle:IsA("TextLabel") then
		CardTitle.Text =
			Config.CardTitle or ""
	end

	local BonusRow =
		Entry:FindFirstChild(
			"BonusRow",
			true
		)

	if BonusRow and BonusRow:IsA("GuiObject") then
		BonusRow.Visible = false
	end

	local CardAvatar =
		Entry:FindFirstChild(
			"CardAvatar",
			true
		)

	if CardAvatar
		and CardAvatar:IsA("ImageLabel") then

		CardAvatar.Visible =
			Config.CardAvatarVisible == true
	end

	local CardMeta =
		Entry:FindFirstChild(
			"CardMeta",
			true
		)

	if CardMeta and CardMeta:IsA("TextLabel") then
		CardMeta.Text =
			Config.CardMeta or ""
	end

	local IconHolder =
		Entry:FindFirstChild(
			"IconHolder",
			true
		)

	local Icon =
		IconHolder
		and IconHolder:FindFirstChild(
			"Icon",
			true
		)

	if Icon and Icon:IsA("ImageLabel") then
		Icon.Image =
			Config.IconImage or ""
	end

	local Banner =
		Entry:FindFirstChild(
			"Banner",
			true
		)

	if Banner
		and Banner:IsA("Frame")
		and not Config.NoBanner then

		local BannerImg =
			Banner:FindFirstChild(
				"BannerImg",
				true
			)

		if BannerImg
			and BannerImg:IsA("ImageLabel") then

			BannerImg.Image =
				Config.BannerImg or ""

			BannerImg.ImageTransparency = 0
		end

		local Fill =
			Banner:FindFirstChild(
				"Fill",
				true
			)

		if Fill and Fill:IsA("Frame") then
			Fill.Visible = false
		end
	end

	Entry.MouseButton1Click:Connect(function()

		if DetailTweening then
			return
		end

		CurrentConfigData = ConfigData
		CurrentState = State

		local Detail =
			RootObject:FindFirstChild(
				"Detail",
				true
			)

		if not Detail
			or not Detail:IsA("Frame") then

			return
		end

		DetailTweening = true

		local DDesc =
			Detail:FindFirstChild(
				"DDesc",
				true
			)

		if DDesc and DDesc:IsA("TextLabel") then
			DDesc.Text =
				Config.CardDesc or ""
		end

		local DTitle =
			Detail:FindFirstChild(
				"DTitle",
				true
			)

		if DTitle and DTitle:IsA("TextLabel") then
			DTitle.Text =
				Config.CardTitle or ""
		end

		local DMeta =
			Detail:FindFirstChild(
				"DMeta",
				true
			)

		if DMeta and DMeta:IsA("TextLabel") then
			DMeta.Text =
				Config.CardMeta or ""
		end

		--------------------------------------------------------
		-- EFFECTS
		--------------------------------------------------------

		local Effects =
			Detail:FindFirstChild(
				"Effects",
				true
			)

		if Effects and Effects:IsA("GuiObject") then

			local EffectRow

			for _, Child in ipairs(
				Effects:GetDescendants()
			) do

				if Child:GetAttribute(
					"EffectRowOriginal"
				) then

					EffectRow = Child
					break
				end
			end

			if not EffectRow then

				EffectRow =
					Effects:FindFirstChild(
						"EffectRow",
						true
					)

				if EffectRow
					and EffectRow:IsA("TextLabel") then

					EffectRow:SetAttribute(
						"EffectRowOriginal",
						true
					)
				end
			end

			for _, Child in ipairs(
				Effects:GetDescendants()
			) do

				if Child:GetAttribute(
					"EffectRowClone"
				) then

					Child:Destroy()
				end
			end

			if EffectRow
				and EffectRow:IsA("TextLabel") then

				local Count = math.max(
					1,
					tonumber(
						Config.EffectRowCount
					) or 1
				)

				for i = 1, Count do

					local RowConfig =
						Config.EffectRows
						and Config.EffectRows[i]

					if i == 1 then

						EffectRow.Visible = true

						if RowConfig then

							EffectRow.Name =
								RowConfig.Name
								or "EffectRow"

							EffectRow.Text =
								RowConfig.Text
								or ""
						end

					else

						local NewEffectRow =
							EffectRow:Clone()

						NewEffectRow.Name =
							RowConfig
							and RowConfig.Name
							or ("EffectRow" .. i)

						NewEffectRow:SetAttribute(
							"EffectRowClone",
							true
						)

						NewEffectRow.Visible = true

						if RowConfig then
							NewEffectRow.Text =
								RowConfig.Text
								or ""
						end

						NewEffectRow.Parent =
							EffectRow.Parent
					end
				end
			end
		end

		--------------------------------------------------------
		-- ICON
		--------------------------------------------------------

		local DIconHolder =
			Detail:FindFirstChild(
				"DIconHolder",
				true
			)

		local DIcon =
			DIconHolder
			and DIconHolder:FindFirstChild(
				"DIcon",
				true
			)

		if DIcon
			and DIcon:IsA("ImageLabel")
			and Icon
			and Icon:IsA("ImageLabel") then

			DIcon.Image =
				Icon.Image
		end

		--------------------------------------------------------
		-- BANNER
		--------------------------------------------------------

		local DBanner =
			Detail:FindFirstChild(
				"DBanner",
				true
			)

		if DBanner
			and DBanner:IsA("Frame")
			and Banner
			and Banner:IsA("Frame") then

			local DBannerImg =
				DBanner:FindFirstChild(
					"BannerImg",
					true
				)

			local BannerImg =
				Banner:FindFirstChild(
					"BannerImg",
					true
				)

			if DBannerImg
				and DBannerImg:IsA("ImageLabel")
				and BannerImg
				and BannerImg:IsA("ImageLabel") then

				DBannerImg.Image =
					BannerImg.Image

				DBannerImg.ImageTransparency =
					BannerImg.ImageTransparency
			end

			local DFill =
				DBanner:FindFirstChild(
					"Fill",
					true
				)

			local Fill =
				Banner:FindFirstChild(
					"Fill",
					true
				)

			if DFill
				and DFill:IsA("Frame")
				and Fill
				and Fill:IsA("Frame") then

				DFill.Visible =
					Fill.Visible
			end
		end

		--------------------------------------------------------
		-- ACTIONS
		--------------------------------------------------------

		local DActions =
			Detail:FindFirstChild(
				"DActions",
				true
			)

		if DActions
			and DActions:IsA("Frame") then

			local EditMod =
				DActions:FindFirstChild(
					"EditMod",
					true
				)

			if EditMod
				and EditMod:IsA("TextButton") then

				EditMod.Visible = false
			end

			local Favorite =
				DActions:FindFirstChild(
					"Favorite",
					true
				)

			if Favorite
				and Favorite:IsA("TextButton") then

				Favorite.Visible = false
			end

			local AddToAccount =
				DActions:FindFirstChild(
					"AddToAccount",
					true
				)

			if AddToAccount
				and AddToAccount:IsA("TextButton") then

				AddToAccount.Text =
					State.Added
					and "UNADD"
					or "ADD TO GAMEPLAY"

				if not AddToAccount:GetAttribute(
					"ModifierConnected"
				) then

					AddToAccount:SetAttribute(
						"ModifierConnected",
						true
					)

					AddToAccount.MouseButton1Click:Connect(
						function()

							if not CurrentConfigData
								or not CurrentState then

								return
							end

							local CurrentConfig =
								CurrentConfigData.Config

							local CurrentState2 =
								CurrentState

							if CurrentState2.Added then

								CurrentState2.Added =
									false

								AddToAccount.Text =
									"ADD TO GAMEPLAY"

								getgenv()[
									CurrentConfigData.Name
								] = nil

								local OldTemplate =
									CurrentState2.Template

								if OldTemplate then

									if OldTemplate ==
										ModifierTemplate then

										OldTemplate.Visible =
											false

									else

										if OldTemplate.Parent then
											OldTemplate:Destroy()
										end
									end
								end

								CurrentState2.Template =
									nil

								ModifierTemplates[
									CurrentConfigData.Name
								] = nil

							else

								CurrentState2.Added =
									true

								getgenv()[
									CurrentConfigData.Name
								] = true

								AddToAccount.Text =
									"UNADD"

								if ModifierTemplate then

									local NewTemplate

									if not OriginalTemplateUsed then

										NewTemplate =
											ModifierTemplate

										OriginalTemplateUsed =
											true

									else

										NewTemplate =
											ModifierTemplate:Clone()

										NewTemplate.Parent =
											ModifierTemplate.Parent
									end

									NewTemplate.Visible =
										true

									if NewTemplate:IsA(
										"TextButton"
									) then

										NewTemplate.Text =
											CurrentConfig.CardTitle
											or ""

										if CurrentConfig.TextColor then
											NewTemplate.TextColor3 =
												CurrentConfig.TextColor
										end
									end

									if CurrentConfig.TemplateColor then
										NewTemplate.BackgroundColor3 =
											CurrentConfig.TemplateColor
									end

									CurrentState2.Template =
										NewTemplate

									ModifierTemplates[
										CurrentConfigData.Name
									] =
										NewTemplate
								end
							end

							UpdateModifiersKs()
						end
					)
				end
			end

			local CloseDetail =
				DActions:FindFirstChild(
					"CloseDetail",
					true
				)

			if CloseDetail
				and (
					CloseDetail:IsA("TextButton")
					or CloseDetail:IsA("ImageButton")
				)
				and not CloseDetail:GetAttribute(
					"Connected"
				) then

				CloseDetail:SetAttribute(
					"Connected",
					true
				)

				CloseDetail.MouseButton1Click:Connect(
					function()

						Detail.Visible =
							false

						DetailOpened =
							false

						DetailTweening =
							false
					end
				)
			end
		end

		--------------------------------------------------------
		-- HIDE UNUSED UI
		--------------------------------------------------------

		for _, Name in ipairs({
			"AvgStars",
			"BonusRow",
			"Stars",
			"DRev",
			"RateHead"
		}) do

			local Item =
				Detail:FindFirstChild(
					Name,
					true
				)

			if Item and Item:IsA("GuiObject") then
				Item.Visible = false
			end
		end

		--------------------------------------------------------
		-- DETAIL TWEEN
		--------------------------------------------------------

		local OriginalPosition =
			Detail.Position

		Detail.Position = UDim2.new(
			OriginalPosition.X.Scale,
			OriginalPosition.X.Offset,
			OriginalPosition.Y.Scale,
			OriginalPosition.Y.Offset + 20
		)

		Detail.Visible = true

		local Tween = TweenService:Create(
			Detail,

			TweenInfo.new(
				0.7,
				Enum.EasingStyle.Quint,
				Enum.EasingDirection.Out
			),

			{
				Position = OriginalPosition
			}
		)

		Tween:Play()

		DetailTweening = false
		DetailOpened = true
	end)
end

----------------------------------------------------------------
-- FIND + CREATE ENTRIES
----------------------------------------------------------------

for _, RootObject in ipairs(Objects) do

	local Template

	for _, Object in ipairs(
		RootObject:GetDescendants()
	) do

		if (
			Object:IsA("TextButton")
			or Object:IsA("ImageButton")
		)
			and Object.Name == "Entry" then

			Template = Object
			break
		end
	end

	if Template and #Configs > 0 then

		local Parent =
			Template.Parent

		for _, Object in ipairs(
			RootObject:GetDescendants()
		) do

			if Object ~= Template
				and (
					Object:IsA("TextButton")
					or Object:IsA("ImageButton")
				)
				and Object.Name == "Entry" then

				Object:Destroy()
			end
		end

		for i, ConfigData in ipairs(Configs) do

			local Entry

			if i == 1 then

				Entry = Template

			else

				Entry = Template:Clone()
				Entry.Parent = Parent
			end

			Entry.Name = "Entry"

			SetupEntry(
				RootObject,
				Entry,
				ConfigData
			)
		end
	end
end

----------------------------------------------------------------
-- SEARCH
----------------------------------------------------------------

local SearchBox

for _, Descendant in ipairs(
	ModifierUI:GetDescendants()
) do

	if Descendant.Name == "Search"
		and Descendant:IsA("TextBox") then

		SearchBox = Descendant
		break
	end
end

if SearchBox then

	SearchBox:GetPropertyChangedSignal(
		"Text"
	):Connect(function()

		local SearchText =
			SearchBox.Text:lower()

		for _, ConfigData in ipairs(Configs) do

			local Config =
				ConfigData.Config

			local State =
				AddedModifiers[
					ConfigData.Name
				]

			if State and State.Entry then

				local CardTitle =
					tostring(
						Config.CardTitle or ""
					):lower()

				local Match =
					SearchText == ""
					or string.find(
						CardTitle,
						SearchText,
						1,
						true
					) ~= nil

				State.Entry.Visible =
					Match
			end
		end
	end)
end

----------------------------------------------------------------
-- CLOSE + BUTTON OPEN
----------------------------------------------------------------

local OldMouseBehavior = UserInputService.MouseBehavior

local function CloseModifierUI()
	if not ModifierUI or not ModifierUI.Parent then
		return
	end

	ModifierUI.Visible = false

	if ButtonModifiers and ButtonModifiers.Parent then
		ButtonModifiers.Interactable = true
	end

	if BreakingStarted then
		breaking3.Volume = 0

		if RoomSound and RoomSound.Parent then
			RoomSound.Volume = RoomSoundOriginalVolume or 0
		end
	end
end

local function OpenModifierUI()
	if not ModifierUI or not ModifierUI.Parent then
		return
	end

	if BreakingStarted then
		if breaking3 and breaking3.Parent then
			breaking3.Volume = BreakingOriginalVolume
			if not breaking3.IsPlaying then
				breaking3:Play()
			end
		end

		if RoomSound and RoomSound.Parent then
			RoomSound.Volume = 0
		end
	else
		BreakingStarted = true

		if breaking3 and breaking3.Parent then
			breaking3.Volume = BreakingOriginalVolume
			breaking3:Play()
		end

		local RoomBoundingCenter =
			workspace:FindFirstChild("RoomBoundingCenter")

		if RoomBoundingCenter then
			RoomSound =
				RoomBoundingCenter:FindFirstChildWhichIsA("Sound")

			if RoomSound then
				RoomSoundOriginalVolume = RoomSound.Volume
				RoomSound.Volume = 0
			end
		end
	end

	OldMouseBehavior = UserInputService.MouseBehavior
	UserInputService.MouseBehavior =
		Enum.MouseBehavior.Default

	ModifierUI.Visible = true

	if ButtonModifiers and ButtonModifiers.Parent then
		ButtonModifiers.Interactable = false
	end
end

----------------------------------------------------------------
-- CLOSE BUTTONS
----------------------------------------------------------------

for _, RootObject in ipairs(Objects) do
	for _, Descendant in ipairs(RootObject:GetDescendants()) do
		if Descendant.Name == "CloseButton"
			and (
				Descendant:IsA("TextButton")
				or Descendant:IsA("ImageButton")
			)
			and not Descendant:GetAttribute("Connected") then

			Descendant:SetAttribute("Connected", true)

			Descendant.MouseButton1Click:Connect(function()
				CloseModifierUI()
			end)
		end
	end
end

----------------------------------------------------------------
-- VISIBLE STATE
----------------------------------------------------------------

ModifierUI:GetPropertyChangedSignal("Visible"):Connect(function()
	if not ModifierUI or not ModifierUI.Parent then
		return
	end

	if ModifierUI.Visible then
		OldMouseBehavior = UserInputService.MouseBehavior
		UserInputService.MouseBehavior =
			Enum.MouseBehavior.Default

		if BreakingStarted then
			breaking3.Volume = BreakingOriginalVolume

			if RoomSound and RoomSound.Parent then
				RoomSound.Volume = 0
			end
		end

		if ButtonModifiers and ButtonModifiers.Parent then
			ButtonModifiers.Interactable = false
		end
	else
		UserInputService.MouseBehavior = OldMouseBehavior

		if BreakingStarted then
			breaking3.Volume = 0

			if RoomSound and RoomSound.Parent then
				RoomSound.Volume =
					RoomSoundOriginalVolume or 0
			end
		end

		if ButtonModifiers and ButtonModifiers.Parent then
			ButtonModifiers.Interactable = true
		end
	end
end)

----------------------------------------------------------------
-- BUTTON OPEN
----------------------------------------------------------------

ButtonModifiers.Interactable = true

ButtonModifiers.MouseButton1Click:Connect(function()
	if not ModifierUI
		or not ModifierUI.Parent then
		return
	end

	if ModifierUI.Visible then
		return
	end

	OpenModifierUI()
end)

----------------------------------------------------------------
-- FADE
----------------------------------------------------------------

local function FadeGui(
	Object,
	Duration
)

	if not Object
		or not Object.Parent then

		return
	end

	local function SafeTween(
		Instance,
		Properties
	)

		pcall(function()

			local Tween =
				TweenService:Create(
					Instance,

					TweenInfo.new(
						Duration,
						Enum.EasingStyle.Quad,
						Enum.EasingDirection.Out
					),

					Properties
				)

			Tween:Play()
		end)
	end

	if Object:IsA("GuiObject") then

		SafeTween(
			Object,
			{
				BackgroundTransparency = 1
			}
		)

		if Object:IsA("TextLabel")
			or Object:IsA("TextButton")
			or Object:IsA("TextBox") then

			SafeTween(
				Object,
				{
					TextTransparency = 1,
					TextStrokeTransparency = 1
				}
			)
		end

		if Object:IsA("ImageLabel")
			or Object:IsA("ImageButton") then

			SafeTween(
				Object,
				{
					ImageTransparency = 1
				}
			)
		end

		if Object:IsA("ScrollingFrame") then

			SafeTween(
				Object,
				{
					ScrollBarImageTransparency = 1
				}
			)
		end
	end

	if Object:IsA("UIStroke") then

		SafeTween(
			Object,
			{
				Transparency = 1
			}
		)
	end

	if Object:IsA("CanvasGroup") then

		SafeTween(
			Object,
			{
				GroupTransparency = 1
			}
		)
	end

	for _, Descendant in ipairs(
		Object:GetDescendants()
	) do

		if Descendant:IsA("GuiObject") then

			SafeTween(
				Descendant,
				{
					BackgroundTransparency = 1
				}
			)

			if Descendant:IsA("TextLabel")
				or Descendant:IsA("TextButton")
				or Descendant:IsA("TextBox") then

				SafeTween(
					Descendant,
					{
						TextTransparency = 1,
						TextStrokeTransparency = 1
					}
				)
			end

			if Descendant:IsA("ImageLabel")
				or Descendant:IsA("ImageButton") then

				SafeTween(
					Descendant,
					{
						ImageTransparency = 1
					}
				)
			end

			if Descendant:IsA("ScrollingFrame") then

				SafeTween(
					Descendant,
					{
						ScrollBarImageTransparency = 1
					}
				)
			end
		end

		if Descendant:IsA("UIStroke") then

			SafeTween(
				Descendant,
				{
					Transparency = 1
				}
			)
		end

		if Descendant:IsA("CanvasGroup") then

			SafeTween(
				Descendant,
				{
					GroupTransparency = 1
				}
			)
		end
	end

	task.wait(Duration)
end

local function FadeAndDestroy(Object)

	if not Object
		or not Object.Parent then

		return
	end

	if Object.Name == "Modifierrsssss"
		and ModifiersKs
		and ModifiersKs:IsDescendantOf(Object) then

		FadeGui(
			ModifiersKs,
			3
		)

	else

		FadeGui(
			Object,
			3
		)
	end

	if Object.Parent then
		Object:Destroy()
	end
end

----------------------------------------------------------------
-- GAME START / CLEANUP
----------------------------------------------------------------

local LatestRoom

pcall(function()

	LatestRoom =
		game.ReplicatedStorage
		.GameData
		.LatestRoom

end)

if LatestRoom then
	LatestRoom.Changed:Wait()

	task.wait(0.1)

	-- Chờ trước khi bắt đầu hiệu ứng kết thúc
	task.wait(1.5)

	-- Destroy ModifierUI + ButtonCharms NGAY khi ModifiersKs chuẩn bị fade
	if ModifierUI and ModifierUI.Parent then
		pcall(function()
			ModifierUI:Destroy()
		end)
	end
	ModifierUI = nil

	if ButtonModifiers and ButtonModifiers.Parent then
		pcall(function()
			ButtonModifiers:Destroy()
		end)
	end
	ButtonModifiers = nil

	-- Chỉ ModifiersKs được fade
	if ModifiersKs and ModifiersKs.Parent then
		FadeAndDestroy(ModifiersKs)
	end

	ModifiersKs = nil
end

pcall(function()
	UserInputService.MouseBehavior =
		Enum.MouseBehavior.LockCenter
end)

pcall(function()
	breaking3:Destroy()
end)

pcall(function()
	Themebro:Destroy()
end)
