local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = workspace.CurrentCamera

-- Защита от дублирования
if CoreGui:FindFirstChild("ScorpionSkeet_UI") then CoreGui.ScorpionSkeet_UI:Destroy() end
if CoreGui:FindFirstChild("ScorpionCrosshair") then CoreGui.ScorpionCrosshair:Destroy() end
if CoreGui:FindFirstChild("ScorpionJumpRing") then CoreGui.JumpRingGui:Destroy() end
if CoreGui:FindFirstChild("ScorpionESP_Gui") then CoreGui.ScorpionESP_Gui:Destroy() end

local Theme = {
    Bg = Color3.fromRGB(17, 17, 17),
    Outline = Color3.fromRGB(35, 35, 35),
    PanelBg = Color3.fromRGB(22, 22, 22),
    Text = Color3.fromRGB(200, 200, 200),
    TextDim = Color3.fromRGB(110, 110, 110),
    Accent = Color3.fromRGB(140, 180, 255),
    ControlBg = Color3.fromRGB(13, 13, 13),
}

local function applyCorner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 4)
    c.Parent = parent
    return c
end

local function applyStroke(parent, color)
    local s = Instance.new("UIStroke")
    s.Color = color or Theme.Outline
    s.Thickness = 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = parent
    return s
end

-- ГЛАВНОЕ ОКНО GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ScorpionSkeet_UI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999
ScreenGui.Enabled = false
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.fromScale(0.5, 0.5)
MainFrame.Size = UDim2.fromOffset(720, 520)
MainFrame.BackgroundColor3 = Theme.Bg
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

applyCorner(MainFrame, 6)
applyStroke(MainFrame, Theme.Outline)

local MainScale = Instance.new("UIScale")
MainScale.Scale = 1
MainScale.Parent = MainFrame

-- Фоновые частицы
local ParticlesHolder = Instance.new("Folder")
ParticlesHolder.Name = "BackgroundParticles"
ParticlesHolder.Parent = MainFrame

task.spawn(function()
    while MainFrame and MainFrame.Parent do
        if MainFrame.Visible then
            local p = Instance.new("Frame")
            p.Size = UDim2.fromOffset(2, 2)
            p.Position = UDim2.new(math.random(), 0, 1, 10)
            p.BackgroundColor3 = Theme.Accent
            p.BackgroundTransparency = 0.4
            p.BorderSizePixel = 0
            p.ZIndex = 5
            p.Parent = ParticlesHolder
            applyCorner(p, 2)

            TweenService:Create(p, TweenInfo.new(6, Enum.EasingStyle.Linear), {
                Position = UDim2.new(p.Position.X.Scale, 0, -0.1, 0),
                BackgroundTransparency = 1
            }):Play()

            task.delay(6, function() if p then p:Destroy() end end)
        end
        task.wait(1)
    end
end)

-- Интро
task.spawn(function()
    local introGui = Instance.new("ScreenGui")
    introGui.Name = "ScorpionIntro"
    introGui.IgnoreGuiInset = true
    introGui.ResetOnSpawn = false
    introGui.DisplayOrder = 1000
    introGui.Parent = playerGui

    local bgOverlay = Instance.new("Frame")
    bgOverlay.Size = UDim2.fromScale(1, 1)
    bgOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bgOverlay.BackgroundTransparency = 0.3
    bgOverlay.Parent = introGui

    local label = Instance.new("TextLabel")
    label.AnchorPoint = Vector2.new(0.5, 0.5)
    label.Position = UDim2.fromScale(0.5, 0.5)
    label.Size = UDim2.fromOffset(500, 80)
    label.BackgroundTransparency = 1
    label.RichText = true
    label.Text = "<font color=\"#8CB4FF\">SCORPION</font><font color=\"#FFFFFF\">.WTF</font>"
    label.Font = Enum.Font.GothamBlack
    label.TextSize = 46
    label.Parent = introGui

    task.delay(1.2, function()
        introGui:Destroy()
        ScreenGui.Enabled = true
    end)
end)

-- Футер
local FooterLabel = Instance.new("TextLabel")
FooterLabel.AnchorPoint = Vector2.new(0.5, 1)
FooterLabel.Position = UDim2.new(0.5, 0, 1, -6)
FooterLabel.Size = UDim2.new(1, -20, 0, 16)
FooterLabel.BackgroundTransparency = 1
FooterLabel.RichText = true
FooterLabel.Text = "<font color=\"#8CB4FF\">Scorpion.wtf</font> <font color=\"#B0B0B0\">Visual Private</font>"
FooterLabel.Font = Enum.Font.GothamBold
FooterLabel.TextSize = 10
FooterLabel.TextXAlignment = Enum.TextXAlignment.Center
FooterLabel.ZIndex = 10
FooterLabel.Parent = MainFrame

