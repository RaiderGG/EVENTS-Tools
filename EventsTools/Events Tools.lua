-- Setting directories for ImGui and scripts
package.path = reaper.ImGui_GetBuiltinPath() .. '/?.lua'
package.path = reaper.GetResourcePath() .. "/Scripts/EventsTools/?.lua;" .. package.path
local ImGui = require 'imgui' '0.9.3'
local sizeX = 323
local sizeY = 408
local comboW = 70
local MarkersToSections = require "MarkersToSections"
local AddTextEvent = require "AddTextEvent"
local AddSectionMarker = require "AddSectionMarker"
local sectionNum ={
    verse = {"##",1,2,3,4,5,6,7,8,9},
    preverse = {"##",1,2,3,4,5},
    postverse = {'##',1,2,3,4,5},
    chorus = {'##',1,2,3,4,5,6,7,8,9},
    prechorus = {'##',1,2,3,4,5},
    postchorus = {'##',1,2,3,4,5},
    bridge = {'##',1,2,3,4,5,6,7,8,9},
    gtr_solo = {'##',1,2,3,4,5,6,7,8,9},
    bass_solo = {'##',1,2,3,4},
    drum_solo = {'##',1,2,3,4},
    interlude = {'##',1,2,3,4},
    main_riff = {'##',1,2,3,4,5,6,7,8,9},
    chorus_riff = {'##',1,2,3,4,5,6,7,8,9}
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
}
-- Create ImGui context
local ctx = ImGui.CreateContext('EVENTS Tools')

