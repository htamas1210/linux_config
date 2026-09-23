-- Input configuration

hl.config({
	input = {
		kb_layout = "hu",
		kb_options = "caps:swapescape",
		accel_profile = "flat",
		natural_scroll = false,
	},
})

hl.gesture({ fingers = 4, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 3, direction = "up", action = "fullscreen" })