-- Сайдбар и вкладки
local Sidebar = Instance.new("ScrollingFrame")
Sidebar.Position = UDim2.fromOffset(12, 12)
Sidebar.Size = UDim2.fromOffset(130, 456)
Sidebar.BackgroundColor3 = Theme.ControlBg
Sidebar.BorderSizePixel = 0
Sidebar.ScrollBarThickness = 0
Sidebar.ZIndex = 2
Sidebar.Parent = MainFrame
applyCorner(Sidebar, 4)
applyStroke(Sidebar, Theme.Outline)

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.Padding = UDim.new(0, 4)
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
SidebarLayout.Parent = Sidebar

local SidebarPad = Instance.new("UIPadding")
SidebarPad.PaddingTop = UDim.new(0, 10)
SidebarPad.PaddingLeft = UDim.new(0, 12)
SidebarPad.Parent = Sidebar

local ContentArea = Instance.new("Frame")
ContentArea.Position = UDim2.fromOffset(154, 12)
ContentArea.Size = UDim2.fromOffset(554, 456)
ContentArea.BackgroundTransparency = 1
ContentArea.ZIndex = 2
ContentArea.Parent = MainFrame

local Tabs = {}
local activeTab = nil

local function SwitchTab(tabData)
    if activeTab == tabData then return end
    if activeTab then
        activeTab.Content.Visible = false
        activeTab.Label.TextColor3 = Theme.TextDim
    end
    activeTab = tabData
    tabData.Content.Visible = true
    tabData.Label.TextColor3 = Theme.Accent
end

local function CreateTab(name)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -12, 0, 28)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.ZIndex = 2
    btn.Parent = Sidebar

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.fromScale(1, 1)
    lbl.BackgroundTransparency = 1
    lbl.Text = name
    lbl.TextColor3 = Theme.TextDim
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 2
    lbl.Parent = btn

    local tabContainer = Instance.new("Frame")
    tabContainer.Size = UDim2.fromScale(1, 1)
    tabContainer.BackgroundTransparency = 1
    tabContainer.Visible = false
    tabContainer.ZIndex = 2
    tabContainer.Parent = ContentArea

    local colLeft = Instance.new("ScrollingFrame")
    colLeft.Size = UDim2.new(0.48, 0, 1, 0)
    colLeft.BackgroundTransparency = 1
    colLeft.BorderSizePixel = 0
    colLeft.ScrollBarThickness = 2
    colLeft.ScrollBarImageColor3 = Theme.Accent
    colLeft.AutomaticCanvasSize = Enum.AutomaticSize.Y
    colLeft.ZIndex = 2
    colLeft.Parent = tabContainer

    local ll = Instance.new("UIListLayout")
    ll.Padding = UDim.new(0, 10)
    ll.SortOrder = Enum.SortOrder.LayoutOrder
    ll.Parent = colLeft

    local colRight = Instance.new("ScrollingFrame")
    colRight.Position = UDim2.new(0.52, 0, 0, 0)
    colRight.Size = UDim2.new(0.48, 0, 1, 0)
    colRight.BackgroundTransparency = 1
    colRight.BorderSizePixel = 0
    colRight.ScrollBarThickness = 2
    colRight.ScrollBarImageColor3 = Theme.Accent
    colRight.AutomaticCanvasSize = Enum.AutomaticSize.Y
    colRight.ZIndex = 2
    colRight.Parent = tabContainer

    local rl = Instance.new("UIListLayout")
    rl.Padding = UDim.new(0, 10)
    rl.SortOrder = Enum.SortOrder.LayoutOrder
    rl.Parent = colRight

    local tabData = {Button = btn, Label = lbl, Content = tabContainer, Left = colLeft, Right = colRight}
    table.insert(Tabs, tabData)

    btn.MouseButton1Click:Connect(function() SwitchTab(tabData) end)
    if #Tabs == 1 then SwitchTab(tabData) end
    return tabData
end

