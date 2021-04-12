if game.PlaceId == 286090429 then
Client = {
    Modules = {
        ClientEnvoirment,
        ClientMain,
        CreateProj,
        CretTrail,
        ModsShit
    },
    Toggles = {
        Walkspeed = false,
        JumpPower = false,
        BHop = false,
        InstantRespawn = false,
        AntiAim = false,
        AutoAmmo = false,
        AutoHealth = false,
        Godmode = false,
        CrazyArrows = false,
        FFA = false,
        Baseball = false,
        Snow = false,
        Trac = false,
        Sight = false,
        FOV = false,
        GreenSmoke = false,
        Visiblecheck = false,
        SilentAim = false,
        FireRate = false,
        Bombs = false
    },
    Values = {
        JumpPower = 50,
        LookMeth = 'Look Up',
        FOV = 150,
        ChatMsg = 'DarkHub Winning',
        AimPart = 'Head'
    }
}

local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/whiteyume1/whiteyume1/main/darkhubuilib.lua"))()
main = lib:Window()
CombatW = main:Tab('Combat')
PlayerW = main:Tab('LocalPlayer')
ServerW = main:Tab('Trolling')
VisualsW = main:Tab('Visuals')
FarmingW = main:Tab('Farming')
MiscW = main:Tab('Misc')

--GC
for i,v in pairs(getgc(true)) do
    if type(v) == 'table' and rawget(v,'updateInventory') and rawget(v,'firebullet') then
        Client.Modules.ClientEnvoirment = getfenv(v.firebullet)
        Client.Modules.ClientMain = v.firebullet
        Client.Modules.ModsShit = v.updateInventory
    end
    if type(v) == 'table' and rawget(v,'CreateProjectile') then
        Client.Modules.CreateProj = v.CreateProjectile
    end
    if type(v) == 'table' and rawget(v,'createtrail') then
        Client.Modules.CretTrail = v.createtrail
    end
end

--Framework
function KillAll()
    local Gun = game.ReplicatedStorage.Weapons:FindFirstChild(game.Players.LocalPlayer.NRPBS.EquippedTool.Value);
    local Crit = math.random() > .6 and true or false;
    for i,v in pairs(game.Players:GetPlayers()) do
        if v and v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
            for i =1,10 do
                local Distance = (game.Players.LocalPlayer.Character.Head.Position - v.Character.Head.Position).magnitude 
                game.ReplicatedStorage.Events.HitPart:FireServer(v.Character.Head, -- Hit Part
                v.Character.Head.Position + Vector3.new(math.random(), math.random(), math.random()), -- Hit Position
                Gun.Name, 
                Crit and 2 or 1, 
                Distance,
                Backstab, 
                Crit, 
                false, 
                1, 
                false, 
                Gun.FireRate.Value,
                Gun.ReloadTime.Value,
                Gun.Ammo.Value,
                Gun.StoredAmmo.Value,
                Gun.Bullets.Value,
                Gun.EquipTime.Value,
                Gun.RecoilControl.Value,
                Gun.Auto.Value,
                Gun['Speed%'].Value,
                game.ReplicatedStorage.wkspc.DistributedTime.Value);
            end 
        end
    end
end
local CurrentCamera = workspace.CurrentCamera
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
function ClosestPlayer()
    local MaxDist, Closest = math.huge
    for i,v in pairs(Players.GetPlayers(Players)) do
        if v ~= LocalPlayer and v.Team ~= LocalPlayer.Team and v.Character then
            local Head = v.Character.FindFirstChild(v.Character, "Head")
            if Head then 
                local Pos, Vis = CurrentCamera.WorldToScreenPoint(CurrentCamera, Head.Position)
                if Vis then
                    local MousePos, TheirPos = Vector2.new(Mouse.X, Mouse.Y), Vector2.new(Pos.X, Pos.Y)
                    local Dist = (TheirPos - MousePos).Magnitude
                    if Dist < MaxDist and Dist <= Client.Values.FOV then
                        MaxDist = Dist
                        Closest = v
                    end
                end
            end
        end
    end
    return Closest
end

function GetAimPart()
    if Client.Values.AimPart == 'Head' then
        return 'Head'
    end
    if Client.Values.AimPart == 'LowerTorso' then
        return 'LowerTorso'
    end
    if Client.Values.AimPart == 'Random' then
        if math.random(1,4) == 1 then
            return 'Head'
        else
            return 'LowerTorso'
        end
    end
end

local mt = getrawmetatable(game)
local namecallold = mt.__namecall
local index = mt.__index
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    local Args = {...}
    NamecallMethod = getnamecallmethod()
    if tostring(NamecallMethod) == "FindPartOnRayWithIgnoreList" and Client.Toggles.WallBang then
        table.insert(Args[2], workspace.Map)
    end
    if NamecallMethod == "FindPartOnRayWithIgnoreList" and not checkcaller() and Client.Toggles.SilentAim then
        local CP = ClosestPlayer()
        if CP and CP.Character and CP.Character.FindFirstChild(CP.Character, GetAimPart()) then
            Args[1] = Ray.new(CurrentCamera.CFrame.Position, (CP.Character[GetAimPart()].Position - CurrentCamera.CFrame.Position).Unit * 1000)
            return namecallold(self, unpack(Args))
        end
    end
    if tostring(NamecallMethod) == "FireServer" and tostring(self) == "ControlTurn" then
        if Client.Toggles.AntiAim == true then
            if Client.Values.LookMeth == "Look Up" then
                Args[1] = 1.3962564026167
            end
            if Client.Values.LookMeth == "Look Down" then
                Args[1] = -1.5962564026167
            end
            if Client.Values.LookMeth == "Torso In Legs" then
                Args[1] = -6.1;
            end
            return namecallold(self, unpack(Args))
        end
    end
    return namecallold(self, ...)
end)
setreadonly(mt, true)
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.NumSides = 460
FOVCircle.Filled = false
FOVCircle.Transparency = 0.6
FOVCircle.Radius = Client.Values.FOV
FOVCircle.Color = Color3.new(0,255,0)
game:GetService("RunService").Stepped:Connect(function()
    if Client.Toggles.FireRate == true then
        Client.Modules.ClientEnvoirment.DISABLED = false
        Client.Modules.ClientEnvoirment.DISABLED2 = false
    end
    if Client.Toggles.NoRecoil == true then
        Client.Modules.ClientEnvoirment.recoil = 0
    end
    if Client.Toggles.NoSpread == true then
        Client.Modules.ClientEnvoirment.currentspread = 0
        Client.Modules.ClientEnvoirment.spreadmodifier = 0
    end
    if Client.Toggles.AlwaysAuto == true then
        Client.Modules.ClientEnvoirment.mode = 'automatic'
    end
    if Client.Toggles.InfAmmo == true then
        debug.setupvalue(Client.Modules.ModsShit, 3, 70)
    end
    FOVCircle.Radius = Client.Values.FOV
    if Client.Toggles.FOV == true then
        FOVCircle.Visible = true
    else
        FOVCircle.Visible = false
    end
    FOVCircle.Position = game:GetService('UserInputService'):GetMouseLocation()
end)
spawn(function()
    while true do wait()
        if Client.Toggles.KillAura then
            for i,v in pairs(game.Players:GetPlayers()) do
                if v and v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then    
                    local Distance = (game.Players.LocalPlayer.Character.PrimaryPart.Position - v.Character.PrimaryPart.Position).magnitude 
                    if Distance <= 12 then
                        game:GetService("ReplicatedStorage").Events.FallDamage:FireServer(1000, v.Character:FindFirstChild("Hitbox"))
                    end
                end
            end
        end
    end
end)
game:GetService("RunService").Stepped:Connect(function()
    if Client.Toggles.CrazyArrows == true then
        if Client.Toggles.FFA == false then
            for i, v in pairs(game.Players:GetPlayers()) do
                if v.Team ~= game.Players.LocalPlayer.Team and v ~= game.Players.LocalPlayer then
                    YesTable = {
                        [1] = game:GetService("Workspace").Map.Clips,
                        [2] = game:GetService("Workspace").Debris,
                        [3] = game.Players.LocalPlayer.Character,
                        [4] = game:GetService("Workspace")["Ray_Ignore"],
                        [5] = game:GetService("Workspace").Map.Spawns,
                        [6] = game:GetService("Workspace").Map.Ignore
                    }
                    for i, v in pairs(game.Players:GetPlayers()) do
                        if v.Character then
                            YesTable[6 + i] = v
                        end
                    end
                    local v1 = {
                        [1] = "Arrow",
                        [2] = 800,
                        [3] = v.Character.Head.Position,
                        [4] = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame,
                        [5] = 100,
                        [6] = 0,
                        [7] = 0,
                        [8] = 0,
                        [9] = "Crossbow",
                        [10] = game.Players.LocalPlayer.Character.HumanoidRootPart.Position,
                        [11] = false,
                        [13] = YesTable,
                        [15] = false,
                        [16] = 142.0182788372
                    }
                    local rem = game:GetService("ReplicatedStorage").Events.ReplicateProjectile
                    rem:FireServer(v1)
                    Client.Modules.CreateProj(game.Players.LocalPlayer.Name, unpack(v1))
                end
            end
        else
            for i, v in pairs(game.Players:GetPlayers()) do
                if v ~= game.Players.LocalPlayer then
                    YesTable = {
                        [1] = game:GetService("Workspace").Map.Clips,
                        [2] = game:GetService("Workspace").Debris,
                        [3] = game.Players.LocalPlayer.Character,
                        [4] = game:GetService("Workspace")["Ray_Ignore"],
                        [5] = game:GetService("Workspace").Map.Spawns,
                        [6] = game:GetService("Workspace").Map.Ignore
                    }
                    for i, v in pairs(game.Players:GetPlayers()) do
                        if v.Character then
                            YesTable[6 + i] = v
                        end
                    end
                    local v1 = {
                        [1] = "Arrow",
                        [2] = 800,
                        [3] = v.Character.Head.Position,
                        [4] = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame,
                        [5] = 100,
                        [6] = 0,
                        [7] = 0,
                        [8] = 0,
                        [9] = "Crossbow",
                        [10] = game.Players.LocalPlayer.Character.HumanoidRootPart.Position,
                        [11] = false,
                        [13] = YesTable,
                        [15] = false,
                        [16] = 142.0182788372
                    }
                    local rem = game:GetService("ReplicatedStorage").Events.ReplicateProjectile
                    rem:FireServer(v1)
                    Client.Modules.CreateProj(game.Players.LocalPlayer.Name, unpack(v1))
                end
            end
        end
    end
end)

spawn(function()
    while true do
        wait(0.1)
        pcall(function()
            if Client.Toggles.Baseball then
                for i, v in pairs(game.Players:GetPlayers()) do
                    YesTable = {
                        [1] = game:GetService("Workspace").Map.Clips,
                        [2] = game:GetService("Workspace").Debris,
                        [3] = game.Players.LocalPlayer.Character,
                        [4] = game:GetService("Workspace")["Ray_Ignore"],
                        [5] = game:GetService("Workspace").Map.Spawns,
                        [6] = game:GetService("Workspace").Map.Ignore
                    }
                    for i, v in pairs(game.Players:GetPlayers()) do
                        if v.Character then
                            YesTable[6 + i] = v
                        end
                    end
                    local v1 = {
                        [1] = "Baseball",
                        [2] = 173,
                        [3] = v.Character.Head.Position,
                        [4] = v.Character.HumanoidRootPart.CFrame + Vector3.new(-10, math.random(0, 15), 0),
                        [5] = 100,
                        [6] = 0,
                        [7] = 0,
                        [8] = 0,
                        [9] = "Baseball Launcher",
                        [10] = v.Character.HumanoidRootPart.Position,
                        [11] = false,
                        [13] = YesTable,
                        [15] = false,
                        [16] = 142.0182788372
                    }
                    local rem = game:GetService("ReplicatedStorage").Events.ReplicateProjectile
                
                    rem:FireServer(v1)
                    Client.Modules.CreateProj(v.Name, unpack(v1))
                end       
                for i, v in pairs(game.Players:GetPlayers()) do
                    YesTable = {
                        [1] = game:GetService("Workspace").Map.Clips,
                        [2] = game:GetService("Workspace").Debris,
                        [3] = game.Players.LocalPlayer.Character,
                        [4] = game:GetService("Workspace")["Ray_Ignore"],
                        [5] = game:GetService("Workspace").Map.Spawns,
                        [6] = game:GetService("Workspace").Map.Ignore
                    }
                    for i, v in pairs(game.Players:GetPlayers()) do
                        if v.Character then
                            YesTable[6 + i] = v
                        end
                    end
                    local v1 = {
                        [1] = "Baseball",
                        [2] = 173,
                        [3] = v.Character.Head.Position,
                        [4] = v.Character.HumanoidRootPart.CFrame + Vector3.new(-10, math.random(0, 15), 0),
                        [5] = 100,
                        [6] = 0,
                        [7] = 0,
                        [8] = 0,
                        [9] = "Baseball Launcher",
                        [10] = v.Character.HumanoidRootPart.Position,
                        [11] = false,
                        [13] = YesTable,
                        [15] = false,
                        [16] = 142.0182788372
                    }
                    local rem = game:GetService("ReplicatedStorage").Events.ReplicateProjectile
                
                    rem:FireServer(v1)
                    Client.Modules.CreateProj(v.Name, unpack(v1))
                end       
            end 
        end)
    end
end)
spawn(function()
    while true do
        wait(0)
        pcall(function()
            if Client.Toggles.Snow then
                for i, v in pairs(game.Players:GetPlayers()) do
                    YesTable = {
                        [1] = game:GetService("Workspace").Map.Clips,
                        [2] = game:GetService("Workspace").Debris,
                        [3] = game.Players.LocalPlayer.Character,
                        [4] = game:GetService("Workspace")["Ray_Ignore"],
                        [5] = game:GetService("Workspace").Map.Spawns,
                        [6] = game:GetService("Workspace").Map.Ignore
                    }
                    for i, v in pairs(game.Players:GetPlayers()) do
                        if v.Character then
                            YesTable[6 + i] = v
                        end
                    end
                    local v1 = {
                        [1] = "Baseball",
                        [2] = 173,
                        [3] = v.Character.Head.Position,
                        [4] = v.Character.HumanoidRootPart.CFrame + Vector3.new(-10, math.random(0, 15), 0),
                        [5] = 100,
                        [6] = 0,
                        [7] = 0,
                        [8] = 0,
                        [9] = "Snowball",
                        [10] = v.Character.HumanoidRootPart.Position,
                        [11] = false,
                        [13] = YesTable,
                        [15] = false,
                        [16] = 142.0182788372
                    }
                    local rem = game:GetService("ReplicatedStorage").Events.ReplicateProjectile
                
                    rem:FireServer(v1)
                    Client.Modules.CreateProj(v.Name, unpack(v1))
                    YesTable = {
                        [1] = game:GetService("Workspace").Map.Clips,
                        [2] = game:GetService("Workspace").Debris,
                        [3] = game.Players.LocalPlayer.Character,
                        [4] = game:GetService("Workspace")["Ray_Ignore"],
                        [5] = game:GetService("Workspace").Map.Spawns,
                        [6] = game:GetService("Workspace").Map.Ignore
                    }
                    for i, v in pairs(game.Players:GetPlayers()) do
                        if v.Character then
                            YesTable[6 + i] = v
                        end
                    end
                    local v1 = {
                        [1] = "Baseball",
                        [2] = 173,
                        [3] = v.Character.Head.Position,
                        [4] = v.Character.HumanoidRootPart.CFrame + Vector3.new(-10, math.random(0, 15), 0),
                        [5] = 100,
                        [6] = 0,
                        [7] = 0,
                        [8] = 0,
                        [9] = "Snowball",
                        [10] = v.Character.HumanoidRootPart.Position,
                        [11] = false,
                        [13] = YesTable,
                        [15] = false,
                        [16] = 142.0182788372
                    }
                    local rem = game:GetService("ReplicatedStorage").Events.ReplicateProjectile
                
                    rem:FireServer(v1)
                    Client.Modules.CreateProj(v.Name, unpack(v1))
                end       
            end
            if Client.Toggles.Bombs then
                for i, v in pairs(game.Players:GetPlayers()) do
                    YesTable = {
                        [1] = game:GetService("Workspace").Map.Clips,
                        [2] = game:GetService("Workspace").Debris,
                        [3] = game.Players.LocalPlayer.Character,
                        [4] = game:GetService("Workspace")["Ray_Ignore"],
                        [5] = game:GetService("Workspace").Map.Spawns,
                        [6] = game:GetService("Workspace").Map.Ignore
                    }
                    for i, v in pairs(game.Players:GetPlayers()) do
                        if v.Character then
                            YesTable[6 + i] = v
                        end
                    end
                    local v1 = {
                        [1] = "Baseball",
                        [2] = 173,
                        [3] = v.Character.Head.Position,
                        [4] = v.Character.HumanoidRootPart.CFrame + Vector3.new(-10, math.random(0, 15), 0),
                        [5] = 100,
                        [6] = 0,
                        [7] = 0,
                        [8] = 0,
                        [9] = "Flaming Pumpkin",
                        [10] = v.Character.HumanoidRootPart.Position,
                        [11] = false,
                        [13] = YesTable,
                        [15] = false,
                        [16] = 142.0182788372
                    }
                    local rem = game:GetService("ReplicatedStorage").Events.ReplicateProjectile
                
                    rem:FireServer(v1)
                    Client.Modules.CreateProj(v.Name, unpack(v1))
                end       
            end 
        end)
    end
end)
spawn(function()
    while true do
        wait(0)
        pcall(function()
            if Client.Toggles.Trac then
                for i, v in pairs(game.Players:GetPlayers()) do
                        if v ~= game.Players.LocalPlayer then
                        local userdata_1 = game.Players.LocalPlayer.Character.PrimaryPart.CFrame * CFrame.Angles(0,0,0);
                        local userdata_2 = game.workspace.CurrentCamera.CFrame.lookVector
                        Camera = game.workspace.CurrentCamera
                        Camera  = {
                            CFrame = CFrame.new(Camera.CFrame.p,v.Character.Head.Position)
                        }
                        x = (Camera.CFrame).LookVector
                        YesTable = {
                            [1] = game:GetService("Workspace").Map.Clips, 
                            [2] = game:GetService("Workspace").Debris, 
                            [3] = game.Players.LocalPlayer.Character, 
                            [4] = game:GetService("Workspace")["Ray_Ignore"], 
                            [5] = game:GetService("Workspace").Map.Spawns, 
                            [6] = game:GetService("Workspace").Map.Ignore
                        }
                        for i,v in pairs(game.Players:GetPlayers()) do
                            if v.Character then
                                YesTable[6+i] = v
                            end
                        end
                        local userdata_2 = x
                        local table_1 = YesTable
                        local userdata_3 = Color3.fromRGB(math.random(1,255),math.random(1,255),math.random(1,255));
                        local string_1 = "Railgun";
                        local userdata_4 = game.Players.LocalPlayer.Character.PrimaryPart;
                        local Target = game:GetService("ReplicatedStorage").Events.Trail;
                        Target:FireServer(userdata_1, userdata_2, table_1, userdata_3, string_1, userdata_4);
                        Client.Modules.CretTrail(userdata_1, userdata_2, table_1, userdata_3, string_1, userdata_4,game.Players.LocalPlayer.Name)
                    end
                end       
            end 
        end)
    end
end)
spawn(function()
    while true do
        wait(0)
        pcall(function()
            if Client.Toggles.Sight then
                local userdata_1 = game.Players.LocalPlayer.Character.PrimaryPart.CFrame * CFrame.Angles(0,0,0);
                local userdata_2 = (game.workspace.CurrentCamera.CFrame.lookVector * 999)
                local table_1 = {
                workspace.Map.Clips,
                game.Workspace.Debris,
                game.Players.LocalPlayer.Character,
                game.Workspace.Ray_Ignore,
                workspace.CurrentCamera,
                game.Workspace:WaitForChild("Map"):WaitForChild("Spawns"),
                game.Workspace:WaitForChild("Map"):WaitForChild("Ignore")
                }
                local userdata_3 = Color3.fromRGB(math.random(1,255),math.random(1,255),math.random(1,255));
                local string_1 = "Railgun";
                local userdata_4 = game.Players.LocalPlayer.Character.PrimaryPart;
                local Target = game:GetService("ReplicatedStorage").Events.Trail;
                Target:FireServer(userdata_1, userdata_2, table_1, userdata_3, string_1, userdata_4);
                Client.Modules.CretTrail(userdata_1, userdata_2, table_1, userdata_3, string_1, userdata_4,game.Players.LocalPlayer.Name)
            end 
        end)
    end
end)

spawn(function()
    while true do
        wait()
        if Client.Toggles.BHop == true then
            game.Players.LocalPlayer.Character.Humanoid.Jump = true
        end
        if Client.Toggles.JumpPower == true then
            game.Players.LocalPlayer.Character.Humanoid.JumpPower = Client.Values.JumpPower
        end
        if Client.Toggles.InstantRespawn == true then
            if not game.Players.LocalPlayer.Character:FindFirstChild('Spawned') and game:GetService("Players").LocalPlayer.Character:FindFirstChild("Cam") then
                if game.Players.LocalPlayer.PlayerGui.Menew.Enabled == false then
                    game:GetService("ReplicatedStorage").Events.LoadCharacter:FireServer()
                    wait(0.5)
                end
            end
        end
    end
end)

