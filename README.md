# Roblox Flight Script

Skybound Flight is a Roblox flight script that adds client-side flight controls to a player character. It is a configurable Roblox script using camera-relative movement, vertical flight, a toggle key, and a temporary speed boost.

## Install

1. Open your Roblox experience in Roblox Studio.
2. In the Explorer, open `StarterPlayer` and then `StarterPlayerScripts`.
3. Insert a `LocalScript`.
4. Copy the contents of `FlightController.client.lua` into the `LocalScript`.
5. Play-test the experience as a client.

The script must run as a `LocalScript` because it uses `Players.LocalPlayer` and `UserInputService`.

## Use

1. Press `F` to toggle flight.
2. Use `W`, `A`, `S`, and `D` to move relative to the camera.
3. Press `Space` to move upward.
4. Press `LeftControl` to move downward.
5. Hold `LeftShift` to increase flight speed.
6. Edit the configuration values at the top of the script to change the keys, normal flight speed, and boost multiplier.

The script automatically handles character respawns and stops flight when the character is removed or defeated.

---

More Roblox script projects by EnderDevelopment: https://github.com/EnderDevelopment

Project page: https://dash.enderdevelopment.com/community/60115429-99d3-4f8f-afcc-b7c5f6599d8f?utm_source=github&utm_medium=readme&utm_campaign=auto_publish&utm_content=60115429-99d3-4f8f-afcc-b7c5f6599d8f