local function CreateSection(column, name)
    local sec = Instance.new("Frame")
    sec.Size = UDim2.new(1, 0, 0, 0)
    sec.AutomaticSize = Enum.AutomaticSize.Y
    sec.BackgroundColor3 = Theme.PanelBg
    sec.BorderSizePixel = 0
    sec.ZIndex = 2
    sec.Parent = column
    applyCorner(sec, 4)
    applyStroke(sec, Theme.Outline)

    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, 10)
    pad.PaddingBottom = UDim.new(0, 10)
    pad.PaddingLeft = UDim.new(0, 10)
    pad.PaddingRight = UDim.new(0, 10)
    pad.Parent = sec

    local lay = Instance.new("UIListLayout")
    lay.Padding = UDim.new(0, 8)
    lay.SortOrder = Enum.SortOrder.LayoutOrder
    lay.Parent = sec

    if name and name ~= "" then
        local hdr = Instance.new("TextLabel")
        hdr.Size = UDim2.new(1, 0, 0, 16)
        hdr.BackgroundTransparency = 1
        hdr.Text = name
        hdr.TextColor3 = Theme.Accent
        hdr.Font = Enum.Font.GothamBold
        hdr.TextSize = 11
        hdr.TextXAlignment = Enum.TextXAlignment.Left
        hdr.ZIndex = 2
        hdr.Parent = sec
    end

    local body = Instance.new("Frame")
    body.Size = UDim2.new(1, 0, 0, 0)
    body.AutomaticSize = Enum.AutomaticSize.Y
    body.BackgroundTransparency = 1
    body.ZIndex = 2
    body.Parent = sec

    local bl = Instance.new("UIListLayout")
    bl.Padding = UDim.new(0, 8)
    bl.SortOrder = Enum.SortOrder.LayoutOrder
    bl.Parent = body

    return body
end