function RandomPlr()
    tempPlrs = {}
    for i,v in pairs(game.Players:GetPlayers()) do
        if v and v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Head") and v.Team ~= game.Players.LocalPlayer.Team and v.Character:FindFirstChild("Spawned") then
            table.insert(tempPlrs,v)
        end
    end
    return tempPlrs[math.random(1,#tempPlrs)]    
end
function SwitchToKnife()
	local N = game:GetService("VirtualInputManager")
	N:SendKeyEvent(true, 51, false, game)
	N:SendKeyEvent(false, 51, false, game)	
end

function KnifeKill()
    OldPos = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
    local Crit = math.random() > .6 and true or false;
    Target = RandomPlr()
    game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(Target.Character.Head.CFrame * CFrame.new(0,2,3))
    SwitchToKnife()
    wait(.2)
    for i =1,20 do
        SwitchToKnife()
        wait()
        local Gun = game.ReplicatedStorage.Weapons:FindFirstChild(game.Players.LocalPlayer.NRPBS.EquippedTool.Value)
        game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(Target.Character.Head.CFrame * CFrame.new(0,2,3))
        local Distance = (game.Players.LocalPlayer.Character.Head.Position - Target.Character.Head.Position).magnitude 
        game.ReplicatedStorage.Events.HitPart:FireServer(Target.Character.Head, -- Hit Part
        Target.Character.Head.Position + Vector3.new(math.random(), math.random(), math.random()), -- Hit Position
        Gun.Name, 
        Crit and 2 or 1, 
        Distance,
        true, 
        Crit, 
        false, 
        1, 
        false, 
        Gun.FireRate.Value,
        Gun.ReloadTime.Value,
        Gun.Ammo.Value,
        Gun.StoredAmmo.Value,
        Gun.Bullets.Value,
        Gun.EquipTime.Value,
        Gun.RecoilControl.Value,
        Gun.Auto.Value,
        Gun['Speed%'].Value,
        game.ReplicatedStorage.wkspc.DistributedTime.Value);
    end
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = OldPos
end

--UI
CombatW:Keybind(
	"Kill All",
	Enum.KeyCode.E,
	function()
		KillAll()
	end
)
CombatW:Keybind(
	"Knife Kill",
	Enum.KeyCode.T,
	function()
		KnifeKill()
	end
)
CombatW:Toggle('Silent Aim',function(state)
    Client.Toggles.SilentAim = state
end)
CombatW:Dropdown('Aim Part',{'Head','LowerTorso','Random'},function(Selected)
    Client.Values.AimPart = Selected
end)
CombatW:Toggle('WallBang',function(state)
    Client.Toggles.WallBang = state
end)
CombatW:Toggle('Kill Aura',function(state)
	Client.Toggles.KillAura = state
end)
CombatW:Toggle('Draw FOV',function(state)
    Client.Toggles.FOV = state
end)
CombatW:Slider('FOV',10,750,function(num)
    Client.Values.FOV = num
end)
CombatW:Label('Gun Mods')
CombatW:Toggle('FireRate',function(state)
    Client.Toggles.FireRate = state
end)
CombatW:Toggle('No Recoil',function(state)
    Client.Toggles.NoRecoil = state
end)
CombatW:Toggle('No Spread',function(state)
    Client.Toggles.NoSpread = state
end)
CombatW:Toggle('Always Auto',function(state)
    Client.Toggles.AlwaysAuto = state
end)
CombatW:Toggle('Inf Ammo',function(state)
    Client.Toggles.InfAmmo = state
end)

oldWalk = Client.Modules.ClientEnvoirment.speedupdate
Client.Modules.ClientEnvoirment.speedupdate = function(...)
    if Client.Toggles.Walkspeed == true then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Client.Values.WalkSpeed
        return nil
    end
    if Client.Toggles.JumpPower == true then
        return nil
    end
    return oldWalk(...)
end
Client.Values.WalkSpeed = 16

PlayerW:Toggle('Toggle Walkspeed',function(state)
    if state == true then
        Client.Toggles.Walkspeed = true
    else
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 10
        Client.Toggles.Walkspeed = false
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 10
    end
end)
PlayerW:Slider('Walkspeed',10,300,function(num)
    if Client.Toggles.Walkspeed == true then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = num
        Client.Values.WalkSpeed = num
    end
end)

PlayerW:Toggle('Toggle JumpPower',function(state)
    if state == true then
        Client.Toggles.JumpPower = true
    else
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = 50
        Client.Toggles.JumpPower = false
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = 50
        wait()
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = 50
    end
end)
PlayerW:Slider('JumpPower',40,500,function(num)
    if Client.Toggles.JumpPower == true then
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = num
        Client.Values.JumpPower = num
    end
end)
PlayerW:Toggle('Infinite Jump', function(state)
    Client.Toggles.InfJump = state
end)
game:GetService("UserInputService").JumpRequest:connect(function()
    if Client.Toggles.InfJump == true then
        game:GetService"Players".LocalPlayer.Character:FindFirstChildOfClass'Humanoid':ChangeState("Jumping")
    end
end)

PlayerW:Toggle('BHop',function(state)
    Client.Toggles.BHop = state
end)
PlayerW:Toggle('Instant Respawn',function(state)
    Client.Toggles.InstantRespawn = state
end)
PlayerW:Toggle('Anti-Aim',function(state)
    Client.Toggles.AntiAim = state
end)
PlayerW:Dropdown('Aim Method',{'Torso In Legs','Look Up','Look Down'},function(Selected)
    Client.Values.LookMeth = Selected
end)
PlayerW:Toggle('Chat Spam',function(state)
    Client.Toggles.SpamChat = state
end)
PlayerW:Textbox(
	"Chat Message",
	true,
	function(Text)
		Client.Values.ChatMsg = tostring(Text)
	end
)

spawn(function()
    while true do
        wait(.01)
        if Client.Toggles.SpamChat == true then
            local v1 = Client.Values.ChatMsg
            local v2 = false
            local v4 = true
            local v5 = true
            local rem = game:GetService("ReplicatedStorage").Events.PlayerChatted
            rem:FireServer(v1, v2, v4, v5)
            wait(.1)
        end
    end
end)

ServerW:Toggle('Crazy Arrows',function(state)
    Client.Toggles.CrazyArrows = state
end)
ServerW:Toggle('Baseball Rain',function(state)
    Client.Toggles.Baseball = state
end)
ServerW:Toggle('Snow',function(state)
    Client.Toggles.Snow = state
end)
ServerW:Toggle('FE Tracers',function(state)
    Client.Toggles.Trac = state
end)
ServerW:Toggle('FE Laser Sight',function(state)
    Client.Toggles.Sight = state
end)
ServerW:Keybind(
    "FE Wall",
    Enum.KeyCode.F,
    function(key)
        Character = game.Players.LocalPlayer.Character
        game.ReplicatedStorage.Events.BuildWall:FireServer(Character.HumanoidRootPart.CFrame.p, Character.HumanoidRootPart.CFrame.p + Character.HumanoidRootPart.CFrame.lookVector * 999)
    end
)
local getname = function(str)
    for i,v in next, game:GetService("Players"):GetChildren() do
        if string.find(string.lower(v.Name), string.lower(str)) then
            return v.Name
        end
    end
end
function FFB(part)
    for i,v in pairs(part:GetDescendants()) do 
        game:GetService("ReplicatedStorage").Events.Whizz:FireServer(v)
    end
end

ServerW:Textbox(
	"ForceField Player",
	true,
	function(Text)
		if getname(Text) then
            FFB(game:GetService('Players')[getname(Text)].Character)
        end
	end
)
ServerW:Button("ForceField All",function()
    for i,v in pairs(game.Players:GetPlayers()) do
        if v.Character and v ~=  game.Players.LocalPlayer then
            FFB(v.Character)
        end
    end
end)

ServerW:Label('Options')
ServerW:Toggle('FFA',function(state)
    Client.Toggles.FFA = state
end)

local Config = {
    Visuals = {
        BoxEsp = false,
        TracerEsp = false,
        TracersOrigin = "Top", 
        NameEsp = false,
        DistanceEsp = false,
        SkeletonEsp = false,
        EnemyColor = Color3.fromRGB(255, 0, 0),
        TeamColor = Color3.fromRGB(0, 255, 0),
        MurdererColor = Color3.fromRGB(255, 0, 0)
    }
}

local Funcs = {}
function Funcs:IsAlive(player)
    if player and player.Character and player.Character:FindFirstChild("Head") and
            workspace:FindFirstChild(player.Character.Name)
     then
        return true
    end
end

function Funcs:Round(number)
    return math.floor(tonumber(number) + 0.5)
end

function Funcs:DrawSquare()
    local Box = Drawing.new("Square")
    Box.Color = Color3.fromRGB(190, 190, 0)
    Box.Thickness = 0.5
    Box.Filled = false
    Box.Transparency = 1
    return Box
end

function Funcs:DrawLine()
    local line = Drawing.new("Line")
    line.Color = Color3.new(190, 190, 0)
    line.Thickness = 0.5
    return line
end

function Funcs:DrawText()
    local text = Drawing.new("Text")
    text.Color = Color3.fromRGB(190, 190, 0)
    text.Size = 20
    text.Outline = true
    text.Center = true
    return text
end

local Services =
    setmetatable(
    {
        LocalPlayer = game:GetService("Players").LocalPlayer,
        Camera = workspace.CurrentCamera
    },
    {
        __index = function(self, idx)
            return rawget(self, idx) or game:GetService(idx)
        end
    }
)

function Funcs:AddEsp(player)
    local Box = Funcs:DrawSquare()
    local Tracer = Funcs:DrawLine()
    local Name = Funcs:DrawText()
    local Distance = Funcs:DrawText()
    local SnapLines = Funcs:DrawLine()
    local HeadLowerTorso = Funcs:DrawLine()
    local NeckLeftUpper = Funcs:DrawLine()
    local LeftUpperLeftLower = Funcs:DrawLine()
    local NeckRightUpper = Funcs:DrawLine()
    local RightUpperLeftLower = Funcs:DrawLine()
    local LowerTorsoLeftUpper = Funcs:DrawLine()
    local LeftLowerLeftUpper = Funcs:DrawLine()
    local LowerTorsoRightUpper = Funcs:DrawLine()
    local RightLowerRightUpper = Funcs:DrawLine()
    Services.RunService.Stepped:Connect(
        function()
            if Funcs:IsAlive(player) and player.Character:FindFirstChild("HumanoidRootPart") then
                local RootPosition, OnScreen =
                    Services.Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
                local HeadPosition =
                    Services.Camera:WorldToViewportPoint(player.Character.Head.Position + Vector3.new(0, 0.5, 0))
                local LegPosition =
                    Services.Camera:WorldToViewportPoint(
                    player.Character.HumanoidRootPart.Position - Vector3.new(0, 4, 0)
                )
                if Config.Visuals.BoxEsp then
                    Box.Visible = OnScreen
                    Box.Size = Vector2.new((2350 / RootPosition.Z) + 2.5, HeadPosition.Y - LegPosition.Y)
                    Box.Position = Vector2.new((RootPosition.X - Box.Size.X / 2) - 1, RootPosition.Y - Box.Size.Y / 2)
                else
                    Box.Visible = false
                end
                if Config.Visuals.TracerEsp then
                    Tracer.Visible = OnScreen
                    if Config.Visuals.TracersOrigin == "Top" then
                        Tracer.To = Vector2.new(Services.Camera.ViewportSize.X / 2, 0)
                        Tracer.From =
                            Vector2.new(
                            Services.Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position).X - 1,
                            RootPosition.Y + (HeadPosition.Y - LegPosition.Y) / 2
                        )
                    elseif Config.Visuals.TracersOrigin == "Middle" then
                        Tracer.To = Vector2.new(Services.Camera.ViewportSize.X / 2, Services.Camera.ViewportSize.Y / 2)
                        Tracer.From =
                            Vector2.new(
                            Services.Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position).X - 1,
                            (RootPosition.Y + (HeadPosition.Y - LegPosition.Y) / 2) -
                                ((HeadPosition.Y - LegPosition.Y) / 2)
                        )
                    elseif Config.Visuals.TracersOrigin == "Bottom" then
                        Tracer.To = Vector2.new(Services.Camera.ViewportSize.X / 2, 1000)
                        Tracer.From =
                            Vector2.new(
                            Services.Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position).X - 1,
                            RootPosition.Y - (HeadPosition.Y - LegPosition.Y) / 2
                        )
                    elseif Config.Visuals.TracersOrigin == "Mouse" then
                        Tracer.To = game:GetService("UserInputService"):GetMouseLocation()
                        Tracer.From =
                            Vector2.new(
                            Services.Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position).X - 1,
                            (RootPosition.Y + (HeadPosition.Y - LegPosition.Y) / 2) -
                                ((HeadPosition.Y - LegPosition.Y) / 2)
                        )
                    end
                else
                    Tracer.Visible = false
                end
                if Config.Visuals.NameEsp then
                    Name.Visible = OnScreen
                    Name.Position =
                        Vector2.new(
                        Services.Camera:WorldToViewportPoint(player.Character.Head.Position).X,
                        Services.Camera:WorldToViewportPoint(player.Character.Head.Position).Y - 40
                    )
                    Name.Text = "[ " .. player.Name .. " ]"
                else
                    Name.Visible = false
                end
                if Config.Visuals.DistanceEsp and player.Character:FindFirstChild("Head") then
                    Distance.Visible = OnScreen
                    Distance.Position =
                        Vector2.new(
                        Services.Camera:WorldToViewportPoint(player.Character.Head.Position).X,
                        Services.Camera:WorldToViewportPoint(player.Character.Head.Position).Y - 25
                    )
                    Distance.Text =
                        "[ " ..
                        Funcs:Round(
                            (game:GetService("Players").LocalPlayer.Character.Head.Position -
                                player.Character.Head.Position).Magnitude
                        ) ..
                            " Studs ]"
                else
                    Distance.Visible = false
                end
                if Config.Visuals.SkeletonEsp then
                    HeadLowerTorso.Visible = OnScreen
                    HeadLowerTorso.From =
                        Vector2.new(
                        Services.Camera:WorldToViewportPoint(player.Character.Head.Position).X,
                        Services.Camera:WorldToViewportPoint(player.Character.Head.Position).Y
                    )
                    HeadLowerTorso.To =
                        Vector2.new(
                        Services.Camera:WorldToViewportPoint(player.Character.LowerTorso.Position).X,
                        Services.Camera:WorldToViewportPoint(player.Character.LowerTorso.Position).Y
                    )
                    NeckLeftUpper.Visible = OnScreen
                    NeckLeftUpper.From =
                        Vector2.new(
                        Services.Camera:WorldToViewportPoint(player.Character.Head.Position).X,
                        Services.Camera:WorldToViewportPoint(player.Character.Head.Position).Y +
                            ((Services.Camera:WorldToViewportPoint(player.Character.UpperTorso.Position).Y -
                                Services.Camera:WorldToViewportPoint(player.Character.Head.Position).Y) /
                                3)
                    )
                    NeckLeftUpper.To =
                        Vector2.new(
                        Services.Camera:WorldToViewportPoint(player.Character.LeftUpperArm.Position).X,
                        Services.Camera:WorldToViewportPoint(player.Character.LeftUpperArm.Position).Y
                    )
                    LeftUpperLeftLower.Visible = OnScreen
                    LeftUpperLeftLower.From =
                        Vector2.new(
                        Services.Camera:WorldToViewportPoint(player.Character.LeftLowerArm.Position).X,
                        Services.Camera:WorldToViewportPoint(player.Character.LeftLowerArm.Position).Y
                    )
                    LeftUpperLeftLower.To =
                        Vector2.new(
                        Services.Camera:WorldToViewportPoint(player.Character.LeftUpperArm.Position).X,
                        Services.Camera:WorldToViewportPoint(player.Character.LeftUpperArm.Position).Y
                    )
                    NeckRightUpper.Visible = OnScreen
                    NeckRightUpper.From =
                        Vector2.new(
                        Services.Camera:WorldToViewportPoint(player.Character.Head.Position).X,
                        Services.Camera:WorldToViewportPoint(player.Character.Head.Position).Y +
                            ((Services.Camera:WorldToViewportPoint(player.Character.UpperTorso.Position).Y -
                                Services.Camera:WorldToViewportPoint(player.Character.Head.Position).Y) /
                                3)
                    )
                    NeckRightUpper.To =
                        Vector2.new(
                        Services.Camera:WorldToViewportPoint(player.Character.RightUpperArm.Position).X,
                        Services.Camera:WorldToViewportPoint(player.Character.RightUpperArm.Position).Y
                    )
                    RightUpperLeftLower.Visible = OnScreen
                    RightUpperLeftLower.From =
                        Vector2.new(
                        Services.Camera:WorldToViewportPoint(player.Character.RightLowerArm.Position).X,
                        Services.Camera:WorldToViewportPoint(player.Character.RightLowerArm.Position).Y
                    )
                    RightUpperLeftLower.To =
                        Vector2.new(
                        Services.Camera:WorldToViewportPoint(player.Character.RightUpperArm.Position).X,
                        Services.Camera:WorldToViewportPoint(player.Character.RightUpperArm.Position).Y
                    )
                    LowerTorsoLeftUpper.Visible = OnScreen
                    LowerTorsoLeftUpper.From =
                        Vector2.new(
                        Services.Camera:WorldToViewportPoint(player.Character.LowerTorso.Position).X,
                        Services.Camera:WorldToViewportPoint(player.Character.LowerTorso.Position).Y
                    )
                    LowerTorsoLeftUpper.To =
                        Vector2.new(
                        Services.Camera:WorldToViewportPoint(player.Character.LeftUpperLeg.Position).X,
                        Services.Camera:WorldToViewportPoint(player.Character.LeftUpperLeg.Position).Y
                    )
                    LeftLowerLeftUpper.Visible = OnScreen
                    LeftLowerLeftUpper.From =
                        Vector2.new(
                        Services.Camera:WorldToViewportPoint(player.Character.LeftLowerLeg.Position).X,
                        Services.Camera:WorldToViewportPoint(player.Character.LeftLowerLeg.Position).Y
                    )
                    LeftLowerLeftUpper.To =
                        Vector2.new(
                        Services.Camera:WorldToViewportPoint(player.Character.LeftUpperLeg.Position).X,
                        Services.Camera:WorldToViewportPoint(player.Character.LeftUpperLeg.Position).Y
                    )
                    LowerTorsoRightUpper.Visible = OnScreen
                    LowerTorsoRightUpper.From =
                        Vector2.new(
                        Services.Camera:WorldToViewportPoint(player.Character.RightLowerLeg.Position).X,
                        Services.Camera:WorldToViewportPoint(player.Character.RightLowerLeg.Position).Y
                    )
                    LowerTorsoRightUpper.To =
                        Vector2.new(
                        Services.Camera:WorldToViewportPoint(player.Character.RightUpperLeg.Position).X,
                        Services.Camera:WorldToViewportPoint(player.Character.RightUpperLeg.Position).Y
                    )
                    RightLowerRightUpper.Visible = OnScreen
                    RightLowerRightUpper.From =
                        Vector2.new(
                        Services.Camera:WorldToViewportPoint(player.Character.LowerTorso.Position).X,
                        Services.Camera:WorldToViewportPoint(player.Character.LowerTorso.Position).Y
                    )
                    RightLowerRightUpper.To =
                        Vector2.new(
                        Services.Camera:WorldToViewportPoint(player.Character.RightUpperLeg.Position).X,
                        Services.Camera:WorldToViewportPoint(player.Character.RightUpperLeg.Position).Y
                    )
                else
                    HeadLowerTorso.Visible = false
                    NeckLeftUpper.Visible = false
                    LeftUpperLeftLower.Visible = false
                    NeckRightUpper.Visible = false
                    RightUpperLeftLower.Visible = false
                    LowerTorsoLeftUpper.Visible = false
                    LeftLowerLeftUpper.Visible = false
                    LowerTorsoRightUpper.Visible = false
                    RightLowerRightUpper.Visible = false
                end
                if game.Players.LocalPlayer.TeamColor ~= player.TeamColor then
                    Box.Color = Config.Visuals.EnemyColor
                    Tracer.Color = Config.Visuals.EnemyColor
                    Name.Color = Config.Visuals.EnemyColor
                    Distance.Color = Config.Visuals.EnemyColor
                    HeadLowerTorso.Color = Config.Visuals.EnemyColor
                    NeckLeftUpper.Color = Config.Visuals.EnemyColor
                    LeftUpperLeftLower.Color = Config.Visuals.EnemyColor
                    NeckRightUpper.Color = Config.Visuals.EnemyColor
                    RightUpperLeftLower.Color = Config.Visuals.EnemyColor
                    LowerTorsoLeftUpper.Color = Config.Visuals.EnemyColor
                    LeftLowerLeftUpper.Color = Config.Visuals.EnemyColor
                    LowerTorsoRightUpper.Color = Config.Visuals.EnemyColor
                    RightLowerRightUpper.Color = Config.Visuals.EnemyColor
                else
                    Box.Color = Config.Visuals.TeamColor
                    Tracer.Color = Config.Visuals.TeamColor
                    Name.Color = Config.Visuals.TeamColor
                    Distance.Color = Config.Visuals.TeamColor
                    HeadLowerTorso.Color = Config.Visuals.TeamColor
                    NeckLeftUpper.Color = Config.Visuals.TeamColor
                    LeftUpperLeftLower.Color = Config.Visuals.TeamColor
                    NeckRightUpper.Color = Config.Visuals.TeamColor
                    RightUpperLeftLower.Color = Config.Visuals.TeamColor
                    LowerTorsoLeftUpper.Color = Config.Visuals.TeamColor
                    LeftLowerLeftUpper.Color = Config.Visuals.TeamColor
                    LowerTorsoRightUpper.Color = Config.Visuals.TeamColor
                    RightLowerRightUpper.Color = Config.Visuals.TeamColor
                end
            else
                Box.Visible = false
                Tracer.Visible = false
                Name.Visible = false
                Distance.Visible = false
                HeadLowerTorso.Visible = false
                NeckLeftUpper.Visible = false
                LeftUpperLeftLower.Visible = false
                NeckRightUpper.Visible = false
                RightUpperLeftLower.Visible = false
                LowerTorsoLeftUpper.Visible = false
                LeftLowerLeftUpper.Visible = false
                LowerTorsoRightUpper.Visible = false
                RightLowerRightUpper.Visible = false
            end
        end
    )
end

for i, v in pairs(Services.Players:GetPlayers()) do
    if v ~= Services.LocalPlayer then
        Funcs:AddEsp(v)
    end
end

Services.Players.PlayerAdded:Connect(
    function(player)
        if v ~= Services.LocalPlayer then
            Funcs:AddEsp(player)
        end
    end
)

VisualsW:Toggle('Boxs',function(state)
    Config.Visuals.BoxEsp = state
end)
VisualsW:Toggle('Tracers',function(state)
    Config.Visuals.TracerEsp = state
end)
VisualsW:Dropdown(
  "Tracers Origin", {'Top','Middle','Bottom','Mouse'}, function(selected)
    Config.Visuals.TracersOrigin = selected
end)
VisualsW:Toggle('Names',function(state)
    Config.Visuals.NameEsp = state
end)
VisualsW:Toggle('Distance',function(state)
    Config.Visuals.DistanceEsp = state
end)
VisualsW:Toggle('Skeletons',function(state)
    Config.Visuals.SkeletonEsp = state
end)
VisualsW:Colorpicker(
	"Team Color",
	Color3.fromRGB(0, 255, 0),
	function(Color)
		Config.Visuals.TeamColor = Color
	end
)
VisualsW:Colorpicker(
	"Enemy Color",
	Color3.fromRGB(255, 0, 0),
	function(Color)
		Config.Visuals.EnemyColor = Color
	end
)


--Farming Framework + UI

function fireButton1(button)
	for i,signal in next, getconnections(button.MouseButton1Click) do
		signal:Fire()
	end
	for i,signal in next, getconnections(button.MouseButton1Down) do
		signal:Fire()
	end
	for i,signal in next, getconnections(button.Activated) do
		signal:Fire()
	end
end
 
function fireButton2(button)
	for i,signal in next, getconnections(button.MouseButton2Click) do
		signal:Fire()
	end
	for i,signal in next, getconnections(button.MouseButton2Down) do
		signal:Fire()
	end
	for i,signal in next, getconnections(button.Activated) do
		signal:Fire()
	end
end

function CheckStateUI()
    if game.Players.LocalPlayer.PlayerGui.Menew.Enabled == true then
        fireButton1(game.Players.LocalPlayer.PlayerGui.Menew.Main.Play)
        wait(0.5)
        game.Players.LocalPlayer.PlayerGui.Menew.Main.Visible = false
        for i, v in pairs(game.Players.LocalPlayer.PlayerGui.GUI.TeamSelection.Buttons:GetChildren()) do
            if not v:FindFirstChild("lock").Visible == true then
                fireButton1(v)
                wait(2)
                break
            end
        end
    end
end
FarmingW:Label('Coming Soon')

MiscW:Label('DarkHub - Arsenal')
MiscW:Label('darkhub.xyz')

--Scapter stop! uwu

Allowed = {
    'RobloxGui',
    'CoreScript',
    'TopBar',
    'CoreScriptLocalization',
    'RobloxPromptGui',
    'RobloxLoadingGui',
    'PurchasePromptApp',
    'RobloxNetworkPauseNotification',
    'DarkHub',
    'DarkHubLib'
}
pcall(function()
    game.CoreGui.ChildAdded:Connect(function(tt)
        game.Players.LocalPlayer:Kick('Scapter stop owo')
        wait()
        while true do end
    end)
    for i,v in pairs(game.CoreGui:GetChildren()) do
        if not table.find(Allowed,v.Name) then
            if v.Name == 'DevConsoleMaster' then
                v:Destroy()
            else
                game.Players.LocalPlayer:Kick('Scapter stop owo')
                wait()
                while true do end
            end
        end
    end
    if hookfunction and rconsoleprint then
        hookfunction(rconsoleprint,function()
            game.Players.LocalPlayer:Kick('Scapter stop owo')
            wait()
            while true do end 
        end)    
    end
end)
end






if PlaceId == 3233893879 then
--Bad Business Script Here///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
pcall(function()

--Load UI
local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/whiteyume1/whiteyume1/main/darkhubuilib.lua"))()
main = lib:Window()
MainWindow = main:Tab('Main')
Esp = main:Tab('Esp')

--Client

Client = {
    Toggles = {
        SilentAim = false,
        FOV = false,
        NoRecoil = false,
        Fly = false
    },
    Visuals = {
        BoxEsp = false,
        TracerEsp = false,
        Names = false,
        TeamCheck = true,
        EnemyColor = Color3.fromRGB(255,0,0),
        TeamColor = Color3.fromRGB(0,255,0),
        ShowTeam = false
    },
    Values = {
        AimPart = "Head",
        FOV = 100
    }
}

--Create UI
MainWindow:Toggle('Silent Aim',function(state)
    Client.Toggles.SilentAim = state
end)
MainWindow:Toggle('Wallbang',function(state)
    local Raycast = require(game:GetService("ReplicatedStorage").TS).Raycast
    if state == true then
        debug.setupvalue(Raycast.CastGeometryAndEnemies, 1, nil)
        debug.setupvalue(Raycast.CastGeometryAndEnemies, 2, nil)
    else
        debug.setupvalue(Raycast.CastGeometryAndEnemies, 1, game:GetService('Workspace').Geometry)
        debug.setupvalue(Raycast.CastGeometryAndEnemies, 2, game:GetService('Workspace').Terrain)
    end
end)
MainWindow:Toggle('FOV Visible',function(state)
    Client.Toggles.FOV = state
end)
MainWindow:Slider('FOV',15,300,function(num)
    Client.Values.FOV = num
end)
MainWindow:Dropdown('BodyPart',{'Chest','Head'},function(Sele)
    Client.Values.AimPart = Sele
end)

MainWindow:Label('Gun Mods')
MainWindow:Toggle('No Recoil',function(state)
    Client.Toggles.NoRecoil = state
end)

MainWindow:Label('Local-Player')
MainWindow:Toggle('Fly',function(state)
    Client.Toggles.Fly = state
end)
game:GetService('UserInputService').InputBegan:connect(function(key, gpe)
    if key.KeyCode == Enum.KeyCode.LeftShift then
        Temp_Up = true
    end
    if key.KeyCode == Enum.KeyCode.LeftControl then
        Temp_Down = true
    end
end)
game:GetService('UserInputService').InputEnded:connect(function(key, gpe)
    if key.KeyCode == Enum.KeyCode.LeftShift then
        Temp_Up = false
    end
    if key.KeyCode == Enum.KeyCode.LeftControl then
        Temp_Down = false
    end
end)
Main = require(game:GetService("ReplicatedStorage"):WaitForChild("TS"));
spawn(function()
    while true do
        wait()
        pcall(function()
            if Client.Toggles.Fly == true then
                game:GetService("Workspace").Gravity = 0
                Me = Main.Characters:GetCharacter(game.Players.LocalPlayer)
                if Temp_Up == true then
                    Me.Root.Velocity = Vector3.new(0,40,0)
                end
                if Temp_Down == true then
                    Me.Root.Velocity = Vector3.new(0,-40,0)
                end
                if Temp_Down == false and Temp_Up == false then
                    if Me.Root.Velocity.Y ~= 0 then
                        Me.Root.Velocity = Vector3.new(0,0,0)
                    end
                end
            else
                game:GetService("Workspace").Gravity = 196.19999694824 
            end
        end)
    end
end)

--FOV
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.NumSides = 460
FOVCircle.Filled = false
FOVCircle.Transparency = 0.6
FOVCircle.Radius = Client.Values.FOV
FOVCircle.Color = Color3.new(0,255,0)

--Framework
local localPlayer = game:GetService("Players").LocalPlayer
local currentCamera = game:GetService("Workspace").CurrentCamera
local Mouse = localPlayer:GetMouse()
Main = require(game:GetService("ReplicatedStorage"):WaitForChild("TS"));
function GetCharacters()
    temptable = {}
        for i,v in pairs(game.Players:GetPlayers()) do
            if v.Name ~= game.Players.LocalPlayer.Name and Main.Teams:GetPlayerTeam(v) ~= Main.Teams:GetPlayerTeam(game.Players.LocalPlayer) then
                temp2 = Main.Characters:GetCharacter(v)
                table.insert(temptable,temp2)
            end
        end
    return temptable
end
function getClosestPlayerToCursor() 
    local closestPlayer = nil
    local shortestDistance = math.huge
        for i, v in pairs(GetCharacters()) do
            local pos = currentCamera:WorldToViewportPoint(v.Body.Head.Position)
            local magnitude = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).magnitude
            if magnitude < shortestDistance and magnitude <= Client.Values.FOV then
                closestPlayer = v
                shortestDistance = magnitude
            end
        end  
    return closestPlayer
end
game:GetService("RunService").Stepped:Connect(function()
    FOVCircle.Position = game:GetService('UserInputService'):GetMouseLocation()
    FOVCircle.Radius = Client.Values.FOV
    if Client.Toggles.FOV == true then
        FOVCircle.Visible = true
    else
        FOVCircle.Visible = false
    end
end)

Main = require(game:GetService("ReplicatedStorage"):WaitForChild("TS"));
Camera =  game.Workspace.CurrentCamera
Main.Input.Reticle.LookVector = function()
    if Client.Toggles.SilentAim == false then
        return game.Workspace.CurrentCamera.CFrame.LookVector
    end
    x = nil
    target = nil
    pcall(function()
        target = getClosestPlayerToCursor()
    end)
    if target == nil then
        return game.Workspace.CurrentCamera.CFrame.LookVector
    end
    Camera = game.Workspace.CurrentCamera
    xt = target
    Camera  = {
        CFrame = CFrame.new(Camera.CFrame.p,xt.Body[Client.Values.AimPart].Position)
    }
    x = (Camera.CFrame).LookVector
    if not xt:FindFirstChild('Body') or not xt.Body:FindFirstChild(Client.Values.AimPart) or x == nil then
        return game.Workspace.CurrentCamera.CFrame.LookVector
    end
    if x ~= nil then
        return x
    else
        return game.Workspace.CurrentCamera.CFrame.LookVector
    end
end
OldRecoil = Main.Camera.Recoil.Fire
Main.Camera.Recoil.Fire =  function(self, name, ...)
    local args = {...}
    if Client.Toggles.NoRecoil then
        return nil
    else
        return OldRecoil(self, name, unpack(args))
    end
end

OldShoot = Main.Network.Fire
Main.Network.Fire = function(...)
    local args = {...};
    if tostring(args[1]) == 'Admin' or tostring(args[2]) == 'Admin' then
        return
    end
    return OldShoot(...)
end

Esp:Toggle('Boxes',function(state)
    Client.Visuals.BoxEsp = state
end)
  
Esp:Toggle('Tracers',function(state)
    Client.Visuals.TracerEsp = state
end)

Esp:Toggle('Names',function(state)
    Client.Visuals.NameEsp = state
end)
Esp:Toggle('Show Team',function(state)
    Client.Visuals.ShowTeam = state
end)

function DrawSquare()
    local Box = Drawing.new("Square")
    Box.Color = Color3.fromRGB(190, 190, 0)
    Box.Thickness = 0.5
    Box.Filled = false
    Box.Transparency = 1
    return Box
end

function DrawLine()
    local line = Drawing.new("Line")
    line.Color = Color3.new(190, 190, 0)
    line.Thickness = 0.5
    return line
end

function DrawText()
    local text = Drawing.new("Text")
    text.Color = Color3.fromRGB(190, 190, 0)
    text.Size = 20
    text.Outline = true
    text.Center = true
    return text
end

--Esp Loader

