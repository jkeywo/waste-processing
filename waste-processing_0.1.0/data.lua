data:extend({
  -- polluted tile
  {
    type = "tile",
    name = "waste",
    collision_mask = {"ground-tile"},
    layer = 35,
    variants =
    {
      main =
      {
        {
          picture = "__waste-processing__/graphics/terrain/waste1.png",
          count = 16,
          size = 1
        },
        {
          picture = "__waste-processing__/graphics/terrain/waste2.png",
          count = 16,
          size = 2,
          probability = 0.39,
          weights = {0.025, 0.010, 0.013, 0.025, 0.025, 0.100, 0.100, 0.005, 0.010, 0.010, 0.005, 0.005, 0.001, 0.015, 0.020, 0.020}
        },
        {
          picture = "__waste-processing__/graphics/terrain/waste4.png",
          count = 22,
          line_length = 11,
          size = 4,
          probability = 1,
          weights = {0.090, 0.125, 0.125, 0.125, 0.125, 0.125, 0.125, 0.025, 0.125, 0.005, 0.010, 0.100, 0.100, 0.010, 0.020, 0.020, 0.010, 0.100, 0.025, 0.100, 0.100, 0.100}
        },
      },
      inner_corner =
      {
        picture = "__waste-processing__/graphics/terrain/waste-inner-corner.png",
        count = 8
      },
      outer_corner =
      {
        picture = "__waste-processing__/graphics/terrain/waste-outer-corner.png",
        count = 8
      },
      side =
      {
        picture = "__waste-processing__/graphics/terrain/waste-side.png",
        count = 8
      }
    },
    walking_sound =
    {
      {
        filename = "__base__/sound/walking/sand-01.ogg",
        volume = 0.8
      },
      {
        filename = "__base__/sound/walking/sand-02.ogg",
        volume = 0.8
      },
      {
        filename = "__base__/sound/walking/sand-03.ogg",
        volume = 0.8
      },
      {
        filename = "__base__/sound/walking/sand-04.ogg",
        volume = 0.8
      }
    },
    map_color={r=160, g=160, b=54},
    ageing=-0.00025,
    vehicle_friction_modifier = 1.8
  },
  {
    type = "tile",
    name = "waste-water",
    collision_mask =
    {
      "water-tile",
      "resource-layer",
      "item-layer",
      "player-layer",
      "doodad-layer"
    },
    layer = 45,
    variants =
    {
      main =
      {
        {
          picture = "__base__/graphics/terrain/deepwater-green/deepwater-green1.png",
          count = 8,
          size = 1
        },
        {
          picture = "__base__/graphics/terrain/deepwater-green/deepwater-green2.png",
          count = 8,
          size = 2
        },
        {
          picture = "__base__/graphics/terrain/deepwater-green/deepwater-green4.png",
          count = 6,
          size = 4
        }
      },
      inner_corner =
      {
        picture = "__base__/graphics/terrain/deepwater-green/deepwater-green-inner-corner.png",
        count = 6
      },
      outer_corner =
      {
        picture = "__base__/graphics/terrain/deepwater-green/deepwater-green-outer-corner.png",
        count = 6
      },
      side =
      {
        picture = "__base__/graphics/terrain/deepwater-green/deepwater-green-side.png",
        count = 8
      }
    },
    map_color={r=0.0941, g=0.2823, b=0.345},
    ageing=0.0006
  },
  -- technology
  {
    type = "technology",
    name = "waste-processor",
    icon = "__base__/graphics/technology/automation.png",
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "waste-processor"
      },
      {
        type = "unlock-recipe",
        recipe = "waste-liquid-processor"
      }
    },
    prerequisites = {"automation"},
    unit =
    {
      count = 10,
      ingredients = {
        {"science-pack-1", 1},
        {"science-pack-2", 1}
      },
      time = 10
    },
    order = "a-b-a",
  },
  -- waste-processor
  {
    type = "item",
    name = "waste-processor",
    icon = "__waste-processing__/graphics/icons/waste-processor.png",
    flags = {"goes-to-quickbar"},
    subgroup = "production-machine",
    order = "c[waste-processor]",
    place_result = "waste-processor",
    stack_size = 10
  },
  {
    type = "recipe",
    name = "waste-processor",
    enabled = false,
    ingredients =
    {
      {"iron-plate", 9},
      {"electronic-circuit", 3},
      {"iron-gear-wheel", 5}
    },
    result = "waste-processor"
  },
  {
    type = "container",
    name = "waste-processor",
    icon = "__waste-processing__/graphics/icons/waste-processor.png",
    flags = {"placeable-neutral", "player-creation"},
    minable = {mining_time = 1, result = "waste-processor"},
    max_health = 250,
    corpse = "big-remnants",
    dying_explosion = "medium-explosion",
    open_sound = { filename = "__base__/sound/metallic-chest-open.ogg", volume=0.65 },
    close_sound = { filename = "__base__/sound/metallic-chest-close.ogg", volume = 0.7 },
    resistances =
    {
      {
        type = "fire",
        percent = 80
      }
    },
    collision_box = {{-1.2, -1.2}, {1.2, 1.2}},
    selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
    inventory_size = 1,
    vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
    picture =
    {
      filename = "__waste-processing__/graphics/entity/waste-processor.png",
      priority = "extra-high",
      width = 102,
      height = 102,
      shift = {0.4, -0.06}
    }
  },
  -- waste liquid processor
  {
    type = "item",
    name = "waste-liquid-processor",
    icon = "__waste-processing__/graphics/icons/waste-liquid-processor.png",
    flags = {"goes-to-quickbar"},
    subgroup = "production-machine",
    order = "d[waste-liquid-processor]",
    place_result = "waste-liquid-processor",
    stack_size = 10
  },
  {
    type = "recipe",
    name = "waste-liquid-processor",
    enabled = false,
    ingredients =
    {
      {"iron-plate", 9},
      {"electronic-circuit", 3},
      {"iron-gear-wheel", 5}
    },
    result = "waste-liquid-processor"
  },
  {
		type = "offshore-pump",
		name = "waste-liquid-processor",
		icon = "__waste-processing__/graphics/icons/waste-liquid-processor.png",
		flags = { "placeable-neutral", "player-creation", "filter-directions" },
		minable = { mining_time = 1, result = "waste-liquid-processor" },
		max_health = 80,
		corpse = "small-remnants",
		fluid = "water",
		resistances = {
			{
				type = "fire",
				percent = 70
			}
		},
		collision_box = { { -0.6, -0.3 }, { 0.6, 0.3 } },
		selection_box = { { -1, -1.49 }, { 1, 0.49 } },
		fluid_box = {
			base_area = 1,
			pipe_covers = pipecoverspictures(),
			pipe_connections = {
				{ position = { 0, 1 } },
			},
		},
		pumping_speed = 0,
		tile_width = 1,
		picture = {
			north = {
				filename = "__waste-processing__/graphics/entity/waste-liquid-processor.png",
				priority = "high",
				shift = { 0.9, 0.05 },
				y = 18,
				width = 160,
				height = 102
			},
			east = {
				filename = "__waste-processing__/graphics/entity/waste-liquid-processor.png",
				priority = "high",
				shift = { 0.9, 0.05 },
				x = 160,
				y = 18,
				width = 160,
				height = 102
			},
			south = {
				filename = "__waste-processing__/graphics/entity/waste-liquid-processor.png",
				priority = "high",
				shift = { 0.509375, 0.65 },
				x = 320,
				width = 135,
				height = 138
			},
			west = {
				filename = "__waste-processing__/graphics/entity/waste-liquid-processor.png",
				priority = "high",
				shift = { 0.609375, 0.05 },
				x = 455,
				y = 18,
				width = 185,
				height = 102
			}
		}
	},
})