local function CreateToggle(parent, text, default, cb)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 20)
    f.BackgroundTransparency = 1
    f.ZIndex = 2
    f.Parent = parent

    local box = Instance.new("Frame")
    box.Size = UDim2.fromOffset(12, 12)
    box.Position = UDim2.new(0, 0, 0.5, -6)
    box.BackgroundColor3 = default and Theme.Accent or Theme.ControlBg
    box.BorderSizePixel = 0
    box.ZIndex = 2
    box.Parent = f
    applyCorner(box, 2)
    applyStroke(box, Theme.Outline)

    local lbl = Instance.new("TextLabel")
    lbl.Position = UDim2.fromOffset(20, 0)
    lbl.Size = UDim2.new(1, -20, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = default and Theme.Text or Theme.TextDim
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 2
    lbl.Parent = f

    local state = default
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.fromScale(1, 1)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.ZIndex = 2
    btn.Parent = f

    btn.MouseButton1Click:Connect(function()
        state = not state
        box.BackgroundColor3 = state and Theme.Accent or Theme.ControlBg
        lbl.TextColor3 = state and Theme.Text or Theme.TextDim
        if cb then cb(state) end
    end)
    return f
end

local function CreateSlider(parent, text, mn, mx, def, cb)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 36)
    f.BackgroundTransparency = 1
    f.ZIndex = 2
    f.Parent = parent

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 14)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Theme.TextDim
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 2
    lbl.Parent = f

    local val = Instance.new("TextLabel")
    val.Size = UDim2.new(1, 0, 0, 14)
    val.BackgroundTransparency = 1
    val.Text = tostring(def)
    val.TextColor3 = Theme.Text
    val.Font = Enum.Font.GothamBold
    val.TextSize = 11
    val.TextXAlignment = Enum.TextXAlignment.Right
    val.ZIndex = 2
    val.Parent = f

    local bar = Instance.new("Frame")
    bar.Position = UDim2.new(0, 0, 0, 20)
    bar.Size = UDim2.new(1, 0, 0, 6)
    bar.BackgroundColor3 = Theme.ControlBg
    bar.BorderSizePixel = 0
    bar.ZIndex = 2
    bar.Parent = f
    applyCorner(bar, 2)
    applyStroke(bar, Theme.Outline)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((def - mn) / (mx - mn), 0, 1, 0)
    fill.BackgroundColor3 = Theme.Accent
    fill.BorderSizePixel = 0
    fill.ZIndex = 2
    fill.Parent = bar
    applyCorner(fill, 2)

    local dragging = false
    local function updateValue(absX)
        local a = math.clamp((absX - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        local v = math.floor(mn + (mx - mn) * a + 0.5)
        fill.Size = UDim2.new(a, 0, 1, 0)
        val.Text = tostring(v)
        if cb then cb(v) end
    end

    local click = Instance.new("TextButton")
    click.Size = UDim2.fromScale(1, 1)
    click.BackgroundTransparency = 1
    click.Text = ""
    click.ZIndex = 3
    click.Parent = bar

    click.MouseButton1Down:Connect(function()
        dragging = true
        updateValue(UserInputService:GetMouseLocation().X)
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            updateValue(i.Position.X)
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    return f
end

local function CreateButton(parent, text, cb)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 26)
    btn.BackgroundColor3 = Theme.ControlBg
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = Theme.Text
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 11
    btn.ZIndex = 2
    btn.Parent = parent
    applyCorner(btn, 4)
    applyStroke(btn, Theme.Outline)

    btn.MouseButton1Click:Connect(function() if cb then cb() end end)
    return btn
end

local function CreateKeybind(parent, text, onSet, onClear)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 24)
    f.BackgroundTransparency = 1
    f.ZIndex = 2
    f.Parent = parent

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -60, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Theme.TextDim
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 2
    lbl.Parent = f

    local keyBtn = Instance.new("TextButton")
    keyBtn.AnchorPoint = Vector2.new(1, 0.5)
    keyBtn.Position = UDim2.new(1, 0, 0.5, 0)
    keyBtn.Size = UDim2.fromOffset(50, 18)
    keyBtn.BackgroundColor3 = Theme.ControlBg
    keyBtn.BorderSizePixel = 0
    keyBtn.Text = "None"
    keyBtn.TextColor3 = Theme.Accent
    keyBtn.Font = Enum.Font.GothamBold
    keyBtn.TextSize = 10
    keyBtn.ZIndex = 2
    keyBtn.Parent = f
    applyCorner(keyBtn, 3)
    applyStroke(keyBtn, Theme.Outline)

    local listening = false
    local currentKey = nil

    keyBtn.MouseButton1Click:Connect(function()
        listening = true
        keyBtn.Text = "..."
    end)

    UserInputService.InputBegan:Connect(function(i, gp)
        if gp or not listening then return end
        if i.UserInputType ~= Enum.UserInputType.Keyboard then return end
        listening = false
        if i.KeyCode == Enum.KeyCode.Escape then
            keyBtn.Text = currentKey and currentKey.Name or "None"
            if currentKey == nil and onClear then onClear() end
            return
        end
        currentKey = i.KeyCode
        keyBtn.Text = i.KeyCode.Name
        if onSet then onSet(i.KeyCode) end
    end)
    return f
end

-- Конфиг
local cfgData = {
    fov = 70, zoomFov = 30, stretch = false, stretchX = 100, stretchY = 75,
    crosshairEnabled = false, crosshairStyle = 1, cLength = 6, cThickness = 2, cGap = 4, cSpeed = 150,
    customTimeEnabled = false, timeOfDay = 14, jumpRingEnabled = false, uiFont = 1,
    shotSound = 1, shotVolume = 120,
    chamsEnabled = false, chamsDist = false, chamsWeapon = false, chamsColorR = 140, chamsColorG = 180, chamsColorB = 255,
    hitboxesEnabled = false, hitboxSize = 2, hitboxVis = false,
    sprayVisualEnabled = false, sprayPercent = 50,
    trailEnabled = false, vignetteEnabled = false
}

local function SaveConfig()
    pcall(function() writefile("scorpion_config.json", HttpService:JSONEncode(cfgData)) end)
end

local function LoadConfig()
    pcall(function()
        if readfile and isfile and isfile("scorpion_config.json") then
            local decoded = HttpService:JSONDecode(readfile("scorpion_config.json"))
            for k, v in pairs(decoded) do cfgData[k] = v end
        end
    end)
end
LoadConfig()

local baseFov = cfgData.fov
local zoomFov = cfgData.zoomFov
local zoomKey = nil
local zoomActive = false

local stretchEnabled = cfgData.stretch
local stretchX = cfgData.stretchX
local stretchY = cfgData.stretchY
local crosshairEnabled = cfgData.crosshairEnabled
local crosshairStyle = cfgData.crosshairStyle
local cLength = cfgData.cLength
local cThickness = cfgData.cThickness
local cGap = cfgData.cGap
local cSpeed = cfgData.cSpeed
local customTimeEnabled = cfgData.customTimeEnabled
local timeOfDay = cfgData.timeOfDay
local jumpRingEnabled = cfgData.jumpRingEnabled
local shotSoundMode = cfgData.shotSound
local shotVolume = cfgData.shotVolume / 100

local chamsEnabled = cfgData.chamsEnabled
local chamsDist = cfgData.chamsDist
local chamsWeapon = cfgData.chamsWeapon
local chamsColor = Color3.fromRGB(cfgData.chamsColorR, cfgData.chamsColorG, cfgData.chamsColorB)

local hitboxesEnabled = cfgData.hitboxesEnabled
local hitboxSize = cfgData.hitboxSize
local hitboxVis = cfgData.hitboxVis
local sprayVisualEnabled = cfgData.sprayVisualEnabled
local sprayPercent = cfgData.sprayPercent
local trailEnabled = cfgData.trailEnabled
local vignetteEnabled = cfgData.vignetteEnabled

local shotSoundIds = {116638799291219, 126038538904906, 111560665479428, 8628978369}

local function PlayWeaponShotSound()
    local s = Instance.new("Sound")
    s.SoundId = "rbxassetid://" .. tostring(shotSoundIds[shotSoundMode] or shotSoundIds[1])
    s.Volume = shotVolume
    s.Parent = SoundService
    s:Play()
    s.Ended:Connect(function() s:Destroy() end)
end

local function CheckAndHook(obj)
    if obj:IsA("Tool") then
        obj.Activated:Connect(PlayWeaponShotSound)
    elseif obj:IsA("Sound") and (obj.Name:lower():find("shoot") or obj.Name:lower():find("fire") or obj.Name:lower():find("shot")) then
        obj:GetPropertyChangedSignal("Playing"):Connect(function() if obj.Playing then PlayWeaponShotSound() end end)
    end
end

if player.Character then
    for _, item in ipairs(player.Character:GetDescendants()) do CheckAndHook(item) end
    player.Character.DescendantAdded:Connect(CheckAndHook)
end
player.CharacterAdded:Connect(function(char)
    char.DescendantAdded:Connect(CheckAndHook)
end)

-- Снос кд прыжка
RunService.Stepped:Connect(function()
    local char = player.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, true) end) end
    end
