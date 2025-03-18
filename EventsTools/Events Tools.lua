-- Setting directories for ImGui and scripts
package.path = reaper.ImGui_GetBuiltinPath() .. '/?.lua'
package.path = reaper.GetResourcePath() .. "/Scripts/EventsTools/?.lua;" .. package.path
local ImGui = require 'imgui' '0.9.3'

-- Load .Lua file functions
local MarkersToSections = require "MarkersToSections"
local MusicStart = require "MusicStart"
local MusicEnd = require "MusicEnd"
local AddEnd = require "AddEnd"
local CrowdClap = require "CrowdClap"
local CrowdNoClap = require "CrowdNoClap"
local CrowdMellow = require "CrowdMellow"
local CrowdNormal = require "CrowdNormal"
local CrowdIntense = require "CrowdIntense"
local CrowdRealtime = require "CrowdRealtime"

-- Create ImGui context
local ctx = ImGui.CreateContext('EVENTS Tools')

-- Main GUI loop
local function loop()
    -- Establecer el tamaño fijo de la ventana
    ImGui.SetNextWindowSize(ctx, 325, 325, ImGui.Cond_Always)

    -- Crear la ventana
    local visible, open = ImGui.Begin(ctx, 'EVENTS Tools', true)
    if visible then
        -- Marker tools section
        ImGui.Text(ctx, 'Markers and practice sections tools')

        -- Button for "Markers to Sections"
        if ImGui.Button(ctx, 'Markers to Sections', 150, 30) then
            MarkersToSections()
        end

		-- Music events section
        ImGui.SeparatorText(ctx,'Music events')

        if ImGui.Button(ctx, 'Add Music Start', 150, 30) then
            MusicStart()
        end

        -- Spacer
        ImGui.SameLine(ctx)

        if ImGui.Button(ctx, 'Add Music End', 150, 30) then
            MusicEnd()
        end

        if ImGui.Button(ctx, 'Add End', 150, 30) then
            AddEnd()
        end

		-- Crowd clap section
        ImGui.SeparatorText(ctx,'Crowd clap')

        if ImGui.Button(ctx, 'Add Crowd Clap', 150, 30) then
            CrowdClap()
        end

		ImGui.SameLine(ctx)

		if ImGui.Button(ctx, 'Add Crowd NoClap', 150, 30) then
            CrowdNoClap()
        end

		-- Crowd clap section
        ImGui.SeparatorText(ctx,'Crowd intensity')

        if ImGui.Button(ctx, 'Crowd Mellow', 150, 30) then
            CrowdMellow()
        end

		ImGui.SameLine(ctx)

		if ImGui.Button(ctx, 'Crowd Normal', 150, 30) then
            CrowdNormal()
        end

		if ImGui.Button(ctx, 'Crowd Intense', 150, 30) then
            CrowdIntense()
        end

		ImGui.SameLine(ctx)

		if ImGui.Button(ctx, 'Crowd Realtime', 150, 30) then
            CrowdRealtime()
        end

        -- Finalizing the window
        ImGui.End(ctx)			
    end

    -- Keep loop active while the window is open
    if open then
        reaper.defer(loop)
    end
end

-- Starting the loop
reaper.defer(loop)