local r = reaper
local sectionText = ""
Section_colors = {
		intro = r.ColorToNative(10,235,10)|0xff000000,
		preverse = r.ColorToNative(195,240,20)|0xff000000,
		verse = r.ColorToNative(240,240,10)|0xff000000,
		postverse = r.ColorToNative(240,190,21)|0xff000000,
		prechorus = r.ColorToNative(248,147,13)|0xff000000,
		chorus = r.ColorToNative(247, 45, 43)|0xff000000,
		postchorus = r.ColorToNative(220,190,10)|0xff000000,
		bridge = r.ColorToNative(220,190,10)|0xff000000,
		gtr_solo = r.ColorToNative(220,190,10)|0xff000000,
		bass_solo = r.ColorToNative(220,190,10)|0xff000000,
		drum_solo = r.ColorToNative(220,190,10)|0xff000000,
		interlude = r.ColorToNative(220,190,10)|0xff000000,
		main_riff = r.ColorToNative(220,190,10)|0xff000000,
		chorus_riff = r.ColorToNative(220,190,10)|0xff000000,
		outro = r.ColorToNative(220,190,10)|0xff000000,
		default = r.ColorToNative(10,10,10)|0xff000000

	}


--Insert a Marker with the Section name provided
---@param sectionGroup string
---@param num? string|integer default nil
---@param suffix? string default nil
local function AddSectionMarker(sectionGroup,num,suffix)
	if num == "##" then
		num = nil
	end
	if suffix == "##" then
		suffix = nil
	end

	local cursor_pos = r.GetCursorPosition()
	local sectionNum = (r.GetNumRegionsOrMarkers(0)+1)
	if num and suffix then
		sectionText = (sectionGroup.."_"..num..suffix)
	elseif suffix then
		sectionText = (sectionGroup.."_"..suffix)
	elseif num then
		sectionText = (sectionGroup.."_"..num)
	else
		sectionText = (sectionGroup)
	end
	-- Insert the marker on the current cursor position.
	r.AddProjectMarker2(0,false,cursor_pos,0,sectionText,sectionNum,Section_colors[sectionGroup] or Section_colors.default)

end
return AddSectionMarker