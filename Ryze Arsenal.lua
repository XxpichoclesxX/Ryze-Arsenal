local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Ryze ARS", "Sentinel")

local Main = Window:NewTab("Aimbot")
local MainSection = Main:NewSection("Aimbot")

MainSection:NewToggle("Aimbot", "Tienes autoapuntado", function(v)
	if v then
		local dwCamera = workspace.CurrentCamera
		local dwRunService = game:GetService("RunService")
		local dwUIS = game:GetService("UserInputService")
		local dwEntities = game:GetService("Players")
		local dwLocalPlayer = dwEntities.LocalPlayer
		local dwMouse = dwLocalPlayer:GetMouse()
		local settings = {
			Aimbot = true,
			Aiming = false,
			Aimbot_AimPart = "Head",
			Aimbot_TeamCheck = true,
			Aimbot_Draw_FOV = true,
			Aimbot_FOV_Radius = 100,
			Aimbot_FOV_Color = Color3.fromRGB(0,255,255)
		}

		local fovcircle = Drawing.new("Circle")
		fovcircle.Visible = settings.Aimbot_Draw_FOV
		fovcircle.Radius = settings.Aimbot_FOV_Radius
		fovcircle.Color = settings.Aimbot_FOV_Color
		fovcircle.Thickness = 1
		fovcircle.Filled = false
		fovcircle.Transparency = 1
	
		fovcircle.Position = Vector2.new(dwCamera.ViewportSize.X / 2, dwCamera.ViewportSize.Y / 2)
	
		dwUIS.InputBegan:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseButton2 then
				settings.Aiming = true
			end
		end)
	
		dwUIS.InputEnded:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseButton2 then
				settings.Aiming = false
			end
		end)

		dwRunService.RenderStepped:Connect(function()

			local dist = math.huge
			local closest_char = nil
	
			if settings.Aiming then
	
				for i,v in next, dwEntities:GetChildren() do 
	
					if v ~= dwLocalPlayer and
						v.Character and
						v.Character:FindFirstChild("HumanoidRootPart") and
						v.Character:FindFirstChild("Humanoid") and
						v.Character:FindFirstChild("Humanoid").Health > 0 then
	
						if settings.Aimbot_TeamCheck == true and
							v.Team ~= dwLocalPlayer.Team or
							settings.Aimbot_TeamCheck == false then
	
							local char = v.Character
							local char_part_pos, is_onscreen = dwCamera:WorldToViewportPoint(char[settings.Aimbot_AimPart].Position)
	
							if is_onscreen then
	
								local mag = (Vector2.new(dwMouse.X, dwMouse.Y) - Vector2.new(char_part_pos.X, char_part_pos.Y)).Magnitude
	
								if mag < dist and mag < settings.Aimbot_FOV_Radius then
	
									dist = mag
									closest_char = char
	
								end
							end
						end
					end
				end
	
				if closest_char ~= nil and
					closest_char:FindFirstChild("HumanoidRootPart") and
					closest_char:FindFirstChild("Humanoid") and
					closest_char:FindFirstChild("Humanoid").Health > 0 then
	
					dwCamera.CFrame = CFrame.new(dwCamera.CFrame.Position, closest_char[settings.Aimbot_AimPart].Position)
				end
			end
		end)
		
	end
end)


local Esp = Window:NewTab("ESP")
local MainSection = Esp:NewSection("ESP")

MainSection:NewToggle("Lineas", "Te da el poder verlos atra vez con lineas", function(v)
	if v then
		local loPlayer = game.Players.LocalPlayer
		local camera = game:GetService("Workspace").CurrentCamera
		local CurrentCamera = workspace.CurrentCamera
		local worldToViewportPoint = CurrentCamera.worldToViewportPoint
	
		_G.TeamCheck = false
	
		for i,v in pairs(game.Players:GetChildren()) do
			local Tracer = Drawing.new("Line")
			Tracer.Visible = false
			Tracer.Color = Color3.new(1,1,1)
			Tracer.Thickness = 1
			Tracer.Transparency = 1
	
			function tracer()
				game:GetService("RunService").RenderStepped:Connect(function()
					if v.Character ~= nil and v.Character:FindFirstChild("Humanoid") ~= nil and v.Character:FindFirstChild("HumanoidRootPart") ~= nil and v ~= loPlayer and v.Character.Humanoid.Health > 0 then
						local Vector, OnScreen = camera:worldToViewportPoint(v.Character.HumanoidRootPart.Position)
	
						if OnScreen then
							Tracer.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 1)
							Tracer.To = Vector2.new(Vector.X, Vector.Y)
	
							if _G.TeamCheck and v.TeamColor == loPlayer.TeamColor then
	
								Tracer.Visible = false
							else
	
								Tracer.Visible = true
							end
						else
							Tracer.Visible = false
						end
					else
						Tracer.Visible = false
					end
				end)
			end
			coroutine.wrap(tracer)()
		end
	
		game.Players.PlayerAdded:Connect(function(v)
			local Tracer = Drawing.New("Line")
			Tracer.Visible = false
			Tracer.Color = Color3.new(1,1,1)
			Tracer.Thickness = 1
			Tracer.Transparency = 1
	
			function tracer()
				game:GetService("RunService").RenderStepped:Connect(function()
					if v.Character ~= nil and v.Character:FindFirstChild("Humanoid") ~= nil and v.Character:FindFirstChild("HumanoidRootPart") ~= nil and v ~= loPlayer and v.Character.Humanoid.Health > 0 then
						local Vector, OnScreen = camera:worldToViewportPoint(v.Character.HumanoidRootPart.Position)
	
						if OnScreen then
							Tracer.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 1)
							Tracer.To = Vector2.new(Vector.X, Vector.Y)
	
							if _G.TeamCheck and v.TeamColor == loPlayer.TeamColor then
	
								Tracer.Visible = false
							else
	
								Tracer.Visible = true
							end
						else
							Tracer.Visible = false
						end
					else
						Tracer.Visible = false
					end
				end)
			end
			coroutine.wrap(tracer)()
		end)
	end
