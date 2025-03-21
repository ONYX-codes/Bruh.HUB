local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Bruh.HUB"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local LoadingFrame = Instance.new("Frame")
LoadingFrame.Size = UDim2.new(0, 300, 0, 150)
LoadingFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
LoadingFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
LoadingFrame.Parent = ScreenGui
local UICornerLoading = Instance.new("UICorner")
UICornerLoading.CornerRadius = UDim.new(0, 10)
UICornerLoading.Parent = LoadingFrame

local LoadingTitle = Instance.new("TextLabel")
LoadingTitle.Size = UDim2.new(1, 0, 0, 50)
LoadingTitle.BackgroundTransparency = 1
LoadingTitle.Text = "Bruh.HUB Loading..."
LoadingTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
LoadingTitle.Font = Enum.Font.SourceSansBold
LoadingTitle.TextSize = 28
LoadingTitle.Parent = LoadingFrame

local ProgressBar = Instance.new("Frame")
ProgressBar.Size = UDim2.new(0.8, 0, 0, 20)
ProgressBar.Position = UDim2.new(0.1, 0, 0.6, 0)
ProgressBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ProgressBar.Parent = LoadingFrame
local UICornerProgress = Instance.new("UICorner")
UICornerProgress.CornerRadius = UDim.new(0, 10)
UICornerProgress.Parent = ProgressBar

local ProgressFill = Instance.new("Frame")
ProgressFill.Size = UDim2.new(0, 0, 1, 0)
ProgressFill.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
ProgressFill.Parent = ProgressBar
local UICornerFill = Instance.new("UICorner")
UICornerFill.CornerRadius = UDim.new(0, 10)
UICornerFill.Parent = ProgressFill

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 500)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.BackgroundTransparency = 1
MainFrame.Visible = true
MainFrame.ZIndex = 1
MainFrame.Parent = ScreenGui
local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 35)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 60, 60))
})
UIGradient.Parent = MainFrame
local UICornerMain = Instance.new("UICorner")
UICornerMain.CornerRadius = UDim.new(0, 15)
UICornerMain.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Title.Text = "Bruh.HUB v2.0"
Title.TextColor3 = Color3.fromRGB(0, 255, 150)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 26
Title.BackgroundTransparency = 1
Title.TextTransparency = 1
Title.ZIndex = 2
Title.Parent = MainFrame
UICornerMain:Clone().Parent = Title

local features = {
    ESP = false,
    Fly = false,
    Speed = false,
    InfJump = false,
    Noclip = false
}

local function createToggle(name, yPos, callback)
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0, 260, 0, 50)
    ToggleButton.Position = UDim2.new(0, 20, 0, yPos)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    ToggleButton.Text = name .. ": OFF"
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.Font = Enum.Font.SourceSans
    ToggleButton.TextSize = 20
    ToggleButton.BackgroundTransparency = 1
    ToggleButton.TextTransparency = 1
    ToggleButton.ZIndex = 2
    ToggleButton.Parent = MainFrame
    UICornerMain:Clone().Parent = ToggleButton

    local state = false
    ToggleButton.MouseButton1Click:Connect(function()
        state = not state
        features[name] = state
        ToggleButton.Text = name .. ": " .. (state and "ON" or "OFF")
        TweenService:Create(ToggleButton, TweenInfo.new(0.3), {
            BackgroundColor3 = state and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(45, 45, 45)
        }):Play()
        callback(state)
    end)
end

local function updateESP(enabled)
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local highlight = player.Character:FindFirstChild("BruhESP")
            if enabled then
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "BruhESP"
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.Parent = player.Character
                end
            elseif highlight then
                highlight:Destroy()
            end
        end
    end
end

local flying = false
local function toggleFly(enabled)
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = character.HumanoidRootPart
    flying = enabled

    if enabled then
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Name = "FlyVelocity"
        bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.Parent = hrp

        spawn(function()
            while flying and hrp do
                local cam = workspace.CurrentCamera
                local moveDir = Vector3.new()
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    moveDir = moveDir + cam.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    moveDir = moveDir - cam.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    moveDir = moveDir - cam.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    moveDir = moveDir + cam.CFrame.RightVector
                end
                bodyVelocity.Velocity = moveDir * 50
                wait()
            end
            if hrp:FindFirstChild("FlyVelocity") then
                hrp.FlyVelocity:Destroy()
            end
        end)
    elseif hrp:FindFirstChild("FlyVelocity") then
        flying = false
        hrp.FlyVelocity:Destroy()
    end
end

local defaultSpeed = 16
local function toggleSpeed(enabled)
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = enabled and 50 or defaultSpeed
    end
end

local infJump = false
local function toggleInfJump(enabled)
    infJump = enabled
    UserInputService.JumpRequest:Connect(function()
        if infJump and LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)
end

local noclip = false
local function toggleNoclip(enabled)
    noclip = enabled
    spawn(function()
        while noclip and LocalPlayer.Character do
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = not noclip
                end
            end
            RunService.Stepped:Wait()
        end
        if not noclip and LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end)
