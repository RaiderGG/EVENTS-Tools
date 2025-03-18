local function CrowdClap()
	local track_name = "EVENTS"
	local track = nil
    
-- Verify if "EVENTS" track exists
	
	for i = 0, reaper.CountTracks(0) - 1 do
		local current_track = reaper.GetTrack(0, i)
		local _, name = reaper.GetTrackName(current_track)
		if name == track_name then
				track = current_track
				break
		end
	end

	if not track then
		reaper.ShowMessageBox("Track '" .. track_name .. "' not found.", "Error", 0)
		return
	end
	
	-- Finding a MIDI Item on "EVENTS" track
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

	-- Getting Play Cursor Position
	local play_cursor_pos = reaper.GetCursorPosition()

	-- Insert text event on the cursor position
	local formatted_text = "[crowd_clap]"
	reaper.MIDI_InsertTextSysexEvt(take, false, false, reaper.MIDI_GetPPQPosFromProjTime(take, play_cursor_pos), 0x01, formatted_text)

	reaper.UpdateArrange()
end
return CrowdClap