-- Setting directories for ImGui and scripts
package.path = reaper.ImGui_GetBuiltinPath() .. '/?.lua'
package.path = reaper.GetResourcePath() .. "/Scripts/EventsTools/?.lua;" .. package.path
local Im = require 'imgui' '0.9.3'
local MarkersToSections = require "MarkersToSections"
local AddTextEvent = require "AddTextEvent"
local AddSectionMarker = require "AddSectionMarker"
local version = "1.1"

--Definitions
local sizeX = 323
local sizeY = 420
local comboW = 70
local prc_unusedsections = {}
local prc_section_names = {}
local unprccombo = {}


--Function Definitions
local function LoadSectionsFile()
    local file_path = reaper.GetResourcePath() .. "/Scripts/EventsTools/sections.txt"
    local sectionsFile = io.open(file_path,"r") or nil
    if sectionsFile then 
        for line in sectionsFile:lines() do
            local marker_name, display_name = line:match('%[prc_(.-)%]%s*"(.-)"')
            if marker_name and display_name then
                -- Add ALL to validation list
                table.insert(prc_unusedsections, marker_name)
                table.insert(prc_section_names, display_name)
            end
        end
    else 
        reaper.ShowMessageBox("sections.txt file not found in the EventsTools folder. Please make sure the file exists and try again.", "Error", 0)
    end
end
LoadSectionsFile()

local sectionCount ={
    verse = {"##",1,2,3,4,5,6,7,8,9},
    preverse = {"##",1,2,3,4,5},
    postverse = {'##',1,2,3,4,5},
    chorus = {'##',1,2,3,4,5,6,7,8,9},
    prechorus = {'##',1,2,3,4,5},
    postchorus = {'##',1,2,3,4,5},
    bridge = {'##',1,2,3,4,5,6,7,8,9},
    interlude = {'##',1,2,3,4},
    gtr_solo = {'##',1,2,3,4,5,6,7,8,9},
    bass_solo = {'##',1,2,3,4},
    drum_solo = {'##',1,2,3,4},
    main_riff = {'##',1,2,3,4,5,6,7,8,9},
    chorus_riff = {'##',1,2,3,4}
}
local sel = {verse = '##',
    preverse = '##',
    postverse = '##',
    chorus = '##',
    prechorus = '##',
    postchorus = '##',
    bridge = '##',
    gtr_solo = '##',
    bass_solo = '##',
    drum_solo = '##',
    interlude = '##',
    main_riff = '##',
    chorus_riff = '##', 
    section = '##'
}
-- Create Im context
local ctx = Im.CreateContext('EVENTS Tools')

