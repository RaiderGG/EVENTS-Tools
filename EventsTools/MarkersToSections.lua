-- Verificar si existe un track llamado "EVENTS"
local function MarkersToSections()
    local track_name = "EVENTS"
    local track = nil

    for i = 0, reaper.CountTracks(0) - 1 do
        local current_track = reaper.GetTrack(0, i)
        local _, name = reaper.GetTrackName(current_track)
        if name == track_name then
            track = current_track
            break
        end
    end

    if not track then
        reaper.ShowMessageBox("No se encontró un track llamado '" .. track_name .. "'.", "Error", 0)
        return
    end

    -- Encontrar un ítem MIDI en el track "EVENTS"
    local midi_item = nil

    for i = 0, reaper.CountTrackMediaItems(track) - 1 do
        local item = reaper.GetTrackMediaItem(track, i)
        local take = reaper.GetActiveTake(item)
        if take and reaper.TakeIsMIDI(take) then
            midi_item = item
            break
        end
    end

    if not midi_item then
        reaper.ShowMessageBox("No se encontró un ítem MIDI en el track '" .. track_name .. "'.", "Error", 0)
        return
    end

    local take = reaper.GetActiveTake(midi_item)

    -- Obtener todos los marcadores y agregar eventos de texto en el ítem MIDI
    local _, num_markers = reaper.CountProjectMarkers(0)
    for i = 0, num_markers - 1 do
        local retval, is_region, pos, _, name, _ = reaper.EnumProjectMarkers(i)
        if not is_region then
            -- Formatear el nombre del marcador
            local formatted_text = "[prc_" .. name .. "]"
            -- Insertar el evento de texto
            reaper.MIDI_InsertTextSysexEvt(take, false, false, reaper.MIDI_GetPPQPosFromProjTime(take, pos), 0x01, formatted_text)
        end
    end

    reaper.UpdateArrange()
    -- reaper.ShowMessageBox("Marcadores trasladados exitosamente como eventos de texto en el ítem MIDI del track 'EVENTS'.", "Éxito", 0)
end

return MarkersToSections