end)

-- FX Эффекты
local trailFx, vignetteGui

local function updateTrail(on)
    if trailFx then trailFx:Destroy(); trailFx = nil end
    if not on then return end
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local folder = hrp:FindFirstChild("ScorpFX") or Instance.new("Folder", hrp)
    folder.Name = "ScorpFX"
    local a0 = Instance.new("Attachment", hrp); a0.Position = Vector3.new(0, 1, 0.5)
    local a1 = Instance.new("Attachment", hrp); a1.Position = Vector3.new(0, -1, 0.5)
    local t = Instance.new("Trail")
    t.Attachment0 = a0; t.Attachment1 = a1; t.Lifetime = 0.4
    t.Color = ColorSequence.new(Theme.Accent, Theme.Text)
    t.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.2), NumberSequenceKeypoint.new(1, 1)})
    t.Parent = folder; trailFx = t
end

local function updateVignette(on)
    if vignetteGui then vignetteGui:Destroy(); vignetteGui = nil end
    if not on then return end
    local sg = Instance.new("ScreenGui", playerGui)
    sg.Name = "ScorpionVignette"
    sg.IgnoreGuiInset = true; sg.DisplayOrder = 998
    local f = Instance.new("Frame", sg)
    f.Size = UDim2.fromScale(1, 1); f.BackgroundColor3 = Color3.new(0, 0, 0); f.BackgroundTransparency = 0.25
    local g = Instance.new("UIGradient", f)
    g.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.65, 1), NumberSequenceKeypoint.new(1, 0)})
    g.Rotation = 90; vignetteGui = sg
end

if trailEnabled then updateTrail(true) end
if vignetteEnabled then updateVignette(true) end

player.CharacterAdded:Connect(function()
    task.wait(1)
    if trailEnabled then updateTrail(true) end
end)

-- Кольцо при приземлении
local function SpawnJumpRing()
    if not jumpRingEnabled then return end
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    task.spawn(function()
        local p = Instance.new("Part")
        p.Size = Vector3.new(0.5, 0.05, 0.5)
        p.CFrame = CFrame.new(hrp.Position - Vector3.new(0, 3, 0))
        p.Anchored = true; p.CanCollide = false
        p.Transparency = 0.2; p.Color = Theme.Accent; p.Material = Enum.Material.Neon
        p.Parent = workspace

        local mesh = Instance.new("CylinderMesh", p)
        mesh.Scale = Vector3.new(1, 0.05, 1)

        for step = 1, 20 do
            if not p then break end
            mesh.Scale = mesh.Scale + Vector3.new(1.5, 0, 1.5)
            p.Transparency = 0.2 + (step / 20 * 0.8)
            task.wait(0.015)
        end
        if p then p:Destroy() end
    end)
end

local lastFloor = true
RunService.RenderStepped:Connect(function()
    if not jumpRingEnabled then return end
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        local onFloor = hum.FloorMaterial ~= Enum.Material.Air
        if not lastFloor and onFloor then SpawnJumpRing() end
        lastFloor = onFloor
    end
end)

-- ESP с защитой от зависания меток при выходе/смерти игрока
local ESP_Gui = Instance.new("ScreenGui")
ESP_Gui.Name = "ScorpionESP_Gui"
ESP_Gui.IgnoreGuiInset = true
ESP_Gui.ResetOnSpawn = false
ESP_Gui.Parent = CoreGui

local espLabels = {}
local frameCounter = 0

-- Очистка текста при выходе игрока
Players.PlayerRemoving:Connect(function(p)
    if espLabels[p] then
        espLabels[p]:Destroy()
        espLabels[p] = nil
    end
end)

