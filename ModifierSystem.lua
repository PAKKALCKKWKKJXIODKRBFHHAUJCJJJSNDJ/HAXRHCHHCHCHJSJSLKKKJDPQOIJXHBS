local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LP = Players.LocalPlayer
local MainUI = LP:WaitForChild("PlayerGui"):WaitForChild("MainUI")

local Url = "https://raw.githubusercontent.com/lynguyen26031993-design/-u/refs/heads/main/Place_74871629393921_TextButton_ButtonCharms_1785943384.txt"
local FileName = "Place_74871629393921_TextButton_ButtonCharms_1785943384.txt"

if not isfile(FileName) then
writefile(FileName, game:HttpGet(Url))
end

local function GetGitSound(GithubSnd, SoundName)
					local url = GithubSnd
					if not isfile(SoundName .. ".mp3") then
						writefile(SoundName .. ".mp3", game:HttpGet(url))
					end
					local sound = Instance.new("Sound")
					sound.SoundId = (getcustomasset or getsynasset)(SoundName .. ".mp3")
					return sound
				end
				
				local Themebro = GetGitSound(
	"https://github.com/lynguyen26031993-design/-u/raw/refs/heads/main/marketplace%20making%202.mp3",
	"jcklppsokjcjjsnbsjfjd"
)

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

local ButtonObjects = game:GetObjects(getcustomasset(FileName))

local ButtonModifiers

for _, Object in ipairs(ButtonObjects) do
Object.Parent = MainUI
Object.Name = "ButtonModifiers"

if Object:IsA("TextButton") then  
	ButtonModifiers = Object  

	Object.Position = UDim2.new(  
		0.0700000003, 0,  
		0.300000012, 0  
	)  

	local Image = Object:FindFirstChildWhichIsA("ImageLabel", true)  

	if Image then  
		Image.Image = "rbxassetid://125464028645163"  
		Image.ImageColor3 = Color3.fromRGB(255, 222, 189)  
	end  
end

end

