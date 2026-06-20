require("full-border"):setup()
require("smart-enter"):setup({
	open_multi = true,
})
require("git"):setup()

Status:children_add(function()
	local h = cx.active.current.hovered
	if not h or ya.target_family() ~= "unix" then
		return ""
	end

	return ui.Line({
		ui.Span(ya.user_name(h.cha.uid) or tostring(h.cha.uid)):fg("magenta"),
		":",
		ui.Span(ya.group_name(h.cha.gid) or tostring(h.cha.gid)):fg("magenta"),
		" ",
	})
end, 500, Status.RIGHT)

Status:children_add(function()
	local h = cx.active.current.hovered
	return ui.Line({
		ui.Span(os.date("%Y-%m-%d %H:%M", tostring(h.cha.mtime):sub(1, 10))):fg("blue"),
		ui.Span(" "),
	})
end, 500, Status.RIGHT)
