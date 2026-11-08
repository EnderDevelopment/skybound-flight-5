local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

local TOGGLE_KEY = Enum.KeyCode.F
local UP_KEY = Enum.KeyCode.Space
local DOWN_KEY = Enum.KeyCode.LeftControl
local BOOST_KEY = Enum.KeyCode.LeftShift
local FLY_SPEED = 70
local BOOST_MULTIPLIER = 1.8

local character
local humanoid
local rootPart
local attachment
local linearVelocity
local flying = false
local heartbeatConnection

local pressedKeys = {
	[Enum.KeyCode.W] = false,
	[Enum.KeyCode.A] = false,
	[Enum.KeyCode.S] = false,
	[Enum.KeyCode.D] = false,
	[UP_KEY] = false,
	[DOWN_KEY] = false,
	[BOOST_KEY] = false,
}

local function stopFlying()
	if not flying then
		return
	end

	flying = false

	if heartbeatConnection then
		heartbeatConnection:Disconnect()
		heartbeatConnection = nil
	end

	if linearVelocity then
		linearVelocity:Destroy()
		linearVelocity = nil
	end

	if attachment then
		attachment:Destroy()
		attachment = nil
	end

	if humanoid and humanoid.Parent then
		humanoid.AutoRotate = true
		humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
	end
end

local function updateCharacterReferences(newCharacter)
	if flying then
		stopFlying()
	end

	character = newCharacter
	humanoid = character:WaitForChild("Humanoid")
	rootPart = character:WaitForChild("HumanoidRootPart")
end

local function getMovementDirection()
	local camera = workspace.CurrentCamera
	if not camera then
		return Vector3.zero
	end

	local direction = Vector3.zero
	local forward = Vector3.new(camera.CFrame.LookVector.X, 0, camera.CFrame.LookVector.Z)
	local right = Vector3.new(camera.CFrame.RightVector.X, 0, camera.CFrame.RightVector.Z)

	if forward.Magnitude > 0 then
		forward = forward.Unit
	end
	if right.Magnitude > 0 then
		right = right.Unit
	end

	if pressedKeys[Enum.KeyCode.W] then
		direction += forward
	end
	if pressedKeys[Enum.KeyCode.S] then
		direction -= forward
	end
	if pressedKeys[Enum.KeyCode.D] then
		direction += right
	end
	if pressedKeys[Enum.KeyCode.A] then
		direction -= right
	end
	if pressedKeys[UP_KEY] then
		direction += Vector3.yAxis
	end
	if pressedKeys[DOWN_KEY] then
		direction -= Vector3.yAxis
	end

	if direction.Magnitude > 1 then
		direction = direction.Unit
	end

	return direction
end

local function startFlying()
	if flying or not character or not humanoid or not rootPart then
		return
	end

	if humanoid.Health <= 0 then
		return
	end

	flying = true
	humanoid.AutoRotate = false
	humanoid:ChangeState(Enum.HumanoidStateType.Physics)

	attachment = Instance.new("Attachment")
	attachment.Name = "FlightAttachment"
	attachment.Parent = rootPart

	linearVelocity = Instance.new("LinearVelocity")
	linearVelocity.Name = "FlightVelocity"
	linearVelocity.Attachment0 = attachment
	linearVelocity.RelativeTo = Enum.ActuatorRelativeTo.World
	linearVelocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
	linearVelocity.MaxForce = math.huge
	linearVelocity.VectorVelocity = Vector3.zero
	linearVelocity.Parent = rootPart

	heartbeatConnection = RunService.Heartbeat:Connect(function()
		if not flying or not rootPart.Parent or humanoid.Health <= 0 then
			stopFlying()
			return
		end

		local direction = getMovementDirection()
		local speed = FLY_SPEED
		if pressedKeys[BOOST_KEY] then
			speed *= BOOST_MULTIPLIER
		end

		linearVelocity.VectorVelocity = direction * speed
		if direction.Magnitude > 0 then
			rootPart.CFrame = CFrame.lookAt(rootPart.Position, rootPart.Position + direction)
		end
	end)
end

local function toggleFlying()
	if flying then
		stopFlying()
	else
		startFlying()
	end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then
		return
	end

	if input.KeyCode == TOGGLE_KEY then
		toggleFlying()
		return
	end

	if pressedKeys[input.KeyCode] ~= nil then
		pressedKeys[input.KeyCode] = true
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if pressedKeys[input.KeyCode] ~= nil then
		pressedKeys[input.KeyCode] = false
	end
end)

player.CharacterAdded:Connect(updateCharacterReferences)
if player.Character then
	updateCharacterReferences(player.Character)
else
	updateCharacterReferences(player.CharacterAdded:Wait())
end