RunService.RenderStepped:Connect(function()
    frameCounter = (frameCounter + 1) % 3
    local myChar = player.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")

    -- Хитбоксы
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player then
            local pChar = p.Character
            if pChar then
                local headPart = pChar:FindFirstChild("Head")
                local torsoPart = pChar:FindFirstChild("HumanoidRootPart")
                local sphereVis = pChar:FindFirstChild("ScorpionHitboxSphere")
                
                local hum = pChar:FindFirstChildOfClass("Humanoid")
                if hitboxVis and headPart and hum and hum.Health > 0 then
                    if not sphereVis then
                        sphereVis = Instance.new("SelectionBox")
                        sphereVis.Name = "ScorpionHitboxSphere"
                        sphereVis.Color3 = Theme.Accent
                        sphereVis.LineThickness = 0.03
                        sphereVis.Parent = pChar
                    end
                    sphereVis.Adornee = headPart
                    sphereVis.Visible = true
                else
                    if sphereVis then sphereVis:Destroy() end
                end

                if headPart and torsoPart then
                    if hitboxesEnabled then
                        headPart.Size = Vector3.new(hitboxSize * 1.5, hitboxSize * 1.5, hitboxSize * 1.5)
                        headPart.CanCollide = false
                        torsoPart.Size = Vector3.new(hitboxSize + 1, hitboxSize + 2, hitboxSize + 1)
                        torsoPart.CanCollide = false
                    else
                        headPart.Size = Vector3.new(2, 1, 1)
                        torsoPart.Size = Vector3.new(2, 2, 1)
                    end
                end
            end
        end
    end

    -- Обновление ESP и чамсов с очисткой неактивных
    if frameCounter == 0 then
        local activePlayers = {}
        for _, p in ipairs(Players:GetPlayers()) do activePlayers[p] = true end

        -- Удаляем метки тех, кто ливнул
        for p, lbl in pairs(espLabels) do
            if not activePlayers[p] then
                lbl:Destroy()
                espLabels[p] = nil
            end
        end

        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player then
                local pChar = p.Character
                local pRoot = pChar and pChar:FindFirstChild("HumanoidRootPart")
                local pHead = pChar and pChar:FindFirstChild("Head")
                local pHum = pChar and pChar:FindFirstChildOfClass("Humanoid")

                local hl = pChar and pChar:FindFirstChild("ScorpionChamsHighlight")
                if chamsEnabled and pChar and pHum and pHum.Health > 0 then
                    if not hl then
                        hl = Instance.new("Highlight")
                        hl.Name = "ScorpionChamsHighlight"
                        hl.Adornee = pChar
                        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        hl.Parent = pChar
                    end
                    hl.FillColor = chamsColor
                    hl.OutlineColor = Color3.new(0, 0, 0)
                    hl.FillTransparency = 0.4
                else
                    if hl then hl:Destroy() end
                end

                local lbl = espLabels[p]
                if chamsEnabled and pRoot and myRoot and pHead and pHum and pHum.Health > 0 then
                    if not lbl then
                        lbl = Instance.new("TextLabel")
                        lbl.BackgroundTransparency = 1
                        lbl.Size = UDim2.fromOffset(160, 40)
                        lbl.AnchorPoint = Vector2.new(0.5, 1)
                        lbl.Font = Enum.Font.GothamBold
                        lbl.TextSize = 11
                        lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
                        lbl.TextStrokeTransparency = 0.5
                        lbl.Parent = ESP_Gui
                        espLabels[p] = lbl
                    end

                    local dist = (pRoot.Position - myRoot.Position).Magnitude
                    local screenPos, onScreen = camera:WorldToViewportPoint(pHead.Position + Vector3.new(0, 1.2, 0))
                    
                    if onScreen then
                        lbl.Position = UDim2.fromOffset(screenPos.X, screenPos.Y)
                        local infoText = string.format("[%s]", p.Name)
                        if chamsDist then infoText = infoText .. string.format(" %dm", math.floor(dist)) end
                        lbl.Text = infoText
                        lbl.Visible = true
                    else
                        lbl.Visible = false
                    end
                else
                    if lbl then lbl.Visible = false end
                end
            end
        end
    end
end)

-- Прицел
local CrosshairGui = Instance.new("ScreenGui")
CrosshairGui.Name = "ScorpionCrosshair"
CrosshairGui.IgnoreGuiInset = true
CrosshairGui.ResetOnSpawn = false
CrosshairGui.Parent = CoreGui

local CrosshairContainer = Instance.new("Frame")
CrosshairContainer.AnchorPoint = Vector2.new(0.5, 0.5)
CrosshairContainer.Position = UDim2.fromScale(0.5, 0.5)
CrosshairContainer.Size = UDim2.fromOffset(100, 100)
CrosshairContainer.BackgroundTransparency = 1
CrosshairContainer.Visible = false
CrosshairContainer.Parent = CrosshairGui

