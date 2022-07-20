--Made by ISync#1147
--If you want to use this in any script Add credits.
--This is very buggy since i did not finish it and got bored of the game

getgenv().BankRobbed = false
getgenv().SwitchServer = true



MaxCapacity = nil
local LocalPlayer = game:GetService("Players").LocalPlayer;
DiedCapacity = nil

local PlaceID = game.PlaceId
local AllIDs = {}
local foundAnything = ""
local actualHour = os.date("!*t").hour
local Deleted = false
local File = pcall(function()
    AllIDs = game:GetService('HttpService'):JSONDecode(readfile("NotSameServers.json"))
end)
if not File then
    table.insert(AllIDs, actualHour)
    writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
end
function TPReturner()
    local Site;
    if foundAnything == "" then
        Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
    else
        Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
    end
    local ID = ""
    if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
        foundAnything = Site.nextPageCursor
    end
    local num = 0;
    for i,v in pairs(Site.data) do
        local Possible = true
        ID = tostring(v.id)
        if tonumber(v.maxPlayers) > tonumber(v.playing) then
            for _,Existing in pairs(AllIDs) do
                if num ~= 0 then
                    if ID == tostring(Existing) then
                        Possible = false
                    end
                else
                    if tonumber(actualHour) ~= tonumber(Existing) then
                        local delFile = pcall(function()
                            delfile("NotSameServers.json")
                            AllIDs = {}
                            table.insert(AllIDs, actualHour)
                        end)
                    end
                end
                num = num + 1
            end
            if Possible == true then
                table.insert(AllIDs, ID)
                wait()
                pcall(function()
                    writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
                    wait()
                    game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID, game.Players.LocalPlayer)
                end)
                wait(4)
            end
        end
    end
end

function Teleport()
    while wait() do
        pcall(function()
            TPReturner()
            if foundAnything ~= "" then
                TPReturner()
            end
        end)
    end
end

function start()
    --bank start
    local function SellBag()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-5.5096611976623535, -8.599377632141113, -19.811023712158203)
        task.wait(0.5)
        fireclickdetector(game:GetService("Workspace").Map.Buildings.Bank.Rob.Sell.ClickDetector)
    end

   --Buy bag function
   local function BuyBag()
    if not game:GetService("Workspace")[LocalPlayer.Name]:FindFirstChild("Duffel Bag") then
                game:GetService("ReplicatedStorage")._network.atm:InvokeServer("Withdraw", 100)

        game:GetService("TweenService"):Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(0, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {CFrame = CFrame.new(-9, -9, -26)}):Play()
        wait(1)
        fireproximityprompt(game:GetService("Workspace").Map.NPCs.BankDealerNPC.HumanoidRootPart.PromptAttachment.ProximityPrompt) -- fires the prompt inside of the object ( make sure your object has a proximityprompt )
        task.wait(0.5)
        game:GetService("ReplicatedStorage")._network.purchase:InvokeServer("bank_dealer", "Duffel Bag")
        task.wait(0.5)
        --MaxCapacity = game:GetService("Workspace")[LocalPlayer.Name]["Duffel Bag"].Handle.AmountDisplay.container["gold_container"].amount.Text:sub(2) 
        --print(MaxCapacity) 
        end
    end   

    FullBag2 = false

    Amm = 0
    FullBag = false
    local function GrabGold()
        while Amm ~= 5 do
            if getgenv().BankRobbed then return end
            for i,v in pairs(game:GetService("Workspace").Map.Buildings.Bank.Rob.items.gold:GetChildren()) do
                if  v.Gold.MeshPart.Transparency ~= 1 then
                    BuyBag()
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Part.CFrame
                    wait(1)
                    fireclickdetector(v.ClickDetector) 
                    if game:GetService("Workspace")[LocalPlayer.Name]["Duffel Bag"].Handle.AmountDisplay.container["gold_container"].amount.Text == "5/5" then
                        FullBag = true
                        Amm = Amm + 1
                        SellBag()
                        task.wait(0.5)
                        getgenv().BankRobbed = true
                        if getgenv().SwitchServer then
                            Teleport()
                        end
                        --GrabJewerly()
                    end
                end
                
            end
        end
    end
    local function Grabcash()
        for i,v in pairs(game:GetService("Workspace").Map.Buildings.Bank.Rob.items.cash:GetChildren()) do
            if v.Transparency ~= 1 then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
                wait(1)
                fireclickdetector(v.ClickDetector) 
            end
        end
        GrabGold()
    end
   
    local function OpenBankDoor()
        game:GetService("TweenService"):Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(0, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {CFrame = CFrame.new(-9, -9, -26)}):Play()
        task.wait(1)
        fireproximityprompt(game:GetService("Workspace").Map.NPCs.BankDealerNPC.HumanoidRootPart.PromptAttachment.ProximityPrompt) -- fires the prompt inside of the object ( make sure your object has a proximityprompt )
        task.wait(0.5)
        game:GetService("ReplicatedStorage")._network.purchase:InvokeServer("bank_dealer", "C4")
        task.wait(0.5)
        game:GetService("TweenService"):Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(0, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {CFrame = CFrame.new(-246, 5, 94)}):Play()
        task.wait(1)
        fireclickdetector(game:GetService("Workspace").Map.Buildings.Bank.Rob.Init.screen.ClickDetector)
        task.wait(2)
        game:GetService("TweenService"):Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(0, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {CFrame = CFrame.new(-224.99034118652344, 6.321899890899658, 102.79098510742188)}):Play()
        task.wait(12)
        fireclickdetector(game:GetService("Workspace").Map.Buildings.Bank.Rob.vault.door.ClickDetector)
        Grabcash()
    end

  
    
    BuyBag()
    task.wait(0.5)
    if game:GetService("Workspace").Map.Buildings.Bank.Rob.Init["explode_wall"].CanCollide == true then
        OpenBankDoor()  
    elseif game:GetService("Workspace").Map.Buildings.Bank.Rob.Init["explode_wall"].CanCollide == false then
        game:GetService("TweenService"):Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(0, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {CFrame = CFrame.new(-224.99034118652344, 6.321899890899658, 102.79098510742188)}):Play()
        task.wait(0.5)
        fireclickdetector(game:GetService("Workspace").Map.Buildings.Bank.Rob.vault.door.ClickDetector)
        task.wait(1)
        Grabcash()
    end
end
game:GetService("Players").LocalPlayer.Character.Humanoid.Died:connect(function()
    pcall(function()
        DiedCapacity = game:GetService("Workspace")[LocalPlayer.Name]["Duffel Bag"].Handle.AmountDisplay.container["gold_container"].amount.Text:sub(1, 1)
    end)
end)
    

repeat task.wait() until game:IsLoaded()
start()