end

createToggle("ESP", 70, updateESP)
createToggle("Fly", 130, toggleFly)
createToggle("Speed", 190, toggleSpeed)
createToggle("InfJump", 250, toggleInfJump)
createToggle("Noclip", 310, toggleNoclip)

local TeleportLabel = Instance.new("TextLabel")
TeleportLabel.Size = UDim2.new(0, 260, 0, 30)
TeleportLabel.Position = UDim2.new(0, 20, 0, 370)
TeleportLabel.BackgroundTransparency = 1
TeleportLabel.Text = "Click to teleport to a player"
TeleportLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
TeleportLabel.Font = Enum.Font.SourceSans
TeleportLabel.TextSize = 16
TeleportLabel.TextTransparency = 1
TeleportLabel.ZIndex = 3
TeleportLabel.Parent = MainFrame

local TeleportFrame = Instance.new("Frame")
TeleportFrame.Size = UDim2.new(0, 260, 0, 30)
TeleportFrame.Position = UDim2.new(0, 20, 0, 370)
TeleportFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
TeleportFrame.BackgroundTransparency = 1
TeleportFrame.ZIndex = 2
TeleportFrame.Parent = MainFrame
UICornerMain:Clone().Parent = TeleportFrame

local TeleportDropdown = Instance.new("TextButton")
TeleportDropdown.Size = UDim2.new(1, 0, 1, 0)
TeleportDropdown.BackgroundTransparency = 1
TeleportDropdown.Text = "Teleport to Player"
TeleportDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
TeleportDropdown.Font = Enum.Font.SourceSans
TeleportDropdown.TextSize = 18
TeleportDropdown.TextTransparency = 1
TeleportDropdown.ZIndex = 2
TeleportDropdown.Parent = TeleportFrame

local DropdownList = Instance.new("Frame")
DropdownList.Size = UDim2.new(0, 260, 0, 0)
DropdownList.Position = UDim2.new(0, 0, 1, 0)
DropdownList.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
DropdownList.BackgroundTransparency = 1
DropdownList.Visible = false
DropdownList.ZIndex = 3
DropdownList.Parent = TeleportFrame
UICornerMain:Clone().Parent = DropdownList

local function updateDropdown()
    for _, v in pairs(DropdownList:GetChildren()) do
        if v:IsA("TextButton") then v:Destroy() end
    end
    local yOffset = 0
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local PlayerButton = Instance.new("TextButton")
            PlayerButton.Size = UDim2.new(1, 0, 0, 30)
            PlayerButton.Position = UDim2.new(0, 0, 0, yOffset)
            PlayerButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            PlayerButton.Text = player.Name
            PlayerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            PlayerButton.Font = Enum.Font.SourceSans
            PlayerButton.TextSize = 16
            PlayerButton.ZIndex = 3
            PlayerButton.Parent = DropdownList
            UICornerMain:Clone().Parent = PlayerButton

            PlayerButton.MouseButton1Click:Connect(function()
                local char = LocalPlayer.Character
                local targetChar = player.Character
                if char and targetChar and char:FindFirstChild("HumanoidRootPart") and targetChar:FindFirstChild("HumanoidRootPart") then
                    char.HumanoidRootPart.CFrame = targetChar.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
                end
                DropdownList.Visible = false
            end)
            yOffset = yOffset + 30
        end
    end
    DropdownList.Size = UDim2.new(0, 260, 0, yOffset)
end

TeleportDropdown.MouseButton1Click:Connect(function()
    DropdownList.Visible = not DropdownList.Visible
    if DropdownList.Visible then updateDropdown() end
end)

Players.PlayerAdded:Connect(function(player)
    if features.ESP then
        player.CharacterAdded:Connect(function(char)
            wait(1)
            updateESP(true)
        end)
    end
end)

local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

RunService.RenderStepped:Connect(function()
    if dragging and dragInput then
        local delta = dragInput.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

MainFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

local function loadGUI()
    local tween = TweenService:Create(ProgressFill, TweenInfo.new(2, Enum.EasingStyle.Linear), {
        Size = UDim2.new(1, 0, 1, 0)
    })
    tween:Play()
    tween.Completed:Wait()

    local fadeOut = TweenService:Create(LoadingFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
        BackgroundTransparency = 1
    })
    fadeOut:Play()
    TweenService:Create(LoadingTitle, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    TweenService:Create(ProgressBar, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    TweenService:Create(ProgressFill, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    fadeOut.Completed:Wait()
    LoadingFrame:Destroy()

    local fadeIn = TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
        BackgroundTransparency = 0
    })
    fadeIn:Play()

    for _, child in pairs(MainFrame:GetChildren()) do
        if child:IsA("TextLabel") or child:IsA("TextButton") then
            TweenService:Create(child, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
        end
        if child:IsA("Frame") or child:IsA("TextButton") then
            TweenService:Create(child, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play()
        end
    end
    fadeIn.Completed:Wait()
end

spawn(loadGUI)

print("Bruh.HUB v2.0 with updated teleport text loaded!")