function AddEsp(player)
    local Box = DrawSquare()
    local Tracer = DrawLine()
    local Name = DrawText()
    game:GetService('RunService').Stepped:Connect(function()
        pcall(function()
            if Main.Characters:GetCharacter(player) == nil or Main.Characters:GetCharacter(player).Health.Value == 0 then
                Box.Visible = false
                Tracer.Visible = false
                Name.Visible = false
            else
                if Client.Visuals.ShowTeam then
                    if Client.Visuals.TeamCheck and Main.Teams:GetPlayerTeam(player) == Main.Teams:GetPlayerTeam(game.Players.LocalPlayer) then
                        Box.Color = Client.Visuals.TeamColor
                        Tracer.Color = Client.Visuals.TeamColor
                        Name.Color = Client.Visuals.TeamColor
                    else
                        Box.Color = Client.Visuals.EnemyColor
                        Tracer.Color = Client.Visuals.EnemyColor
                        Name.Color = Client.Visuals.EnemyColor
                    end
                    if Main.Characters:GetCharacter(player).Body:FindFirstChild("Chest") and player.InMenu.Value == false then
                        local RootPosition, OnScreen = game.Workspace.CurrentCamera:WorldToViewportPoint(Main.Characters:GetCharacter(player).Body.Chest.Position)
                        local HeadPosition = game.Workspace.CurrentCamera:WorldToViewportPoint(Main.Characters:GetCharacter(player).Body.Head.Position + Vector3.new(0, 0.5, 0))
                        local LegPosition = game.Workspace.CurrentCamera:WorldToViewportPoint(Main.Characters:GetCharacter(player).Body.Chest.Position - Vector3.new(0, 4, 0))
                        if Client.Visuals.BoxEsp then
                            Box.Visible = OnScreen
                            Box.Size = Vector2.new((2350 / RootPosition.Z) + 2.5, HeadPosition.Y - LegPosition.Y)
                            Box.Position = Vector2.new((RootPosition.X - Box.Size.X / 2) - 1, RootPosition.Y - Box.Size.Y / 2)
                        else
                            Box.Visible = false
                        end
                        if Client.Visuals.TracerEsp then
                            Tracer.Visible = OnScreen
                            Tracer.To = Vector2.new(game.Workspace.CurrentCamera.ViewportSize.X / 2, 1000)
                            Tracer.From = Vector2.new(game.Workspace.CurrentCamera:WorldToViewportPoint(Main.Characters:GetCharacter(player).Body.Chest.Position).X - 1, RootPosition.Y - (HeadPosition.Y - LegPosition.Y) / 2)
                        else
                            Tracer.Visible = false
                        end
                        if Client.Visuals.NameEsp then
                            Name.Visible = OnScreen
                            Name.Position = Vector2.new(game.Workspace.CurrentCamera:WorldToViewportPoint(Main.Characters:GetCharacter(player).Body.Head.Position).X, game.Workspace.CurrentCamera:WorldToViewportPoint(Main.Characters:GetCharacter(player).Body.Head.Position).Y - 40)
                            Name.Text = player.Name
                        else
                            Name.Visible = false
                        end
                    else
                        Box.Visible = false
                        Tracer.Visible = false
                        Name.Visible = false
                    end
                    if not player then
                        Box.Visible = false
                        Tracer.Visible = false
                        Name.Visible = false
                    end
                else
                    if Main.Teams:GetPlayerTeam(player) == Main.Teams:GetPlayerTeam(game.Players.LocalPlayer) then
                        Box.Visible = false
                        Tracer.Visible = false
                        Name.Visible = false
                    end
                    if Client.Visuals.TeamCheck and Main.Teams:GetPlayerTeam(player) ~= Main.Teams:GetPlayerTeam(game.Players.LocalPlayer) then
                        Box.Color = Client.Visuals.EnemyColor
                        Tracer.Color = Client.Visuals.EnemyColor
                        Name.Color = Client.Visuals.EnemyColor
                        if Main.Characters:GetCharacter(player).Body:FindFirstChild("Chest") and player.InMenu.Value == false then
                        local RootPosition, OnScreen = game.Workspace.CurrentCamera:WorldToViewportPoint(Main.Characters:GetCharacter(player).Body.Chest.Position)
                        local HeadPosition = game.Workspace.CurrentCamera:WorldToViewportPoint(Main.Characters:GetCharacter(player).Body.Head.Position + Vector3.new(0, 0.5, 0))
                        local LegPosition = game.Workspace.CurrentCamera:WorldToViewportPoint(Main.Characters:GetCharacter(player).Body.Chest.Position - Vector3.new(0, 4, 0))
                        if Client.Visuals.BoxEsp then
                            Box.Visible = OnScreen
                            Box.Size = Vector2.new((2350 / RootPosition.Z) + 2.5, HeadPosition.Y - LegPosition.Y)
                            Box.Position = Vector2.new((RootPosition.X - Box.Size.X / 2) - 1, RootPosition.Y - Box.Size.Y / 2)
                        else
                            Box.Visible = false
                        end
                        if Client.Visuals.TracerEsp then
                            Tracer.Visible = OnScreen
                            Tracer.To = Vector2.new(game.Workspace.CurrentCamera.ViewportSize.X / 2, 1000)
                            Tracer.From = Vector2.new(game.Workspace.CurrentCamera:WorldToViewportPoint(Main.Characters:GetCharacter(player).Body.Chest.Position).X - 1, RootPosition.Y - (HeadPosition.Y - LegPosition.Y) / 2)
                        else
                            Tracer.Visible = false
                        end
                        if Client.Visuals.NameEsp then
                            Name.Visible = OnScreen
                            Name.Position = Vector2.new(game.Workspace.CurrentCamera:WorldToViewportPoint(Main.Characters:GetCharacter(player).Body.Head.Position).X, game.Workspace.CurrentCamera:WorldToViewportPoint(Main.Characters:GetCharacter(player).Body.Head.Position).Y - 40)
                            Name.Text = player.Name
                        else
                            Name.Visible = false
                        end
                    else
                        Box.Visible = false
                        Tracer.Visible = false
                        Name.Visible = false
                    end
                        if not player then
                            Box.Visible = false
                            Tracer.Visible = false
                            Name.Visible = false
                        end
                    end
                end
            end
        end)
    end)
end
  
for i, v in pairs(game:GetService('Players'):GetPlayers()) do
    if v ~= game:GetService('Players').LocalPlayer then
        AddEsp(v)
    end
end
  
game:GetService('Players').PlayerAdded:Connect(function(player)
    if v ~= game:GetService('Players').LocalPlayer then
        AddEsp(player)
    end
end)
end)
end







if PlaceId == 3527629287 then
--Big Paintball Script Here//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
local v1 = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"))
v1.Message.New("Thanks for using Dark Hub!")
v1.Message.New("Using an Alt? Make sure to use alts to keep your main safe!")  --stfu faggot adam

local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/whiteyume1/whiteyume1/main/darkhubuilib.lua"))()
main = lib:Window()

local Combat = main:Tab("Combat")
local window = main:Tab("Other")

Combat:Label("Main:")
Combat:Button(
"Unlock All Guns",
function()
    local v1 = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"))
    v1.GunCmds.DoesOwnGun = function()
        return true
    end
    local m = getrawmetatable(game)
    local runservice = game:GetService("RunService")
    local uis = game:GetService("UserInputService")
    setreadonly(m, false)
    local on = false
    local namecall = m.__namecall
    local function namecallfunction(self, ...)
        local args = {...}
        if getnamecallmethod() == "FireServer" then
            if tostring(self) == "request respawn" then
                if args[1] then
                    if args[1][1] then
                        args[1][1][1] = "1"
                    end
                end
            end
        end
        return namecall(self, unpack(args))
    end
    m.__namecall = namecallfunction
    setreadonly(m, true)
end
)
t_SilentAim = false
Combat:Toggle(
"Silent Aim",
function(State)
    t_SilentAim = State
end
)
Combat:Label("Gun Mods:")
Combat:Dropdown(
"Gun Mods",
{"Remove Firerate", "Inf Damage", "Always Automatic", "No Drop"},
function(Mod)
    if Mod == "Remove Firerate" then
        Firerate()
    end
    if Mod == "Inf Damage" then
        infD()
    end
    if Mod == "Always Automatic" then
        Auto()
    end
    if Mod == "No Drop" then
        NoDrop()
    end
end
)
function Firerate()
for i, v in pairs(getgc(true)) do
    if type(v) == "table" and rawget(v, "firerate") then
        v.firerate = 0.00001
    end
end
end
function infD()
for i, v in pairs(getgc(true)) do
    if type(v) == "table" and rawget(v, "firerate") then
        v.damage = 5000
        v.gadgetDamage = 80000
    end
end
end
function Auto()
for i, v in pairs(getgc(true)) do
    if type(v) == "table" and rawget(v, "firerate") then
        v.automatic = true
    end
end
end
function NoDrop()
for i, v in pairs(getgc(true)) do
    if type(v) == "table" and rawget(v, "firerate") then
        v.velocity = 50000
    end
end
end
Combat:Slider(
"Custom Zoom",1,6,
function(Value)
    v_ZOOM = Value
end
)

Combat:Label("Extras:")
Combat:Button(
"Destroy Drones",
function()
    for i, v in pairs(workspace["__THINGS"].Drones:GetChildren()) do
        workspace["__THINGS"]["__REMOTES"]["do drone damage"]:FireServer(
            {[1] = {[1] = v, [2] = math.huge}, [2] = {[1] = false, [2] = false}}
        )
    end
end
)
Combat:Button(
"Destroy Sentries",
function()
    for i, v in pairs(workspace["__THINGS"].Sentries:GetChildren()) do
        workspace["__THINGS"]["__REMOTES"]["do sentry damage"]:FireServer(
            {[1] = {[1] = v, [2] = math.huge}, [2] = {[1] = false, [2] = false}}
        )
    end
end
)

v_ZOOM = 2

v_AddSpeed = 1
window:Slider(
"Additional Speed",
1,
5,
function(Value)
    v_AddSpeed = Value
end
)

window:Slider(
"JumpPower",
30,
100,
function(Value)
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
end
)

--Speed Framework

local checks = {
"Ammo",
"ammo",
"Damage",
"damage",
"Firerate",
"firerate",
"FireRate",
"fireRate",
"Recoil",
"recoil",
"Spread",
"spread",
"ability",
"Ability"
}
for i, v in pairs(getgc(true)) do
for x = 1, #checks do
    if type(v) == "table" and rawget(v, checks[x]) then
        spawn(
            function()
                while true do
                    wait()
                    v.additionalSpeed = v_AddSpeed
                end
            end
        )
    end
end
end

--Zoom Framework

local checks = {
"Ammo",
"ammo",
"Damage",
"damage",
"Firerate",
"firerate",
"FireRate",
"fireRate",
"Recoil",
"recoil",
"Spread",
"spread",
"ability",
"Ability"
}
for i, v in pairs(getgc(true)) do
for x = 1, #checks do
    if type(v) == "table" and rawget(v, checks[x]) then
        spawn(
            function()
                while true do
                    wait()
                    v.zoomAmount = v_ZOOM
                end
            end
        )
    end
end
end

--Silent Aim Framework
local m = getrawmetatable(game)
local runservice = game:GetService("RunService")
local uis = game:GetService("UserInputService")
setreadonly(m, false)


function GetPlayer()
local temp_PlayerTable = {}
for i, v in pairs(game:GetService("Players"):GetPlayers()) do
    if v.Character and v ~= game:GetService("Players").LocalPlayer then
        if v.Team ~= game:GetService("Players").LocalPlayer.Team and v.Character:FindFirstChild("Humanoid") and not v.Character:FindFirstChildOfClass("ForceField") and v.Character:FindFirstChild("Head") then
            table.insert(temp_PlayerTable,v)
        end
    end
end
return temp_PlayerTable[math.random(1,#temp_PlayerTable)].Character
end

local mt = getrawmetatable(game)
local namecallold = mt.__namecall
local index = mt.__index
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
local args = {...}
if getnamecallmethod() == "FireServer" then
    if t_SilentAim == true then
        if tostring(self) == "new projectile" then
            if args[1] then
                if args[1][1] then
                    warn('roblox')
                    if #args[1][1] == 3 and GetPlayer() then
                        Targ = GetPlayer()
                        local A_1 = {
                            [1] = {
                                [1] = Targ.Humanoid,
                                [2] = args[1][1][2],
                                [3] = 235,
                                [4] = Targ.Head.Position,
                                [5] = false,
                                [6] = false,
                                [7] = false
                            },
                            [2] = {
                                [1] = false,
                                [2] = false,
                                [3] = false,
                                [4] = false,
                                [5] = false,
                                [6] = 2,
                                [7] = 2
                            }
                        }
                        game:GetService("Workspace")["__THINGS"]["__REMOTES"]["do damage"]:FireServer(A_1)
                    end
                end
            end
        end
    end
end
return namecallold(self, ...)
end)
setreadonly(mt, true)


--CrossHair Colors
function CrossHairColor(COLOR)
for i, v in pairs(game:GetService("Players").Wowtheskyispurple.PlayerGui.Crosshair.Frame:GetChildren()) do
    pcall(
        function()
            v.BackgroundColor3 = COLOR
        end
    )
end
end
--Extras

local checks = {
"Ammo",
"ammo",
"Damage",
"damage",
"Firerate",
"firerate",
"FireRate",
"fireRate",
"Recoil",
"recoil",
"Spread",
"spread",
"ability",
"Ability"
}
for i, v in pairs(getgc(true)) do
for x = 1, #checks do
    if type(v) == "table" and rawget(v, checks[x]) then
        v.description = "-Dark Hub"
    end
end
end

setting = {}

ESPBOXS = {}
ESPLINES = {}
yescolors = Color3.fromRGB(0, 255, 255)
local a
local b

function partPos(part)
return workspace.CurrentCamera:WorldToViewportPoint(part)
end
yescolors = Color3.new(1, 0, 1)
function esp(char)
coroutine.resume(
    coroutine.create(
        function()
            local espBox = Drawing.new("Square")
            espBox.Color = yescolors
            espBox.Thickness = 2
            --table.insert(ESPBOXS,espBox)
            espBox.Filled = false
            espBox.Transparency = 0.8
            game:GetService("RunService").Stepped:connect(
                function()
                    local success, response =
                        pcall(
                        function()
                            if char ~= nil then
                                local rootPos = partPos(char.HumanoidRootPart.Position)
                                local headPos = partPos(char.Head.Position + Vector3.new(0, 0.5, 0))
                                local legPos = partPos(char.HumanoidRootPart.Position - Vector3.new(0, 3, 0))
                                espBox.Size = Vector2.new(2350 / rootPos.Z, headPos.Y - legPos.Y)
                                espBox.Color = yescolors
                                espBox.Position =
                                    Vector2.new(rootPos.X - espBox.Size.X / 2, rootPos.Y - espBox.Size.Y / 2)
                            end
                            local _, screen =
                                workspace.CurrentCamera:WorldToViewportPoint(char.HumanoidRootPart.Position)
                            if
                                screen and
                                    (game.Players:GetPlayerFromCharacter(char).Team ~= game.Players.LocalPlayer.Team or
                                        setting.ffa)
                             then
                                if char.Parent == nil then
                                    espBox.Visible = false
                                end
                                if setting.esp and setting.espBox then
                                    espBox.Visible = true
                                else
                                    espBox.Visible = false
                                end
                            else
                                espBox.Visible = false
                            end
                        end
                    )
                    if not success then
                        espBox.Visible = false
                    end
                end
            )
        end
    )
)
end
for i, v in next, game.Players:GetPlayers() do
if v ~= game.Players.LocalPlayer then
    if v.Character:FindFirstChild("HumanoidRootPart") then
        esp(v.Character)
    end
    v.CharacterAdded:connect(
        function(char)
            esp(char)
        end
    )
end
end

game.Players.PlayerAdded:connect(
function(plr)
    if plr:FindFirstChild("HumanoidRootPart") then
        esp(v.Character)
    end
    plr.CharacterAdded:connect(
        function(char)
            esp(char)
        end
    )
end
)

local e = main:Tab("ESP")
e:Toggle(
"ESP",
function(state)
    setting.esp = state
end
)
e:Toggle(
"Boxes",
function(state)
    setting.espBox = state
end
)
e:Toggle(
"FFA",
function(state)
    setting.ffa = state
end
)

e:Colorpicker(
"ColorPicker",
Color3.fromRGB(0, 255, 255),
function(ColoRr)
    yescolors = ColoRr
end
)
end









if PlaceId == 263761432 then
--Horrific Housing Script Here///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
if game.CoreGui:FindFirstChild("DarkHub") then 
game.CoreGui.DarkHub:Destroy()
end

local yes = game:GetService("ReplicatedStorage").WinnerUi:Clone()
yes.Frame.Left.Title.Text = "Dark"
yes.Frame.Right.Title.Text = "Hub"
yes.Parent = game.Players.LocalPlayer.PlayerGui
repeat wait() until yes.Parent == nil

local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/whiteyume1/whiteyume1/main/darkhubuilib.lua"))()
main = lib:Window()
local Farming = main:Tab("Main")
t_Farm = false
Farming:Toggle('AutoFarm',function(state)
t_Farm = state
end)
Farming:Button('Free Grand Prize',function()
game:GetService("ReplicatedStorage").GiveGrandPrize:FireServer()
end)
Farming:Button('Get Potion',function()
game.ReplicatedStorage.EventRemotes.Potion:FireServer("Pass")
game.ReplicatedStorage.EventRemotes.Potion:FireServer("Drink")
end)
Farming:Button('Goto Lobby',function()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0.0262833498, 7.88768053, -7.52940941, 0.999931633, 0.000497492729, 0.0116874278, -2.32248567e-08, 0.99909538, -0.0425250307, -0.0116980113, 0.0425221287, 0.999027133)
end)

spawn(function()
while true do
    wait(0.2)
    if t_Farm == true then
    local v1 = "MiissionSuccess3"
    local rem = game:GetService("ReplicatedStorage").EventRemotes.GhasterBlaster
    rem:FireServer(v1)
    rem:FireServer(v1)
    rem:FireServer(v1)
    end
end        
end)
local Extra = main:Tab("Other") 

local Extras = main:Tab("LocalPlayer")
Extras:Slider("WalkSpeed",16,100, function(Value) game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value end)
Extras:Slider("JumpPower",50,100, function(Value) game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value end)
pets = {}
for i,v in pairs(game:GetService("ReplicatedStorage").Pets:GetChildren()) do
table.insert(pets,v.Name)
end

Extra:Label('Free Pets')
Extra:Dropdown("Free Pet", pets,function(NAMEERR)
if NAMEERR ~= 'Pet' then
    game.ReplicatedStorage.PetChange:FireServer(NAMEERR)
end
end)

Extra:Button('Rebirth',function()
game:GetService("ReplicatedStorage").Rebirth:FireServer()
end)
Extra:Button('Pick Up Card',function()
game.workspace.InteractionObjects.CardPickUp.Interact.Interaction:FireServer()
end)
Extra:Button('Destroy Spleef',function()
for _,v in pairs(game:GetService("Workspace").Spleef:GetDescendants()) do
    if v:IsA("TouchTransmitter") then
    firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, v.Parent, 0) --0 is touch
    wait()
    firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, v.Parent, 1) -- 1 is untouch
    end
end
end)
end










if game.PlaceId == 606849621 then
--Jailbreak Script Here //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

repeat wait() until game:IsLoaded() == true

function Notif(Text,Time)
require(game:GetService("ReplicatedStorage").Game.Notification).SetColor(Color3.fromRGB(0,0,0))
require(game:GetService("ReplicatedStorage").Game.Notification).new({
    Text = Text,
    Duration = Time
})
end

--Auto Hasher

local HasherClient = {
Modules = {
    HashTable = '',
    DonutFunc = '',
    KickFunc = '',
    HeliFunc = '',
    ExplodeWallFunc = ''
},
Hashes = {
    Donut1 = '',   
    Donut2 = '',    
    KickHash = '',  
    Team = '',      
    GiftSafe = '',  
    HeliCrate = '', 
    Interact = '',  
    Eject = '',     
    Taze = '',      
    GrabGun = ''    
}
}

--Collect All Hashes

for i,v in pairs(getgc(true)) do
if HasherClient.Modules.HashTable == '' and type(v) == 'table' then
    for i2,v2 in pairs(v) do
        if type(v2) == 'string' and v2:sub(1,1) == '!' and v2:len() > 10 then
            HasherClient.Modules.HashTable = v
        end
    end
end
--Donut1 Func
if HasherClient.Modules.DonutFunc == '' and type(v) == 'table' and rawget(v,'Fun') and rawget(v,'Part') and type(v.Fun) == 'function' and v.Part.Name == 'Donut' then
    HasherClient.Modules.DonutFunc = v.Fun
end
if HasherClient.Modules.KickFunc == '' and type(v) == 'function' and getfenv(v).script and getfenv(v).script == game:GetService('Players').LocalPlayer.PlayerScripts.LocalScript then
    if debug.getconstants(v) and table.find(debug.getconstants(v),'FailedPcall') then
        HasherClient.Modules.KickFunc = v
    end
end
if HasherClient.Modules.HeliFunc == '' and type(v) == 'table' and type(rawget(v, "Heli")) == "table" then
    HasherClient.Modules.HeliFunc = v.Heli.Update
end
if HasherClient.Modules.ExplodeWallFunc == ''  and type(v) == 'function' and getfenv(v).script and getfenv(v).script == game:GetService('Players').LocalPlayer.PlayerScripts.LocalScript then
    if debug.getconstants(v) and table.find(debug.getconstants(v),'ExplodeWall') and table.find(debug.getconstants(v),'FireServer') then
        HasherClient.Modules.ExplodeWallFunc = v
    end
end
end

--Donut 1
Donut1Constants = {}
for i,v in pairs(getconstants(HasherClient.Modules.DonutFunc)) do
if type(v) == 'string' and v ~= 'sub' and v ~= 'reverse' and v ~= 'Name' and v ~= 'tick' and v ~= 'FireServer' then
    table.insert(Donut1Constants, v)