local PrimeConfig = {
    CardDesc = "Still Ripper but drank 100 cans of Blue Monster",
    CardTitle = "Prime Ripper",
    TemplateColor = Color3.fromRGB(100, 100, 255),
    TextColor = Color3.fromRGB(77,154,255),
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
    TemplateColor = Color3.fromRGB(255,115,0),
    TextColor = Color3.fromRGB(255,196,120),
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

local Url = "https://github.com/PAKKALCKKWKKJXIODKRBFHHAUJCJJJSNDJ/piuyqykpcbbejsjbxhdkkksiaokdjhhsjsjhh/raw/refs/heads/main/Place_6839171747_Frame_Modifirrssjj_1787887445.txt"
local FileName = "Place_6839171747_Frame_Modifirrssjj_1787887445.txt"

if not isfile(FileName) then
writefile(FileName, game:HttpGet(Url))
end

local Objects = game:GetObjects(getcustomasset(FileName))

local ModifierUI

for _, Object in ipairs(Objects) do
Object.Parent = MainUI

if Object:IsA("GuiObject") then  
	Object.Name = "Modifierrsssss"  
	Object.Visible = false  
	ModifierUI = Object  
end

end


if ButtonModifiers and ModifierUI then
	ButtonModifiers.Interactable = true
	
	local OldMouseBehavior = UserInputService.MouseBehavior

ModifierUI:GetPropertyChangedSignal("Visible"):Connect(function()
	if ModifierUI.Visible then
		OldMouseBehavior = UserInputService.MouseBehavior
		UserInputService.MouseBehavior = Enum.MouseBehavior.Default
	else
		UserInputService.MouseBehavior = OldMouseBehavior
	end
end)

	ModifierUI:GetPropertyChangedSignal("Visible"):Connect(function()
		if not BreakingStarted then
			return
		end

		if ModifierUI.Visible then
			breaking3.Volume = BreakingOriginalVolume

			if RoomSound then
				RoomSound.Volume = 0
			end
		else
			breaking3.Volume = 0

			if RoomSound then
				RoomSound.Volume = RoomSoundOriginalVolume
			end
		end
	end)

	ButtonModifiers.MouseButton1Click:Connect(function()
		if not BreakingStarted then
			BreakingStarted = true

			breaking3.Volume = BreakingOriginalVolume
			breaking3:Play()

			local RoomBoundingCenter = workspace:FindFirstChild("RoomBoundingCenter")

			if RoomBoundingCenter then
				RoomSound = RoomBoundingCenter:FindFirstChildWhichIsA("Sound")

				if RoomSound then
					RoomSoundOriginalVolume = RoomSound.Volume
					RoomSound.Volume = 0
				end
			end
		end

		ButtonModifiers.Interactable = false
		ModifierUI.Visible = true
	end)

	for _, Descendant in ipairs(ModifierUI:GetDescendants()) do
		if Descendant.Name == "CloseButton"
			and (Descendant:IsA("TextButton") or Descendant:IsA("ImageButton")) then

			Descendant.MouseButton1Click:Connect(function()
				ModifierUI.Visible = false
				ButtonModifiers.Interactable = true
			end)

			break
		end
	end
end

local ModifierFile = "Place_6839171747_Frame_ModifiersKs_1788583482.txt"
local ModifierUrl = "https://github.com/PAKKALCKKWKKJXIODKRBFHHAUJCJJJSNDJ/HAXRHCHHCHCHJSJSLKKKJDPQOIJXHBS/raw/refs/heads/main/Place_6839171747_Frame_ModifiersKs_1788583482.txt"

if not isfile(ModifierFile) then
writefile(ModifierFile, game:HttpGet(ModifierUrl))
end

local ModifierObjects = game:GetObjects(getcustomasset(ModifierFile))

local ModifiersKs
local ModifierTemplate

for _, Object in ipairs(ModifierObjects) do
Object.Parent = MainUI

if Object:IsA("Frame") and not ModifiersKs then  
	ModifiersKs = Object  
end

end

if ModifiersKs then
ModifiersKs.Visible = false

ModifierTemplate = ModifiersKs:FindFirstChild("Template", true)  

if ModifierTemplate and ModifierTemplate:IsA("TextButton") then  
	ModifierTemplate.Visible = false  
end

end

table.sort(Configs, function(a, b)
	return a.Name < b.Name
end)

for _, RootObject in ipairs(Objects) do
for _, Descendant in ipairs(RootObject:GetDescendants()) do
if Descendant.Name == "CloseButton"
and (Descendant:IsA("TextButton") or Descendant:IsA("ImageButton"))
and not Descendant:GetAttribute("Connected") then

Descendant:SetAttribute("Connected", true)  

		Descendant.MouseButton1Click:Connect(function()  
			if RootObject:IsA("GuiObject") then  
				RootObject.Visible = false  
			end  
		end)  
	end  
end

end

local AddedModifiers = {}
local ModifierTemplates = {}
local OriginalTemplateUsed = false

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

local Desc = ModifiersKs:FindFirstChild("Desc", true)  

if Desc and Desc:IsA("TextLabel") then  
	Desc.Text = tostring(Count) .. " MODIFIERS ACTIVATED"  
end

end

UpdateModifiersKs()

local DetailOpened = false
local DetailTweening = false

local CurrentConfigData
local CurrentState

local function SetupEntry(RootObject, Entry, ConfigData)
local Config = ConfigData.Config

local State = {  
Added = false,  
Template = nil,  
Entry = Entry

}

AddedModifiers[ConfigData.Name] = State  

Entry.Visible = true  

local CardDesc = Entry:FindFirstChild("CardDesc", true)  

if CardDesc and CardDesc:IsA("TextLabel") then  
	CardDesc.Text = Config.CardDesc or ""  
end  

local CardTitle = Entry:FindFirstChild("CardTitle", true)  

if CardTitle and CardTitle:IsA("TextLabel") then  
	CardTitle.Text = Config.CardTitle or ""  
end  

local BonusRow = Entry:FindFirstChild("BonusRow", true)  

if BonusRow and BonusRow:IsA("GuiObject") then  
	BonusRow.Visible = false  
end  

local CardAvatar = Entry:FindFirstChild("CardAvatar", true)  

if CardAvatar and CardAvatar:IsA("ImageLabel") then  
	CardAvatar.Visible = Config.CardAvatarVisible == true  
end  

local CardMeta = Entry:FindFirstChild("CardMeta", true)  

if CardMeta and CardMeta:IsA("TextLabel") then  
	CardMeta.Text = Config.CardMeta or ""  
end  

local IconHolder = Entry:FindFirstChild("IconHolder", true)  
local Icon = IconHolder and IconHolder:FindFirstChild("Icon", true)  

if Icon and Icon:IsA("ImageLabel") then  
	Icon.Image = Config.IconImage or ""  
end  

local Banner = Entry:FindFirstChild("Banner", true)  

if Banner and Banner:IsA("Frame") and not Config.NoBanner then  
	local BannerImg = Banner:FindFirstChild("BannerImg", true)  

	if BannerImg and BannerImg:IsA("ImageLabel") then  
		BannerImg.Image = Config.BannerImg or ""  
		BannerImg.ImageTransparency = 0  
	end  

	local Fill = Banner:FindFirstChild("Fill", true)  

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

	local Detail = RootObject:FindFirstChild("Detail", true)  

	if not Detail or not Detail:IsA("Frame") then  
		return  
	end  

	DetailTweening = true  

	local DDesc = Detail:FindFirstChild("DDesc", true)  

	if DDesc and DDesc:IsA("TextLabel") then  
		DDesc.Text = Config.CardDesc or ""  
	end  

	local DTitle = Detail:FindFirstChild("DTitle", true)  

	if DTitle and DTitle:IsA("TextLabel") then  
		DTitle.Text = Config.CardTitle or ""  
	end  

	local DMeta = Detail:FindFirstChild("DMeta", true)  

	if DMeta and DMeta:IsA("TextLabel") then  
		DMeta.Text = Config.CardMeta or ""  
	end  

	local Effects = Detail:FindFirstChild("Effects", true)  

	if Effects and Effects:IsA("GuiObject") then  
		local EffectRow  

		for _, Child in ipairs(Effects:GetDescendants()) do  
			if Child:GetAttribute("EffectRowOriginal") then  
				EffectRow = Child  
				break  
			end  
		end  

		if not EffectRow then  
			EffectRow = Effects:FindFirstChild("EffectRow", true)  

			if EffectRow and EffectRow:IsA("TextLabel") then  
				EffectRow:SetAttribute(  
					"EffectRowOriginal",  
					true  
				)  
			end  
		end  

		for _, Child in ipairs(Effects:GetDescendants()) do  
			if Child:GetAttribute("EffectRowClone") then  
				Child:Destroy()  
			end  
		end  

		if EffectRow and EffectRow:IsA("TextLabel") then  
			local Count = math.max(  
				1,  
				tonumber(Config.EffectRowCount) or 1  
			)  

			for i = 1, Count do  
				local RowConfig = Config.EffectRows  
					and Config.EffectRows[i]  

				if i == 1 then  
					EffectRow.Visible = true  

					if RowConfig then  
						EffectRow.Name =  
							RowConfig.Name or "EffectRow"  

						EffectRow.Text =  
							RowConfig.Text or ""  
					end  
				else  
					local NewEffectRow = EffectRow:Clone()  

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
							RowConfig.Text or ""  
					end  

					NewEffectRow.Parent =  
						EffectRow.Parent  
				end  
			end  
		end  
	end  

	local DIconHolder =  
		Detail:FindFirstChild("DIconHolder", true)  

	local DIcon =  
		DIconHolder  
		and DIconHolder:FindFirstChild("DIcon", true)  

	if DIcon  
		and DIcon:IsA("ImageLabel")  
		and Icon  
		and Icon:IsA("ImageLabel") then  

		DIcon.Image = Icon.Image  
	end  

	local DBanner =  
		Detail:FindFirstChild("DBanner", true)  

	if DBanner  
		and DBanner:IsA("Frame")  
		and Banner  
		and Banner:IsA("Frame") then  

		local DBannerImg =  
			DBanner:FindFirstChild("BannerImg", true)  

		local BannerImg =  
			Banner:FindFirstChild("BannerImg", true)  

		if DBannerImg  
			and DBannerImg:IsA("ImageLabel")  
			and BannerImg  
			and BannerImg:IsA("ImageLabel") then  

			DBannerImg.Image = BannerImg.Image  
			DBannerImg.ImageTransparency =  
				BannerImg.ImageTransparency  
		end  

		local DFill =  
			DBanner:FindFirstChild("Fill", true)  

		local Fill =  
			Banner:FindFirstChild("Fill", true)  

		if DFill  
			and DFill:IsA("Frame")  
			and Fill  
			and Fill:IsA("Frame") then  

			DFill.Visible = Fill.Visible  
		end  
	end  

	local DActions =  
		Detail:FindFirstChild("DActions", true)  
		  
		if DActions and DActions:IsA("Frame") then  
local AddToAccount =  
	DActions:FindFirstChild("AddToAccount", true)  

if AddToAccount  
	and AddToAccount:IsA("TextButton") then  

	AddToAccount.Text =  
		State.Added  
		and "UNADD"  
		or "ADD TO GAMEPLAY"  
end

end

if DActions and DActions:IsA("Frame") then  
		local EditMod =  
			DActions:FindFirstChild("EditMod", true)  

		if EditMod and EditMod:IsA("TextButton") then  
			EditMod.Visible = false  
		end  

		local Favorite =  
			DActions:FindFirstChild("Favorite", true)  

		if Favorite and Favorite:IsA("TextButton") then  
			Favorite.Visible = false  
		end  

		local AddToAccount =  
DActions:FindFirstChild("AddToAccount", true)

if AddToAccount
and AddToAccount:IsA("TextButton") then

if CurrentState == State then  
	AddToAccount.Text =  
		State.Added  
		and "UNADD"  
		or "ADD TO GAMEPLAY"  
end  

if not AddToAccount:GetAttribute(  
	"ModifierConnected"  
) then  

	AddToAccount:SetAttribute(  
		"ModifierConnected",  
		true  
	)  

	AddToAccount.MouseButton1Click:Connect(function()  
		if not CurrentConfigData  
			or not CurrentState then  
			return  
		end  

		local Config =  
			CurrentConfigData.Config  

		local State =  
			CurrentState  

		if State.Added then  
			State.Added = false  

			AddToAccount.Text =  
				"ADD TO GAMEPLAY"  
				  
				getgenv()[CurrentConfigData.Name] = nil  

			local OldTemplate =  
				State.Template  

			if OldTemplate then  
				if OldTemplate ==  
					ModifierTemplate then  

					OldTemplate.Visible = false  
				else  
					if OldTemplate.Parent then  
						OldTemplate:Destroy()  
					end  
				end  
			end  

			State.Template = nil  

			ModifierTemplates[  
				CurrentConfigData.Name  
			] = nil  

		else  
			State.Added = true  
			  
			getgenv()[CurrentConfigData.Name] = true  

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

				NewTemplate.Visible = true  

				if NewTemplate:IsA("TextButton") then
    NewTemplate.Text = Config.CardTitle or ""

    if Config.TextColor then
        NewTemplate.TextColor3 = Config.TextColor
    end
end

if Config.TemplateColor then
    NewTemplate.BackgroundColor3 =
        Config.TemplateColor
end

				State.Template =  
					NewTemplate  

				ModifierTemplates[  
					CurrentConfigData.Name  
				] = NewTemplate  
			end  
		end  

		UpdateModifiersKs()  
	end)  
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
					Detail.Visible = false  
					DetailOpened = false  
					DetailTweening = false  
				end  
			)  
		end  
	end  

	for _, Name in ipairs({  
		"AvgStars",  
		"BonusRow",  
		"Stars",  
		"DRev",  
		"RateHead"  
	}) do  
		local Item =  
			Detail:FindFirstChild(Name, true)  

		if Item and Item:IsA("GuiObject") then  
			Item.Visible = false  
		end  
	end  

	local OriginalPosition = Detail.Position  

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

