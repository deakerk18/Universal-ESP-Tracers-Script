local lplr = game.Players.LocalPlayer
local camera = game:GetService("Workspace").CurrentCamera
local RunService = game:GetService("RunService")

_G.TeamCheck = true

local function drawTracer(player)
    local Tracer = Drawing.new("Line")
    Tracer.Visible = false
    Tracer.Color = Color3.new(1, 1, 1)
    Tracer.Thickness = 1.4
    Tracer.Transparency = 1

    local function updateTracer()
        if not player or not player.Character then  
            Tracer.Visible = false
            return
        end

        local character = player.Character
        local humanoid = character:FindFirstChild("Humanoid")
        local head = character:FindFirstChild("Head") 
        local rootPart = character:FindFirstChild("HumanoidRootPart")

        if not humanoid or humanoid.Health <= 0 or not (head or rootPart) then
            Tracer.Visible = false
            return
        end
        
        local targetPart = head or rootPart

        local vector, onScreen = camera:WorldToViewportPoint(targetPart.Position)

        if onScreen then
            Tracer.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y) 
            Tracer.To = Vector2.new(vector.X, vector.Y)

            if _G.TeamCheck and player.TeamColor == lplr.TeamColor then
                Tracer.Visible = false
            else
                Tracer.Visible = true   
            end
        else
            Tracer.Visible = false
        end
    end


    RunService.RenderStepped:Connect(updateTracer)

    player.CharacterRemoving:Connect(function()
		Tracer:Remove()
    end)
	
end

for _, player in pairs(game.Players:GetPlayers()) do
    drawTracer(player)
end

game.Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		drawTracer(player)
	end)
end)