local function createLine(name)
    local l = Instance.new("Frame")
    l.Name = name
    l.BackgroundColor3 = Color3.fromRGB(140, 180, 255)
    l.BorderSizePixel = 0
    l.Parent = CrosshairContainer
    return l
end

local cTop, cBottom, cLeft, cRight, cDot = createLine("Top"), createLine("Bottom"), createLine("Left"), createLine("Right"), createLine("Dot")
applyCorner(cDot, 3)

local SpinLabel = Instance.new("TextLabel")
SpinLabel.AnchorPoint = Vector2.new(0.5, 0.5)
SpinLabel.Position = UDim2.fromScale(0.5, 0.5)
SpinLabel.Size = UDim2.fromOffset(80, 80)
SpinLabel.BackgroundTransparency = 1
SpinLabel.Text = "卐"
SpinLabel.TextColor3 = Color3.fromRGB(140, 180, 255)
SpinLabel.Font = Enum.Font.GothamBold
SpinLabel.Visible = false
SpinLabel.Parent = CrosshairContainer

-- Камера и рендер
local RENDER_NAME = "ScorpionEngineOptimized"
camera.FieldOfView = baseFov
local currentRotation = 0

RunService:BindToRenderStep(RENDER_NAME, Enum.RenderPriority.Camera.Value + 10, function(dt)
    if customTimeEnabled then Lighting.ClockTime = timeOfDay end

    local targetFov = zoomActive and zoomFov or baseFov
    if camera.FieldOfView ~= targetFov then camera.FieldOfView = targetFov end

    if stretchEnabled then
        local sx, sy = stretchX / 100, stretchY / 100
        local pos, look, up, right = camera.CFrame.Position, camera.CFrame.LookVector, camera.CFrame.UpVector, camera.CFrame.RightVector
        camera.CFrame = CFrame.fromMatrix(pos, right * sx, up * sy, -look)
    end

    if crosshairEnabled then
        CrosshairContainer.Visible = true
        if crosshairStyle == 1 then
            SpinLabel.Visible = false; cDot.Visible = false
            cTop.Visible = true; cBottom.Visible = true; cLeft.Visible = true; cRight.Visible = true
            cTop.Size = UDim2.fromOffset(cThickness, cLength)
            cTop.Position = UDim2.new(0.5, -cThickness/2, 0.5, -cGap - cLength)
            cBottom.Size = UDim2.fromOffset(cThickness, cLength)
            cBottom.Position = UDim2.new(0.5, -cThickness/2, 0.5, cGap)
            cLeft.Size = UDim2.fromOffset(cLength, cThickness)
            cLeft.Position = UDim2.new(0.5, -cGap - cLength, 0.5, -cThickness/2)
            cRight.Size = UDim2.fromOffset(cLength, cThickness)
            cRight.Position = UDim2.new(0.5, cGap, 0.5, -cThickness/2)
        elseif crosshairStyle == 2 then
            SpinLabel.Visible = false
            cTop.Visible = false; cBottom.Visible = false; cLeft.Visible = false; cRight.Visible = false; cDot.Visible = true
            local dotSize = math.clamp(cLength, 2, 12)
            cDot.Size = UDim2.fromOffset(dotSize, dotSize)
            cDot.Position = UDim2.new(0.5, -dotSize/2, 0.5, -dotSize/2)
        elseif crosshairStyle == 3 then
            cTop.Visible = false; cBottom.Visible = false; cLeft.Visible = false; cRight.Visible = false; cDot.Visible = false
            SpinLabel.Visible = true
            currentRotation = (currentRotation + cSpeed * dt) % 360
            SpinLabel.Rotation = currentRotation
            SpinLabel.TextSize = cLength * 1.5 + (cThickness * 2)
        end
    else
        CrosshairContainer.Visible = false
    end
end)

local function Unload()
   SaveConfig()
   pcall(function() RunService:UnbindFromRenderStep(RENDER_NAME) end)
   if trailFx then trailFx:Destroy() end
   if vignetteGui then vignetteGui:Destroy() end
   CrosshairGui:Destroy()
   ESP_Gui:Destroy()
   ScreenGui:Destroy()
end

-- Вкладки
local tabVisuals = CreateTab("Visuals")
local tabCamera = CreateTab("Camera")
local tabStretch = CreateTab("Stretch")
local tabFX = CreateTab("Visual FX")
local tabSettings = CreateTab("Settings")