end
end
local FF_Donut1Constants = Donut1Constants[1]
local LL_Donut1Constants = Donut1Constants[table.maxn(Donut1Constants)]
for i, v in pairs(HasherClient.Modules.HashTable) do
if string.find(i, FF_Donut1Constants) and string.find(i, LL_Donut1Constants) and FF_Donut1Constants:sub(1,1) == i:sub(1,1) and LL_Donut1Constants:sub(#LL_Donut1Constants,#LL_Donut1Constants) == i:sub(#i,#i) then
    HasherClient.Hashes.Donut1 = i
    break
end
end

--Donut 2

Donut2Func = getproto(require(game:GetService("ReplicatedStorage").Game.Item.Donut).InputBegan, 1)
Donut2Constants = {}
for i,v in pairs(getconstants(Donut2Func)) do
if type(v) == 'string' and v ~= 'sub' and v ~= 'reverse' and v ~= 'Name' and v ~= 'tick' and v ~= 'FireServer' and v ~= 'SpringItemRotation' and v ~= 'Config' and v ~= 'Motion' and v ~= 'Hip' and v ~= 'Springs' and v ~= 'ItemRotation' and v ~= 'SetTarget' and v ~= 'Local' and v ~= 'LastConsumed' then
    table.insert(Donut2Constants, v)
end
end
local FF_Donut2Constants = Donut2Constants[1]
local LL_Donut2Constants = Donut2Constants[table.maxn(Donut2Constants)]
for i, v in pairs(HasherClient.Modules.HashTable) do
if string.find(i, FF_Donut2Constants) and string.find(i, LL_Donut2Constants) and FF_Donut2Constants:sub(1,1) == i:sub(1,1) and LL_Donut2Constants:sub(#LL_Donut2Constants,#LL_Donut2Constants) == i:sub(#i,#i) then
    HasherClient.Hashes.Donut2 = i
    break
end
end

--KickHash

KickHashConstants = {}
for i,v in pairs(getconstants(HasherClient.Modules.KickFunc)) do
if type(v) == 'string' and v ~= 'sub' and v ~= 'reverse' and v ~= 'Name' and v ~= 'tick' and v ~= 'FireServer' and v ~= 'FailedPcall' and v ~= 'pcall' and v ~= '' then
    table.insert(KickHashConstants, v)
end
end
local FF_KickHashConstants = KickHashConstants[1]
local LL_KickHashConstants = KickHashConstants[table.maxn(KickHashConstants)]
for i, v in pairs(HasherClient.Modules.HashTable) do
if string.find(i, FF_KickHashConstants) and string.find(i, LL_KickHashConstants) and FF_KickHashConstants:sub(1,1) == i:sub(1,1) and LL_KickHashConstants:sub(#LL_KickHashConstants,#LL_KickHashConstants) == i:sub(#i,#i) then
    HasherClient.Hashes.KickHash = i
    break
end
end

--Team

TeamFunc = getproto(require(game:GetService("ReplicatedStorage").Game.TeamChooseUI).Show,6)
TeamConstants = {}
for i,v in pairs(getconstants(TeamFunc)) do
if type(v) == 'string' and v ~= 'sub' and v ~= 'reverse' and v ~= 'Name' and v ~= 'tick' and v ~= 'FireServer' and v ~= 'Police' and v ~= 'Prisoner' and v ~= 'assert' and v ~= '' then
    table.insert(TeamConstants, v)
end
end
local FF_TeamConstants = TeamConstants[1]
local LL_TeamConstants = TeamConstants[table.maxn(TeamConstants)]
for i, v in pairs(HasherClient.Modules.HashTable) do
if string.find(i, FF_TeamConstants) and string.find(i, LL_TeamConstants) and FF_TeamConstants:sub(1,1) == i:sub(1,1) and LL_TeamConstants:sub(#LL_TeamConstants,#LL_TeamConstants) == i:sub(#i,#i) then
    HasherClient.Hashes.Team = i
    break
end
end

--GiftSafe
SafeFunc = getproto(require(game:GetService("ReplicatedStorage").Game.SafesUI).SetupBuySafes,3)
SafeConstants = {}
for i,v in pairs(getconstants(SafeFunc)) do
if type(v) == 'string' and v ~= 'sub' and v ~= 'reverse' and v ~= 'Name' and v ~= 'tick' and v ~= 'FireServer' and v ~= '' and v ~= 'ContainerPlayerName' and v ~= 'PlayerName' and v ~= 'Text' and v ~= 'SelectedTier' and v ~= 'ContainerIcon' and v ~= 'Icon' and v ~= 'Image' and v ~= 'CloseGift' then
    table.insert(SafeConstants, v)
end
end
local FF_SafeConstants = SafeConstants[1]
local LL_SafeConstants = SafeConstants[table.maxn(SafeConstants)]
for i, v in pairs(HasherClient.Modules.HashTable) do
if string.find(i, FF_SafeConstants) and string.find(i, LL_SafeConstants) and FF_SafeConstants:sub(1,1) == i:sub(1,1) and LL_SafeConstants:sub(#LL_SafeConstants,#LL_SafeConstants) == i:sub(#i,#i) then
    HasherClient.Hashes.GiftSafe = i
end
end

--HeliCrate

HeliCrateConstants = {}
for i,v in pairs(getconstants(HasherClient.Modules.HeliFunc)) do  
if i > table.find(getconstants(HasherClient.Modules.HeliFunc), "PointToObjectSpace") and i < table.find(getconstants(HasherClient.Modules.HeliFunc), "FireServer") then
    table.insert(HeliCrateConstants, v)
end
end
local FF_HeliCrateConstants = HeliCrateConstants[1]
local LL_HeliCrateConstants = HeliCrateConstants[table.maxn(HeliCrateConstants)]
for i, v in pairs(HasherClient.Modules.HashTable) do
if string.find(i, FF_HeliCrateConstants) and string.find(i, LL_HeliCrateConstants) and FF_HeliCrateConstants:sub(1,1) == i:sub(1,1) and LL_HeliCrateConstants:sub(#LL_HeliCrateConstants,#LL_HeliCrateConstants) == i:sub(#i,#i) then
    HasherClient.Hashes.HeliCrate = i
end
end

--Interact

InteractConstants = {}
for i,v in pairs(getconstants(HasherClient.Modules.ExplodeWallFunc)) do  
if type(v) == 'string' and v ~= 'sub' and v ~= 'reverse' and v ~= 'Name' and v ~= 'tick' and v ~= 'FireServer' and v ~= '' and v ~= 'ExplodeWall' then
    table.insert(InteractConstants, v)
end
end
local FF_InteractConstants = InteractConstants[1]
local LL_InteractConstants = InteractConstants[table.maxn(InteractConstants)]
for i, v in pairs(HasherClient.Modules.HashTable) do
if string.find(i, FF_InteractConstants) and string.find(i, LL_InteractConstants) and FF_InteractConstants:sub(1,1) == i:sub(1,1) and LL_InteractConstants:sub(#LL_InteractConstants,#LL_InteractConstants) == i:sub(#i,#i) then
    HasherClient.Hashes.Interact = i
end
end

--Taze
TazeFunc = require(game:GetService('ReplicatedStorage').Game.Item.Taser).Tase
TazeConstants = {}
for i,v in pairs(getconstants(TazeFunc)) do  
if i > table.find(getconstants(TazeFunc), "GetPlayerFromCharacter") and i < table.find(getconstants(TazeFunc), "Name") and v~= "sub" and v ~= "reverse" then
    table.insert(TazeConstants, v)
end
end
local FF_TazeConstants = TazeConstants[1]
local LL_TazeConstants = TazeConstants[table.maxn(TazeConstants)]
for i, v in pairs(HasherClient.Modules.HashTable) do
if string.find(i, FF_TazeConstants) and string.find(i, LL_TazeConstants) and FF_TazeConstants:sub(1,1) == i:sub(1,1) and LL_TazeConstants:sub(#LL_TazeConstants,#LL_TazeConstants) == i:sub(#i,#i) then
    HasherClient.Hashes.Taze = i
end
end


Client = {
Hashes = {
    Donut1 = HasherClient.Hashes.Donut1,    
    Donut2 = HasherClient.Hashes.Donut2,    
    KickHash = HasherClient.Hashes.KickHash,  
    Team = HasherClient.Hashes.Team,      
    GiftSafe = HasherClient.Hashes.GiftSafe,  
    HeliCrate = HasherClient.Hashes.HeliCrate, 
    Interact = HasherClient.Hashes.Interact,  
    Taze = HasherClient.Hashes.Taze,      
},
Toggles = {
    Walkspeed = false,
    JumpPower = false,
    InfJump = false,
    NoClip = false,
    NoRagdoll = false,
    Godmode = false,
    AutoFarm = false,
    AutoArrest = false,
    RainbowNitro = false,
    RainbowCar = false,
    InfNitro = false,
    RainbowCarS = false,
    LoopExplode = false,
    LoopVolcano = false,
    LoopSewer = false,
    OpenAllDoors = false,
    NoTirePop = false
},
Values = {
    WalkSpeed = 16,
    JumpPower = 50,
    Method = 1,
    carspeed = 1,
    turnspeed = 1.5,
    suspention = 3
},
Teleports = {
    ['Jewelry Out'] = CFrame.new(156.103851, 18.540699, 1353.72388),
    ['Jewelry In'] = CFrame.new(133.300705, 17.9375954, 1316.42407),
    ['Bank Out'] = CFrame.new(11.6854906, 17.8929214, 788.188171),
    ['Bank In'] = CFrame.new(24.6513691, 19.4347649, 853.291687),
    ['Museum Out'] = CFrame.new(1103.53406, 138.152878, 1246.98511),
    ['Donut Shop'] = CFrame.new(76.4559402, 21.0584793, -1591.01416, 0.790199757, 0.156331331, -0.592574954, 0.015425493, 0.96153754, 0.274239838, 0.612655461, -0.225844979, 0.757395089),
    ['Gas Station'] = CFrame.new(-1584.1051, 18.4732189, 721.38739),
    ['PowerPlant'] = CFrame.new(702.740967, 39.0193367, 2371.88672, -0.998025119, -0.00970620103, -0.0620610416, -0.00215026829, 0.992689848, -0.120674998, 0.0627786592, -0.120303221, -0.990750134),
    ['Airport'] = CFrame.new(-1227.47449, 64.4552231, 2787.64233),
    ['Gun Shop'] = CFrame.new(-27.8670673, 17.7929249, -1774.66882),
    ['Volcano Base'] = CFrame.new(1726.72266, 50.4146309, -1745.76196),
    ['City Base'] = CFrame.new(-244.824478, 17.8677788, 1573.81616),
    ['Boat Port'] = CFrame.new(-407.957886, 22.5707016, 2049.26074, -0.976195455, 0.0327876508, -0.214399904, 0.00279002171, 0.990324318, 0.138744399, 0.216874525, 0.134843469, -0.966841578),
    ['Boat Cave'] = CFrame.new(1875.21838, 32.8055534, 1909.28687, -0.701772571, 0.0434923843, -0.711072326, -0.0087880427, 0.997530222, 0.0696865618, 0.712346911, 0.0551530346, -0.699657202),
    ['Prison Cells'] = CFrame.new(-1461.07605, -0.318537951, -1824.14917),
    ['Prison Yard'] = CFrame.new(-1219.36316, 17.7750931, -1760.8584),
    ['Prison Parking'] = CFrame.new(-1173.36951, 18.698061, -1533.47656),
    ['1M Shop'] = CFrame.new(706.598267, 20.5805721, -1573.26294),
    ['Military Base'] = CFrame.new(766.283386, 18.0144463, -324.15921),
    ['Evil Lair'] = CFrame.new(1735.52405, 18.1646328, -1726.05249),
    ['Secret Agent Base'] = CFrame.new(1506.60754, 69.8824005, 1634.42456),
    ['Garage'] = CFrame.new(-384.259521, 19.6279697, 1221.55005),
    ['Lookout'] = CFrame.new(1328.05725, 166.614426, 2609.93457),
}
}

--Bypass Anticheat
local startedTime = tick();
for i,v in pairs(getgc(true)) do
if not KickFunc and type(v) == 'function' and getfenv(v).script and getfenv(v).script == game:GetService('Players').LocalPlayer.PlayerScripts.LocalScript then
    if debug.getconstants(v) and table.find(debug.getconstants(v),'FailedPcall') then
        KickFunc = v
    end
end
end

x = debug.getupvalues(KickFunc)[1]
OldFire = getupvalue(x,18)
local FireServerHook = newcclosure(function(TEvent, Key, ...)
if Key then
    Args = {...}
    if tostring(Key) == 'JumpPower' then
        print('DEBUG : '..'ATTEMPTED KICK FOR JUMPPOWER')
        return
    end
    if string.match(tostring(Key),'NoClip') then
        print('DEBUG : '..'ATTEMPTED KICK FOR NOCLIP')
        return
    end
    if tostring(Key) == 'Getupvalues' then
        print('DEBUG : '..'ATTEMPTED KICK FOR GETUPVALUES DETECTED ENVIORMENT')
        return
    end
end
return OldFire(TEvent, Key, ...)
end)
setupvalue(x,18,FireServerHook)

if not KickFunc then
return nil 
end
Notif('Please give DarkHub some time to load!',3)


wait(0.5)
--Load GC Framework
local startedTime = tick();
for i,v in pairs(getgc(true)) do
if not Network and type(v) == 'table' and rawget(v,'FireServer') then
    Network = v
end
if not HashTable and type(v) == "table" then
    for i2,v2 in pairs(v) do
        if type(v2) == "string" and v2:sub(1,1) == "!" and v2:len() > 10 then
            HashTable = v
        end
    end
end
if not ExitCar and type(v) == "function" and getfenv(v).script == game:GetService("Players").LocalPlayer.PlayerScripts.LocalScript then
    local con = getconstants(v)
    if table.find(con, "LastVehicleExit") and table.find(con, "tick") then
        ExitCar = v
    end
end
if not Falling and type(v) == "table" and rawget(v, 'Ragdoll') and rawget(v, 'Unragdoll') then
    Falling = v
end
if not DonutFunction and type(v) == "function" and getfenv(v).script == game:GetService("ReplicatedStorage").Game.Inventory then
    DonutFunction = v
end
if not PoliceFunction and  type(v) == 'function' and getfenv(v).script and getfenv(v).script.name == 'LocalScript' then
    Cnts = debug.getconstants(v)
    if type(Cnts) == 'table' and table.find(Cnts, "ShouldArrest") and #Cnts == 3 then
        PoliceFunction = v
    end
end
if not NitroTable and type(v) == "table" and rawget(v, "Nitro") and rawget(v,'NitroLastMax') then
    Nitro = v
end
if not GarageFuncCar and type(v) == 'function' and getfenv(v).script == game:GetService('ReplicatedStorage').Game.Garage.GarageUI then
    local Right = debug.getconstants(debug.getproto(require(game:GetService('ReplicatedStorage').Game.Garage.GarageUI).Init,1))
    if unpack(debug.getconstants(v)) == unpack(Right) and not table.find(debug.getconstants(v),'Index') then
        GarageFuncCar = v
    end
end
if not PlayFunc and type(v) == "function" and getfenv(v).script == game:GetService("Players").LocalPlayer.PlayerScripts.LocalScript then
    local con = getconstants(v)
    if table.find(con, "Play") and table.find(con, "Source") and table.find(con, "FireServer") then
        PlayFunc = v
    end
end
if not DoorOpenFunc and type(v) == "function" and getfenv(v).script == game:GetService("Players").LocalPlayer.PlayerScripts.LocalScript then
    local con = getconstants(v)
    if table.find(con, "SequenceRequireState") then
        DoorOpenFunc = v
    end
end
if not BBClient and type(v) == 'table' and rawget(v,'doesPlayerOwn') then
    BBClient = v
end
end
wait(.5)
if not HashTable[Client.Hashes.KickHash] then
Notif('DEBUG : Unable to Find Kick Hash! Continue with caution!')
end

if PoliceFunction then
ArrestFunc = getupvalue(getupvalue(PoliceFunction,1),7)
end


wait(0.2)

local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/whiteyume1/whiteyume1/main/darkhubuilib.lua"))()
main = lib:Window()

local Teleports_Tab = main:Tab("Teleports")
local Farming_Tab = main:Tab('Farming')
local Player_Tab = main:Tab("LocalPlayer")
local Vehicle_Tab = main:Tab('Vehicle')
local Server_Tab = main:Tab("Server")
local Tool_Tab = main:Tab("Tools")
local Esp_Tab = main:Tab("Esp")


Temp_Tried = 0
wait(0.03)


function MyCar()
for i,v in next, game:GetService("Workspace").Vehicles:GetChildren() do
    if v.Seat.PlayerName.Value == game:GetService('Players').LocalPlayer.Name then
        return v
    end
end
end
function FindCars(Name)
local Vehicles = {}
for i,v in pairs(workspace.Vehicles:GetChildren()) do 
    if v.Name == Name and v:FindFirstChild("Seat") and v.Seat:FindFirstChild("Player") and v.Seat.Player.Value == false then 
        table.insert(Vehicles, v)
     end 
end
return Vehicles
end

function Teleport(cframe, LeaveCar)
if MyCar() ~= nil and LeaveCar then
    ExitCar()
    ExitCar()
    wait(0.3)
end
if game:GetService('Players').LocalPlayer.Character and game:GetService('Players').LocalPlayer.Character.Humanoid.Sit == true then
    MyCar():SetPrimaryPartCFrame(cframe)
    return
end
require(game:GetService('ReplicatedStorage').Game.ItemSystem.ItemSystem).Unequip()
local function FindCars(Name)
    local Vehicles = {}
    for i,v in pairs(workspace.Vehicles:GetChildren()) do 
        if v.Name == Name and v:FindFirstChild("Seat") and v.Seat:FindFirstChild("Player") and v.Seat.Player.Value == false then 
            table.insert(Vehicles, v)
        end 
    end
    return Vehicles
end
local Vehicle, EnterFunctionT = nil, nil
function SetVehicle()
    if require(game:GetService("ReplicatedStorage").Game.Vehicle).GetLocalVehicleModel() == false then
        Vehicle = FindCars("Camaro")[math.random(1, #FindCars("Camaro"))]
        for i,v in pairs(require(game:GetService('ReplicatedStorage').Module.UI).CircleAction.Specs) do
            if v.Tag and v.Tag.Name == "Seat" and v.Tag.Parent == Vehicle then
                EnterFunctionT = v
            end
        end
    else
        Vehicle = require(game:GetService("ReplicatedStorage").Game.Vehicle).GetLocalVehicleModel()
    end
end
SetVehicle()
if Vehicle then 
    workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
    local cameraCF = workspace.CurrentCamera.CFrame
    local old = Vehicle.PrimaryPart.CFrame
    wait()
    for i,v in pairs(Vehicle:GetDescendants()) do 
        if v:IsA("BasePart") then 
            v.Anchored = false    
        end    
    end
    wait(0.05)
    if EnterFunctionT and EnterFunctionT.Tag then
        for i = 1,20 do 
            game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = Vehicle.BoundingBox.CFrame + Vector3.new(0,2,0)
            game:GetService("RunService").RenderStepped:wait()
        end
        wait(0.02)
        for i = 1,5 do
            EnterFunctionT:Callback(EnterFunctionT.Tag)
            game:GetService("RunService").RenderStepped:wait()
        end
    end
    workspace.CurrentCamera.CFrame = cameraCF
    wait()
    for i,v in pairs(Vehicle:GetDescendants()) do 
        if v:IsA("BasePart") then 
            v.Anchored = true
        end    
    end
    workspace.CurrentCamera.CFrame = cameraCF
    wait(0.01)
    Vehicle:SetPrimaryPartCFrame(cframe + Vector3.new(-14,14,0))
    for i,v in pairs(Vehicle:GetDescendants()) do 
        if v:IsA("BasePart") then 
            v.Anchored = false    
        end  
    end
    if not LeaveCar then
        wait(0.2)
        Vehicle:SetPrimaryPartCFrame(cframe)
    else
        wait(0.5)
        for i = 1,3 do
            ExitCar()
        end
        wait(0.3)
        for i = 1,8 do
            wait()
            for i,v in pairs(Vehicle:GetDescendants()) do 
                if v:IsA("BasePart") then 
                    v.Anchored = true
                end    
            end
            game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0,-15,0)
            game:GetService('Players').LocalPlayer.Character:SetPrimaryPartCFrame(cframe)
            game:GetService('Players').LocalPlayer.Character.Humanoid:SetStateEnabled("FallingDown", false)
        end
        wait(0.46)
        if LeaveCar and (cframe.p - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).magnitude > 52  then 
            wait(0.5)
            Teleport(cframe, LeaveCar)
        end
    end
end
end

function RobCarTP(cframe, LeaveCar)
if Client.Toggles.AutoFarm == false then
    print('offline')
    while wait() do end
end
if MyCar() ~= nil and LeaveCar then
    ExitCar()
    ExitCar()
    wait(0.6)
end
if game:GetService('Players').LocalPlayer.Character and game:GetService('Players').LocalPlayer.Character.Humanoid.Sit == true then
    MyCar():SetPrimaryPartCFrame(cframe)
    return
end
require(game:GetService('ReplicatedStorage').Game.ItemSystem.ItemSystem).Unequip()
local function FindCars(Name)
    local Vehicles = {}
    for i,v in pairs(workspace.Vehicles:GetChildren()) do 
        if v.Name == Name and v:FindFirstChild("Seat") and v.Seat:FindFirstChild("Player") and v.Seat.Player.Value == false then 
            table.insert(Vehicles, v)
        end 
    end
    return Vehicles
end
local Vehicle, EnterFunctionT = nil, nil
function SetVehicle()
    if require(game:GetService("ReplicatedStorage").Game.Vehicle).GetLocalVehicleModel() == false then
        Vehicle = FindCars("Camaro")[math.random(1, #FindCars("Camaro"))]
        for i,v in pairs(require(game:GetService('ReplicatedStorage').Module.UI).CircleAction.Specs) do
            if v.Tag and v.Tag.Name == "Seat" and v.Tag.Parent == Vehicle then
                EnterFunctionT = v
            end
        end
    else
        Vehicle = require(game:GetService("ReplicatedStorage").Game.Vehicle).GetLocalVehicleModel()
    end
end
SetVehicle()
if Vehicle then 
    workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
    local cameraCF = workspace.CurrentCamera.CFrame
    local old = Vehicle.PrimaryPart.CFrame
    wait()
    for i,v in pairs(Vehicle:GetDescendants()) do 
        if v:IsA("BasePart") then 
            v.Anchored = false    
        end    
    end
    wait(0.1)
    if EnterFunctionT and EnterFunctionT.Tag then
        for i = 1,20 do 
            game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = Vehicle.BoundingBox.CFrame + Vector3.new(0,2,0)
            game:GetService("RunService").RenderStepped:wait()
        end
        wait(0.3)
        for i = 1,5 do
            EnterFunctionT:Callback(EnterFunctionT.Tag)
            game:GetService("RunService").RenderStepped:wait()
        end
    end
    workspace.CurrentCamera.CFrame = cameraCF
    wait(.1)
    for i,v in pairs(Vehicle:GetDescendants()) do 
        if v:IsA("BasePart") then 
            v.Anchored = true
        end    
    end
    workspace.CurrentCamera.CFrame = cameraCF
    wait(0.1)
    for i = 1,10 do
        wait()
        Vehicle:SetPrimaryPartCFrame(cframe + Vector3.new(-14,14,0))
    end
    for i,v in pairs(Vehicle:GetDescendants()) do 
        if v:IsA("BasePart") then 
            v.Anchored = false    
        end  
    end
    if not LeaveCar then
        wait(0.2)
        Vehicle:SetPrimaryPartCFrame(cframe)
    else
        wait(0.89)
        for i = 1,3 do
            ExitCar()
        end
        wait(0.3)
        for i = 1,8 do
            wait()
            for i,v in pairs(Vehicle:GetDescendants()) do 
                if v:IsA("BasePart") then 
                    v.Anchored = true
                end    
            end
            game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0,-15,0)
            game:GetService('Players').LocalPlayer.Character:SetPrimaryPartCFrame(cframe)
            game:GetService('Players').LocalPlayer.Character.Humanoid:SetStateEnabled("FallingDown", false)
        end
        wait(0.7)
        if LeaveCar and (cframe.p - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).magnitude > 52  then 
            wait(0.5)
            RobCarTP(cframe, LeaveCar)
        end
    end
end
end
function SmallTp(cframeinput)
game:GetService('Players').LocalPlayer.Character.Humanoid:SetStateEnabled("FallingDown", false)
local Pos_A = -10 + math.random() * -10
local Pos_B = (cframeinput - cframeinput.p) + Vector3.new(game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.Position.X, Pos_A, game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.Position.Z)
local Pos_C = Vector3.new(cframeinput.X, Pos_A, cframeinput.Z) - Pos_B.p
local OldGrav = workspace.Gravity
workspace.Gravity = 0
for indx = 0, Pos_C.Magnitude, 5 do
    game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.CFrame = Pos_B + Pos_C.Unit * indx
    game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
    wait()
end
game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.CFrame = cframeinput
workspace.Gravity = OldGrav
wait(.1)
end

CarTPFARM = function(cframe, LeaveCar)
pcall(function()
    if game:GetService('Players').LocalPlayer.Character and game:GetService('Players').LocalPlayer.Character.Humanoid.Sit == true and LeaveCar == true then
        game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.E, false, game)
        wait(0.4)
    end
    x = require(game:GetService('ReplicatedStorage').Game.ItemSystem.ItemSystem)
    x.Unequip()
        local function FindCars(Name)
            local Vehicles = {}
            for i,v in pairs(workspace.Vehicles:GetChildren()) do 
                if v.Name == Name and v:FindFirstChild("Seat") and v.Seat:FindFirstChild("Player") and v.Seat.Player.Value == false then 
                    table.insert(Vehicles, v)
                end 
            end
            return Vehicles
        end
        local Vehicle, EnterFunctionT = nil, nil
        function SetVehicle()
            if require(game:GetService("ReplicatedStorage").Game.Vehicle).GetLocalVehicleModel() == false then
                Vehicle = FindCars("Camaro")[math.random(1, #FindCars("Camaro"))]
                for i,v in pairs(require(game:GetService('ReplicatedStorage').Module.UI).CircleAction.Specs) do
                    if v.Tag and v.Tag.Name == "Seat" and v.Tag.Parent == Vehicle then
                        EnterFunctionT = v
                    end
                end
            else
                Vehicle = require(game:GetService("ReplicatedStorage").Game.Vehicle).GetLocalVehicleModel()
            end
        end
        SetVehicle()
        if Vehicle then 
            if Vehicle:FindFirstChild("Seat") and Vehicle.Seat.Player.Value == true then
                SetVehicle()
            end
        elseif Vehicle == nil then
            SpawnVehicle("Camaro")
            wait(0.1)
            SetVehicle()
        end
        if Vehicle then 
            workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
            local cameraCF = workspace.CurrentCamera.CFrame
            local old = Vehicle.PrimaryPart.CFrame
            wait()
            for i,v in pairs(Vehicle:GetDescendants()) do 
                if v:IsA("BasePart") then 
                    v.Anchored = false    
                end    
            end
            wait(0.05)
            if EnterFunctionT and EnterFunctionT.Tag then
                for i = 1,20 do 
                    game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = Vehicle.BoundingBox.CFrame + Vector3.new(0,2,0)
                    game:GetService("RunService").RenderStepped:wait()
                end
                wait(0.02)
                for i = 1,5 do
                    EnterFunctionT:Callback(EnterFunctionT.Tag)
                    game:GetService("RunService").RenderStepped:wait()
                end
            end
            workspace.CurrentCamera.CFrame = cameraCF
            wait()
            for i,v in pairs(Vehicle:GetDescendants()) do 
                if v:IsA("BasePart") then 
                    v.Anchored = true
                end    
            end
            workspace.CurrentCamera.CFrame = cameraCF
            wait(0.01)
            Vehicle:SetPrimaryPartCFrame(cframe)
            if LeaveCar then
                wait(0.05)
                workspace.CurrentCamera.CFrame = cameraCF
                game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.E, false, game)
                wait(0.2)
                Vehicle:SetPrimaryPartCFrame(old)
                workspace.CurrentCamera.CFrame = cameraCF
            end
        for i,v in pairs(Vehicle:GetDescendants()) do 
            if v:IsA("BasePart") then 
                v.Anchored = false    
            end    
        end
        wait(0.25)
    end
end)
end

function Handcuffs()
Cuffs = nil
for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.HotbarGui.Container:GetChildren()) do
    if v:FindFirstChild('Icon') and v.Icon.Image == 'rbxassetid://700374045' then
        Cuffs = v
        x = require(game:GetService('ReplicatedStorage').Game.ItemSystem.ItemSystem)
        x.Equip(game:GetService('Players').LocalPlayer,{i = Cuffs.Name,Frame = Cuffs.Icon,Name = "Handcuffs"})
    end
end
if not Cuffs then
    wait(0.3)
    ExitCar()
    Network:FireServer(Client.Hashes.Team,'Police')
    wait(3)
end
end
function PlayersCar(Name)
for i,v in next, game:GetService("Workspace").Vehicles:GetChildren() do
    if v.Seat.PlayerName.Value == Name or v:FindFirstChild('Passenger') and v.Passenger.PlayerName.Value == Name then
        return v
    end
end
end

function CarTP(cframe, LeaveCar)
if game:GetService('Players').LocalPlayer.Character and game:GetService('Players').LocalPlayer.Character.Humanoid.Sit == true then
    MyCar():SetPrimaryPartCFrame(cframe)
    return
end
x = require(game:GetService('ReplicatedStorage').Game.ItemSystem.ItemSystem)
x.Unequip()
local function FindCars(Name)
    local Vehicles = {}
    for i,v in pairs(workspace.Vehicles:GetChildren()) do 
        if v.Name == Name and v:FindFirstChild("Seat") and v.Seat:FindFirstChild("Player") and v.Seat.Player.Value == false then 
            table.insert(Vehicles, v)
        end 
    end
    return Vehicles
end
local Vehicle, EnterFunctionT = nil, nil
function SetVehicle()
    if require(game:GetService("ReplicatedStorage").Game.Vehicle).GetLocalVehicleModel() == false then
        Vehicle = FindCars("Camaro")[math.random(1, #FindCars("Camaro"))]
        for i,v in pairs(require(game:GetService('ReplicatedStorage').Module.UI).CircleAction.Specs) do
            if v.Tag and v.Tag.Name == "Seat" and v.Tag.Parent == Vehicle then
                EnterFunctionT = v
            end
        end
    else
        Vehicle = require(game:GetService("ReplicatedStorage").Game.Vehicle).GetLocalVehicleModel()
    end
end
SetVehicle()
if Vehicle then 
    if Vehicle:FindFirstChild("Seat") and Vehicle.Seat.Player.Value == true then
        SetVehicle()
    end
elseif Vehicle == nil then
    SpawnVehicle("Camaro")
    wait(0.1)
    SetVehicle()
end
if Vehicle then 
    workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
    local cameraCF = workspace.CurrentCamera.CFrame
    local old = Vehicle.PrimaryPart.CFrame
    wait()
    for i,v in pairs(Vehicle:GetDescendants()) do 
        if v:IsA("BasePart") then 
            v.Anchored = false    
        end    
    end
    wait(0.05)
    if EnterFunctionT and EnterFunctionT.Tag then
        for i = 1,20 do 
            game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = Vehicle.BoundingBox.CFrame + Vector3.new(0,2,0)
            game:GetService("RunService").RenderStepped:wait()
        end
        wait(0.02)
        for i = 1,5 do
            EnterFunctionT:Callback(EnterFunctionT.Tag)
            game:GetService("RunService").RenderStepped:wait()
        end
    end
    workspace.CurrentCamera.CFrame = cameraCF
    wait()
    for i,v in pairs(Vehicle:GetDescendants()) do 
        if v:IsA("BasePart") then 
            v.Anchored = true
        end    
    end
    workspace.CurrentCamera.CFrame = cameraCF
    wait(0.01)
    Vehicle:SetPrimaryPartCFrame(cframe)
    workspace.CurrentCamera.CFrame = cameraCF
    for i,v in pairs(Vehicle:GetDescendants()) do 
        if v:IsA("BasePart") then 
            v.Anchored = false    
        end    
    end
    wait(0.2)
    for i = 1,3 do
        ExitCar()
    end
end
end



--Teleports

Teleports_Tab:Dropdown('Teleport Method',{'Method 1','Method 2'},function(Sele)
if Sele == 'Method 1' then
    Client.Values.Method = 1
    Notif('Using Method 1',2)
else
    Client.Values.Method = 2
    Notif('Using Method 2',2)
end
end)

for i,v in pairs(Client.Teleports) do
Teleports_Tab:Button(tostring(i),function()
    if Client.Toggles.AutoArrest == true or Client.Toggles.AutoFarm == true then
        Notif('Please Disabled Farming First',2)
        return
    end
    if Client.Values.Method == 1 then
        CarTP(v)
    else
        Temp_Tried = 1
        Teleport(v, true)
    end
end)
end

--LocalPlayer

Player_Tab:Toggle('WalkSpeed',function(state)
Client.Toggles.WalkSpeed = state
end)
Player_Tab:Slider('WalkSpeed Config',16,100,function(num)
Client.Values.WalkSpeed = num
end)
Player_Tab:Toggle('JumpPower',function(state)
Client.Toggles.JumpPower = state
end)
Player_Tab:Slider('JumpPower Config',50,175,function(num)
Client.Values.JumpPower = num
end)
Player_Tab:Toggle("Inf Jump", function(state)
Client.Toggles.InfJump = state
end)
Player_Tab:Toggle('No Clip',function(state)
Client.Toggles.NoClip = state
end)
wait(0.03)
game:GetService("UserInputService").JumpRequest:connect(function()
if Client.Toggles.InfJump then
    game:GetService"Players".LocalPlayer.Character:FindFirstChildOfClass'Humanoid':ChangeState("Jumping")
end
end)
game:GetService("RunService").RenderStepped:Connect(function()
if Client.Toggles.WalkSpeed then
    game:GetService('Players').LocalPlayer.Character.Humanoid.WalkSpeed = Client.Values.WalkSpeed
end
if Client.Toggles.JumpPower then
    game:GetService('Players').LocalPlayer.Character.Humanoid.JumpPower = Client.Values.JumpPower
else
    game:GetService('Players').LocalPlayer.Character.Humanoid.JumpPower = 50
end
end)

game:GetService("RunService").Stepped:Connect(function()
if Client.Toggles.NoClip then
    for i, v in ipairs(game:GetService("Players").LocalPlayer.Character:GetChildren()) do
        if v:IsA("BasePart")then
            v.CanCollide = false
        end
    end
end
end)

local oldRagdoll = Falling.Ragdoll
Falling.Ragdoll = function(...)
if Client.Toggles.NoRagdoll then
    return wait(9e9)
else
    return oldRagdoll(...)
end
end
Player_Tab:Toggle('No Ragdoll',function(state)
Client.Toggles.NoRagdoll = state
end)
require(game:GetService("ReplicatedStorage").Game.ItemSystem.ItemSystem).Errors = function() return end
Player_Tab:Toggle('Godmode',function(state)
Client.Toggles.Godmode = state
if state == true then
    debug.setconstant(DonutFunction,12,"Errors")
else
    debug.setconstant(DonutFunction,12,"Unequip")
end
end)
game:GetService("RunService").Stepped:Connect(function()
if Client.Toggles.Godmode  then
    Network:FireServer(Client.Hashes.Donut1,'Donut')
    Network:FireServer(Client.Hashes.Donut2)
end
end)

Player_Tab:Button('No Wait E',function()
while wait(.1) do
    m = require(game:GetService("ReplicatedStorage").Module:WaitForChild("UI"))
    for i,v in next, m.CircleAction.Specs do
        v.Duration = 0
        v.Timed = true
    end
end
end)
Player_Tab:Button('Remove Suit',function()
fireclickdetector(game:GetService('Workspace').ClothingRacks.ClothingRack.Hitbox.ClickDetector)
end)
Player_Tab:Button('No Team Switch Delay',function()
require(game:GetService("ReplicatedStorage").Resource.Settings).Time.BetweenTeamChange = 0
end)

Player_Tab:Toggle('FE Orange Justice',function(state)
if state == true then
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local character = player.Character 
    local humanoid = character:FindFirstChild("Humanoid")
    local animation = Instance.new("Animation")
    animation.AnimationId = "http://www.roblox.com/asset/?id=3066265539"
    local animationTrack = humanoid:LoadAnimation(animation)
    animationTrack:Play()
else
    local AnimationTracks = game:GetService('Players').LocalPlayer.Character.Humanoid:GetPlayingAnimationTracks()
    for i, track in pairs (AnimationTracks) do
        if string.match(track.Animation.AnimationId,"3066265539") then
            track:Stop()
        end
    end
end
end)

function firetouchinterest(Part,Touch,Inx)
temp_Old = Touch.CFrame
Touch.CFrame = Part.CFrame
wait()
Touch.CFrame = temp_Old
end

Player_Tab:Dropdown('Change Team',{'Police','Criminal','Prisoner'},function(Sele)
if game:GetService('Players').LocalPlayer.Character and game:GetService('Players').LocalPlayer.Character.Humanoid.Sit == true then
    ExitCar()
    wait()
end
if Sele == 'Police' then
    Network:FireServer(Client.Hashes.Team,'Police')
end
if Sele == 'Criminal' then
    Network:FireServer(Client.Hashes.Team,'Prisoner')
    wait(0.8)
    firetouchinterest(game:GetService('Players').LocalPlayer.Character.HumanoidRootPart, game:GetService("Workspace").Apartments.Skyscraper3.ExitDoor.Touch, 0)
end
if Sele == 'Prisoner' then
    Network:FireServer(Client.Hashes.Team,'Prisoner')
end
end)

Player_Tab:Button('Fix Camera',function()
if MyCar() then
    workspace.CurrentCamera.CameraSubject = MyCar().PrimaryPart
    workspace.CurrentCamera.CameraType = "Custom"
else
    workspace.CurrentCamera.CameraSubject = game:GetService('Players').LocalPlayer.Character.Humanoid
    workspace.CurrentCamera.CameraType = "Custom"
end
end)

Player_Tab:Button('Fix Player',function()
Network:FireServer(Client.Hashes.Team,'Prisoner')
end)

--Farming Tab

MainStatus = Farming_Tab:Label('Farming Disabled For Rewrite')

function MyCar()
for i,v in next, game:GetService("Workspace").Vehicles:GetChildren() do
    if not v:FindFirstChild('Seat') then return nil end
    if v.Seat and v.Seat.PlayerName.Value == game:GetService('Players').LocalPlayer.Name then
        return v
    end
end
end


Vehicle_Tab:Toggle('Rainbow Nitro Client',function(state)
Client.Toggles.RainbowNitro = state
end)
Vehicle_Tab:Toggle('Rainbow Car Client',function(state)
Client.Toggles.RainbowCar = state
end)
Vehicle_Tab:Toggle('Inf Nitro Client',function(state)
Client.Toggles.InfNitro = state
end)


game:GetService("RunService").Stepped:Connect(function()
if Client.Toggles.InfNitro == true then
    Nitro.Nitro = 200
    Nitro.NitroLastMax = 200
end
for i,v in pairs(workspace.Vehicles:GetChildren()) do
    if v:FindFirstChild('Seat') then
        if v.Seat:WaitForChild("PlayerName").Value == game:GetService('Players').LocalPlayer.Name then
            for a,b in pairs(v.Model:GetChildren()) do
                if b.Name == "Nitrous" and Client.Toggles.RainbowNitro == true then
                    currrain = Color3.fromHSV(tick()%5/5,1,1)
                    b.Fire.Color = ColorSequence.new(currrain)
                    b.Smoke.Color = ColorSequence.new(currrain)
                end
                if b:IsA('BasePart') and Client.Toggles.RainbowCar == true then
                    b.Color = Color3.fromHSV(tick()%5/5,1,1)
                end
            end
        end
    end
end
end)

local FlySpeed = 50
function GetCarMain()
local x = game:GetService("Players").LocalPlayer.Name
for j, y in pairs(workspace.Vehicles:GetChildren()) do
    if y:FindFirstChild("Seat") and y:FindFirstChild("Engine") then
        if y.Seat.PlayerName.Value == x then
            return y.Engine, false
        end
    elseif y:FindFirstChild("Seat") and y:FindFirstChild("Model") then
        if y.Seat.PlayerName.Value == x then
            if y.Model:FindFirstChild("Body") then
                return y.Model.Body, true
            end
        end
    end
end
end
function FlyPart(z, A)
local B = Instance.new("Folder")
B.Name = "Storage"
for j, C in pairs(z:GetChildren()) do
    if C:IsA("BodyGyro") then
        C.Parent = B
    end
end
local D = Instance.new("BodyPosition", z)
D.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
D.Name = "Position"
local E = Instance.new("BodyGyro", z)
E.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
E.Name = "Rotate"
workspace.CurrentCamera.CameraSubject = z
local f = game:GetService("Players").LocalPlayer:GetMouse()
local F = 0
local G =
    f.KeyDown:Connect(
    function(H)
        if H == "w" then
            if A then
                F = FlySpeed
            else
                F = tonumber("-" .. tostring(FlySpeed))
            end
        elseif H == "s" then
            if A then
                F = tonumber("-" .. tostring(FlySpeed))
            else
                F = FlySpeed
            end
        end
    end
)
f.KeyUp:Connect(
    function(H)
        if H == "w" then
            F = 0
        elseif H == "s" then
            F = 0
        end
    end
)
local I = {}
I.IsRunning = true
I.Part = z
I.Storage = B
I.MT = G
coroutine.resume(
    coroutine.create(
        function()
            repeat
                local J = workspace.CurrentCamera.CFrame
                local K = z.Position
                local L = (K - J.p).Magnitude
                D.Position = (J * CFrame.new(0, 0, tonumber("-" .. tostring(L)) + F)).p + Vector3.new(0, 0.2225, 0)
                E.CFrame = J
                wait()
            until I.IsRunning == false or workspace.CurrentCamera.CameraSubject ~= z
            D:Remove()
            E:Remove()
            for j, M in pairs(I.Storage:GetChildren()) do
                M.Parent = I.Part
            end
            I.MT:Disconnect()
            I.Storage:Remove()
        end
    )
)
return I
end
Vehicle_Tab:Button(
"Car Fly",
function()
    if Client.Toggles.Autofarm == true or Client.Toggles.AutoArrest then
        return
    end
    if GetCarMain() ~= nil then
        local O, A = GetCarMain()
        local P = FlyPart(O, A)
        if A then
            repeat
                wait()
            until O.Parent.Parent.Seat.PlayerName.Value ~= game:GetService("Players").LocalPlayer.Name
        else
            repeat
                wait()
            until O.Parent.Seat.PlayerName.Value ~= game:GetService("Players").LocalPlayer.Name
        end
        wait(0.1)
        workspace.CurrentCamera.CameraSubject = d
    end
end
)
Vehicle_Tab:Slider(
"Car Fly Speed",10,300,
function(v)
    FlySpeed = v
end
)
Vehicle_Tab:Toggle('Auto Pilot',function(state)
debug.setupvalue(require(game:GetService('ReplicatedStorage').Module.AlexChassis).OnAction, 8, state)
end)

Vehicle_Tab:Button('Boats On Lands',function()
local old = require(game:GetService("ReplicatedStorage").Game.Boat.Boat).UpdatePhysics
require(game:GetService("ReplicatedStorage").Game.Boat.Boat).UpdatePhysics = function(abc)
    abc.Config.SpeedForward = 5
    return old(abc)
end
end)

Vehicle_Tab:Label('Car Mods')
Vehicle_Tab:Slider("CarSpeed",1,100,function(v)
Client.Values.carspeed = v
end)
Vehicle_Tab:Slider("TurnSpeed",1,100, function(v)
Client.Values.turnspeed = v
end)
Vehicle_Tab:Slider("Suspention",1,100, function(v)
Client.Values.suspention = v
end)

game:GetService("RunService").RenderStepped:Connect(function()
local x = pcall(function()
local vehicle = require(game:GetService("ReplicatedStorage").Game.Vehicle)
debug.getupvalues(vehicle["GetLocalVehiclePacket"])[1]["GarageEngineSpeed"] = Client.Values.carspeed
debug.getupvalues(vehicle["GetLocalVehiclePacket"])[1]["TurnSpeed"] = Client.Values.turnspeed
debug.getupvalues(vehicle["GetLocalVehiclePacket"])[1]["Height"] = Client.Values.suspention
if Client.Toggles.NoTirePop == true then
    debug.getupvalues(vehicle["GetLocalVehiclePacket"])[1]["TirePopDuration"] = 0
else
    debug.getupvalues(vehicle["GetLocalVehiclePacket"])[1]["TirePopDuration"] = 7.5
end
end) if not x then end end)



Server_Tab:Button('Destroy Everyones Ears',function()
for i,v in pairs(require(game:GetService('ReplicatedStorage').Resource.Settings).Sounds) do
    PlayFunc(i ,{Source = workspace, 
    Volume = math.huge, 
    Multi = true,
    MaxTime = 10
    }, false)
end
end)

Server_Tab:Button('Erupt Volcano',function()
LocalPlayer = game:GetService('Players').LocalPlayer
workspace.LavaFun.Lavatouch.Transparency = 1
firetouchinterest(LocalPlayer.Character:WaitForChild('HumanoidRootPart'), workspace.LavaFun.Lavatouch, 0)
end)
Server_Tab:Toggle('Loop Erupt Volcano',function(state)
workspace.LavaFun.Lavatouch.Transparency = 1
Client.Toggles.LoopVolcano = state
end)    
Server_Tab:Button('Open All Sewers',function()
for i,v in pairs(game:GetService("Workspace").EscapeRoutes.SewerHatches:GetChildren()) do
    Network:FireServer(Client.Hashes.Interact,'SewerHatch',v.SewerHatch)
end
end)
Server_Tab:Toggle('Loop Open Sewers',function(state)
Client.Toggles.LoopSewer = state
end)    

Server_Tab:Button('Explode Wall',function()
Network:FireServer(Client.Hashes.Interact,'ExplodeWall')
end)
Server_Tab:Toggle('Loop Explode Wall',function(state)
Client.Toggles.LoopExplode = state
end)

spawn(function()
while true do
    wait(0.7)
    if Client.Toggles.LoopExplode == true then
        Network:FireServer(Client.Hashes.Interact,'ExplodeWall')
    end
    if Client.Toggles.LoopSewer == true then
        for i,v in pairs(game:GetService("Workspace").EscapeRoutes.SewerHatches:GetChildren()) do
            Network:FireServer(Client.Hashes.Interact,'SewerHatch',v.SewerHatch)
        end
    end
    if Client.Toggles.LoopVolcano == true then
        LocalPlayer = game:GetService('Players').LocalPlayer
        firetouchinterest(LocalPlayer.Character:WaitForChild('HumanoidRootPart'), workspace.LavaFun.Lavatouch, 0)
    end
end
end)

local doors = {}
wait()
for i,v in pairs(getgc(true)) do 
if type(v) == "function" and getfenv(v).script == game:GetService("Players").LocalPlayer.PlayerScripts.LocalScript then
    for i2,v2 in pairs(debug.getupvalues(v)) do 
        if type(v2) == "table" and v2["Type"] and v2["Model"] and v2["OpenFun"] and v2["CloseFun"] and v2["Tag"] and v2["State"] and v2["Settings"] then
            table.insert(doors,v2)
        end
    end
end
end
Server_Tab:Button('Open All Doors',function()
for i,v in pairs(doors) do
    DoorOpenFunc(v)
end
end)
Server_Tab:Toggle('Open All Doors',function(state)
Client.Hashes.OpenAllDoors = state
end)
spawn(function()
while true do
    wait(1)
    if Client.Hashes.OpenAllDoors then
        for i,v in pairs(doors) do
            DoorOpenFunc(v)
        end
    end
end
end)


Tool_Tab:Button('Grab All Guns',function()
Guns = require(game:GetService("ReplicatedStorage").Game.GunShop.Data.Held)
for i,v in pairs(Guns) do
    if type(v.Name) == 'string' and BBClient and BBClient.doesPlayerOwn(v.Name) then
        Network:FireServer(Client.Hashes.GrabGun,v.Name)
    end
end    
end)

Tool_Tab:Button('Gun Mods',function()
for i,v in pairs(game:GetService('ReplicatedStorage').Game.ItemConfig:GetChildren()) do
    local cst = require(v)
    cst.CamShakeMagnitude = 0
    cst.MagSize = math.huge
    cst.ReloadTime = 0
    cst.FireAuto = true
    cst.FireFreq = 30
end
local old = require(game:GetService('ReplicatedStorage').Game.Item.Taser).Tase
require(game:GetService('ReplicatedStorage').Game.Item.Taser).Tase = function(self, ...)
    self.Config.ReloadTime = 0
    self.ReloadTimeHit = 0
    return old(self, ...)
end
end)


Tool_Tab:Button('Get Jetpack',function()
game:GetService("Workspace").TouchTrigger.JetPackGiver.CFrame = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame
end)
Tool_Tab:Button('Inf Jetpack Fuel',function()
local RocketConfig = {}
for i,v in next, debug.getupvalues(require(game:GetService('ReplicatedStorage').Game.JetPack.JetPack).Init) do
    if typeof(v) == "table" then
        if v.Equip then
            RocketConfig = v
            break
        end
    end
end
RocketConfig.LocalMaxFuel = math.huge
RocketConfig.LocalFuel = math.huge
RocketConfig.LocalFuelType = "Rocket"
end)
Tool_Tab:Button('Grab Glider',function()
fireclickdetector(game:GetService("Workspace").Givers.Glider.ClickDetector)
end)
Tool_Tab:Button('Donut',function()
Network:FireServer(Client.Hashes.Donut1,'Donut')
end)


--ESP

Config = {
Visuals = {
    BoxEsp = false,
    TracerEsp = false,
    Names = false,
    TeamCheck = true,
    Criminal = Color3.fromRGB(255, 0, 0),
    Police = Color3.fromRGB(0, 0, 255),
    Prisoner = Color3.fromRGB(255, 165, 0),
    ShowTeam = true,
    ShowCops = false,
    ShowCrims = false,
    ShowPris = false
}
}
local Services =
setmetatable(
{
    LocalPlayer = game:GetService("Players").LocalPlayer,
    Camera = workspace.CurrentCamera
},
{
    __index = function(self, idx)
        return rawget(self, idx) or game:GetService(idx)
    end
}
)

local Funcs = {}

function Funcs:Round(number)
return math.floor(tonumber(number) + 0.5)
end

function Funcs:DrawSquare()
local Box = Drawing.new("Square")
Box.Color = Color3.fromRGB(190, 190, 0)
Box.Thickness = 0.5
Box.Filled = false
Box.Transparency = 1
return Box
end

function Funcs:DrawQuad() -- Unused
local quad = Drawing.new("Quad")
quad.Color = Color3.fromRGB(190, 190, 0)
quad.Thickness = 0.5
quad.Filled = false
quad.Transparency = 1
return quad
end

function Funcs:DrawLine()
local line = Drawing.new("Line")
line.Color = Color3.new(190, 190, 0)
line.Thickness = 0.5
return line
end

function Funcs:DrawText()
local text = Drawing.new("Text")
text.Color = Color3.fromRGB(190, 190, 0)
text.Size = 20
text.Outline = true
text.Center = true
return text
end

Esp_Tab:Toggle(
"Boxes",
function(state)
    Config.Visuals.BoxEsp = state
end
)

Esp_Tab:Toggle(
"Tracers",
function(state)
    Config.Visuals.TracerEsp = state
end
)

Esp_Tab:Toggle(
"Names",
function(state)
    Config.Visuals.NameEsp = state
end
)
Esp_Tab:Toggle(
"Show Crims",
function(state)
    Config.Visuals.ShowCrims = state
end
)
Esp_Tab:Toggle(
"Show Prisoners",
function(state)
    Config.Visuals.ShowPris = state
end
)
Esp_Tab:Toggle(
"Show Cops",
function(state)
    Config.Visuals.ShowCops = state
end
)

--Esp Loader

function Funcs:AddEsp(player)
local Box = Funcs:DrawSquare()
local Tracer = Funcs:DrawLine()
local Name = Funcs:DrawText()
Services.RunService.Stepped:Connect(
    function()
        if player.Character == nil or player.Character.Humanoid.Health == 0 then
            Box.Visible = false
            Tracer.Visible = false
            Name.Visible = false
        else
            if player then
                if player.Team.Name == "Police" then
                    Box.Color = Config.Visuals.Police
                    Tracer.Color = Config.Visuals.Police
                    Name.Color = Config.Visuals.Police
                end
                if player.Team.Name == "Prisoner" then
                    Box.Color = Config.Visuals.Prisoner
                    Tracer.Color = Config.Visuals.Prisoner
                    Name.Color = Config.Visuals.Prisoner
                end
                if player.Team.Name == "Criminal" then
                    Box.Color = Config.Visuals.Criminal
                    Tracer.Color = Config.Visuals.Criminal
                    Name.Color = Config.Visuals.Criminal
                end
                if player.Character and player.Character:FindFirstChild("Head") then
                    local RootPosition, OnScreen =
                        Services.Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
                    local HeadPosition =
                        Services.Camera:WorldToViewportPoint(
                        player.Character.Head.Position + Vector3.new(0, 0.5, 0)
                    )
                    local LegPosition =
                        Services.Camera:WorldToViewportPoint(
                        player.Character.HumanoidRootPart.Position - Vector3.new(0, 4, 0)
                    )
                    if Config.Visuals.BoxEsp then
                        tempYO = false
                        if player.Team.Name == "Police" and Config.Visuals.ShowCops == true then
                            Box.Visible = OnScreen
                            tempYO = true
                        end
                        if player.Team.Name == "Prisoner" and Config.Visuals.ShowPris == true then
                            Box.Visible = OnScreen
                            tempYO = true
                        end
                        if player.Team.Name == "Criminal" and Config.Visuals.ShowCrims == true then
                            Box.Visible = OnScreen
                            tempYO = true
                        end
                        if tempYO == false then
                            Box.Visible = false
                        end
                        Box.Size = Vector2.new((2350 / RootPosition.Z) + 2.5, HeadPosition.Y - LegPosition.Y)
                        Box.Position =
                            Vector2.new((RootPosition.X - Box.Size.X / 2) - 1, RootPosition.Y - Box.Size.Y / 2)
                    else
                        Box.Visible = false
                    end
                    if Config.Visuals.TracerEsp then
                        tempYO = false
                        if player.Team.Name == "Police" and Config.Visuals.ShowCops == true then
                            Tracer.Visible = OnScreen
                            tempYO = true
                        end
                        if player.Team.Name == "Prisoner" and Config.Visuals.ShowPris == true then
                            Tracer.Visible = OnScreen
                            tempYO = true
                        end
                        if player.Team.Name == "Criminal" and Config.Visuals.ShowCrims == true then
                            Tracer.Visible = OnScreen
                            tempYO = true
                        end
                        if tempYO == false then
                            Tracer.Visible = false
                        end
                        Tracer.To = Vector2.new(Services.Camera.ViewportSize.X / 2, 0)
                        Tracer.From =
                            Vector2.new(
                            Services.Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position).X - 1,
                            RootPosition.Y + (HeadPosition.Y - LegPosition.Y) / 2
                        )
                    else
                        Tracer.Visible = false
                    end
                    if Config.Visuals.NameEsp then
                        tempYO = false
                        if player.Team.Name == "Police" and Config.Visuals.ShowCops == true then
                            Name.Visible = OnScreen
                            tempYO = true
                        end
                        if player.Team.Name == "Prisoner" and Config.Visuals.ShowPris == true then
                            Name.Visible = OnScreen
                            tempYO = true
                        end
                        if player.Team.Name == "Criminal" and Config.Visuals.ShowCrims == true then
                            Name.Visible = OnScreen
                            tempYO = true
                        end
                        if tempYO == false then
                            Name.Visible = false
                        end
                        Name.Position =
                            Vector2.new(
                            Services.Camera:WorldToViewportPoint(player.Character.Head.Position).X,
                            Services.Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position).Y - 40
                        )
                        Name.Text = player.Name
                    else
                        Name.Visible = false
                    end
                else
                    Box.Visible = false
                    Tracer.Visible = false
                    Name.Visible = false
                end
                if not player then
                    Box.Visible = false
                    Tracer.Visible = false
                    Name.Visible = false
                end
            end
        end
    end
)
end

for i, v in pairs(Services.Players:GetPlayers()) do
if v ~= Services.LocalPlayer then
    Funcs:AddEsp(v)
end
end

Services.Players.PlayerAdded:Connect(
function(player)
    if v ~= Services.LocalPlayer then
        Funcs:AddEsp(player)
    end
end
)

wait(0.3)
Notif('DarkHub Injected...',5)
end







if game.PlaceId == 3101667897 then
--Legends Of Speed Script Here //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/whiteyume1/whiteyume1/main/darkhubuilib.lua"))()

main = lib:Window()
FarmingW = main:Tab('Farming')

Client = {
Toggles = {
    Hoops = false,
    Steps = false,
    Rebirth = false
}
}
FarmingW:Toggle('AutoFarm Hoops',function(state)
Client.Toggles.Hoops = state
end)
FarmingW:Toggle('Super Autofarm',function(state)
Client.Toggles.Steps = state
end)
FarmingW:Toggle('Auto Rebirth',function(state)
Client.Toggles.Rebirth = state
end)



spawn(function()
while true do 
    wait()
    if Client.Toggles.Steps == true then
        local A_1 = "collectOrb" local A_2 = "Gem" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Yellow Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Orange Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Blue Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Gem" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Yellow Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Orange Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Blue Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Gem" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Yellow Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Orange Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Blue Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Gem" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Yellow Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Orange Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Blue Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Gem" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Yellow Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Orange Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Blue Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Gem" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Yellow Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Orange Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Blue Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Gem" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Yellow Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Orange Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Blue Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Gem" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Yellow Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Orange Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Blue Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Gem" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Yellow Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Orange Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Blue Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3)
    end
    if Client.Toggles.Steps == true then
        local A_1 = "collectOrb" local A_2 = "Gem" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Yellow Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Orange Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Blue Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Gem" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Yellow Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Orange Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Blue Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Gem" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Yellow Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Orange Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Blue Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Gem" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Yellow Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Orange Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Blue Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Gem" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Yellow Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Orange Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Blue Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Gem" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Yellow Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Orange Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Blue Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Gem" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Yellow Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Orange Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Blue Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Gem" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Yellow Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Orange Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Blue Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Gem" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Yellow Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Orange Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Blue Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3)
    end
    if Client.Toggles.Steps == true then
        local A_1 = "collectOrb" local A_2 = "Gem" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Yellow Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Orange Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Blue Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Gem" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Yellow Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Orange Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Blue Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Gem" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Yellow Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Orange Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Blue Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Gem" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Yellow Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Orange Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Blue Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Gem" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Yellow Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Orange Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Blue Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Gem" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Yellow Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Orange Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Blue Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Gem" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Yellow Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Orange Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Blue Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Gem" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Yellow Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Orange Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Blue Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Gem" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Yellow Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Orange Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Blue Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3)
    end
    if Client.Toggles.Steps == true then
        local A_1 = "collectOrb" local A_2 = "Gem" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Yellow Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Orange Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Blue Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Gem" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Yellow Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Orange Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Blue Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Gem" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Yellow Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Orange Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Blue Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Gem" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Yellow Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Orange Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Blue Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Gem" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Yellow Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Orange Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Blue Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Gem" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Yellow Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Orange Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Blue Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Gem" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Yellow Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Orange Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Blue Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Gem" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Yellow Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Orange Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Blue Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Gem" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Yellow Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Orange Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Blue Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3)
    end
    if Client.Toggles.Steps == true then
        local A_1 = "collectOrb" local A_2 = "Gem" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Yellow Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Orange Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Blue Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Gem" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Yellow Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Orange Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Blue Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Gem" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Yellow Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Orange Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Blue Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Gem" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Yellow Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Orange Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Blue Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Gem" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Yellow Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Orange Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Blue Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Gem" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Yellow Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Orange Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Blue Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Gem" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Yellow Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Orange Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Blue Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Gem" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Yellow Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Orange Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Blue Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Gem" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Yellow Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Orange Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3) local A_1 = "collectOrb" local A_2 = "Blue Orb" local A_3 = "City" local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent Event:FireServer(A_1, A_2, A_3)
    end
    if Client.Toggles.Rebirth == true then
        local v1 = "rebirthRequest"
        local rem = game:GetService("ReplicatedStorage").rEvents.rebirthEvent
        rem:FireServer(v1)
    end
end
end)




spawn(function()
while true do 
    wait()
    if Client.Toggles.Hoops then
        for i, v in pairs(workspace.Hoops:GetChildren()) do
            if v.Name == "Hoop" then
                v.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
            end
        end
        wait(0.6)
        for i, v in pairs(workspace.Hoops:GetChildren()) do
            if v.Name == "Hoop" then
                v.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0,100,0)
            end
        end
    end
end
end)
Tele = main:Tab('Teleports')

Tele:Button('City',function()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-720.867676, 5.9992404, 521.217224, 0.69439292, -0.0281433277, -0.719045162, 5.3551048e-08, 0.999234915, -0.0391098633, 0.71959573, 0.0271575749, 0.693861663)
end)
Tele:Button('Snow City',function()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-798.230164, 6.01365137, 2209.10327, -0.599616408, -0.0321650021, -0.799640834, 6.00703061e-08, 0.999191999, -0.0401918516, 0.800287485, -0.0240997449, -0.599131942)
end)
Tele:Button('Magma City',function()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1878.58093, 6.00838995, 4335.40332, -0.00650931895, -0.0437152088, -0.999022901, 1.44413207e-07, 0.999044001, -0.0437161401, 0.99997896, -0.000284698559, -0.00650309771)
end)

