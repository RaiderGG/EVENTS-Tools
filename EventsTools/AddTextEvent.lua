-- Función para insertar un evento de texto en la posición del cursor de reproducción
local function AddTextEvent(formattedText)
	local track_name = "EVENTS"
	local track = nil
-- Verify if there's a track named "EVENTS"
	
	for i = 0, reaper.CountTracks(0) - 1 do
		local current_track = reaper.GetTrack(0, i)
		local _, name = reaper.GetTrackName(current_track)
		if name == track_name then
            track = current_track
            -- reaper.ShowConsoleMsg("EVENTS track found, looking for MIDI Item\n")
            break
		end
	end

	if not track then
		reaper.ShowMessageBox("Track '" .. track_name .. "' not found.", "Error", 0)
		return
	end
	
	-- Find the MIDI Item on track "EVENTS"
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
		reaper.ShowMessageBox("Midi item on '" .. track_name .. "' not found.", "Error", 0)
		return
	end

	local take = reaper.GetActiveTake(midi_item)

	-- Obtener la posición del cursor de reproducción
	local play_cursor_pos = reaper.GetCursorPosition()

	-- Insertar el evento de texto en la posición del cursor de reproducción
	reaper.MIDI_InsertTextSysexEvt(take, false, false, reaper.MIDI_GetPPQPosFromProjTime(take, play_cursor_pos), 0x01, ("[" .. formattedText .. "]"))

end
return AddTextEvent