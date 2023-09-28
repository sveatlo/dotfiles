return {
	{
		"tamton-aquib/duck.nvim",
		enabled = true,
        -- stylua: ignore
		keys = {
			{ "<leader>zd", function() require("duck").hatch() end, desc = "Duck Hatch" },
			{ "<leader>zD", function() require("duck").cook() end, desc = "Duck Cook" },
		},
	},
	{
		"folke/drop.nvim",
		enabled = false,
		event = "VeryLazy",
		opts = function()
			math.randomseed(os.time())
			local theme = ({ "leaves", "snow", "stars", "xmas", "spring", "summer" })[math.random(1, 6)]
			return {
				max = 80, -- maximum number of drops on the screen
				interval = 150, -- every 150ms we update the drops
				screensaver = 1000 * 60 * 5, -- 5 minutes
				theme = theme,
			}
		end,
	},
	{
		"giusgad/pets.nvim",
		enabled = true,
		cmd = {
			"PetsNew",
			"PetsNewCustom",
			"PetsList",
			"PetsKill",
			"PetsKillAll",
			"PetsRemove",
			"PetsRemoveAll",
			"PetsPauseToggle",
			"PetsHideToggle",
			"PetsIdleToggle",
			"PetsSleepToggle",
		},
		requires = {
			"giusgad/hologram.nvim",
			"MunifTanjim/nui.nvim",
		},
	},
}