end)

MainSection:NewToggle("Cajas", "Te da el poder verlos atra vez con cajas", function(v)
	local Player = game:GetService("Players").LocalPlayer
	local Camera = game:GetService("Workspace").CurrentCamera
	local Mouse = Player:GetMouse()

	local function Dist(pointA, pointB) -- errors need fix  : (
		return math.sqrt(math.pow(pointA.X - pointB.X, 2) + math.pow(pointA.Y - pointB.Y, 2))
	end

	local function GetClosest(points, dest)
		local min  = math.huge 
		local closest = nil
		for _,v in pairs(points) do
			local dist = Dist(v, dest)
			if dist < min then
				min = dist
				closest = v
			end
		end
		return closest
	end

	local function DrawESP(plr)
		local Box = Drawing.new("Quad")
		Box.Visible = false
		Box.PointA = Vector2.new(0, 0)
		Box.PointB = Vector2.new(0, 0)
		Box.PointC = Vector2.new(0, 0)
		Box.PointD = Vector2.new(0, 0)
		Box.Color = Color3.fromRGB(255, 255, 255)
		Box.Thickness = 0.1
		Box.Transparency = 1

		local function Update()
			local c
			c = game:GetService("RunService").RenderStepped:Connect(function()
				if plr.Character ~= nil and plr.Character:FindFirstChildOfClass("Humanoid") ~= nil and plr.Character:FindFirstChild("HumanoidRootPart") ~= nil and plr.Character:FindFirstChildOfClass("Humanoid").Health > 0 and plr.Character:FindFirstChild("Head") ~= nil then
					local pos, vis = Camera:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
					if vis then 
						local points = {}
						local c = 0
						for _,v in pairs(plr.Character:GetChildren()) do
							if v:IsA("BasePart") then
								c = c + 1
								local p = Camera:WorldToViewportPoint(v.Position)
								if v.Name == "HumanoidRootPart" then
									p = Camera:WorldToViewportPoint((v.CFrame * CFrame.new(0, 0, -v.Size.Z)).p)
								elseif v.Name == "Head" then
									p = Camera:WorldToViewportPoint((v.CFrame * CFrame.new(0, v.Size.Y/2, v.Size.Z/1.25)).p)
								elseif string.match(v.Name, "Left") then
									p = Camera:WorldToViewportPoint((v.CFrame * CFrame.new(-v.Size.X/2, 0, 0)).p)
								elseif string.match(v.Name, "Right") then
									p = Camera:WorldToViewportPoint((v.CFrame * CFrame.new(v.Size.X/2, 0, 0)).p)
								end
								points[c] = p
							end
						end
						local Left = GetClosest(points, Vector2.new(0, pos.Y))
						local Right = GetClosest(points, Vector2.new(Camera.ViewportSize.X, pos.Y))
						local Top = GetClosest(points, Vector2.new(pos.X, 0))
						local Bottom = GetClosest(points, Vector2.new(pos.X, Camera.ViewportSize.Y))

						if Left ~= nil and Right ~= nil and Top ~= nil and Bottom ~= nil then
							Box.PointA = Vector2.new(Right.X, Top.Y)
							Box.PointB = Vector2.new(Left.X, Top.Y)
							Box.PointC = Vector2.new(Left.X, Bottom.Y)
							Box.PointD = Vector2.new(Right.X, Bottom.Y)

							Box.Visible = true
						else 
							Box.Visible = false
						end
					else 
						Box.Visible = false
					end
				else
					Box.Visible = false
					if game.Players:FindFirstChild(plr.Name) == nil then
						c:Disconnect()
					end
				end
			end)
		end
		coroutine.wrap(Update)()
	end

	for _,v in pairs(game:GetService("Players"):GetChildren()) do
		if v.Name ~= Player.Name then 
			DrawESP(v)
		end
	end

	game:GetService("Players").PlayerAdded:Connect(function(v)
		DrawESP(v)
	end)	
end)