OtherW = main:Tab('Other')

OtherW:Button('Collect All Chests',function()
for i,v in pairs(workspace.rewardChests:GetChildren()) do
    for i = 1,5 do
        local v1 = v
        local rem = game:GetService("ReplicatedStorage").rEvents.collectCourseChestRemote
        rem:InvokeServer(v1)
    end
end
end)
end
if game.PlaceId == 292439477 then
--Phantom Forces (blaž#4755 was here :troll:) //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

pcall(function()
local Config = {
  Visuals = {
    BoxEsp = false,
    CornerBoxEsp = false,
    TracerEsp = false,
    TracersOrigin = "Top",
    FullBright = false,
    EnemyColor = Color3.fromRGB(190, 190, 0),
    TeamColor = Color3.fromRGB(0, 190, 0),
    GunColor = Color3.fromRGB(0, 190, 0),
    BulletTracersColor = Color3.fromRGB(100, 100, 255),
    ImpactPointsColor = Color3.fromRGB(255, 50, 50),
    GunAndArmsColor = Color3.fromRGB(255, 100, 255),
    AlwaysDay = false,
    BulletTracers = false,
    ImpactPoints = false
  },
  Aimbot = {
    Aimbot = false,
    Smoothness = 0.25,
    AimBone = "head",
    RandomAimBone = false,
    MouseTwoDown = false,
    Silent = false,
    VisCheck = false,
    DrawFOV = false,
    FOV = 200,
    SnapLines = false,
    KillAura = false
  },
  GunMods = {
    Recoil = false,
    Spread = false,
    InstaReload = false,
    FireRate = false,
    FireRateSpeed = 2000,
    RainbowGun = false,
    Sway = false,
    Bob = false,
    CombineMags = false
  },
  OldGunModules = {},
  Player = {
    Walkspeed = 16,
    Jumppower = 4,
    Gravity = 0,
    FallDmg = false,
    AlwaysAllowSpawn = false,
    FreeseCharOnGameEnd = false,
    Team = "nigger"
  }
}

local Services = setmetatable({
  LocalPlayer = game:GetService("Players").LocalPlayer,
  Camera = workspace.CurrentCamera,
  Workspace = game:GetService("Workspace")
}, {
  __index = function(self, idx)
    return rawget(self, idx) or game:GetService(idx)
  end
})

local Funcs = {}

function Funcs:Round(number)
  return math.floor(tonumber(number) + 0.5)
end

function Funcs:DrawSquare()
  local Box = Drawing.new("Square")
  Box.Color = Color3.fromRGB(190, 190, 0)
  Box.Thickness = 0.5
  Box.Filled = false
  Box.Transparency = 1
  return Box
end

function Funcs:DrawLine()
  local line = Drawing.new("Line")
  line.Color = Color3.new(190, 190, 0)
  line.Thickness = 0.5
  return line
end

function Funcs:DrawText()
  local text = Drawing.new("Text")
  text.Color = Color3.fromRGB(190, 190, 0)
  text.Size = 20
  text.Outline = true
  text.Center = true
  return text
end

function Funcs:GetCharacter(player)
  return plrs[player]
end

function Funcs:GetLocalCharacter()
  for i,v in pairs(game:GetService("Workspace").Players.Ghosts:GetChildren()) do
    if v:FindFirstChild("Humanoid") then
      return v
    end
  end
  for i,v in pairs(game:GetService("Workspace").Players.Phantoms:GetChildren()) do
    if v:FindFirstChild("Humanoid") then
      return v
    end
  end
end

local dot = Vector3.new().Dot
local getbodyparts
local gamelogic
local physics
local particle
local network
local camera
local effects
local _old
local solve

for i,v in next, getgc(true) do
  if type(v) == "table" and rawget(v,'step') and rawget(v,'reset') and rawget(v,'new') then
    particle = v;
    __old = v.new;
  end
  if type(v) == "table" and rawget(v,'trajectory') then
    physics = v;
  end
  if type(v) == "table" and rawget(v,'solve') then
    solve = v.solve;
  end
  if type(v) == "table" and rawget(v,'getbodyparts') then
    getbodyparts = v.getbodyparts;
  end
  if type(v) == "table" and rawget(v,'bullethit') and rawget(v,'breakwindow') then
    effects = v;
    _old = v.bullethit;
  end
  if type(v) == "function" then
    for k, x in pairs(debug.getupvalues(v)) do
      if type(x) == "table" then
        if rawget(x, "send") then
          network = x
        elseif rawget(x, "angles") then
          camera = x
        elseif rawget(x, "gammo") then
          gamelogic = x
        end
      end
    end
  end
end

local newphysics = game:GetService("ReplicatedFirst").SharedModules.Old.Utilities.Math.physics:Clone()
newphysics.Parent = Services.Workspace
newphysics.Name = "darkhub on toppppp"
trajectory = require(newphysics).trajectory

function Funcs:IsAlive(character)
  if character and character:FindFirstChild("Head") and character ~= Funcs:GetLocalCharacter() then
    for i, v in pairs(game:GetService("Workspace").Players.Phantoms:GetChildren()) do
      if v == character then
        return true
      end
    end
    for i, v in pairs(game:GetService("Workspace").Players.Ghosts:GetChildren()) do
      if v == character then
        return true
      end
    end
  end
end

local ticket = 0
local Mouse = Services.LocalPlayer:GetMouse()
local UserInputService = game:GetService("UserInputService")
local target = false
local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/whiteyume1/whiteyume1/main/darkhubuilib.lua"))()
main = lib:Window()
Aimbot = main:Tab('Aimbot')
Esp = main:Tab('Visuals')
GunMods = main:Tab('Gun Mods')
Player = main:Tab('Player')

Aimbot:Toggle('Aimbot',function(state)
  Config.Aimbot.Aimbot = state
end)

Aimbot:Toggle('Silent Aim',function(state)
  Config.Aimbot.Silent = state
end)

Aimbot:Toggle('Visible Check ( USE THIS )',function(state)
  Config.Aimbot.VisCheck = state
end)

Aimbot:Toggle('Knife Kill Aura',function(state)
  Config.Aimbot.KillAura = state
end)

Aimbot:Toggle('Draw FOV',function(state)
  Config.Aimbot.DrawFOV = state
end)

Aimbot:Dropdown(
  "Aim Bone", {'Head','Torso','Random'},
  function(selected)
    if selected == "Random" then
      Config.Aimbot.RandomAimBone = true
    elseif selected == "Head" then
      Config.Aimbot.RandomAimBone = false
      Config.Aimbot.AimBone = "head"
    elseif selected == "Torso" then
      Config.Aimbot.RandomAimBone = false
      Config.Aimbot.AimBone = "rootpart"
    end
  end
)

Aimbot:Slider('Smoothness',0,10,function(number)
  Config.Aimbot.Smoothness = number / 10
end)

Aimbot:Slider('FOV',0,1000,function(number)
  Config.Aimbot.FOV = number
end)

Esp:Toggle('Boxes',function(state)
  Config.Visuals.BoxEsp = state
end)

Esp:Toggle('Corner Boxes',function(state)
  Config.Visuals.CornerBoxEsp = state
end)

Esp:Toggle('Tracers',function(state)
  Config.Visuals.TracerEsp = state
end)

Esp:Dropdown(
  "Tracers Origin",{'Top','Middle','Bottom','Mouse'}, 
  function(selected)
    Config.Visuals.TracersOrigin = selected
  end
)

Esp:Colorpicker("Team Esp Color",Color3.fromRGB(0, 190, 0), function(color)
  Config.Visuals.TeamColor = color
end)

Esp:Colorpicker("Enemy Esp Color", Color3.fromRGB(190, 190, 0),function(color)
  Config.Visuals.EnemyColor = color
end)

Esp:Label('Other Visuals')

Esp:Toggle('Full Bright',function(state)
  if state == false then
    Config.Visuals.FullBright = true
    pcall(function()
      game:GetService("Lighting").Brightness = 1
      game:GetService("Lighting").FogEnd = 100000
      game:GetService("Lighting").GlobalShadows = true
      game:GetService("Lighting").Ambient = Color3.fromRGB(0, 0, 0)
    end)
  elseif state == true then
    Config.Visuals.FullBright = false
    pcall(function()
      game:GetService("Lighting").Brightness = 1
      game:GetService("Lighting").FogEnd = 786543
      game:GetService("Lighting").GlobalShadows = false
      game:GetService("Lighting").Ambient = Color3.fromRGB(178, 178, 178)
    end)
  end
end)

Esp:Toggle('Always Day',function(state)
  Config.Visuals.AlwaysDay = state
end)

Esp:Toggle('Bullet Tracers',function(state)
  Config.Visuals.BulletTracers = state
end)

Esp:Colorpicker("Bullet Tracers Color",Color3.fromRGB(100, 100, 255), function(color)
  Config.Visuals.BulletTracersColor = color
end)

Esp:Toggle('Impact Points',function(state)
  Config.Visuals.ImpactPoints = state
end)

Esp:Colorpicker("Impact Points Color",Color3.fromRGB(255, 50, 50), function(color)
  Config.Visuals.ImpactPointsColor = color
end)

GunMods:Toggle('No Recoil',function(state)
  Config.GunMods.Recoil = state
  Funcs:UpdateGuns()
end)

GunMods:Toggle('No Spread',function(state)
  Config.GunMods.Spread = state
  Funcs:UpdateGuns()
end)

GunMods:Toggle('Insta Reload',function(state)
  Config.GunMods.InstaReload = state
  Funcs:UpdateGuns()
end)

GunMods:Toggle('Fire Rate',function(state)
  Config.GunMods.FireRate = state
  Funcs:UpdateGuns()
end)

GunMods:Slider('Fire Rate Speed',2000,3000,function(number)
  Config.GunMods.FireRateSpeed = number
  Funcs:UpdateGuns()
end)

GunMods:Toggle('Combine Mags',function(state)
  Config.GunMods.CombineMags = state
  Funcs:UpdateGuns()
end)

GunMods:Toggle('Rainbow Gun',function(state)
  Config.GunMods.RainbowGun = state
  Funcs:UpdateGuns()
end)

GunMods:Toggle('No Gun Sway',function(state)
  Config.GunMods.Sway = state
  Funcs:UpdateGuns()
end)

GunMods:Toggle('No Gun Bob',function(state)
  Config.GunMods.Bob = state
  Funcs:UpdateGuns()
end)

Player:Slider('Walkspeed',16,65,function(number)
  Config.Player.Walkspeed = number
end)

Player:Slider('Jumppower',4,100,function(number)
  Config.Player.Jumppower = number
end)

Player:Slider('Gravity',0,195,function(number)
  Config.Player.Gravity = number
  game.Workspace.Gravity = 196.19999694824 - Config.Player.Gravity
end)

Player:Toggle('No Fall Damage',function(state)
  Config.Player.FallDmg = state
end)


Player:Toggle('Dont Freeze Character',function(state)
  Config.Player.FreeseCharOnGameEnd = state
end)

local things = Instance.new("Part", Services.Workspace)
things.Name = "things"
things.Transparency = 1

function Funcs:Trace(firstpos, secondpos)
  --local colorSequence = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.new(Config.Visuals.BulletTracersColor.R, Config.Visuals.BulletTracersColor.G, Config.Visuals.BulletTracersColor.B)), ColorSequenceKeypoint.new(1, Color3.new(Config.Visuals.BulletTracersColor.R, Config.Visuals.BulletTracersColor.G, Config.Visuals.BulletTracersColor.B))})
  local colorSequence = ColorSequence.new(Config.Visuals.BulletTracersColor, Config.Visuals.BulletTracersColor)
  local start = Instance.new("Part", things)
  local endd = Instance.new("Part", things)
  local Attachment = Instance.new("Attachment", start)
  local Attachment2 = Instance.new("Attachment", endd)
  local laser = Instance.new("Beam", start)
  start.Size = Vector3.new(1, 1, 1)
  start.Transparency = 1
  start.CanCollide = false
  start.CFrame = CFrame.new(firstpos)
  start.Anchored = true
  endd.Size = Vector3.new(1, 1, 1)
  endd.Transparency = 1
  endd.CanCollide = false
  endd.CFrame = CFrame.new(secondpos)
  endd.Anchored = true
  laser.FaceCamera = false
  laser.Color = colorSequence
  laser.LightEmission = 0
  laser.LightInfluence = 0
  laser.Width0 = 0.1
  laser.Width1 = 0.1
  laser.Attachment0 = Attachment
  laser.Attachment1 = Attachment2
  delay(1.6, function()
    for i = 0.5, 1.3, 0.2 do
      wait()
      laser.Transparency = NumberSequence.new(i)
    end
    start:Destroy()
    endd:Destroy()
  end)
