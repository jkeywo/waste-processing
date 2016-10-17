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
          picture = "__base__/graphics/terrain/deepwater/deepwater1.png",
          count = 8,
          size = 1
        },
        {
          picture = "__base__/graphics/terrain/deepwater/deepwater2.png",
          count = 8,
          size = 2
        },
        {
          picture = "__base__/graphics/terrain/deepwater/deepwater4.png",
          count = 6,
          size = 4
        }
      },
      inner_corner =
      {
        picture = "__base__/graphics/terrain/deepwater/deepwater-inner-corner.png",
        count = 6
      },
      outer_corner =
      {
        picture = "__base__/graphics/terrain/deepwater/deepwater-outer-corner.png",
        count = 6
      },
      side =
      {
        picture = "__base__/graphics/terrain/deepwater/deepwater-side.png",
        count = 8
      }
    },
    map_color={r=0.0941, g=0.2823, b=0.345},
    ageing=0.0006
  },
  -- waste processor
  {
    type = "technology",
    name = "waste-processor",
    icon = "__base__/graphics/technology/automation.png",
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "waste-processor"
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
  {
    type = "item",
    name = "waste-processor",
    icon = "__waste-processing__/graphics/icons/waste-processor.png",
    flags = {"goes-to-quickbar"},
    subgroup = "production-machine",
    order = "c[waste-processor]",
    place_result = "waste-processor",
    stack_size = 50
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
})