for _, RootObject in ipairs(Objects) do
local Template

for _, Object in ipairs(RootObject:GetDescendants()) do  
	if (Object:IsA("TextButton") or Object:IsA("ImageButton"))  
		and Object.Name == "Entry" then  

		Template = Object  
		break  
	end  
end  

if Template and #Configs > 0 then  
	local Parent = Template.Parent  

	for _, Object in ipairs(RootObject:GetDescendants()) do  
		if Object ~= Template  
			and (Object:IsA("TextButton") or Object:IsA("ImageButton"))  
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

local SearchBox

for _, Descendant in ipairs(ModifierUI:GetDescendants()) do
if Descendant.Name == "Search"
and Descendant:IsA("TextBox") then

SearchBox = Descendant  
	break  
end

end

if SearchBox then
SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
local SearchText = SearchBox.Text:lower()

for _, ConfigData in ipairs(Configs) do  
		local Config = ConfigData.Config  
		local State = AddedModifiers[ConfigData.Name]  

		if State and State.Entry then  
			local CardTitle = tostring(Config.CardTitle or ""):lower()  

			local Match =  
				SearchText == ""  
				or string.find(  
					CardTitle,  
					SearchText,  
					1,  
					true  
				) ~= nil  

			State.Entry.Visible = Match  
		end  
	end  