end

function Funcs:Highlight(pos)
  local highlight = Instance.new("Part", things)
  highlight.Size = Vector3.new(0.4, 0.4, 0.4)
  highlight.Transparency = 0.5
  highlight.CanCollide = false
  highlight.Position = pos
  --highlight.CFrame = CFrame.new(pos)
  highlight.Anchored = true
  highlight.Color = Config.Visuals.ImpactPointsColor
  delay(2, function()
    for i = 1, 10 do
      wait()
      highlight.Transparency = highlight.Transparency + 0.05
    end
    highlight:Destroy()
  end)
end

function Funcs.IsVisible(part)
local ignore = {Services.LocalPlayer.Character, part.Parent, Services.Workspace.Camera}
local ray = {Services.LocalPlayer.Character.HumanoidRootPart.Position, part.Position}
local parts = Services.Camera:GetPartsObscuringTarget(ray, ignore)
if not parts[2] then
  return true
end
end

function Funcs:GetTarget()
  local plr = nil;
  local distance = math.huge;
  for i, v in next, game:GetService('Players'):GetPlayers() do
    if v.Name ~= game:GetService('Players').LocalPlayer.Name then
      if debug.getupvalues(getbodyparts)[1][v] and v.Team ~= game:GetService('Players').LocalPlayer.Team then
        local pos, onScreen = Services.Camera:WorldToViewportPoint(debug.getupvalues(getbodyparts)[1][v]['head'].Position);
        local magnitude = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).magnitude;
        local vis = Funcs.IsVisible(debug.getupvalues(getbodyparts)[1][v][Config.Aimbot.AimBone])
        if magnitude < distance and magnitude <= Config.Aimbot.FOV and onScreen and Config.Aimbot.VisCheck and vis or magnitude < distance and magnitude <= Config.Aimbot.FOV and onScreen and not Config.Aimbot.VisCheck then
          plr = v;
          distance = magnitude;
        end
      end
    end
  end
  return plr;
end

effects.bullethit = function(self, ...)
  local args = {...}
  if Config.Visuals.ImpactPoints then
    Funcs:Highlight(args[2])
  end
  return _old(self, unpack(args))
end

particle.new = function(data)
  if Config.Aimbot.Silent and gamelogic.currentgun and data.visualorigin == gamelogic.currentgun.barrel.Position then
    local plr = Funcs:GetTarget()
    if plr then
      data.position = debug.getupvalues(getbodyparts)[1][plr][Config.Aimbot.AimBone].Position;
      data.velocity = trajectory(Services.Camera.CFrame.Position, Vector3.new(0, -196.2, 0), debug.getupvalues(getbodyparts)[1][plr][Config.Aimbot.AimBone].Position, gamelogic.currentgun.data.bulletspeed)
    end
  end
  return __old(data)
end

local send = network.send
network.send = function(self, name, ...)
  local args = {...}
  if name == "falldamage" and Config.Player.FallDmg then
    return;
  end
  if name == "newbullets" then
    local target = Funcs:GetTarget()
    if target and debug.getupvalues(getbodyparts)[1][target] and debug.getupvalues(getbodyparts)[1][target].head and Config.Aimbot.Silent then
      local targetPos = debug.getupvalues(getbodyparts)[1][target][Config.Aimbot.AimBone].Position
      local localPos = camera.basecframe * Vector3.new(0, 0, 0.5)
      local dir = trajectory(localPos, Vector3.new(0, -192.6, 0), targetPos, gamelogic.currentgun.data.bulletspeed)
      bulletdata = {
        firepos = localPos,
        camerapos = localPos,
        pitch = 1,
        bullets = {
          {
            dir,
            ticket,
          }
        }
      }
      send(self, "newbullets", bulletdata, tick())
      send(self, "bullethit", target, targetPos, debug.getupvalues(getbodyparts)[1][target][Config.Aimbot.AimBone], ticket)
      Funcs:Trace(gamelogic.currentgun.barrel.Position, targetPos)
      if Config.Visuals.ImpactPoints then
        Funcs:Highlight(targetPos)
      end
      ticket = ticket - 1
    end
    if Config.Visuals.BulletTracers and target == nil and Config.Aimbot.Silent or Config.Visuals.BulletTracers and not Config.Aimbot.Silent then
      Funcs:Trace(gamelogic.currentgun.barrel.Position, args[1]["bullets"][1][1] * args[1]["bullets"][1][2])
    end
  end
  return send(self, name, unpack(args))
end

spawn(function()
  while wait() do
    pcall(function()
      TargetPlayer = Funcs:GetTarget()
      if TargetPlayer and Config.Aimbot.MouseTwoDown and Config.Aimbot.Aimbot and debug.getupvalues(getbodyparts)[1][TargetPlayer] then
        local niggasbone = Services.Camera:WorldToScreenPoint(debug.getupvalues(getbodyparts)[1][TargetPlayer][Config.Aimbot.AimBone].Position)
        local moveto = Vector2.new((niggasbone.X-Mouse.X)*Config.Aimbot.Smoothness,(niggasbone.Y-Mouse.Y)*Config.Aimbot.Smoothness)
        mousemoverel(moveto.X,moveto.Y)
      end
    end)
  end
end)

Mouse.Button2Down:Connect(function()
  Config.Aimbot.MouseTwoDown = true
end)

Mouse.Button2Up:Connect(function()
  Config.Aimbot.MouseTwoDown = false
end)

function Funcs:AddEsp(player)
  local bottomrightone = Funcs:DrawLine()
  local bottomleftone = Funcs:DrawLine()
  local toprightone = Funcs:DrawLine()
  local topleftone = Funcs:DrawLine()
  local toplefttwo = Funcs:DrawLine()
  local bottomlefttwo = Funcs:DrawLine()
  local toprighttwo = Funcs:DrawLine()
  local bottomrighttwo = Funcs:DrawLine()
  local box = Funcs:DrawSquare()
  local tracer = Funcs:DrawLine()
  Services.RunService.Stepped:Connect(function()
    if debug.getupvalues(getbodyparts)[1][player] and Funcs:IsAlive(debug.getupvalues(getbodyparts)[1][player].head.Parent) and player.Team ~= Services.LocalPlayer.Team then
      bottomrightone.Color = Config.Visuals.EnemyColor
      bottomleftone.Color = Config.Visuals.EnemyColor
      toprightone.Color = Config.Visuals.EnemyColor
      topleftone.Color = Config.Visuals.EnemyColor
      toplefttwo.Color = Config.Visuals.EnemyColor
      bottomlefttwo.Color = Config.Visuals.EnemyColor
      toprighttwo.Color = Config.Visuals.EnemyColor
      bottomrighttwo.Color = Config.Visuals.EnemyColor
      box.Color = Config.Visuals.EnemyColor
      tracer.Color = Config.Visuals.EnemyColor
    else
      bottomrightone.Color = Config.Visuals.TeamColor
      bottomleftone.Color = Config.Visuals.TeamColor
      toprightone.Color = Config.Visuals.TeamColor
      topleftone.Color = Config.Visuals.TeamColor
      toplefttwo.Color = Config.Visuals.TeamColor
      bottomlefttwo.Color = Config.Visuals.TeamColor
      toprighttwo.Color = Config.Visuals.TeamColor
      bottomrighttwo.Color = Config.Visuals.TeamColor
      box.Color = Config.Visuals.TeamColor
      tracer.Color = Config.Visuals.TeamColor
    end
    if debug.getupvalues(getbodyparts)[1][player] and Funcs:IsAlive(debug.getupvalues(getbodyparts)[1][player].head.Parent) and debug.getupvalues(getbodyparts)[1][player].rootpart then
      local RootPosition, OnScreen = Services.Camera:WorldToViewportPoint(debug.getupvalues(getbodyparts)[1][player].rootpart.Position)
      local HeadPosition = Services.Camera:WorldToViewportPoint(debug.getupvalues(getbodyparts)[1][player].head.Position + Vector3.new(0, 0, 0))
      local LegPosition = Services.Camera:WorldToViewportPoint(debug.getupvalues(getbodyparts)[1][player].rootpart.Position - Vector3.new(0, 5, 0))
      local length = RootPosition.Y - ((HeadPosition.Y - LegPosition.Y) / 2)
      local lengthx = RootPosition.X - ((HeadPosition.Y - LegPosition.Y) / 2)
      local size = HeadPosition.Y - LegPosition.Y
      if Config.Visuals.CornerBoxEsp and Funcs:IsAlive(debug.getupvalues(getbodyparts)[1][player].head.Parent) then
        bottomrightone.Visible = OnScreen
        bottomrightone.From = Vector2.new(RootPosition.X - ((HeadPosition.Y - LegPosition.Y) / 2), length)
        bottomrightone.To = Vector2.new(RootPosition.X - ((HeadPosition.Y - LegPosition.Y) / 2) + (size / 3), length)
        bottomleftone.Visible = OnScreen
        bottomleftone.From = Vector2.new((RootPosition.X - ((HeadPosition.Y - LegPosition.Y) / 2)) + size, length)
        bottomleftone.To = Vector2.new(RootPosition.X - ((HeadPosition.Y - LegPosition.Y) / 2) + ((size / 3) * 2), length)
        toprightone.Visible = OnScreen
        toprightone.From = Vector2.new(RootPosition.X - ((HeadPosition.Y - LegPosition.Y) / 2), length + size)
        toprightone.To = Vector2.new(RootPosition.X - ((HeadPosition.Y - LegPosition.Y) / 2) + (size / 3), length + size)
        topleftone.Visible = OnScreen
        topleftone.From = Vector2.new((RootPosition.X - ((HeadPosition.Y - LegPosition.Y) / 2)) + size, length + size)
        topleftone.To = Vector2.new(RootPosition.X - ((HeadPosition.Y - LegPosition.Y) / 2) + ((size / 3) * 2), length + size)
        toplefttwo.Visible = OnScreen
        toplefttwo.From = Vector2.new(lengthx, (RootPosition.Y - ((HeadPosition.Y - LegPosition.Y) / 2)) + size)
        toplefttwo.To = Vector2.new(lengthx, (RootPosition.Y - ((HeadPosition.Y - LegPosition.Y) / 2)) + ((size / 3) * 2))
        bottomlefttwo.Visible = OnScreen
        bottomlefttwo.From = Vector2.new(lengthx, (RootPosition.Y - (HeadPosition.Y - LegPosition.Y) / 2))
        bottomlefttwo.To = Vector2.new(lengthx, (RootPosition.Y - ((HeadPosition.Y - LegPosition.Y) / 2)) + (size / 3))
        toprighttwo.Visible = OnScreen
        toprighttwo.From = Vector2.new(lengthx + size, (RootPosition.Y - ((HeadPosition.Y - LegPosition.Y) / 2)) + size)
        toprighttwo.To = Vector2.new(lengthx + size, (RootPosition.Y - ((HeadPosition.Y - LegPosition.Y) / 2)) + ((size / 3) * 2))
        bottomrighttwo.Visible = OnScreen
        bottomrighttwo.From = Vector2.new(lengthx + size, (RootPosition.Y - (HeadPosition.Y - LegPosition.Y) / 2))
        bottomrighttwo.To = Vector2.new(lengthx + size, (RootPosition.Y - ((HeadPosition.Y - LegPosition.Y) / 2)) + (size / 3))
      else
        bottomrightone.Visible = false
        bottomleftone.Visible = false
        toprightone.Visible = false
        topleftone.Visible = false
        toplefttwo.Visible = false
        bottomlefttwo.Visible = false
        toprighttwo.Visible = false
        bottomrighttwo.Visible = false
      end
      if Config.Visuals.BoxEsp then
        box.Visible = OnScreen
        box.Size = Vector2.new(HeadPosition.Y - LegPosition.Y, HeadPosition.Y - LegPosition.Y)
        box.Position = Vector2.new(RootPosition.X - ((HeadPosition.Y - LegPosition.Y) / 2), RootPosition.Y - ((HeadPosition.Y - LegPosition.Y) / 2))
      else
        box.Visible = false
      end
      if Config.Visuals.TracerEsp then
        tracer.Visible = OnScreen
        if Config.Visuals.TracersOrigin == "Top" then
          tracer.To = Vector2.new(Services.Camera.ViewportSize.X / 2, 0)
          tracer.From = Vector2.new(RootPosition.X - 1, RootPosition.Y + (HeadPosition.Y - LegPosition.Y) / 2)
        elseif Config.Visuals.TracersOrigin == "Middle" then
          tracer.To = Vector2.new(Services.Camera.ViewportSize.X / 2, Services.Camera.ViewportSize.Y / 2)
          tracer.From = Vector2.new(RootPosition.X - 1, (RootPosition.Y + (HeadPosition.Y - LegPosition.Y) / 2) - ((HeadPosition.Y - LegPosition.Y) / 2))
        elseif Config.Visuals.TracersOrigin == "Bottom" then
          tracer.To = Vector2.new(Services.Camera.ViewportSize.X / 2, 1000)
          tracer.From = Vector2.new(RootPosition.X - 1, RootPosition.Y - (HeadPosition.Y - LegPosition.Y) / 2)
        elseif Config.Visuals.TracersOrigin == "Mouse" then
          tracer.To = game:GetService('UserInputService'):GetMouseLocation();
          tracer.From = Vector2.new(RootPosition.X - 1, (RootPosition.Y + (HeadPosition.Y - LegPosition.Y) / 2) - ((HeadPosition.Y - LegPosition.Y) / 2))
        end
      else
        tracer.Visible = false
      end
    else
      bottomrightone.Visible = false
      bottomleftone.Visible = false
      toprightone.Visible = false
      topleftone.Visible = false
      toplefttwo.Visible = false
      bottomlefttwo.Visible = false
      toprighttwo.Visible = false
      bottomrighttwo.Visible = false
      box.Visible = false
      tracer.Visible = false
    end
  end)
end

for i, v in pairs(Services.Players:GetPlayers()) do
  if v ~= Services.LocalPlayer then
    Funcs:AddEsp(v)
  end
end

Services.Players.PlayerAdded:Connect(function(player)
  if v ~= Services.LocalPlayer then
    Funcs:AddEsp(player)
  end
end)

for i, v in pairs(game:GetService("ReplicatedStorage").GunModules:GetChildren()) do
  rv = require(v)
  Config.OldGunModules[v] = {}
  Config.OldGunModules[v]["aimrotkickmin"] = rv.aimrotkickmin
  Config.OldGunModules[v]["aimrotkickmax"] = rv.aimrotkickmax
  Config.OldGunModules[v]["aimtranskickmin"] = rv.aimtranskickmin
  Config.OldGunModules[v]["aimtranskickmax"] = rv.aimtranskickmax
  Config.OldGunModules[v]["aimcamkickmin"] = rv.aimcamkickmin
  Config.OldGunModules[v]["aimcamkickmax"] = rv.aimcamkickmax
  Config.OldGunModules[v]["camkickspeed"] = rv.camkickspeed
  Config.OldGunModules[v]["rotkickmin"] = rv.rotkickmin
  Config.OldGunModules[v]["rotkickmax"] = rv.rotkickmax
  Config.OldGunModules[v]["transkickmin"] = rv.transkickmin
  Config.OldGunModules[v]["transkickmax"] = rv.transkickmax
  Config.OldGunModules[v]["camkickmin"] = rv.camkickmin
  Config.OldGunModules[v]["camkickmax"] = rv.camkickmax
  Config.OldGunModules[v]["aimcamkickspeed"] = rv.aimcamkickspeed
  Config.OldGunModules[v]["modelkickspeed"] = rv.modelkickspeed
  Config.OldGunModules[v]["modelrecoverspeed"] = rv.modelrecoverspeed
  Config.OldGunModules[v]["hipfirespread"] = rv.hipfirespread
  Config.OldGunModules[v]["hipfirestability"] = rv.hipfirestability
  Config.OldGunModules[v]["hipfirespreadrecover"] = rv.hipfirespreadrecover
  Config.OldGunModules[v]["crosssize"] = rv.crosssize
  Config.OldGunModules[v]["crossexpansion"] = rv.crossexpansion
  Config.OldGunModules[v]["swayamp"] = rv.swayamp
  Config.OldGunModules[v]["swayspeed"] = rv.swayspeed
  Config.OldGunModules[v]["steadyspeed"] = rv.steadyspeed
  Config.OldGunModules[v]["breathspeed"] = rv.breathspeed
  Config.OldGunModules[v]["variablefirerate"] = rv.variablefirerate
  Config.OldGunModules[v]["firerate"] = rv.firerate
  Config.OldGunModules[v]["firemodes"] = rv.firemodes
  Config.OldGunModules[v]["firemodes"] = rv.firemodes
  if rv["magsize"] and rv["sparerounds"] then
    Config.OldGunModules[v]["magsize"] = rv.magsize
    Config.OldGunModules[v]["sparerounds"] = rv.sparerounds
  end
  if rv.animations and rv.animations.reload then
    for k, j in pairs(rv.animations) do
      if string.find(string.lower(k), "reload") then
        Config.OldGunModules[v]["timescale"] = rv.animations[k].timescale
      end
    end
  end
end

function Funcs:UpdateGuns()
  for i,s in pairs(game:GetService("ReplicatedStorage").GunModules:GetChildren()) do
    rs = require(s)
    if Config.GunMods.Recoil then
      rs.aimrotkickmin = Vector3.new(0, 0, 0)
      rs.aimrotkickmax = Vector3.new(0, 0, 0)
      rs.aimtranskickmin = Vector3.new(0, 0, 0)
      rs.aimtranskickmax = Vector3.new(0, 0, 0)
      rs.aimcamkickmin = Vector3.new(0, 0, 0)
      rs.aimcamkickmax = Vector3.new(0, 0, 0)
      rs.camkickspeed = 99999
      rs.rotkickmin = Vector3.new(0, 0, 0)
      rs.rotkickmax = Vector3.new(0, 0, 0)
      rs.transkickmin = Vector3.new(0, 0, 0)
      rs.transkickmax = Vector3.new(0, 0, 0)
      rs.camkickmin = Vector3.new(0, 0, 0)
      rs.camkickmax = Vector3.new(0, 0, 0)
      rs.aimcamkickspeed = 99999
      rs.modelkickspeed = 99999
      rs.modelrecoverspeed = 99999
    else
      rs.aimrotkickmin = Config.OldGunModules[s].aimrotkickmin
      rs.aimrotkickmax = Config.OldGunModules[s].aimrotkickmax
      rs.aimtranskickmin = Config.OldGunModules[s].aimtranskickmin
      rs.aimtranskickmax = Config.OldGunModules[s].aimtranskickmax
      rs.aimcamkickmin = Config.OldGunModules[s].aimcamkickmin
      rs.aimcamkickmax = Config.OldGunModules[s].aimcamkickmax
      rs.camkickspeed = Config.OldGunModules[s].camkickspeed
      rs.rotkickmin = Config.OldGunModules[s].rotkickmin
      rs.rotkickmax = Config.OldGunModules[s].rotkickmax
      rs.transkickmin = Config.OldGunModules[s].transkickmin
      rs.transkickmax = Config.OldGunModules[s].transkickmax
      rs.camkickmin = Config.OldGunModules[s].camkickmin
      rs.camkickmax = Config.OldGunModules[s].camkickmax
      rs.aimcamkickspeed = Config.OldGunModules[s].aimcamkickspeed
      rs.modelkickspeed = Config.OldGunModules[s].modelkickspeed
      rs.modelrecoverspeed = Config.OldGunModules[s].modelrecoverspeed
    end
    if Config.GunMods.Spread then
      rs.hipfirespread = 0.00001
      rs.hipfirestability = 0.00001
      rs.hipfirespreadrecover = 99999
      rs.crosssize = 5
      rs.crossexpansion = 0.00001
    else
      rs.hipfirespread = Config.OldGunModules[s].hipfirespread
      rs.hipfirestability = Config.OldGunModules[s].hipfirestability
      rs.hipfirespreadrecover = Config.OldGunModules[s].hipfirespreadrecover
      rs.crosssize = Config.OldGunModules[s].crosssize
      rs.crossexpansion = Config.OldGunModules[s].crossexpansion
    end
    if Config.GunMods.Sway then
      rs.swayamp = 0.00001
      rs.swayspeed = 0.00001
      rs.steadyspeed = 0.00001
      rs.breathspeed = 0.00001
    else
      rs.swayamp = Config.OldGunModules[s].swayamp
      rs.swayspeed = Config.OldGunModules[s].swayspeed
      rs.steadyspeed = Config.OldGunModules[s].steadyspeed
      rs.breathspeed = Config.OldGunModules[s].breathspeed
    end
    if Config.GunMods.FireRate then
      rs.variablefirerate = false
      rs.firerate = Config.GunMods.FireRateSpeed
      rs.firemodes = {true}
    else
      rs.variablefirerate = Config.OldGunModules[s].variablefirerate
      rs.firerate = Config.OldGunModules[s].firerate
      rs.firemodes = Config.OldGunModules[s].firemodes
    end
    if Config.GunMods.CombineMags and rs["magsize"] and rs["sparerounds"] then
      rs.magsize = rs.magsize + rs.sparerounds
      rs.sparerounds = 0
    elseif rs["magsize"] and rs["sparerounds"] then
      rs.magsize = Config.OldGunModules[s].magsize
      rs.sparerounds = Config.OldGunModules[s].sparerounds
    end
    if Config.GunMods.InstaReload then
      if rs.animations and rs.animations.reload then
        for k, v in pairs(rs.animations) do
          if string.find(string.lower(k), "reload") then
            rs.animations[k].timescale = 0
          end
        end
      end
    else
      if rs.animations and rs.animations.reload then
        for k, v in pairs(rs.animations) do
          if string.find(string.lower(k), "reload") then
            rs.animations[k].timescale = Config.OldGunModules[s].timescale
          end
        end
      end
    end
  end