do
    local s = CreateSection(tabVisuals.Left, "Crosshair Builder")
    CreateToggle(s, "Enable Custom Crosshair", cfgData.crosshairEnabled, function(st) crosshairEnabled = st; cfgData.crosshairEnabled = st; SaveConfig() end)
    CreateSlider(s, "Style (1:Cross, 2:Dot, 3:Spin)", 1, 3, cfgData.crosshairStyle, function(v) crosshairStyle = v; cfgData.crosshairStyle = v; SaveConfig() end)
    CreateSlider(s, "Length / Size", 2, 30, cfgData.cLength, function(v) cLength = v; cfgData.cLength = v; SaveConfig() end)
    CreateSlider(s, "Thickness", 1, 8, cfgData.cThickness, function(v) cThickness = v; cfgData.cThickness = v; SaveConfig() end)
    CreateSlider(s, "Gap", 0, 20, cfgData.cGap, function(v) cGap = v; cfgData.cGap = v; SaveConfig() end)
    CreateSlider(s, "Spin Speed", 0, 400, cfgData.cSpeed, function(v) cSpeed = v; cfgData.cSpeed = v; SaveConfig() end)

    local sEsp = CreateSection(tabVisuals.Left, "Player ESP Chams & Info")
    CreateToggle(sEsp, "Enable Wallhack Chams", cfgData.chamsEnabled, function(st) chamsEnabled = st; cfgData.chamsEnabled = st; SaveConfig() end)
    CreateToggle(sEsp, "Show Distance (Meters)", cfgData.chamsDist, function(st) chamsDist = st; cfgData.chamsDist = st; SaveConfig() end)

    local sCombat = CreateSection(tabVisuals.Right, "Combat Enhancements")
    CreateToggle(sCombat, "Legit Hitboxes", cfgData.hitboxesEnabled, function(st) hitboxesEnabled = st; cfgData.hitboxesEnabled = st; SaveConfig() end)
    CreateToggle(sCombat, "Hitbox Sphere ESP (Vis)", cfgData.hitboxVis, function(st) hitboxVis = st; cfgData.hitboxVis = st; SaveConfig() end)
    CreateSlider(sCombat, "Hitbox Size (1 - 3)", 1, 3, cfgData.hitboxSize, function(v) hitboxSize = v; cfgData.hitboxSize = v; SaveConfig() end)
end

do
    local s = CreateSection(tabCamera.Left, "Field of View")
    CreateSlider(s, "Field of View", 50, 120, cfgData.fov, function(v) baseFov = v; cfgData.fov = v; SaveConfig() end)
    CreateSlider(s, "Zoom FOV", 20, 60, cfgData.zoomFov, function(v) zoomFov = v; cfgData.zoomFov = v; SaveConfig() end)
    CreateKeybind(s, "Zoom Keybind", function(k) zoomKey = k end, function() zoomKey = nil; zoomActive = false end)
end

do
    local s = CreateSection(tabStretch.Left, "Resolution Stretch (4:3)")
    CreateToggle(s, "Enable Stretch", cfgData.stretch, function(st) stretchEnabled = st; cfgData.stretch = st; SaveConfig() end)
    CreateSlider(s, "Stretch X Scale", 50, 120, cfgData.stretchX, function(v) stretchX = v; cfgData.stretchX = v; SaveConfig() end)
    CreateSlider(s, "Stretch Y Scale", 50, 119, cfgData.stretchY, function(v) stretchY = v; cfgData.stretchY = v; SaveConfig() end)
end

do
    local s = CreateSection(tabFX.Left, "World & Visual FX")
    CreateToggle(s, "Movement Trail", cfgData.trailEnabled, function(st) trailEnabled = st; cfgData.trailEnabled = st; updateTrail(st); SaveConfig() end)
    CreateToggle(s, "Screen Vignette", cfgData.vignetteEnabled, function(st) vignetteEnabled = st; cfgData.vignetteEnabled = st; updateVignette(st); SaveConfig() end)
    CreateToggle(s, "Jump Land Ring", cfgData.jumpRingEnabled, function(st) jumpRingEnabled = st; cfgData.jumpRingEnabled = st; SaveConfig() end)
end

do
    local s = CreateSection(tabSettings.Left, "Menu Configuration")
    CreateSlider(s, "UI Scale", 70, 130, 100, function(v) MainScale.Scale = v / 100 end)
    CreateButton(s, "Unload Script", Unload)
end

-- Перетаскивание и бинды
local dragging, dragStart, startPos = false, nil, nil
MainFrame.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = i.Position; startPos = MainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(i)
    if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local delta = i.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)

UserInputService.InputBegan:Connect(function(i, gp)
    if not gp then
        if i.KeyCode == Enum.KeyCode.Insert then
            MainFrame.Visible = not MainFrame.Visible
        end
        if zoomKey and i.KeyCode == zoomKey then
            zoomActive = not zoomActive
        end
    end
end)