end)

end

local function FadeGui(Object, Duration)
	local Tweens = {}

	local function AddTween(Instance, Properties)
		local Tween = TweenService:Create(
			Instance,
			TweenInfo.new(
				Duration,
				Enum.EasingStyle.Quad,
				Enum.EasingDirection.Out
			),
			Properties
		)

		Tween:Play()
		table.insert(Tweens, Tween)
	end

	if Object:IsA("GuiObject") then
		if Object.BackgroundTransparency ~= nil then
			AddTween(Object, {
				BackgroundTransparency = 1
			})
		end

		if Object:IsA("TextLabel")
			or Object:IsA("TextButton")
			or Object:IsA("TextBox") then

			AddTween(Object, {
				TextTransparency = 1,
				TextStrokeTransparency = 1
			})
		end

		if Object:IsA("ImageLabel")
			or Object:IsA("ImageButton") then

			AddTween(Object, {
				ImageTransparency = 1
			})
		end

		if Object:IsA("ScrollingFrame") then
			AddTween(Object, {
				ScrollBarImageTransparency = 1
			})
		end
	end

	if Object:IsA("UIStroke") then
		AddTween(Object, {
			Transparency = 1
		})
	end

	if Object:IsA("CanvasGroup") then
		AddTween(Object, {
			GroupTransparency = 1
		})
	end

	for _, Descendant in ipairs(Object:GetDescendants()) do
		if Descendant:IsA("GuiObject") then
			if Descendant.BackgroundTransparency ~= nil then
				AddTween(Descendant, {
					BackgroundTransparency = 1
				})
			end

			if Descendant:IsA("TextLabel")
				or Descendant:IsA("TextButton")
				or Descendant:IsA("TextBox") then

				AddTween(Descendant, {
					TextTransparency = 1,
					TextStrokeTransparency = 1
				})
			end

			if Descendant:IsA("ImageLabel")
				or Descendant:IsA("ImageButton") then

				AddTween(Descendant, {
					ImageTransparency = 1
				})
			end

			if Descendant:IsA("ScrollingFrame") then
				AddTween(Descendant, {
					ScrollBarImageTransparency = 1
				})
			end
		end

		if Descendant:IsA("UIStroke") then
			AddTween(Descendant, {
				Transparency = 1
			})
		end

		if Descendant:IsA("CanvasGroup") then
			AddTween(Descendant, {
				GroupTransparency = 1
			})
		end
	end

	task.wait(3)
end

local function FadeAndDestroy(Object)
	if not Object or not Object.Parent then
		return
	end

	if Object.Name == "Modifierrsssss" then
		if ModifiersKs and ModifiersKs:IsDescendantOf(Object) then
			FadeGui(ModifiersKs, 3)
		else
			FadeGui(Object, 3)
		end
	else
		FadeGui(Object, 3)
	end

	if Object.Parent then
		Object:Destroy()
	end
end

local LatestRoom = game.ReplicatedStorage.GameData.LatestRoom

LatestRoom.Changed:Wait()

for _, Object in ipairs(MainUI:GetChildren()) do
	if Object == ModifiersKs then
	task.wait(1.5)
	
		FadeAndDestroy(Object)
	elseif Object.Name == "ButtonModifiers"
		or Object.Name == "Modifierrsssss" then
		Object:Destroy()
	end
end

UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
breaking3:Destroy() 