end

for a,b in pairs(getgc(true)) do
  if typeof(b) == "table" and rawget(b,"setbasewalkspeed") then
    game:GetService("RunService").Stepped:Connect(function()
      b:setbasewalkspeed(Config.Player.Walkspeed)
    end)
  end
end

for a,b in pairs(getgc(true)) do
  if typeof(b) == "table" and rawget(b,"jump") then
    h = b.jump
    function b.jump(...)
      local o = {...}
      o[2] = Config.Player.Jumppower
      return h(unpack(o))
    end
  end
end

local FOVCircle = Drawing.new("Circle")
FOVCircle.Color = Color3.fromRGB(190, 190, 0)
FOVCircle.Thickness = 0.5
FOVCircle.NumSides = 16
FOVCircle.Filled = false
FOVCircle.Transparency = 1

spawn(function()
  while wait(0.2) do
    if Config.Aimbot.KillAura then
      pcall(function()
        for i, v in next, game:GetService('Players'):GetPlayers() do
          if v.Name ~= game:GetService('Players').LocalPlayer.Name then
            if debug.getupvalues(getbodyparts)[1][v] and debug.getupvalues(getbodyparts)[1][v]['head'] then
              mag  = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - debug.getupvalues(getbodyparts)[1][v]['head'].Position).magnitude
              if mag < 14 then
                network:send('knifehit',v,tick(),debug.getupvalues(getbodyparts)[1][v]['head'])
              end    
            end
          end
        end
      end)
    end
  end
end)

Services.RunService.Stepped:Connect(function()
  if Config.Player.FreeseCharOnGameEnd then
    game:GetService("ReplicatedStorage").ServerSettings.ShowResults.Value = false
  end
  if Config.Player.AlwaysAllowSpawn then
    game:GetService("ReplicatedStorage").ServerSettings.AllowSpawn.Value = true
  end
  if Config.Aimbot.RandomAimBone then
    random = math.random(1,2)
    if random == 1 then
      Config.Aimbot.AimBone = "head"
    elseif random == 2 then
      Config.Aimbot.AimBone = "rootpart"
    end
  end
  if Config.GunMods.RainbowGun then
    for a,b in pairs(workspace.Camera:GetChildren()) do 
      for c,d in pairs(game:GetService("ReplicatedStorage").GunModels:GetChildren()) do ---Darkhub skidded this
        if b.Name == d.Name then 
          for e,f in pairs(b:GetChildren()) do 
            if f:IsA("BasePart") then 
              f.Color = Color3.fromHSV(tick()%5/5,1,1)
              f.Material = "Neon"
            end
          end
        end
      end
    end
  end
  if Config.GunMods.Bob then
    pcall(function()
      if type(debug.getupvalue(gamelogic.currentgun.step, 28)) == 'function' then
        debug.setupvalue(gamelogic.currentgun.step, 28, function() return CFrame.new() end)
      end
    end)
  end
  FOVCircle.Position = game:GetService('UserInputService'):GetMouseLocation();
  FOVCircle.Radius = Config.Aimbot.FOV
  if Config.Aimbot.DrawFOV then
    FOVCircle.Visible = true
  else
    FOVCircle.Visible = false
  end
  for i,v in pairs(game:GetService("Workspace").Players.Ghosts:GetChildren()) do
    if v:FindFirstChild("Humanoid") then
      Config.Player.Team = "Phantoms"
    end
  end
  for i,v in pairs(game:GetService("Workspace").Players.Phantoms:GetChildren()) do
    if v:FindFirstChild("Humanoid") then
      Config.Player.Team = "Ghosts"
    end
  end
end)
end)
end








if game.PlaceId == 2041312716 then
--Ragdoll Engine Script Here////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/whiteyume1/whiteyume1/main/darkhubuilib.lua"))()

local main = lib:CreateMain()

local Main = main:CreateWindow("Server")
local LPWIN = main:CreateWindow("LocalPlayer")

Client = {
Toggles = {
    NoRagDoll = false,
    BombAll = false
}
}

local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/whiteyume1/whiteyume1/main/darkhubuilib.lua", true))()
local lib2 = loadstring(game:HttpGet("https://raw.githubusercontent.com/whiteyume1/whiteyume1/main/darkhubuilib.lua", true))()
function Info(Text)
lib:Notify("[ INFO ] : "..Text)
end
function Error(Text)
local colour = "fa34f7" -- Hex Type
lib2:Notify("[ ERROR ] : "..Text, "0x" .. colour)
end

function BombRemote()
temp_bombs = {}
for i,v in pairs(game:GetService('Players'):GetPlayers()) do
    if v:FindFirstChild('Backpack') and v.Backpack:FindFirstChild('ImpulseGrenade') then
        table.insert(temp_bombs,v.Backpack.ImpulseGrenade.CreateGrenade)
    end
end
return temp_bombs[math.random(1,#temp_bombs)]
end
function InvisRemote()
temp_bombs = {}
for i,v in pairs(game:GetService('Players'):GetPlayers()) do
    if v:FindFirstChild('Backpack') and v.Backpack:FindFirstChild('OddPotion') then
        table.insert(temp_bombs,v.Backpack.OddPotion.TransEvent)
    end
end
return temp_bombs[math.random(1,#temp_bombs)]
end
function PotionRemote()
temp_bombs = {}
for i,v in pairs(game:GetService('Players'):GetPlayers()) do
    if v:FindFirstChild('Backpack') and v.Backpack:FindFirstChild('OddPotion') then
        table.insert(temp_bombs,v.Backpack.OddPotion.PotionEvent)
    end
end
return temp_bombs[math.random(1,#temp_bombs)]
end

function BombAll()
pcall(function()
    if not BombRemote() then
        Error('Failed To Fetch Remote')
    end
    for i = 1,3 do
        for i,v in pairs(game:GetService('Players'):GetPlayers()) do
            if v ~= game.Players.LocalPlayer then    
                local v1 = Vector3.new(0, 0, 0)
                local v2 = v.Character.Head.CFrame
                local rem = BombRemote()
                rem:FireServer(v1, v2)
            end
        end
    end
end)
end

local getname = function(str)
for i,v in next, game:GetService("Players"):GetChildren() do
    if string.find(string.lower(v.Name), string.lower(str)) then
        return v.Name
    end
end
end

LPWIN:Slider('Walkspeed',function(num)
game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = num
end,{min=16,max=500})
LPWIN:Slider('JumpPower',function(num)
game.Players.LocalPlayer.Character.Humanoid.JumpPower = num
end,{min=50,max=500})
LPWIN:Toggle('No Ragdoll',function(state)
Client.Toggles.NoRagDoll = state
end)
LPWIN:Button('Drink Weird Potion',function()
if not PotionRemote() then
    Error('Failed To Fetch Remote')
    return
end
local rem = PotionRemote()
rem:FireServer()
end)
LPWIN:TextBox('Goto','Name',function(Text)
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService('Players')[getname(Text)].Character.Head.CFrame
end)
Main:TextBox('Bomb','Name',function(Text)
for i = 1,3 do
    for i,v in pairs(game:GetService('Players'):GetPlayers()) do
        if v == game:GetService('Players')[getname(Text)] then    
            local v1 = Vector3.new(0, 0, 0)
            local v2 = v.Character.Head.CFrame
            local rem = BombRemote()
            rem:FireServer(v1, v2)
        end
    end
end
end)
Main:Button('Bomb All',function()
BombAll()
end)
Main:Toggle('Loop Bomb All',function(state)
Client.Toggles.BombAll = state
end)
Main:Toggle('Invisible Me',function(state)
if not InvisRemote() then
    Error('Failed To Fetch Remote')
    return
end
if state == true then
    for i,v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
        if v.Name ~= 'HumanoidRootPart' then
            local v1 = v
            local v2 = 1
            local rem = InvisRemote()
            rem:FireServer(v1, v2)
        end
    end
else
    for i,v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
        if v.Name ~= 'HumanoidRootPart' then
            local v1 = v
            local v2 = 0
            local rem = InvisRemote()
            rem:FireServer(v1, v2)
        end
    end
end
end)
Main:Button('Ghost Me',function(state)
for i,v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
    if v.Name ~= 'HumanoidRootPart' then
        local v1 = v
        local v2 = 0.6
        local rem = InvisRemote()
        rem:FireServer(v1, v2)
    end
end
end)
Main:Button('Invisible All Players',function()
pcall(function()
    for i,v in pairs(game.Players:GetPlayers()) do
        wait()
        for i,v in pairs(v.Character:GetDescendants()) do
            if v.Name ~= 'HumanoidRootPart' then
                local v1 = v
                local v2 = 1
                local rem = InvisRemote()
                rem:FireServer(v1, v2)
            end
        end
    end
end)
end)
Main:Button('Visible All Players',function()
pcall(function()
    for i,v in pairs(game.Players:GetPlayers()) do
        wait()
        for i,v in pairs(v.Character:GetDescendants()) do
            if v.Name ~= 'HumanoidRootPart' then
                local v1 = v
                local v2 = 0
                local rem = InvisRemote()
                rem:FireServer(v1, v2)
            end
        end
    end
end)
end)
Main:Button('Invisible Map',function()
for i,v in pairs(game.Workspace:GetDescendants()) do
    if v:IsA('Part') or v:IsA('BasePart') and v.Name ~= 'HumanoidRootPart' then
        local v1 = v
        local v2 = 1
        local rem = InvisRemote()
        rem:FireServer(v1, v2)
    end
end
end)
Main:Button('Visible Map',function()
for i,v in pairs(game.Workspace:GetDescendants()) do
    if v:IsA('Part') or v:IsA('BasePart') and v.Name ~= 'HumanoidRootPart' then
        local v1 = v
        local v2 = 0
        local rem = InvisRemote()
        rem:FireServer(v1, v2)
    end
end
end)
game:GetService("RunService").RenderStepped:Connect(function()
if Client.Toggles.NoRagDoll == true then
    game:GetService("Players").LocalPlayer.Character["Local Ragdoll"].Disabled = true
else
    game:GetService("Players").LocalPlayer.Character["Local Ragdoll"].Disabled = false
end
end)

spawn(function()
while true do
    wait(3.2)
    pcall(function()
        if Client.Toggles.BombAll == true then
            BombAll()
        end
    end)
end
end)
end









if game.PlaceId == 2377868063 then
--Sound Space Script Here/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/whiteyume1/whiteyume1/main/darkhubuilib.lua"))()
main = lib:Window()
Notif = getsenv(game.Players.LocalPlayer.PlayerScripts.SpecialMessageHandler).Announce
localPlayer = game:GetService("Players").LocalPlayer
currentCamera = game:GetService("Workspace").CurrentCamera
Mouse = localPlayer:GetMouse()
CameraLock = false
v_TweenV = 0
MainScript = getsenv(game.ReplicatedFirst.GameScript)
VRModule = require(game.ReplicatedFirst.VR.VRModule)
LockValue = CFrame.new(Vector3.new(7, 3, 0) +  Vector3.new(0.1, 0, 0)) * CFrame.Angles(0, math.pi / 2, 0)
local TweenValue = Instance.new("CFrameValue")
TweenValue.Value = CFrame.new(Vector3.new(7, 3, 0) +  Vector3.new(0.1, 0, 0)) * CFrame.Angles(0, math.pi / 2, 0)

local UserInputService = game:GetService("UserInputService")
Main = main:Tab('Sound Space')

Main:Keybind(
"AutoPlay",Enum.KeyCode.E,
function()
    t_Status = not t_Status
    if t_Status == true then
        Notif({Msg = "Enabled", Img = "TominoCZ"})
    else
        Notif({Msg = "Disabled", Img = "TominoCZ"})
    end
end
)
Main:Toggle('Camera Lock',function(state)
CameraLock = state
end)
Main:Slider('Smoothness',0,2,function(num)
v_TweenV = num
end)
t_Trail = false
Main:Toggle('Cursor Trail',function(state)
t_Trail = state
end)
oldColor = getfenv(require(game:GetService("ReplicatedFirst").GameScript).CursorTrail)._G.PlayerData.Inventory.CursorColors.Equipped
t_rainbow = false
Main:Toggle('Rainbow Cursor',function(state)
t_rainbow = state
end)
Main:Toggle('No Fail',function(state)
game:GetService("Players").LocalPlayer.MapData.Mods.NoFail.Value = state
end)
spawn(function()
while wait() do
    getfenv(require(game:GetService("ReplicatedFirst").GameScript).CursorTrail)._G.PlayerData.Settings.CursorTrail = t_Trail
    if t_rainbow == true then
        getfenv(require(game:GetService("ReplicatedFirst").GameScript).CursorTrail)._G.PlayerData.Inventory.CursorColors.Equipped = 11
    else
        getfenv(require(game:GetService("ReplicatedFirst").GameScript).CursorTrail)._G.PlayerData.Inventory.CursorColors.Equipped = oldColor
    end
end
end)
local Camera = game.workspace.CurrentCamera
local Player = game.Players.LocalPlayer
t_Status = false
Tab_Cubes = {}

game.Workspace.DescendantAdded:Connect(function(v)
if v:IsA("Part") and v:FindFirstChildOfClass('Color3Value') and v:FindFirstChildOfClass('SelectionBox') then
    table.insert(Tab_Cubes,v)
end
end)

function CleanUp()
for i,v in pairs(Tab_Cubes) do
    if v.Parent == nil then
        table.remove(Tab_Cubes,i)
    end
end
end

function getClosestCube()
local closestCube = nil
local shortestDistance = math.huge

if Tab_Cubes then
    for i, v in pairs(Tab_Cubes) do
        if Camera and v.Parent ~= nil then
            local magnitude = (v.Position - Camera.CFrame.p).magnitude
            if magnitude < shortestDistance then
                closestCube = v
                shortestDistance = magnitude
            end
        end
    end
end

return closestCube
end


game:GetService('RunService').Heartbeat:connect(function()
CleanUp()
if t_Status and not CameraLock then
    if getClosestCube() ~= nil then
        magnitude = (getClosestCube().Position - Camera.CFrame.p).magnitude
        --game:GetService("TweenService"):Create(workspace.CurrentCamera, TweenInfo.new(magnitude / 250, Enum.EasingStyle.Linear), {CFrame = CFrame.new(workspace.CurrentCamera.CFrame.p, Vector3.new(0, getClosestCube().Position.Y,  getClosestCube().Position.Z))}):Play()
        if v_TweenV == 0 then
            game:GetService("TweenService"):Create(workspace.CurrentCamera, TweenInfo.new(0.01, Enum.EasingStyle.Linear), {CFrame = CFrame.new(workspace.CurrentCamera.CFrame.p, Vector3.new(0, getClosestCube().Position.Y,  getClosestCube().Position.Z))}):Play()
        end
        if v_TweenV == 1 then
            game:GetService("TweenService"):Create(workspace.CurrentCamera, TweenInfo.new(magnitude / 700, Enum.EasingStyle.Linear), {CFrame = CFrame.new(workspace.CurrentCamera.CFrame.p, Vector3.new(0, getClosestCube().Position.Y,  getClosestCube().Position.Z))}):Play()
        end
        if v_TweenV == 2 then
            game:GetService("TweenService"):Create(workspace.CurrentCamera, TweenInfo.new(magnitude / 250, Enum.EasingStyle.Linear), {CFrame = CFrame.new(workspace.CurrentCamera.CFrame.p, Vector3.new(0, getClosestCube().Position.Y,  getClosestCube().Position.Z))}):Play()
        end
    end
end
if t_Status and CameraLock then
    if getClosestCube() ~= nil then
        magnitude = (getClosestCube().Position - Camera.CFrame.p).magnitude
        if v_TweenV == 0 then
            game:GetService("TweenService"):Create(TweenValue, TweenInfo.new(0.01, Enum.EasingStyle.Linear), {Value = CFrame.new(Camera.CFrame.p, Vector3.new(0, getClosestCube().Position.Y, getClosestCube().Position.Z))}):Play()
        end
        if v_TweenV == 1 then
            game:GetService("TweenService"):Create(TweenValue, TweenInfo.new(magnitude / 700, Enum.EasingStyle.Linear), {Value = CFrame.new(Camera.CFrame.p, Vector3.new(0, getClosestCube().Position.Y, getClosestCube().Position.Z))}):Play()
        end
        if v_TweenV == 2 then
            game:GetService("TweenService"):Create(TweenValue, TweenInfo.new(magnitude / 250, Enum.EasingStyle.Linear), {Value = CFrame.new(Camera.CFrame.p, Vector3.new(0, getClosestCube().Position.Y, getClosestCube().Position.Z))}):Play()
        end
    end
end
end)

function IsPlaying()
if game.Players.LocalPlayer.MapData.Playing.Value or getClosestCube() ~= nil then
    return true
else
    return false
end
end

debug.setupvalue(MainScript.UpdateSaber, 1, function()
if CameraLock and not t_Status and IsPlaying() then
    local camera = workspace.CurrentCamera
    camera.CameraType = Enum.CameraType.Scriptable 
    return CFrame.new(Camera.CFrame.Position, Mouse.Hit.Position)
end
if CameraLock and t_Status and IsPlaying() then
    local camera = workspace.CurrentCamera
    camera.CameraType = Enum.CameraType.Scriptable
    camera.CFrame = LockValue
    if getClosestCube() ~= nil and IsPlaying() then
        if v_TweenV == 0 then
            return CFrame.new(Camera.CFrame.Position, getClosestCube().Position)
        end
        return TweenValue.Value
    else
        return(Camera.CFrame)
    end
end
if not CameraLock and not IsPlaying() then
    Camera.CameraType = "Track"
    UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
    return(Camera.CFrame)
end
if IsPlaying() and not CameraLock then
    Camera.CameraType = "Track"
    UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
    return(Camera.CFrame)
end
if not CameraLock then
    Camera.CameraType = "Track"
    UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
    return(Camera.CFrame)
end
end)
--MainScript.ResetCamera()
function SpoofCamera()
return CFrame.new(Camera.CFrame.Position, Mouse.Hit.Position)
end
VRModule.GetWorldCFrame = SpoofCamera

Notif({Msg = "DarkHub Loaded", Img = "TominoCZ"})
end










if game.PlaceId == 2377868063 then
--Strucid Script Here////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
local Config = {
Visuals = {
BoxEsp = false,
CornerBoxEsp = false,
TracerEsp = false,
TracersOrigin = "Top", -- "Top", "Middle", "Bottom", or "Mouse"
NameEsp = false,
DistanceEsp = false,
SkeletonEsp = false,
EnemyColor = Color3.fromRGB(190, 190, 0),
TeamColor = Color3.fromRGB(0, 190, 0),
TeamCheck = true -- Auto changes if gamemode is ffa
},
Aimbot = {
Aimbot = false,
TriggerBot = false,
Smoothness = 0.25,
AimBone = "Head",
RandomAimBone = true,
MouseTwoDown = false, -- Dont Touch
Silent = false,
VisCheck = false,
DrawFOV = false,
FOV = 200,
SnapLines = false
},
GunMods = {
Recoil = false,
Spread = false,
FireRate = false,
InfAmmo = false,
InfRange = false,
Wallbang = false
},
LocalPlayer = {
Nofatigue = false,
PROFOV = false,
NoFD = false
}
}

local Services = setmetatable({
LocalPlayer = game:GetService("Players").LocalPlayer,
Camera = workspace.CurrentCamera,
}, {
__index = function(self, idx)
return rawget(self, idx) or game:GetService(idx)
end
})

local Funcs = {}

function Funcs:IsAlive(player)
if player and player.Character and player.Character:FindFirstChild("Head") and workspace:FindFirstChild(player.Character.Name) and player ~= Services.LocalPlayer then
return true
end
end

function Funcs:Round(number)
return math.floor(tonumber(number) + 0.5)
end

function Funcs:DrawSquare()
local Box = Drawing.new("Square")
Box.Color = Color3.fromRGB(190, 190, 0)
Box.Thickness = 0.5
Box.Filled = false
Box.Transparency = 1
return Box
end

function Funcs:DrawQuad() -- Unused
local quad = Drawing.new("Quad")
quad.Color = Color3.fromRGB(190, 190, 0)
quad.Thickness = 0.5
quad.Filled = false
quad.Transparency = 1
return quad
end

function Funcs:DrawLine()
local line = Drawing.new("Line")
line.Color = Color3.new(190, 190, 0)
line.Thickness = 0.5
return line
end

function Funcs:DrawText()
local text = Drawing.new("Text")
text.Color = Color3.fromRGB(190, 190, 0)
text.Size = 20
text.Outline = true
text.Center = true
return text
end

local Mouse = Services.LocalPlayer:GetMouse()
local UserInputService = game:GetService("UserInputService")
local target = false
local mt = getrawmetatable(game)
local oldIndex = mt.__index
local oldNamecall = mt.__namecall
local newClose = newcclosure or function(f) return f end
if setreadonly then setreadonly(mt, false) else make_writeable(mt, true) end
local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/whiteyume1/whiteyume1/main/darkhubuilib.lua"))()
main = lib:Window()
Aimbot = main:Tab('Aimbot')
LPTab = main:Tab('LocalPlayer')
Esp = main:Tab('Visuals')
GunMods = main:Tab('Gun Mods')

Aimbot:Toggle('Aimbot',function(state)
Config.Aimbot.Aimbot = state
end)
LPTab:Button('Godmode',function()
if game.Players.LocalPlayer.Character.Shield then 
game.Players.LocalPlayer.Character.Shield:Destroy()
end
end)
LPTab:Toggle('No Fall Damage',function(state)
Config.LocalPlayer.NoFD = state
end)
LPTab:Toggle('No Fatigue',function(state)
Config.LocalPlayer.Nofatigue = state
end)
LPTab:Toggle('Pro FOV',function(state)
Config.LocalPlayer.PROFOV = state
end)
LPTab:Label('Capture The Flag Gamemode: ')
LPTab:Button('Capture Blue Flag',function()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(720.119934, 14.0500002, -141.047821, -0.182928354, 0.149346098, -0.971716464, 9.39479447e-17, 0.988394439, 0.151909381, 0.983126223, 0.0277885329, -0.18080537)
wait(.2)
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(144.149765, 13.8993807, 109.046661, -0.564625502, -0.0990719274, 0.819379568, 0, 0.99276948, 0.120036662, -0.825347245, 0.0677757636, -0.560542941)
end)
LPTab:Button('Capture Red Flag',function()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(144.149765, 13.8993807, 109.046661, -0.564625502, -0.0990719274, 0.819379568, 0, 0.99276948, 0.120036662, -0.825347245, 0.0677757636, -0.560542941)
wait(.2)
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(720.119934, 14.0500002, -141.047821, -0.182928354, 0.149346098, -0.971716464, 9.39479447e-17, 0.988394439, 0.151909381, 0.983126223, 0.0277885329, -0.18080537)
end)

local RunService = game:GetService("RunService")
RunService.Heartbeat:Connect(function()
if Config.LocalPlayer.Nofatigue == true then
game.Players.LocalPlayer.Character.Humanoid.JumpPower = 50
end
if Config.LocalPlayer.PROFOV == true then
game.workspace.CurrentCamera.FieldOfView = 110
end
if Config.LocalPlayer.PROFOV == false then
game.workspace.CurrentCamera.FieldOfView = 70
end
end)
OldFire = require(game:GetService("ReplicatedStorage").NetworkModule).FireServer 
require(game:GetService("ReplicatedStorage").NetworkModule).FireServer = function(...)
args = {...}
if Config.LocalPlayer.NoFD == true and tostring(args[2]) == 'FallDamage' then
    return
end
return OldFire(...)
end


Aimbot:Toggle('Silent Aim',function(state)
Config.Aimbot.Silent = state
end)

Aimbot:Toggle('Trigger Bot',function(state)
Config.Aimbot.TriggerBot = state
end)

Aimbot:Dropdown(
"Aim Bone",{'Random','Head (Bannable!)','Torso','Left Arm','Right Arm','Left Leg','Right Leg'}, 
function(selected)
if selected == "Random" then
  Config.Aimbot.RandomAimBone = true
elseif selected == "Head (Bannable!)" then
  Config.Aimbot.AimBone = "Head"
  Config.Aimbot.RandomAimBone = false
elseif selected == "Torso" then
  Config.Aimbot.AimBone = "UpperTorso"
  Config.Aimbot.RandomAimBone = false
elseif selected == "Left Arm" then
  Config.Aimbot.AimBone = "LeftLowerArm"
  Config.Aimbot.RandomAimBone = false
elseif selected == "Right Arm" then
  Config.Aimbot.AimBone = "RightLowerArm"
  Config.Aimbot.RandomAimBone = false
elseif selected == "Left Leg" then
  Config.Aimbot.AimBone = "LeftLowerLeg"
  Config.Aimbot.RandomAimBone = false
elseif selected == "Right Leg" then
  Config.Aimbot.AimBone = "RightLowerLeg"
  Config.Aimbot.RandomAimBone = false
end
end
)

Aimbot:Toggle('Draw FOV',function(state)
Config.Aimbot.DrawFOV = state
end)

Aimbot:Slider('Smoothness',0,10,function(number)
Config.Aimbot.Smoothness = number / 10
end)

Aimbot:Slider('FOV',0,1000,function(number)
Config.Aimbot.FOV = number
end)

Esp:Toggle('Boxes',function(state)
Config.Visuals.BoxEsp = state
end)

Esp:Toggle('Corner Boxes',function(state)
Config.Visuals.CornerBoxEsp = state
end)

Esp:Toggle('Skeleton',function(state)
Config.Visuals.SkeletonEsp = state
end)

Esp:Toggle('Tracers',function(state)
Config.Visuals.TracerEsp = state
end)

Esp:Dropdown(
"Tracers Origin",{'Top','Middle','Bottom','Mouse'}, 
function(selected)
Config.Visuals.TracersOrigin = selected
end
)

Esp:Colorpicker("Team Esp Color",Color3.fromRGB(0, 190, 0), function(color)
Config.Visuals.TeamColor = color
end)

Esp:Colorpicker("Enemy Esp Color",Color3.fromRGB(190, 190, 0), function(color)
Config.Visuals.EnemyColor = color
end)

GunMods:Toggle('No Recoil',function(state)
Config.GunMods.Recoil = state
Funcs:UpdateGuns()
end)

GunMods:Toggle('No Spread',function(state)
Config.GunMods.Spread = state
end)

GunMods:Toggle('FireRate',function(state)
Config.GunMods.FireRate = state
Funcs:UpdateGuns()
end)

GunMods:Toggle('Infinite Ammo',function(state)
Config.GunMods.InfAmmo = state
end)

GunMods:Toggle('Infinite Range ( Buggy )',function(state)
Config.GunMods.InfRange = state
end)

GunMods:Toggle('Wallbang',function(state)
Config.GunMods.Wallbang = state
end)

-- Aimbot
function Funcs:GetTarget()
local nearestmagnitude = math.huge
local nearestenemy = nil
local vector = nil
for i,v in next, Services.Players:GetChildren() do
if Config.Visuals.TeamCheck then
  if v.Team ~= Services.LocalPlayer.Team and Funcs:IsAlive(v) then
    if v.Character and  v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
      local vector, onScreen = Services.Camera:WorldToScreenPoint(v.Character["HumanoidRootPart"].Position)
      if onScreen then
        local ray = Ray.new(
          Services.Camera.CFrame.p,
          (v.Character["UpperTorso"].Position-Services.Camera.CFrame.p).unit*500
        )
        local ignore = {
          Services.LocalPlayer.Character,
        }
        local magnitude = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(vector.X, vector.Y)).magnitude
        if magnitude < nearestmagnitude and magnitude <= Config.Aimbot["FOV"] then
          nearestenemy = v
          nearestmagnitude = magnitude
        end
      end
    end
  end
else
  if v.Character and  v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0  and Funcs:IsAlive(v) then
    local vector, onScreen = Services.Camera:WorldToScreenPoint(v.Character["HumanoidRootPart"].Position)
    if onScreen then
      local ray = Ray.new(
        Services.Camera.CFrame.p,
        (v.Character["UpperTorso"].Position-Services.Camera.CFrame.p).unit*500
      )
      local ignore = {
        Services.LocalPlayer.Character,
      }
      local magnitude = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(vector.X, vector.Y)).magnitude
      if magnitude < nearestmagnitude and magnitude <= Config.Aimbot["FOV"] then
        nearestenemy = v
        nearestmagnitude = magnitude
      end
    end
  end
end
end
return nearestenemy
end

spawn(function()
while wait() do
pcall(function()
  TargetPlayer = Funcs:GetTarget()
  if TargetPlayer and Config.Aimbot.MouseTwoDown and Config.Aimbot.Aimbot then
    local niggasbone = game:GetService("Workspace").CurrentCamera:WorldToScreenPoint(TargetPlayer.Character[Config.Aimbot.AimBone].Position)
    local moveto = Vector2.new((niggasbone.X-Mouse.X)*Config.Aimbot.Smoothness,(niggasbone.Y-Mouse.Y)*Config.Aimbot.Smoothness)
    mousemoverel(moveto.X,moveto.Y)
  end
  if Config.Aimbot.TriggerBot == true then
    local Target = Mouse.Target
    if Target then
      local TargetPlayer = LocalPlayer.Parent:FindFirstChild(Target.Parent.Name)
      if Target.Parent and TargetPlayer ~= nil and TargetPlayer.Team ~= LocalPlayer.Team and LocalPlayer.Character.Head then
        mouse1press() wait() mouse1release()
      end
    end
  end
  Services.RunService.Heartbeat:wait()
end)
end
end)

Mouse.Button2Down:Connect(function()
Config.Aimbot.MouseTwoDown = true
end)

Mouse.Button2Up:Connect(function()
Config.Aimbot.MouseTwoDown = false
end)

function Funcs:AddEsp(player)
local Box = Funcs:DrawSquare()
local Tracer = Funcs:DrawLine()
local Name = Funcs:DrawText()
local Distance = Funcs:DrawText()
local SnapLines = Funcs:DrawLine()
local HeadLowerTorso = Funcs:DrawLine()
local NeckLeftUpper = Funcs:DrawLine()
local LeftUpperLeftLower = Funcs:DrawLine()
local NeckRightUpper = Funcs:DrawLine()
local RightUpperLeftLower = Funcs:DrawLine()
local LowerTorsoLeftUpper = Funcs:DrawLine()
local LeftLowerLeftUpper = Funcs:DrawLine()
local LowerTorsoRightUpper = Funcs:DrawLine()
local RightLowerRightUpper = Funcs:DrawLine()
local bottomrightone = Funcs:DrawLine()
local bottomleftone = Funcs:DrawLine()
local toprightone = Funcs:DrawLine()
local topleftone = Funcs:DrawLine()
local toplefttwo = Funcs:DrawLine()
local bottomlefttwo = Funcs:DrawLine()
local toprighttwo = Funcs:DrawLine()
local bottomrighttwo = Funcs:DrawLine()
Services.RunService.Stepped:Connect(function()
if Config.Visuals.TeamCheck and player.Team == Services.LocalPlayer.Team then
  Box.Color = Config.Visuals.TeamColor
  Tracer.Color = Config.Visuals.TeamColor
  HeadLowerTorso.Color = Config.Visuals.TeamColor
  NeckLeftUpper.Color = Config.Visuals.TeamColor
  LeftUpperLeftLower.Color = Config.Visuals.TeamColor
  NeckRightUpper.Color = Config.Visuals.TeamColor
  RightUpperLeftLower.Color = Config.Visuals.TeamColor
  LowerTorsoLeftUpper.Color = Config.Visuals.TeamColor
  LeftLowerLeftUpper.Color = Config.Visuals.TeamColor
  LowerTorsoRightUpper.Color = Config.Visuals.TeamColor
  RightLowerRightUpper.Color = Config.Visuals.TeamColor
  bottomrightone.Color = Config.Visuals.TeamColor
  bottomleftone.Color = Config.Visuals.TeamColor
  toprightone.Color = Config.Visuals.TeamColor
  topleftone.Color = Config.Visuals.TeamColor
  toplefttwo.Color = Config.Visuals.TeamColor
  bottomlefttwo.Color = Config.Visuals.TeamColor
  toprighttwo.Color = Config.Visuals.TeamColor
  bottomrighttwo.Color = Config.Visuals.TeamColor
else
  Box.Color = Config.Visuals.EnemyColor
  Tracer.Color = Config.Visuals.EnemyColor
  HeadLowerTorso.Color = Config.Visuals.EnemyColor
  NeckLeftUpper.Color = Config.Visuals.EnemyColor
  LeftUpperLeftLower.Color = Config.Visuals.EnemyColor
  NeckRightUpper.Color = Config.Visuals.EnemyColor
  RightUpperLeftLower.Color = Config.Visuals.EnemyColor
  LowerTorsoLeftUpper.Color = Config.Visuals.EnemyColor
  LeftLowerLeftUpper.Color = Config.Visuals.EnemyColor
  LowerTorsoRightUpper.Color = Config.Visuals.EnemyColor
  RightLowerRightUpper.Color = Config.Visuals.EnemyColor
  bottomrightone.Color = Config.Visuals.EnemyColor
  bottomleftone.Color = Config.Visuals.EnemyColor
  toprightone.Color = Config.Visuals.EnemyColor
  topleftone.Color = Config.Visuals.EnemyColor
  toplefttwo.Color = Config.Visuals.EnemyColor
  bottomlefttwo.Color = Config.Visuals.EnemyColor
  toprighttwo.Color = Config.Visuals.EnemyColor
  bottomrighttwo.Color = Config.Visuals.EnemyColor
end
if Funcs:IsAlive(player) and player.Character:FindFirstChild("HumanoidRootPart") then
  local RootPosition, OnScreen = Services.Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
  local HeadPosition = Services.Camera:WorldToViewportPoint(player.Character.Head.Position + Vector3.new(0, 0, 0)) -- can creat an offset if u want
  local LegPosition = Services.Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position - Vector3.new(0, 5, 0))
  local length = RootPosition.Y - ((HeadPosition.Y - LegPosition.Y) / 2)
  local lengthx = RootPosition.X - ((HeadPosition.Y - LegPosition.Y) / 2)
  local size = HeadPosition.Y - LegPosition.Y
  if Config.Visuals.BoxEsp then
    Box.Visible = OnScreen
    Box.Size = Vector2.new(HeadPosition.Y - LegPosition.Y, HeadPosition.Y - LegPosition.Y)
    Box.Position = Vector2.new(RootPosition.X - ((HeadPosition.Y - LegPosition.Y) / 2), RootPosition.Y - ((HeadPosition.Y - LegPosition.Y) / 2))
  else
    Box.Visible = false
  end
  if Config.Visuals.CornerBoxEsp and Funcs:IsAlive(player) then
    bottomrightone.Visible = OnScreen
    bottomrightone.From = Vector2.new(RootPosition.X - ((HeadPosition.Y - LegPosition.Y) / 2), length)
    bottomrightone.To = Vector2.new(RootPosition.X - ((HeadPosition.Y - LegPosition.Y) / 2) + (size / 3), length)
    bottomleftone.Visible = OnScreen
    bottomleftone.From = Vector2.new((RootPosition.X - ((HeadPosition.Y - LegPosition.Y) / 2)) + size, length)
    bottomleftone.To = Vector2.new(RootPosition.X - ((HeadPosition.Y - LegPosition.Y) / 2) + ((size / 3) * 2), length)
    toprightone.Visible = OnScreen
    toprightone.From = Vector2.new(RootPosition.X - ((HeadPosition.Y - LegPosition.Y) / 2), length + size)
    toprightone.To = Vector2.new(RootPosition.X - ((HeadPosition.Y - LegPosition.Y) / 2) + (size / 3), length + size)
    topleftone.Visible = OnScreen
    topleftone.From = Vector2.new((RootPosition.X - ((HeadPosition.Y - LegPosition.Y) / 2)) + size, length + size)
    topleftone.To = Vector2.new(RootPosition.X - ((HeadPosition.Y - LegPosition.Y) / 2) + ((size / 3) * 2), length + size)
    toplefttwo.Visible = OnScreen
    toplefttwo.From = Vector2.new(lengthx, (RootPosition.Y - ((HeadPosition.Y - LegPosition.Y) / 2)) + size)
    toplefttwo.To = Vector2.new(lengthx, (RootPosition.Y - ((HeadPosition.Y - LegPosition.Y) / 2)) + ((size / 3) * 2))
    bottomlefttwo.Visible = OnScreen
    bottomlefttwo.From = Vector2.new(lengthx, (RootPosition.Y - (HeadPosition.Y - LegPosition.Y) / 2))
    bottomlefttwo.To = Vector2.new(lengthx, (RootPosition.Y - ((HeadPosition.Y - LegPosition.Y) / 2)) + (size / 3))
    toprighttwo.Visible = OnScreen
    toprighttwo.From = Vector2.new(lengthx + size, (RootPosition.Y - ((HeadPosition.Y - LegPosition.Y) / 2)) + size)
    toprighttwo.To = Vector2.new(lengthx + size, (RootPosition.Y - ((HeadPosition.Y - LegPosition.Y) / 2)) + ((size / 3) * 2))
    bottomrighttwo.Visible = OnScreen
    bottomrighttwo.From = Vector2.new(lengthx + size, (RootPosition.Y - (HeadPosition.Y - LegPosition.Y) / 2))
    bottomrighttwo.To = Vector2.new(lengthx + size, (RootPosition.Y - ((HeadPosition.Y - LegPosition.Y) / 2)) + (size / 3))
  else
    bottomrightone.Visible = false
    bottomleftone.Visible = false
    toprightone.Visible = false
    topleftone.Visible = false
    toplefttwo.Visible = false
    bottomlefttwo.Visible = false
    toprighttwo.Visible = false
    bottomrighttwo.Visible = false
  end
  if Config.Visuals.TracerEsp then
    Tracer.Visible = OnScreen
    if Config.Visuals.TracersOrigin == "Top" then
      Tracer.To = Vector2.new(Services.Camera.ViewportSize.X / 2, 0)
      Tracer.From = Vector2.new(Services.Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position).X - 1, RootPosition.Y + (HeadPosition.Y - LegPosition.Y) / 2)
    elseif Config.Visuals.TracersOrigin == "Middle" then
      Tracer.To = Vector2.new(Services.Camera.ViewportSize.X / 2, Services.Camera.ViewportSize.Y / 2)
      Tracer.From = Vector2.new(Services.Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position).X - 1, (RootPosition.Y + (HeadPosition.Y - LegPosition.Y) / 2) - ((HeadPosition.Y - LegPosition.Y) / 2))
    elseif Config.Visuals.TracersOrigin == "Bottom" then
      Tracer.To = Vector2.new(Services.Camera.ViewportSize.X / 2, 1000)
      Tracer.From = Vector2.new(Services.Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position).X - 1, RootPosition.Y - (HeadPosition.Y - LegPosition.Y) / 2)
    elseif Config.Visuals.TracersOrigin == "Mouse" then
      Tracer.To = game:GetService('UserInputService'):GetMouseLocation();
      Tracer.From = Vector2.new(Services.Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position).X - 1, (RootPosition.Y + (HeadPosition.Y - LegPosition.Y) / 2) - ((HeadPosition.Y - LegPosition.Y) / 2))
    end
  else
    Tracer.Visible = false
  end
  if Config.Visuals.SkeletonEsp then
    HeadLowerTorso.Visible = OnScreen
    HeadLowerTorso.From = Vector2.new(Services.Camera:WorldToViewportPoint(player.Character.Head.Position).X, Services.Camera:WorldToViewportPoint(player.Character.Head.Position).Y)
    HeadLowerTorso.To = Vector2.new(Services.Camera:WorldToViewportPoint(player.Character.LowerTorso.Position).X, Services.Camera:WorldToViewportPoint(player.Character.LowerTorso.Position).Y)
    NeckLeftUpper.Visible = OnScreen
    NeckLeftUpper.From = Vector2.new(Services.Camera:WorldToViewportPoint(player.Character.Head.Position).X, Services.Camera:WorldToViewportPoint(player.Character.Head.Position).Y + ((Services.Camera:WorldToViewportPoint(player.Character.UpperTorso.Position).Y - Services.Camera:WorldToViewportPoint(player.Character.Head.Position).Y) / 3))
    NeckLeftUpper.To = Vector2.new(Services.Camera:WorldToViewportPoint(player.Character.LeftUpperArm.Position).X, Services.Camera:WorldToViewportPoint(player.Character.LeftUpperArm.Position).Y)
    LeftUpperLeftLower.Visible = OnScreen
    LeftUpperLeftLower.From = Vector2.new(Services.Camera:WorldToViewportPoint(player.Character.LeftLowerArm.Position).X, Services.Camera:WorldToViewportPoint(player.Character.LeftLowerArm.Position).Y)
    LeftUpperLeftLower.To = Vector2.new(Services.Camera:WorldToViewportPoint(player.Character.LeftUpperArm.Position).X, Services.Camera:WorldToViewportPoint(player.Character.LeftUpperArm.Position).Y)
    NeckRightUpper.Visible = OnScreen
    NeckRightUpper.From = Vector2.new(Services.Camera:WorldToViewportPoint(player.Character.Head.Position).X, Services.Camera:WorldToViewportPoint(player.Character.Head.Position).Y + ((Services.Camera:WorldToViewportPoint(player.Character.UpperTorso.Position).Y - Services.Camera:WorldToViewportPoint(player.Character.Head.Position).Y) / 3))
    NeckRightUpper.To = Vector2.new(Services.Camera:WorldToViewportPoint(player.Character.RightUpperArm.Position).X, Services.Camera:WorldToViewportPoint(player.Character.RightUpperArm.Position).Y)
    RightUpperLeftLower.Visible = OnScreen
    RightUpperLeftLower.From = Vector2.new(Services.Camera:WorldToViewportPoint(player.Character.RightLowerArm.Position).X, Services.Camera:WorldToViewportPoint(player.Character.RightLowerArm.Position).Y)
    RightUpperLeftLower.To = Vector2.new(Services.Camera:WorldToViewportPoint(player.Character.RightUpperArm.Position).X, Services.Camera:WorldToViewportPoint(player.Character.RightUpperArm.Position).Y)
    LowerTorsoLeftUpper.Visible = OnScreen
    LowerTorsoLeftUpper.From = Vector2.new(Services.Camera:WorldToViewportPoint(player.Character.LowerTorso.Position).X, Services.Camera:WorldToViewportPoint(player.Character.LowerTorso.Position).Y)
    LowerTorsoLeftUpper.To = Vector2.new(Services.Camera:WorldToViewportPoint(player.Character.LeftUpperLeg.Position).X, Services.Camera:WorldToViewportPoint(player.Character.LeftUpperLeg.Position).Y)
    LeftLowerLeftUpper.Visible = OnScreen
    LeftLowerLeftUpper.From = Vector2.new(Services.Camera:WorldToViewportPoint(player.Character.LeftLowerLeg.Position).X, Services.Camera:WorldToViewportPoint(player.Character.LeftLowerLeg.Position).Y)
    LeftLowerLeftUpper.To = Vector2.new(Services.Camera:WorldToViewportPoint(player.Character.LeftUpperLeg.Position).X, Services.Camera:WorldToViewportPoint(player.Character.LeftUpperLeg.Position).Y)
    LowerTorsoRightUpper.Visible = OnScreen
    LowerTorsoRightUpper.From = Vector2.new(Services.Camera:WorldToViewportPoint(player.Character.RightLowerLeg.Position).X, Services.Camera:WorldToViewportPoint(player.Character.RightLowerLeg.Position).Y)
    LowerTorsoRightUpper.To = Vector2.new(Services.Camera:WorldToViewportPoint(player.Character.RightUpperLeg.Position).X, Services.Camera:WorldToViewportPoint(player.Character.RightUpperLeg.Position).Y)
    RightLowerRightUpper.Visible = OnScreen
    RightLowerRightUpper.From = Vector2.new(Services.Camera:WorldToViewportPoint(player.Character.LowerTorso.Position).X, Services.Camera:WorldToViewportPoint(player.Character.LowerTorso.Position).Y)
    RightLowerRightUpper.To = Vector2.new(Services.Camera:WorldToViewportPoint(player.Character.RightUpperLeg.Position).X, Services.Camera:WorldToViewportPoint(player.Character.RightUpperLeg.Position).Y)
  else
    HeadLowerTorso.Visible = false
    NeckLeftUpper.Visible = false
    LeftUpperLeftLower.Visible = false
    NeckRightUpper.Visible = false
    RightUpperLeftLower.Visible = false
    LowerTorsoLeftUpper.Visible = false
    LeftLowerLeftUpper.Visible = false
    LowerTorsoRightUpper.Visible = false
    RightLowerRightUpper.Visible = false
  end