-- Main GUI loop
local function loop()
    ImGui.SetNextWindowSize(ctx, sizeX, sizeY,ImGui.Cond_Appearing)

    local visible, open = ImGui.Begin(ctx, 'EVENTS Tools', true, ImGui.WindowFlags_NoScrollbar | ImGui.WindowFlags_NoCollapse | ImGui.WindowFlags_NoResize)
    if visible then
        -- Marker tools section
        ImGui.SeparatorText(ctx, 'Copy ALL Section markers to "EVENTS" Track')

        -- Button for "Markers to Sections"
        if ImGui.Button(ctx, 'Copy Markers to EVENTS track', 307, 30) then
            MarkersToSections()
        end

		-- Music events section
        ImGui.SeparatorText(ctx,'Music events')

        if ImGui.Button(ctx, 'Add Music Start', 150, 30) then
            AddTextEvent('music_start')
        end

        ImGui.SameLine(ctx)

        if ImGui.Button(ctx, 'Add Music End', 150, 30) then
            AddTextEvent("music_end")
        end

        if ImGui.Button(ctx, 'Add End', 150, 30) then
            AddTextEvent("end")
        end

		-- Crowd clap on/off section
        ImGui.SeparatorText(ctx,'Crowd clap')

        if ImGui.Button(ctx, 'Add Crowd Clap', 150, 30) then
            AddTextEvent("crowd_clap")
        end

		ImGui.SameLine(ctx)

		if ImGui.Button(ctx, 'Add Crowd NoClap', 150, 30) then
            AddTextEvent("crowd_noclap")
        end

		-- Crowd intensity section
        ImGui.SeparatorText(ctx,'Crowd intensity')

        if ImGui.Button(ctx, 'Crowd Mellow', 150, 30) then
            AddTextEvent("crowd_mellow")
        end

		ImGui.SameLine(ctx)

		if ImGui.Button(ctx, 'Crowd Normal', 150, 30) then
            AddTextEvent("crowd_normal")
        end

		if ImGui.Button(ctx, 'Crowd Intense', 150, 30) then
            AddTextEvent("crowd_intense")
        end

		ImGui.SameLine(ctx)

		if ImGui.Button(ctx, 'Crowd Realtime', 150, 30) then
            AddTextEvent("crowd_realtime")
        end

        		-- Crowd clap section
        ImGui.SeparatorText(ctx,'Add Section Markers')

        if ImGui.Button(ctx, 'Open Sections Menu', 307, 30) then
            local center_x, center_y = ImGui.Viewport_GetCenter(ImGui.GetWindowViewport(ctx))
            ImGui.SetNextWindowPos(ctx, (center_x + (0.5*sizeX)), center_y, ImGui.Cond_Appearing, 0, 0.5)
            ImGui.SetNextWindowSize(ctx,855,sizeY)
            ImGui.OpenPopup(ctx,'Add Sections')
            
            
        end

        if ImGui.BeginPopupModal(ctx, 'Add Sections', nil) then
            ImGui.SeparatorText(ctx, 'Add Section Markers, you need to copy them to EVENTS track')

            --Buttons for Intro sections
            if ImGui.Button(ctx, 'Intro',125,30) then AddSectionMarker("intro") end
            ImGui.SameLine(ctx,0,90)
            if ImGui.Button(ctx, 'A',30,30) then AddSectionMarker("intro",nil,"a") end
            ImGui.SameLine(ctx,0,10)
            if ImGui.Button(ctx, 'B',30,30) then AddSectionMarker("intro",nil,"b") end
            ImGui.SameLine(ctx,0,10)
            if ImGui.Button(ctx, 'C',30,30) then AddSectionMarker("intro",nil,"c") end
            ImGui.SameLine(ctx,0,10)
            if ImGui.Button(ctx, 'D',30,30) then AddSectionMarker("intro",nil,"d") end
            ImGui.SameLine(ctx,0,40)

            --Markers for Bridge Sections
            if ImGui.Button(ctx, 'Bridge',125,30) then 
                AddSectionMarker("bridge",  sel.bridge)
            end
            ImGui.SameLine(ctx,0,10)

            ImGui.PushStyleVar(ctx,ImGui.StyleVar_FramePadding,0,6.5)
            ImGui.SetNextItemWidth(ctx,comboW)
            if ImGui.BeginCombo(ctx,"##bridge",sel.bridge,ImGui.ComboFlags_HeightLarge) then
                for i,v in ipairs(sectionNum.bridge) do
                    local is_sel = sel.bridge == i
                    if ImGui.Selectable(ctx, sectionNum.bridge[i], is_sel) then
                        sel.bridge = sectionNum.bridge[i]
                    end

                    if sel then
                        ImGui.SetItemDefaultFocus(ctx)
                    end
                end
                ImGui.EndCombo(ctx)
            end
            ImGui.PopStyleVar(ctx)
            --using ##to give unique button ID and skip the characters from drawing
            ImGui.SameLine(ctx,0,10)
            if ImGui.Button(ctx, 'A##brdg',30,30) then AddSectionMarker("bridge", sel.bridge, "a") end
            ImGui.SameLine(ctx,0,10)
            if ImGui.Button(ctx, 'B##brdg',30,30) then AddSectionMarker("bridge" ,  sel.bridge ,  "b") end
            ImGui.SameLine(ctx,0,10)
            if ImGui.Button(ctx, 'C##brdg',30,30) then AddSectionMarker("bridge" ,  sel.bridge ,  "c") end
            ImGui.SameLine(ctx,0,10)
            if ImGui.Button(ctx, 'D##brdg',30,30) then AddSectionMarker("bridge" ,  sel.bridge ,  "d") end
            

            --Markers for Preverse Sections
            if ImGui.Button(ctx, 'Preverse',125,30) then 
                AddSectionMarker("preverse",  sel.preverse)
            end
            ImGui.SameLine(ctx,0,10)

            ImGui.PushStyleVar(ctx,ImGui.StyleVar_FramePadding,0,6.5)
            ImGui.SetNextItemWidth(ctx,comboW)
            if ImGui.BeginCombo(ctx,"##preverse",sel.preverse,ImGui.ComboFlags_HeightLarge) then
                
                for i,v in ipairs(sectionNum.preverse) do
                    local is_sel = sel.preverse == i
                    if ImGui.Selectable(ctx, sectionNum.preverse[i], is_sel) then
                        sel.preverse = sectionNum.preverse[i]
                    end

                    if sel then
                        ImGui.SetItemDefaultFocus(ctx)
                    end
                end
    
                ImGui.EndCombo(ctx)
            end
            ImGui.PopStyleVar(ctx)
            --using ##to give unique button ID and skip the characters from drawing
            ImGui.SameLine(ctx,0,10)
            if ImGui.Button(ctx, 'A##prev',30,30) then AddSectionMarker("preverse", sel.preverse, "a") end
            ImGui.SameLine(ctx,0,10)
            if ImGui.Button(ctx, 'B##prev',30,30) then AddSectionMarker("preverse" ,  sel.preverse ,  "b") end
            ImGui.SameLine(ctx,0,10)
            if ImGui.Button(ctx, 'C##prev',30,30) then AddSectionMarker("preverse" ,  sel.preverse ,  "c") end
            ImGui.SameLine(ctx,0,10)
            if ImGui.Button(ctx, 'D##prev',30,30) then AddSectionMarker("preverse" ,  sel.preverse ,  "d") end
            ImGui.SameLine(ctx,0,40)

            --Markers for Interlude Sections
            if ImGui.Button(ctx, 'Interlude',125,30) then 
                AddSectionMarker("interlude",  sel.interlude)
            end
            ImGui.SameLine(ctx,0,10)

            ImGui.PushStyleVar(ctx,ImGui.StyleVar_FramePadding,0,6.5)
            ImGui.SetNextItemWidth(ctx,comboW)
            if ImGui.BeginCombo(ctx,"##interlude",sel.interlude,ImGui.ComboFlags_HeightLarge) then
                for i,v in ipairs(sectionNum.interlude) do
                    local is_sel = sel.interlude == i
                    if ImGui.Selectable(ctx, sectionNum.interlude[i], is_sel) then
                        sel.interlude = sectionNum.interlude[i]
                    end

                    if sel then
                        ImGui.SetItemDefaultFocus(ctx)
                    end
                end
                ImGui.EndCombo(ctx)
            end
            ImGui.PopStyleVar(ctx)
            --using ##to give unique button ID and skip the interaracters from drawing
            ImGui.SameLine(ctx,0,10)
            if ImGui.Button(ctx, 'A##inter',30,30) then AddSectionMarker("interlude", sel.interlude, "a") end
            ImGui.SameLine(ctx,0,10)
            if ImGui.Button(ctx, 'B##inter',30,30) then AddSectionMarker("interlude" ,  sel.interlude ,  "b") end
            ImGui.SameLine(ctx,0,10)
            if ImGui.Button(ctx, 'C##inter',30,30) then AddSectionMarker("interlude" ,  sel.interlude ,  "c") end
            ImGui.SameLine(ctx,0,10)
            if ImGui.Button(ctx, 'D##inter',30,30) then AddSectionMarker("interlude" ,  sel.interlude ,  "d") end

            --Markers for Verse Sections
            if ImGui.Button(ctx, 'Verse',125,30) then 
                AddSectionMarker("verse",  sel.verse)
            end
            ImGui.SameLine(ctx,0,10)

            ImGui.PushStyleVar(ctx,ImGui.StyleVar_FramePadding,0,6.5)
            ImGui.SetNextItemWidth(ctx,comboW)
            if ImGui.BeginCombo(ctx,"##verse",sel.verse,ImGui.ComboFlags_HeightLarge) then
                for i,v in ipairs(sectionNum.verse) do
                    local is_sel = sel.verse == i
                    if ImGui.Selectable(ctx, sectionNum.verse[i], is_sel) then
                        sel.verse = sectionNum.verse[i]
                    end

                    if sel then
                        ImGui.SetItemDefaultFocus(ctx)
                    end
                end
                ImGui.EndCombo(ctx)
            end
            ImGui.PopStyleVar(ctx)
            --using ##to give unique button ID and skip the characters from drawing
            ImGui.SameLine(ctx,0,10)
            if ImGui.Button(ctx, 'A##v',30,30) then AddSectionMarker("verse", sel.verse, "a") end
            ImGui.SameLine(ctx,0,10)
            if ImGui.Button(ctx, 'B##v',30,30) then AddSectionMarker("verse" ,  sel.verse ,  "b") end
            ImGui.SameLine(ctx,0,10)
            if ImGui.Button(ctx, 'C##v',30,30) then AddSectionMarker("verse" ,  sel.verse ,  "c") end
            ImGui.SameLine(ctx,0,10)
            if ImGui.Button(ctx, 'D##v',30,30) then AddSectionMarker("verse" ,  sel.verse ,  "d") end
            ImGui.SameLine(ctx,0,40)

            --Markers for Gtr_solo Sections
            if ImGui.Button(ctx, 'Guitar Solo',125,30) then 
                AddSectionMarker("gtr_solo",  sel.gtr_solo)
            end
            ImGui.SameLine(ctx,0,10)

            ImGui.PushStyleVar(ctx,ImGui.StyleVar_FramePadding,0,6.5)
            ImGui.SetNextItemWidth(ctx,comboW)
            if ImGui.BeginCombo(ctx,"##gtr_solo",sel.gtr_solo,ImGui.ComboFlags_HeightLarge) then
                for i,v in ipairs(sectionNum.gtr_solo) do
                    local is_sel = sel.gtr_solo == i
                    if ImGui.Selectable(ctx, sectionNum.gtr_solo[i], is_sel) then
                        sel.gtr_solo = sectionNum.gtr_solo[i]
                    end

                    if sel then
                        ImGui.SetItemDefaultFocus(ctx)
                    end
                end
                ImGui.EndCombo(ctx)
            end
            ImGui.PopStyleVar(ctx)
            --using ##to give unique button ID and skip the gsoloaracters from drawing
            ImGui.SameLine(ctx,0,10)
            if ImGui.Button(ctx, 'A##gsolo',30,30) then AddSectionMarker("gtr_solo", sel.gtr_solo, "a") end
            ImGui.SameLine(ctx,0,10)
            if ImGui.Button(ctx, 'B##gsolo',30,30) then AddSectionMarker("gtr_solo" ,  sel.gtr_solo ,  "b") end
            ImGui.SameLine(ctx,0,10)
            if ImGui.Button(ctx, 'C##gsolo',30,30) then AddSectionMarker("gtr_solo" ,  sel.gtr_solo ,  "c") end
            ImGui.SameLine(ctx,0,10)
            if ImGui.Button(ctx, 'D##gsolo',30,30) then AddSectionMarker("gtr_solo" ,  sel.gtr_solo ,  "d") end

            --Markers for Postverse Sections
            if ImGui.Button(ctx, 'Postverse',125,30) then 
                AddSectionMarker("postverse",  sel.postverse)
            end
            ImGui.SameLine(ctx,0,10)

            ImGui.PushStyleVar(ctx,ImGui.StyleVar_FramePadding,0,6.5)
            ImGui.SetNextItemWidth(ctx,comboW)
            if ImGui.BeginCombo(ctx,"##postverse",sel.postverse,ImGui.ComboFlags_HeightLarge) then
                for i,v in ipairs(sectionNum.postverse) do
                    local is_sel = sel.postverse == i
                    if ImGui.Selectable(ctx, sectionNum.postverse[i], is_sel) then
                        sel.postverse = sectionNum.postverse[i]
                    end

                    if sel then
                        ImGui.SetItemDefaultFocus(ctx)
                    end
                end
                ImGui.EndCombo(ctx)
            end
            ImGui.PopStyleVar(ctx)
            --using ##to give unique button ID and skip the characters from drawing
            ImGui.SameLine(ctx,0,10)
            if ImGui.Button(ctx, 'A##postv',30,30) then AddSectionMarker("postverse", sel.postverse, "a") end
            ImGui.SameLine(ctx,0,10)
            if ImGui.Button(ctx, 'B##postv',30,30) then AddSectionMarker("postverse" , sel.postverse, "b") end
            ImGui.SameLine(ctx,0,10)
            if ImGui.Button(ctx, 'C##postv',30,30) then AddSectionMarker("postverse", sel.postverse, "c") end
            ImGui.SameLine(ctx,0,10)
            if ImGui.Button(ctx, 'D##postv',30,30) then AddSectionMarker("postverse" , sel.postverse, "d") end
            ImGui.SameLine(ctx,0,40)

            --Markers for Bass_solo Sections
            if ImGui.Button(ctx, 'Bass Solo',125,30) then 
                AddSectionMarker("bass_solo",sel.bass_solo)
            end
            ImGui.SameLine(ctx,0,10)

            ImGui.PushStyleVar(ctx,ImGui.StyleVar_FramePadding,0,6.5)
            ImGui.SetNextItemWidth(ctx,comboW)
            if ImGui.BeginCombo(ctx,"##bass_solo",sel.bass_solo,ImGui.ComboFlags_HeightLarge) then
                for i,v in ipairs(sectionNum.bass_solo) do
                    local is_sel = sel.bass_solo == i
                    if ImGui.Selectable(ctx, sectionNum.bass_solo[i], is_sel) then
                        sel.bass_solo = sectionNum.bass_solo[i]
                    end

                    if sel then
                        ImGui.SetItemDefaultFocus(ctx)
                    end
                end
                ImGui.EndCombo(ctx)
            end
            ImGui.PopStyleVar(ctx)
            --using ##to give unique button ID and skip the characters from drawing
            ImGui.SameLine(ctx,0,10)
            if ImGui.Button(ctx, 'A##bsolo',30,30) then AddSectionMarker("bass_solo", sel.bass_solo, "a") end
            ImGui.SameLine(ctx,0,10)
            if ImGui.Button(ctx, 'B##bsolo',30,30) then AddSectionMarker("bass_solo" ,  sel.bass_solo ,  "b") end
            ImGui.SameLine(ctx,0,10)
            if ImGui.Button(ctx, 'C##bsolo',30,30) then AddSectionMarker("bass_solo" ,  sel.bass_solo ,  "c") end
            ImGui.SameLine(ctx,0,10)
            if ImGui.Button(ctx, 'D##bsolo',30,30) then AddSectionMarker("bass_solo" ,  sel.bass_solo ,  "d") end


            --Markers for Prechorus Sections
            if ImGui.Button(ctx, 'Prechorus',125,30) then 
                AddSectionMarker("prechorus",  sel.prechorus)
            end
            ImGui.SameLine(ctx,0,10)

            ImGui.PushStyleVar(ctx,ImGui.StyleVar_FramePadding,0,6.5)
            ImGui.SetNextItemWidth(ctx,comboW)
            if ImGui.BeginCombo(ctx,"##prechorus",sel.prechorus,ImGui.ComboFlags_HeightLarge) then
                for i,v in ipairs(sectionNum.prechorus) do
                    local is_sel = sel.prechorus == i
                    if ImGui.Selectable(ctx, sectionNum.prechorus[i], is_sel) then
                        sel.prechorus = sectionNum.prechorus[i]
                    end

                    if sel then
                        ImGui.SetItemDefaultFocus(ctx)
                    end
                end
                ImGui.EndCombo(ctx)
            end
            ImGui.PopStyleVar(ctx)
            --using ##to give unique button ID and skip the characters from drawing
            ImGui.SameLine(ctx,0,10)
            if ImGui.Button(ctx, 'A##prech',30,30) then AddSectionMarker("prechorus", sel.prechorus, "a") end
            ImGui.SameLine(ctx,0,10)
            if ImGui.Button(ctx, 'B##prech',30,30) then AddSectionMarker("prechorus" ,  sel.prechorus ,  "b") end
            ImGui.SameLine(ctx,0,10)
            if ImGui.Button(ctx, 'C##prech',30,30) then AddSectionMarker("prechorus" ,  sel.prechorus ,  "c") end
            ImGui.SameLine(ctx,0,10)
            if ImGui.Button(ctx, 'D##prech',30,30) then AddSectionMarker("prechorus" ,  sel.prechorus ,  "d") end
            ImGui.SameLine(ctx,0,40)

            --Markers for Drum_solo Sections
            if ImGui.Button(ctx, 'Drum solo',125,30) then 
                AddSectionMarker("drum_solo",  sel.drum_solo)
            end
            ImGui.SameLine(ctx,0,10)

            ImGui.PushStyleVar(ctx,ImGui.StyleVar_FramePadding,0,6.5)
            ImGui.SetNextItemWidth(ctx,comboW)
            if ImGui.BeginCombo(ctx,"##drum_solo",sel.drum_solo,ImGui.ComboFlags_HeightLarge) then
                for i,v in ipairs(sectionNum.drum_solo) do
                    local is_sel = sel.drum_solo == i
                    if ImGui.Selectable(ctx, sectionNum.drum_solo[i], is_sel) then
                        sel.drum_solo = sectionNum.drum_solo[i]
                    end

                    if sel then
                        ImGui.SetItemDefaultFocus(ctx)
                    end
                end
                ImGui.EndCombo(ctx)
            end
            ImGui.PopStyleVar(ctx)
            --using ##to give unique button ID and skip the dsoloaracters from drawing
            ImGui.SameLine(ctx,0,10)
            if ImGui.Button(ctx, 'A##dsolo',30,30) then AddSectionMarker("drum_solo", sel.drum_solo, "a") end
            ImGui.SameLine(ctx,0,10)
            if ImGui.Button(ctx, 'B##dsolo',30,30) then AddSectionMarker("drum_solo" ,  sel.drum_solo ,  "b") end
            ImGui.SameLine(ctx,0,10)
            if ImGui.Button(ctx, 'C##dsolo',30,30) then AddSectionMarker("drum_solo" ,  sel.drum_solo ,  "c") end
            ImGui.SameLine(ctx,0,10)
            if ImGui.Button(ctx, 'D##dsolo',30,30) then AddSectionMarker("drum_solo" ,  sel.drum_solo ,  "d") end


            --Markers for Chorus Sections
            if ImGui.Button(ctx, 'Chorus',125,30) then 
                AddSectionMarker("chorus",  sel.chorus)
            end
            ImGui.SameLine(ctx,0,10)

            ImGui.PushStyleVar(ctx,ImGui.StyleVar_FramePadding,0,6.5)
            ImGui.SetNextItemWidth(ctx,comboW)
            if ImGui.BeginCombo(ctx,"##chorus",sel.chorus,ImGui.ComboFlags_HeightLarge) then
                for i,v in ipairs(sectionNum.chorus) do
                    local is_sel = sel.chorus == i
                    if ImGui.Selectable(ctx, sectionNum.chorus[i], is_sel) then
                        sel.chorus = sectionNum.chorus[i]
                    end

                    if sel then
                        ImGui.SetItemDefaultFocus(ctx)
                    end
                end
                ImGui.EndCombo(ctx)
            end
            ImGui.PopStyleVar(ctx)
            --using ##to give unique button ID and skip the characters from drawing
            ImGui.SameLine(ctx,0,10)
            if ImGui.Button(ctx, 'A##ch',30,30) then AddSectionMarker("chorus", sel.chorus, "a") end
            ImGui.SameLine(ctx,0,10)
            if ImGui.Button(ctx, 'B##ch',30,30) then AddSectionMarker("chorus" ,  sel.chorus ,  "b") end
            ImGui.SameLine(ctx,0,10)
            if ImGui.Button(ctx, 'C##ch',30,30) then AddSectionMarker("chorus" ,  sel.chorus ,  "c") end
            ImGui.SameLine(ctx,0,10)
            if ImGui.Button(ctx, 'D##ch',30,30) then AddSectionMarker("chorus" ,  sel.chorus ,  "d") end


            --Markers for Postchorus Sections
            if ImGui.Button(ctx, 'Postchorus',125,30) then 
                AddSectionMarker("postchorus",  sel.postchorus)
            end
            ImGui.SameLine(ctx,0,10)

            ImGui.PushStyleVar(ctx,ImGui.StyleVar_FramePadding,0,6.5)
            ImGui.SetNextItemWidth(ctx,comboW)
            if ImGui.BeginCombo(ctx,"##postchorus",sel.postchorus,ImGui.ComboFlags_HeightLarge) then
                for i,v in ipairs(sectionNum.postchorus) do
                    local is_sel = sel.postchorus == i
                    if ImGui.Selectable(ctx, sectionNum.postchorus[i], is_sel) then
                        sel.postchorus = sectionNum.postchorus[i]
                    end

                    if sel then
                        ImGui.SetItemDefaultFocus(ctx)
                    end
                end
                ImGui.EndCombo(ctx)
            end
            ImGui.PopStyleVar(ctx)
            --using ##to give unique button ID and skip the characters from drawing
            ImGui.SameLine(ctx,0,10)
            if ImGui.Button(ctx, 'A##postch',30,30) then AddSectionMarker("postchorus", sel.postchorus, "a") end
            ImGui.SameLine(ctx,0,10)
            if ImGui.Button(ctx, 'B##postch',30,30) then AddSectionMarker("postchorus" ,  sel.postchorus ,  "b") end
            ImGui.SameLine(ctx,0,10)
            if ImGui.Button(ctx, 'C##postch',30,30) then AddSectionMarker("postchorus" ,  sel.postchorus ,  "c") end
            ImGui.SameLine(ctx,0,10)
            if ImGui.Button(ctx, 'D##postch',30,30) then AddSectionMarker("postchorus" ,  sel.postchorus ,  "d") end




            ImGui.EndPopup(ctx)
                
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