-- Main GUI loop
local function loop()
    Im.SetNextWindowSize(ctx, sizeX, sizeY,Im.Cond_Appearing)

    local visible, open = Im.Begin(ctx, 'EVENTS Tools v' .. version, true, Im.WindowFlags_NoScrollbar | Im.WindowFlags_NoCollapse | Im.WindowFlags_NoResize)
    if visible then
        -- Marker tools section
        Im.SeparatorText(ctx, 'Sections')

        -- Button for "Markers to Sections"
        if Im.Button(ctx, 'Open Sections window', 307, 30) then
            local center_x, center_y = Im.Viewport_GetCenter(Im.GetWindowViewport(ctx))
            Im.SetNextWindowPos(ctx, (center_x + (0.5*sizeX)), center_y, Im.Cond_Appearing, 0, 0.5)
            Im.SetNextWindowSize(ctx,787,sizeY)
            Im.OpenPopup(ctx,'Add Sections')
        end

        if Im.Button(ctx, 'Copy Markers to EVENTS track', 307, 30) then
            MarkersToSections()
        end

		-- Music events section
        Im.SeparatorText(ctx,'Music Events')

        if Im.Button(ctx, 'Music Start', 150, 30) then
            AddTextEvent('music_start')
        end

        Im.SameLine(ctx)

        if Im.Button(ctx, 'Music End', 150, 30) then
            AddTextEvent("music_end")
        end

        if Im.Button(ctx, 'End', 150, 30) then
            AddTextEvent("end")
        end

		-- Crowd clap on/off section
        Im.SeparatorText(ctx,'Crowd Clap')

        if Im.Button(ctx, 'Crowd Clap', 150, 30) then
            AddTextEvent("crowd_clap")
        end

		Im.SameLine(ctx)

		if Im.Button(ctx, 'Crowd NoClap', 150, 30) then
            AddTextEvent("crowd_noclap")
        end

		-- Crowd intensity section
        Im.SeparatorText(ctx,'Crowd Intensity')

        if Im.Button(ctx, 'Crowd Mellow', 150, 30) then
            AddTextEvent("crowd_mellow")
        end

		Im.SameLine(ctx)

		if Im.Button(ctx, 'Crowd Normal', 150, 30) then
            AddTextEvent("crowd_normal")
        end

		if Im.Button(ctx, 'Crowd Intense', 150, 30) then
            AddTextEvent("crowd_intense")
        end

		Im.SameLine(ctx)

		if Im.Button(ctx, 'Crowd Realtime', 150, 30) then
            AddTextEvent("crowd_realtime")
        end


        --Sections Window
        if Im.BeginPopupModal(ctx, 'Add Sections', nil,Im.WindowFlags_NoResize) then
            if not unprccombo.filter then
                unprccombo = {
                    filter = Im.CreateTextFilter(),
                    selidx = "##"
                }
                Im.Attach(ctx, unprccombo.filter)
            end
            Im.Text(ctx, 'Add Section Markers, you need to copy them to EVENTS track. \nYou can also search for any other section on the search box.')

            --Buttons for Intro sections
            if Im.Button(ctx, 'Intro',125,30) then AddSectionMarker("intro") end
            Im.SameLine(ctx,0,90)
            if Im.Button(ctx, 'A',30,30) then AddSectionMarker("intro",nil,"a") end
            Im.SameLine(ctx,0,10)
            if Im.Button(ctx, 'B',30,30) then AddSectionMarker("intro",nil,"b") end
            Im.SameLine(ctx,0,10)
            if Im.Button(ctx, 'C',30,30) then AddSectionMarker("intro",nil,"c") end
            Im.SameLine(ctx,0,10)
            if Im.Button(ctx, 'D',30,30) then AddSectionMarker("intro",nil,"d") end
            Im.SameLine(ctx,0,40)

            --Markers for Bridge Sections
            if Im.Button(ctx, 'Bridge',125,30) then 
                AddSectionMarker("bridge",  sel.bridge)
            end
            Im.SameLine(ctx,0,10)

            Im.PushStyleVar(ctx,Im.StyleVar_FramePadding,0,6.5)
            Im.SetNextItemWidth(ctx,comboW)
            if Im.BeginCombo(ctx,"##bridge",tostring(sel.bridge),Im.ComboFlags_HeightLarge) then
                for i,v in ipairs(sectionCount.bridge) do
                    local is_sel = sel.bridge == v
                    if Im.Selectable(ctx, sectionCount.bridge[i], is_sel) then
                        sel.bridge = sectionCount.bridge[i]
                    end

                    if sel.bridge then
                        Im.SetItemDefaultFocus(ctx)
                    end
                end
                Im.EndCombo(ctx)
            end
            Im.PopStyleVar(ctx)
            --using ##to give unique button ID and skip the characters from drawing
            Im.SameLine(ctx,0,10)
            if Im.Button(ctx, 'A##brdg',30,30) then AddSectionMarker("bridge", sel.bridge, "a") end
            Im.SameLine(ctx,0,10)
            if Im.Button(ctx, 'B##brdg',30,30) then AddSectionMarker("bridge" ,  sel.bridge ,  "b") end
            Im.SameLine(ctx,0,10)
            if Im.Button(ctx, 'C##brdg',30,30) then AddSectionMarker("bridge" ,  sel.bridge ,  "c") end
            Im.SameLine(ctx,0,10)
            if Im.Button(ctx, 'D##brdg',30,30) then AddSectionMarker("bridge" ,  sel.bridge ,  "d") end
            

            --Markers for Preverse Sections
            if Im.Button(ctx, 'Preverse',125,30) then 
                AddSectionMarker("preverse",  sel.preverse)
            end
            Im.SameLine(ctx,0,10)

            Im.PushStyleVar(ctx,Im.StyleVar_FramePadding,0,6.5)
            Im.SetNextItemWidth(ctx,comboW)
            if Im.BeginCombo(ctx,"##preverse",sel.preverse,Im.ComboFlags_HeightLarge) then
                
                for i,v in ipairs(sectionCount.preverse) do
                    local is_sel = sel.preverse == v
                    if Im.Selectable(ctx, sectionCount.preverse[i], is_sel) then
                        sel.preverse = sectionCount.preverse[i]
                    end

                    if sel.preverse then
                        Im.SetItemDefaultFocus(ctx)
                    end
                end
    
                Im.EndCombo(ctx)
            end
            Im.PopStyleVar(ctx)
            --using ##to give unique button ID and skip the characters from drawing
            Im.SameLine(ctx,0,10)
            if Im.Button(ctx, 'A##prev',30,30) then AddSectionMarker("preverse", sel.preverse, "a") end
            Im.SameLine(ctx,0,10)
            if Im.Button(ctx, 'B##prev',30,30) then AddSectionMarker("preverse" ,  sel.preverse ,  "b") end
            Im.SameLine(ctx,0,10)
            if Im.Button(ctx, 'C##prev',30,30) then AddSectionMarker("preverse" ,  sel.preverse ,  "c") end
            Im.SameLine(ctx,0,10)
            if Im.Button(ctx, 'D##prev',30,30) then AddSectionMarker("preverse" ,  sel.preverse ,  "d") end
            Im.SameLine(ctx,0,40)

            --Markers for Interlude Sections
            if Im.Button(ctx, 'Interlude',125,30) then 
                AddSectionMarker("interlude",  sel.interlude)
            end
            Im.SameLine(ctx,0,10)

            Im.PushStyleVar(ctx,Im.StyleVar_FramePadding,0,6.5)
            Im.SetNextItemWidth(ctx,comboW)
            if Im.BeginCombo(ctx,"##interlude",sel.interlude,Im.ComboFlags_HeightLarge) then
                for i,v in ipairs(sectionCount.interlude) do
                    local is_sel = sel.interlude == v
                    if Im.Selectable(ctx, sectionCount.interlude[i], is_sel) then
                        sel.interlude = sectionCount.interlude[i]
                    end

                    if sel then
                        Im.SetItemDefaultFocus(ctx)
                    end
                end
                Im.EndCombo(ctx)
            end
            Im.PopStyleVar(ctx)
            --using ##to give unique button ID and skip the interaracters from drawing
            Im.SameLine(ctx,0,10)
            if Im.Button(ctx, 'A##inter',30,30) then AddSectionMarker("interlude", sel.interlude, "a") end
            Im.SameLine(ctx,0,10)
            if Im.Button(ctx, 'B##inter',30,30) then AddSectionMarker("interlude" ,  sel.interlude ,  "b") end
            Im.SameLine(ctx,0,10)
            if Im.Button(ctx, 'C##inter',30,30) then AddSectionMarker("interlude" ,  sel.interlude ,  "c") end
            Im.SameLine(ctx,0,10)
            if Im.Button(ctx, 'D##inter',30,30) then AddSectionMarker("interlude" ,  sel.interlude ,  "d") end

            --Markers for Verse Sections
            if Im.Button(ctx, 'Verse',125,30) then 
                AddSectionMarker("verse",  sel.verse)
            end
            Im.SameLine(ctx,0,10)

            Im.PushStyleVar(ctx,Im.StyleVar_FramePadding,0,6.5)
            Im.SetNextItemWidth(ctx,comboW)
            if Im.BeginCombo(ctx,"##verse",sel.verse,Im.ComboFlags_HeightLarge | Im.WindowFlags_NoScrollbar) then
                for i,v in ipairs(sectionCount.verse) do
                    local is_sel = sel.verse == v
                    if Im.Selectable(ctx, sectionCount.verse[i], is_sel) then
                        sel.verse = sectionCount.verse[i]
                    end

                    if sel then
                        Im.SetItemDefaultFocus(ctx)
                    end
                end
                Im.EndCombo(ctx)
            end
            Im.PopStyleVar(ctx)
            --using ##to give unique button ID and skip the characters from drawing
            Im.SameLine(ctx,0,10)
            if Im.Button(ctx, 'A##v',30,30) then AddSectionMarker("verse", sel.verse, "a") end
            Im.SameLine(ctx,0,10)
            if Im.Button(ctx, 'B##v',30,30) then AddSectionMarker("verse" ,  sel.verse ,  "b") end
            Im.SameLine(ctx,0,10)
            if Im.Button(ctx, 'C##v',30,30) then AddSectionMarker("verse" ,  sel.verse ,  "c") end
            Im.SameLine(ctx,0,10)
            if Im.Button(ctx, 'D##v',30,30) then AddSectionMarker("verse" ,  sel.verse ,  "d") end
            Im.SameLine(ctx,0,40)

            --Markers for Gtr_solo Sections
            if Im.Button(ctx, 'Guitar Solo',125,30) then 
                AddSectionMarker("gtr_solo",  sel.gtr_solo)
            end
            Im.SameLine(ctx,0,10)

            Im.PushStyleVar(ctx,Im.StyleVar_FramePadding,0,6.5)
            Im.SetNextItemWidth(ctx,comboW)
            if Im.BeginCombo(ctx,"##gtr_solo",sel.gtr_solo,Im.ComboFlags_HeightRegular) then
                for i,v in ipairs(sectionCount.gtr_solo) do
                    local is_sel = sel.gtr_solo == v
                    if Im.Selectable(ctx, sectionCount.gtr_solo[i], is_sel) then
                        sel.gtr_solo = sectionCount.gtr_solo[i]
                    end

                    if sel then
                        Im.SetItemDefaultFocus(ctx)
                    end
                end
                Im.EndCombo(ctx)
            end
            Im.PopStyleVar(ctx)
            --using ##to give unique button ID and skip the gsoloaracters from drawing
            Im.SameLine(ctx,0,10)
            if Im.Button(ctx, 'A##gsolo',30,30) then AddSectionMarker("gtr_solo", sel.gtr_solo, "a") end
            Im.SameLine(ctx,0,10)
            if Im.Button(ctx, 'B##gsolo',30,30) then AddSectionMarker("gtr_solo" ,  sel.gtr_solo ,  "b") end
            Im.SameLine(ctx,0,10)
            if Im.Button(ctx, 'C##gsolo',30,30) then AddSectionMarker("gtr_solo" ,  sel.gtr_solo ,  "c") end
            Im.SameLine(ctx,0,10)
            if Im.Button(ctx, 'D##gsolo',30,30) then AddSectionMarker("gtr_solo" ,  sel.gtr_solo ,  "d") end

            --Markers for Postverse Sections
            if Im.Button(ctx, 'Postverse',125,30) then 
                AddSectionMarker("postverse",  sel.postverse)
            end
            Im.SameLine(ctx,0,10)

            Im.PushStyleVar(ctx,Im.StyleVar_FramePadding,0,6.5)
            Im.SetNextItemWidth(ctx,comboW)
            if Im.BeginCombo(ctx,"##postverse",sel.postverse,Im.ComboFlags_HeightLarge) then
                for i,v in ipairs(sectionCount.postverse) do
                    local is_sel = sel.postverse == v
                    if Im.Selectable(ctx, sectionCount.postverse[i], is_sel) then
                        sel.postverse = sectionCount.postverse[i]
                    end

                    if sel then
                        Im.SetItemDefaultFocus(ctx)
                    end
                end
                Im.EndCombo(ctx)
            end
            Im.PopStyleVar(ctx)
            --using ##to give unique button ID and skip the characters from drawing
            Im.SameLine(ctx,0,10)
            if Im.Button(ctx, 'A##postv',30,30) then AddSectionMarker("postverse", sel.postverse, "a") end
            Im.SameLine(ctx,0,10)
            if Im.Button(ctx, 'B##postv',30,30) then AddSectionMarker("postverse" , sel.postverse, "b") end
            Im.SameLine(ctx,0,10)
            if Im.Button(ctx, 'C##postv',30,30) then AddSectionMarker("postverse", sel.postverse, "c") end
            Im.SameLine(ctx,0,10)
            if Im.Button(ctx, 'D##postv',30,30) then AddSectionMarker("postverse" , sel.postverse, "d") end
            Im.SameLine(ctx,0,40)

            --Markers for Bass_solo Sections
            if Im.Button(ctx, 'Bass Solo',125,30) then 
                AddSectionMarker("bass_solo",sel.bass_solo)
            end
            Im.SameLine(ctx,0,10)

            Im.PushStyleVar(ctx,Im.StyleVar_FramePadding,0,6.5)
            Im.SetNextItemWidth(ctx,comboW)
            if Im.BeginCombo(ctx,"##bass_solo",sel.bass_solo,Im.ComboFlags_HeightLarge) then
                for i,v in ipairs(sectionCount.bass_solo) do
                    local is_sel = sel.bass_solo == v
                    if Im.Selectable(ctx, sectionCount.bass_solo[i], is_sel) then
                        sel.bass_solo = sectionCount.bass_solo[i]
                    end

                    if sel then
                        Im.SetItemDefaultFocus(ctx)
                    end
                end
                Im.EndCombo(ctx)
            end
            Im.PopStyleVar(ctx)
            --using ##to give unique button ID and skip the characters from drawing
            Im.SameLine(ctx,0,10)
            if Im.Button(ctx, 'A##bsolo',30,30) then AddSectionMarker("bass_solo", sel.bass_solo, "a") end
            Im.SameLine(ctx,0,10)
            if Im.Button(ctx, 'B##bsolo',30,30) then AddSectionMarker("bass_solo" ,  sel.bass_solo ,  "b") end
            Im.SameLine(ctx,0,10)
            if Im.Button(ctx, 'C##bsolo',30,30) then AddSectionMarker("bass_solo" ,  sel.bass_solo ,  "c") end
            Im.SameLine(ctx,0,10)
            if Im.Button(ctx, 'D##bsolo',30,30) then AddSectionMarker("bass_solo" ,  sel.bass_solo ,  "d") end


            --Markers for Prechorus Sections
            if Im.Button(ctx, 'Prechorus',125,30) then 
                AddSectionMarker("prechorus",  sel.prechorus)
            end
            Im.SameLine(ctx,0,10)

            Im.PushStyleVar(ctx,Im.StyleVar_FramePadding,0,6.5)
            Im.SetNextItemWidth(ctx,comboW)
            if Im.BeginCombo(ctx,"##prechorus",sel.prechorus,Im.ComboFlags_HeightLarge) then
                for i,v in ipairs(sectionCount.prechorus) do
                    local is_sel = sel.prechorus == v
                    if Im.Selectable(ctx, sectionCount.prechorus[i], is_sel) then
                        sel.prechorus = sectionCount.prechorus[i]
                    end

                    if sel then
                        Im.SetItemDefaultFocus(ctx)
                    end
                end
                Im.EndCombo(ctx)
            end
            Im.PopStyleVar(ctx)
            --using ##to give unique button ID and skip the characters from drawing
            Im.SameLine(ctx,0,10)
            if Im.Button(ctx, 'A##prech',30,30) then AddSectionMarker("prechorus", sel.prechorus, "a") end
            Im.SameLine(ctx,0,10)
            if Im.Button(ctx, 'B##prech',30,30) then AddSectionMarker("prechorus" ,  sel.prechorus ,  "b") end
            Im.SameLine(ctx,0,10)
            if Im.Button(ctx, 'C##prech',30,30) then AddSectionMarker("prechorus" ,  sel.prechorus ,  "c") end
            Im.SameLine(ctx,0,10)
            if Im.Button(ctx, 'D##prech',30,30) then AddSectionMarker("prechorus" ,  sel.prechorus ,  "d") end
            Im.SameLine(ctx,0,40)

            --Markers for Drum_solo Sections
            if Im.Button(ctx, 'Drum solo',125,30) then 
                AddSectionMarker("drum_solo",  sel.drum_solo)
            end
            Im.SameLine(ctx,0,10)

            Im.PushStyleVar(ctx,Im.StyleVar_FramePadding,0,6.5)
            Im.SetNextItemWidth(ctx,comboW)
            if Im.BeginCombo(ctx,"##drum_solo",sel.drum_solo,Im.ComboFlags_HeightLarge) then
                for i,v in ipairs(sectionCount.drum_solo) do
                    local is_sel = sel.drum_solo == v
                    if Im.Selectable(ctx, sectionCount.drum_solo[i], is_sel) then
                        sel.drum_solo = sectionCount.drum_solo[i]
                    end

                    if sel then
                        Im.SetItemDefaultFocus(ctx)
                    end
                end
                Im.EndCombo(ctx)
            end
            Im.PopStyleVar(ctx)
            --using ##to give unique button ID and skip the dsoloaracters from drawing
            Im.SameLine(ctx,0,10)
            if Im.Button(ctx, 'A##dsolo',30,30) then AddSectionMarker("drum_solo", sel.drum_solo, "a") end
            Im.SameLine(ctx,0,10)
            if Im.Button(ctx, 'B##dsolo',30,30) then AddSectionMarker("drum_solo" ,  sel.drum_solo ,  "b") end
            Im.SameLine(ctx,0,10)
            if Im.Button(ctx, 'C##dsolo',30,30) then AddSectionMarker("drum_solo" ,  sel.drum_solo ,  "c") end
            Im.SameLine(ctx,0,10)
            if Im.Button(ctx, 'D##dsolo',30,30) then AddSectionMarker("drum_solo" ,  sel.drum_solo ,  "d") end


            --Markers for Chorus Sections
            if Im.Button(ctx, 'Chorus',125,30) then 
                AddSectionMarker("chorus",  sel.chorus)
            end
            Im.SameLine(ctx,0,10)

            Im.PushStyleVar(ctx,Im.StyleVar_FramePadding,0,6.5)
            Im.SetNextItemWidth(ctx,comboW)
            if Im.BeginCombo(ctx,"##chorus",sel.chorus,Im.ComboFlags_HeightLarge) then
                for i,v in ipairs(sectionCount.chorus) do
                    local is_sel = sel.chorus == v
                    if Im.Selectable(ctx, sectionCount.chorus[i], is_sel) then
                        sel.chorus = sectionCount.chorus[i]
                    end

                    if sel then
                        Im.SetItemDefaultFocus(ctx)
                    end
                end
                Im.EndCombo(ctx)
            end
            Im.PopStyleVar(ctx)
            --using ##to give unique button ID and skip the characters from drawing
            Im.SameLine(ctx,0,10)
            if Im.Button(ctx, 'A##ch',30,30) then AddSectionMarker("chorus", sel.chorus, "a") end
            Im.SameLine(ctx,0,10)
            if Im.Button(ctx, 'B##ch',30,30) then AddSectionMarker("chorus" ,  sel.chorus ,  "b") end
            Im.SameLine(ctx,0,10)
            if Im.Button(ctx, 'C##ch',30,30) then AddSectionMarker("chorus" ,  sel.chorus ,  "c") end
            Im.SameLine(ctx,0,10)
            if Im.Button(ctx, 'D##ch',30,30) then AddSectionMarker("chorus" ,  sel.chorus ,  "d") end
            Im.SameLine(ctx,0,40)

            --Markers for Main_riff Sections
            if Im.Button(ctx, 'Main Riff',125,30) then 
                AddSectionMarker("main_riff",  sel.main_riff)
            end
            Im.SameLine(ctx,0,10)

            Im.PushStyleVar(ctx,Im.StyleVar_FramePadding,0,6.5)
            Im.SetNextItemWidth(ctx,comboW)
            if Im.BeginCombo(ctx,"##main_riff",sel.main_riff,Im.ComboFlags_HeightLarge) then
                for i,v in ipairs(sectionCount.main_riff) do
                    local is_sel = sel.main_riff == v
                    if Im.Selectable(ctx, sectionCount.main_riff[i], is_sel) then
                        sel.main_riff = sectionCount.main_riff[i]
                    end

                    if sel then
                        Im.SetItemDefaultFocus(ctx)
                    end
                end
                Im.EndCombo(ctx)
            end
            Im.PopStyleVar(ctx)
            --using ##to give unique button ID and skip the mriffaracters from drawing
            Im.SameLine(ctx,0,10)
            if Im.Button(ctx, 'A##mriff',30,30) then AddSectionMarker("main_riff", sel.main_riff, "a") end
            Im.SameLine(ctx,0,10)
            if Im.Button(ctx, 'B##mriff',30,30) then AddSectionMarker("main_riff" ,  sel.main_riff ,  "b") end
            Im.SameLine(ctx,0,10)
            if Im.Button(ctx, 'C##mriff',30,30) then AddSectionMarker("main_riff" ,  sel.main_riff ,  "c") end
            Im.SameLine(ctx,0,10)
            if Im.Button(ctx, 'D##mriff',30,30) then AddSectionMarker("main_riff" ,  sel.main_riff ,  "d") end


            --Markers for Postchorus Sections
            if Im.Button(ctx, 'Postchorus',125,30) then 
                AddSectionMarker("postchorus",  sel.postchorus)
            end
            Im.SameLine(ctx,0,10)

            Im.PushStyleVar(ctx,Im.StyleVar_FramePadding,0,6.5)
            Im.SetNextItemWidth(ctx,comboW)
            if Im.BeginCombo(ctx,"##postchorus",sel.postchorus,Im.ComboFlags_HeightLarge) then
                for i,v in ipairs(sectionCount.postchorus) do
                    local is_sel = sel.postchorus == v
                    if Im.Selectable(ctx, sectionCount.postchorus[i], is_sel) then
                        sel.postchorus = sectionCount.postchorus[i]
                    end

                    if sel then
                        Im.SetItemDefaultFocus(ctx)
                    end
                end
                Im.EndCombo(ctx)
            end
            Im.PopStyleVar(ctx)
            --using ##to give unique button ID and skip the characters from drawing
            Im.SameLine(ctx,0,10)
            if Im.Button(ctx, 'A##postch',30,30) then AddSectionMarker("postchorus", sel.postchorus, "a") end
            Im.SameLine(ctx,0,10)
            if Im.Button(ctx, 'B##postch',30,30) then AddSectionMarker("postchorus" ,  sel.postchorus ,  "b") end
            Im.SameLine(ctx,0,10)
            if Im.Button(ctx, 'C##postch',30,30) then AddSectionMarker("postchorus" ,  sel.postchorus ,  "c") end
            Im.SameLine(ctx,0,10)
            if Im.Button(ctx, 'D##postch',30,30) then AddSectionMarker("postchorus" ,  sel.postchorus ,  "d") end
            Im.SameLine(ctx,0,40)

            --Markers for Chorus_riff Sections
            if Im.Button(ctx, 'Chorus riff',125,30) then 
                AddSectionMarker("chorus_riff",  sel.chorus_riff)
            end
            Im.SameLine(ctx,0,10)

            Im.PushStyleVar(ctx,Im.StyleVar_FramePadding,0,6.5)
            Im.SetNextItemWidth(ctx,comboW)
            if Im.BeginCombo(ctx,"##chorus_riff",sel.chorus_riff,Im.ComboFlags_HeightLarge) then
                for i,v in ipairs(sectionCount.chorus_riff) do
                    local is_sel = sel.chorus_riff == v
                    if Im.Selectable(ctx, sectionCount.chorus_riff[i], is_sel) then
                        sel.chorus_riff = sectionCount.chorus_riff[i]
                    end

                    if sel then
                        Im.SetItemDefaultFocus(ctx)
                    end
                end
                Im.EndCombo(ctx)
            end
            Im.PopStyleVar(ctx)
            --using ##to give unique button ID and skip the chriffaracters from drawing
            Im.SameLine(ctx,0,10)
            if Im.Button(ctx, 'A##chriff',30,30) then AddSectionMarker("chorus_riff", sel.chorus_riff, "a") end
            Im.SameLine(ctx,0,10)
            if Im.Button(ctx, 'B##chriff',30,30) then AddSectionMarker("chorus_riff" ,  sel.chorus_riff ,  "b") end
            Im.SameLine(ctx,0,10)
            if Im.Button(ctx, 'C##chriff',30,30) then AddSectionMarker("chorus_riff" ,  sel.chorus_riff ,  "c") end
            Im.SameLine(ctx,0,10)
            if Im.Button(ctx, 'D##chriff',30,30) then AddSectionMarker("chorus_riff" ,  sel.chorus_riff ,  "d") end

            --Buttons for Outro sections
            if Im.Button(ctx, 'Outro',125,30) then AddSectionMarker("outro") end
            Im.SameLine(ctx,0,90)
            if Im.Button(ctx, 'A##outro',30,30) then AddSectionMarker("outro",nil,"a") end
            Im.SameLine(ctx,0,10)
            if Im.Button(ctx, 'B##outro',30,30) then AddSectionMarker("outro",nil,"b") end
            Im.SameLine(ctx,0,10)
            if Im.Button(ctx, 'C##outro',30,30) then AddSectionMarker("outro",nil,"c") end
            Im.SameLine(ctx,0,10)
            if Im.Button(ctx, 'D##outro',30,30) then AddSectionMarker("outro",nil,"d") end
            Im.SameLine(ctx,0,40)
            Im.PushStyleVar(ctx,Im.StyleVar_FramePadding,0,6.5)
            Im.PushItemWidth(ctx,205)
            if Im.BeginCombo(ctx,"##searchsections",sel.section,Im.ComboFlags_HeightLarge ) then
                if Im.IsWindowAppearing(ctx) then
                    Im.SetKeyboardFocusHere(ctx)
                    Im.TextFilter_Clear(unprccombo.filter)
                end
                Im.SetNextItemShortcut(ctx, Im.Mod_Ctrl | Im.Key_F)
                Im.TextFilter_Draw(unprccombo.filter, ctx, '##Filter',-(Im.NumericLimits_Float()))
                
                for i,v in ipairs(prc_unusedsections) do
                    local is_sel = prc_section_names == v
                    if Im.TextFilter_PassFilter(unprccombo.filter,prc_section_names[i]) then
                        if Im.Selectable(ctx, prc_section_names[i], is_sel) then
                            unprccombo.selidx = i
                            sel.section = prc_section_names[i]
                        end
                    end
                end
                Im.EndCombo(ctx)   
            end
            Im.PopItemWidth(ctx)
            Im.PopStyleVar(ctx)
            Im.SameLine(ctx,0,10)
            if Im.Button(ctx,"Place Section Marker",150,30) then
                if sel.section ~= "##" then
                    local curPos = reaper.GetCursorPosition()
                    local cSection = prc_unusedsections[unprccombo.selidx]
                    --reaper.ShowConsoleMsg("section: " .. (cSection or "none"))
                    local markerNum = (reaper.GetNumRegionsOrMarkers(0)+1)
                    reaper.AddProjectMarker2(0,0,curPos,0,cSection,markerNum,Section_colors.default)
                else end
            end

            Im.Separator(ctx)
            Im.Spacing(ctx)
            Im.Spacing(ctx)
            Im.SameLine(ctx,0,252.3)
            if Im.Button(ctx,"Close",262.3,30) then
                Im.CloseCurrentPopup(ctx)
            end
            Im.EndPopup(ctx)
                
        end
        

        -- Finalizing the window
        Im.End(ctx)			
    end

    -- Keep loop active while the window is open
    if open then
        reaper.defer(loop)
    end
end


-- Starting the loop
reaper.defer(loop)