else
  Box.Visible = false
  Tracer.Visible = false
  HeadLowerTorso.Visible = false
  NeckLeftUpper.Visible = false
  LeftUpperLeftLower.Visible = false
  NeckRightUpper.Visible = false
  RightUpperLeftLower.Visible = false
  LowerTorsoLeftUpper.Visible = false
  LeftLowerLeftUpper.Visible = false
  LowerTorsoRightUpper.Visible = false
  RightLowerRightUpper.Visible = false
  bottomrightone.Visible = false
  bottomleftone.Visible = false
  toprightone.Visible = false
  topleftone.Visible = false
  toplefttwo.Visible = false
  bottomlefttwo.Visible = false
  toprighttwo.Visible = false
  bottomrighttwo.Visible = false
end
end)
end

for i, v in pairs(Services.Players:GetPlayers()) do
if v ~= Services.LocalPlayer then
Funcs:AddEsp(v)
end
end

Services.Players.PlayerAdded:Connect(function(player)
if v ~= Services.LocalPlayer then
Funcs:AddEsp(player)
end
end)

local HitParticle = require(game:GetService("ReplicatedStorage").GlobalStuff).HitParticle
local GetWSettings = require(game:GetService("ReplicatedStorage").GlobalStuff).GetWSettings
local WeaponModules = game:GetService("ReplicatedStorage").Weapons.Modules:Clone()

require(game:GetService("ReplicatedStorage").GlobalStuff).HitParticle = function(...)
if Config.GunMods.Wallbang then
  return
else
  return HitParticle(...)
end
end

require(game:GetService("ReplicatedStorage").GlobalStuff).GetWSettings = function(Argument_1, Argument_2)
if tostring(getfenv(2).script.Name) == "MainListener" then
return GetWSettings(Argument_1, Argument_2)
end
return require(WeaponModules:FindFirstChild(Argument_2))
end

function Funcs:UpdateGuns()
for a,b in pairs(WeaponModules:GetChildren()) do
if b.Name ~= "Pickaxe" then
  if Config.GunMods.Recoil == true then
    require(b).Recoil = 0
  else
    require(b).Recoil = require(game:GetService("ReplicatedStorage").Weapons.Modules[b.Name]).Recoil
  end
  if Config.GunMods.FireRate == true then
    require(b).Debounce = 0
  else
    require(b).Debounce = require(game:GetService("ReplicatedStorage").Weapons.Modules[b.Name]).Debounce
  end
end
end
end


local hooked = false
local FOVCircle = Drawing.new("Circle")
FOVCircle.Color = Color3.fromRGB(190, 190, 0)
FOVCircle.Thickness = 0.5
FOVCircle.NumSides = 16
FOVCircle.Filled = false
FOVCircle.Transparency = 1
setreadonly(getrawmetatable(game), false)
local __namecall = getrawmetatable(game).__namecall
getrawmetatable(game).__namecall = function(...)
if ({...})[2] == 1 and ({...})[3] == 21 then
  return true
else
  return __namecall(...)
end
end


Services.RunService.Stepped:Connect(function()
for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui:GetChildren()) do
if v:FindFirstChild("ImageLabel") then
  game.Players.LocalPlayer:Kick("tell the darkhub people to fix their script (and dont worry you're not banned)")
end
end
FOVCircle.Position = game:GetService('UserInputService'):GetMouseLocation();
FOVCircle.Radius = Config.Aimbot.FOV
if Config.Aimbot.DrawFOV then
FOVCircle.Visible = true
else
FOVCircle.Visible = false
end
if Services.LocalPlayer.PlayerGui.MenuGUI.RoundInfoFrame.RoundType.Text == "FFA" then
Config.Visuals.TeamCheck = false
else
Config.Visuals.TeamCheck = true
end
if Config.Aimbot.RandomAimBone then
random = math.random(1,3)
if random == 1 then
  Config.Aimbot.AimBone = "Head"
elseif random == 2 then
  Config.Aimbot.AimBone = "UpperTorso"
elseif random == 3 then
  Config.Aimbot.AimBone = "LowerTorso"
end
end
pcall(function()
if Config.GunMods.Recoil == true then
  --getsenv(game:GetService("Players").LocalPlayer.PlayerGui.MainGui.MainLocal).CameraRecoil = function() end
end
if Config.GunMods.FireRate == true then
  getfenv(getsenv(game:GetService("Players").LocalPlayer.PlayerGui.MainGui.MainLocal).Shoot).wait = function()
    return game:GetService("RunService").Stepped:Wait()
  end
end

if Config.GunMods.InfAmmo then
  getsenv(game:GetService("Players").LocalPlayer.PlayerGui.MainGui.MainLocal).UpdateAmmoLabel = function()
    for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.MainGui:GetDescendants()) do 
      pcall(function()
        if string.find(v.Text, " | ") then 
          v.Text = "-1 | 0"
        end
      end)
    end
  end
  A_1 = 4
  A_2 = "Reload"
  Event = game:GetService("ReplicatedStorage").Network.RemoteEvent
  Event:FireServer(A_1, A_2)
  local reload_stats = nil
  for i,v in pairs(getsenv(game:GetService("Players").LocalPlayer.PlayerGui.MainGui.MainLocal)) do 
    if i == "Reload" then 
      for k,x in pairs(debug.getupvalues(v)) do 
        if k == 7 then
          reload_stats = x
        end
      end
    end
  end
  if reload_stats then 
    for i,v in pairs(reload_stats) do
      if typeof(v) == 'table' then 
        pcall(function()
          v[2] = math.huge
        end)
      end
    end
  end
end
if Config.GunMods.InfRange and hooked == false then
  pcall(function()
    if game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("MainGui") and game:GetService("Players").LocalPlayer.PlayerGui.MainGui:FindFirstChild("MainLocal") then
    local RayCast = getsenv(game:GetService("Players").LocalPlayer.PlayerGui.MainGui.MainLocal).RayCast
      getsenv(game:GetService("Players").LocalPlayer.PlayerGui.MainGui.MainLocal).RayCast = function(Argument_1, Argument_2, Argument_3, Argument_4, Argument_5, ...)
        hooked = true
        if Argument_1 ~= game:GetService("Players").LocalPlayer.Character.Head.Position then
          local RayHit, RayPosition = game:GetService("Workspace").FindPartOnRayWithIgnoreList(game:GetService("Workspace"), Ray.new(Argument_1, (Argument_2 - Argument_1).unit * 9.0071993e+15), Argument_3)
          return RayHit, RayPosition
        end
        return RayCast(Argument_1, Argument_2, Argument_3, Argument_4, Argument_5, ...)
      end
    else
      hooked = false
    end
  end)
end
if Config.GunMods.Spread and Config.Aimbot.Silent == false or Config.GunMods.Spread and Config.Aimbot.Silent and not Funcs:GetTarget() then
  require(game.ReplicatedStorage.GlobalStuff).ConeOfFire = function(...)
    local args = {...}
    local ret = (args[3] + Vector3.new(0.001,0,0.001))
    return ret
  end
elseif not Config.GunMods.Spread and Config.Aimbot.Silent and not Funcs:GetTarget() or not Config.GunMods.Spread and Config.Aimbot.Silent == false then
  require(game:GetService("ReplicatedStorage").GlobalStuff).ConeOfFire = function(p83, p84, p85, p86)
    local v60 = math.random(0, math.tan(math.rad(p86)) * (p85 - p84).magnitude * 100) / 100;
    local v61 = math.rad(math.random(0, 360));
    return (CFrame.new(p85, p84) * CFrame.new(math.cos(v61) * v60, math.sin(v61) * v60, 0)).p;
  end
end
local ConeOfFire = require(game:GetService("ReplicatedStorage").GlobalStuff).ConeOfFire
if Config.Aimbot.Silent then
  local ConeOfFire = require(game:GetService("ReplicatedStorage").GlobalStuff).ConeOfFire
  require(game:GetService("ReplicatedStorage").GlobalStuff).ConeOfFire = function(...)
    if tostring(getfenv(2).script.Name) == "MainListener" then
      return ConeOfFire(...)
    end
    if Funcs:GetTarget() ~= nil then
      return Funcs:GetTarget().Character[Config.Aimbot.AimBone].Position
    end
    return ({...})[3]
  end
end
end)
end)
local RayHook;
RayHook = hookfunction(workspace.FindPartOnRayWithIgnoreList,newcclosure(function(...)
args = {...}
if tostring(getfenv(2).script.Name) == 'MainListener' or game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChild("Head") and game:GetService("Players").LocalPlayer.Character.Head:FindFirstChild("GliderWeld") then
    return RayHook(...)
end
if tostring(getfenv(2).script.Name) == 'MainLocal' then
    args[3] = {game:GetService("Workspace").IgnoreThese, game:GetService("Players").LocalPlayer.Character, game:GetService("Workspace").BuildStuff, game:GetService("Workspace").Map}
    return RayHook(unpack(args))
end
return RayHook(...)
end))
end












if game.PlaceId == 15675702 then
--Tilty Tokens (darkhub's owner is a mother fucker)//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/whiteyume1/whiteyume1/main/darkhubuilib.lua"))()
main = lib:Window()
local w = main:Tab('DarkHub')
w:Button("Complete Level", function()
for i,v in pairs(workspace.Camera.Board.Pins:GetChildren()) do
    child.Parent = workspace
    child.Name = "OldPin"
end
keypress(0x41)
wait(.026)
keyrelease(0x41)
wait(2)
for i, v in pairs(workspace:GetChildren()) do
    if v.Name == "OldPin" then
        v:Destroy()
    end
end
end)
end







if game.PlaceId == 1962086868 then
--Tower Of Hell
y = game:GetService("Players").LocalPlayer.PlayerScripts.LocalScript
getsenv(y).kick = function() return nil end
getsenv(y).kick()

local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/whiteyume1/whiteyume1/main/darkhubuilib.lua"))()
main = lib:Window()
local MainWindow = main:Tab('Main')
TimeAlive = 0

MainWindow:Button('Instant Top',function()
if game.Players.LocalPlayer.Character:FindFirstChild('ForceField') or TimeAlive < 1 then
    return    
end
local temp_table = {}
for i,v in pairs(game:GetService("Workspace").tower:GetDescendants()) do
    if v:IsA('Part') and v.CanCollide == true then
        table.insert(temp_table,v)
        v.CanCollide = false
    end
end
Me = game.Players.LocalPlayer.Character
Old = Me.KillScript.Disabled
Me.Humanoid.Jump = true
for i = 1,300 do
    wait()
    Me.KillScript.Disabled = true
    Me.HumanoidRootPart.Velocity = Vector3.new(0,4000,0)
    o = game:GetService("Workspace").tower.sections.finish.exit.ParticleBrick.Position.Y
    e = game.Players.LocalPlayer.Character.HumanoidRootPart.Position.Y
    x = o - e
    if x < 5 then
        Me.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
        Me.HumanoidRootPart.CFrame = CFrame.new(game:GetService("Workspace").tower.sections.finish.exit.carpet.CFrame.X,game:GetService("Workspace").tower.sections.finish.exit.carpet.CFrame.Y + 3,game:GetService("Workspace").tower.sections.finish.exit.carpet.CFrame.Z)
        break
    end
end
for i,v in pairs(temp_table) do
    v.CanCollide = true
end
Me.KillScript.Disabled = Old
end)

MainWindow:Toggle('Godmode',function(state)
if state == true then
    require(game:GetService("ReplicatedStorage").Mutators.invincibility).mutate()
else
    require(game:GetService("ReplicatedStorage").Mutators.invincibility).revert()
end
end)
MainWindow:Toggle('Double Jump',function(state)
if state == true then
    require(game:GetService("ReplicatedStorage").Mutators["double jump"]).mutate()
else
    require(game:GetService("ReplicatedStorage").Mutators["double jump"]).revert()
end
end)
MainWindow:Button('Get All Items',function()
for i,v in pairs(game:GetService("ReplicatedStorage").Gear:GetChildren()) do
    New = v:Clone()
    New.Parent = game.Players.LocalPlayer.Backpack
end
end)

MainWindow:Slider('Speed',1,91,function(val)
game:GetService("ReplicatedStorage").globalSpeed.Value = val
end)

MainWindow:Toggle('Gravity',function(state)
if state == true then
    require(game:GetService("ReplicatedStorage").Mutators.gravity).mutate()
else
    require(game:GetService("ReplicatedStorage").Mutators.gravity).revert()
end
end)

workspace.ChildAdded:Connect(function(child)
if child.Name == game.Players.LocalPlayer.Character.Name then
    TimeAlive = 0
end
end)

spawn(function()
pcall(function()
    while true do
        wait(1)
        TimeAlive = TimeAlive + 1
    end
end)
end)
end
