require "util"
require "config"

require "stdlib.area.tile"
require "stdlib.entity.entity"
require "stdlib.event.event"
require "stdlib.time"

local list_initialised = false
local entity_list = {}

local function count_fluids( entity )
  local _fluids = 0
  if entity.fluidbox and #entity.fluidbox > 0 then
    for _, _fluid_box in pairs(entity.fluidbox) do
      _fluids = _fluids + _fluid_box.amount
    end
  end
  return _fluids
end

local function clear_fluids( _entity )
    for i = 1, #entity.fluidbox do
      local _fluid_box = entity.fluidbox[i]
      _fluid_box.amount = 0.0
      entity.fluidbox[i] = _fluid_box
    end
end

local function create_pollution_at( position, surface, amount )
  -- immediatey create some air pollution
  surface.pollute(position, amount * Config.air_pollution_ratio)

  -- find some unpolluted ground to contaminate
  local _new_tiles = {}
  position = Tile.from_position(position)
  while amount > 0.0 do
    local _tile = surface.get_tile(position.x, position.y)
    if _tile.name ~= "waste" then
      if _tile.collides_with("water-tile") then
        table.insert( _new_tiles, { name = "waste-water", position = position } )
      else
        table.insert( _new_tiles, { name = "waste", position = position } )
      end
      amount = amount - 1.0
    end
    position = Tile.adjacent(surface, position, false)[math.random(1,4)]
  end
  surface.set_tiles( _new_tiles )
end

Event.register(defines.events.on_tick, function(event)
  if not list_initialised then
    entity_list = {}
    for _, _surface in pairs(game.surfaces) do
      local _entities = _surface.find_entities_filtered({name = "waste-processor"})
      for _, _entity in pairs(_entities) do
        table.insert( entity_list, _entity )
      end
      _entities = _surface.find_entities_filtered({name = "waste-liquid-processor"})
      for _, _entity in pairs(_entities) do
        table.insert( entity_list, _entity )
      end
    end
    list_initialised = true
  end
  
  -- only continue every second
  if (event.tick % Time.SECOND) ~= 0 then
    return
  end
  
  -- for each waste processor
  for _, _entity in pairs(entity_list) do
    if _entity.valid then
      local _existing_pollution = Entity.get_data(_entity) or 0.0
      -- item pollution
      if _entity.get_item_count() > 0 then
        _existing_pollution = _existing_pollution + _entity.get_item_count() * Config.item_pollution.managed
        _entity.get_inventory(defines.inventory.chest).clear()
      end
      -- fluid pollution
      local _fluid_amount = count_fluids( _entity )
      if _fluid_amount > 0.0 then
        _existing_pollution = _existing_pollution + _fluid_amount * Config.fluid_pollution.managed
        clear_fluids( _entity )
      end
      -- apply managed pollution
      if _existing_pollution >= 1.0 then
        create_pollution_at( _entity.position, _entity.surface, math.floor(_existing_pollution) )
        _existing_pollution = _existing_pollution - math.floor(_existing_pollution)
      end
      -- set remaining pollution
      Entity.set_data(_entity, _existing_pollution)
    end
  end
end)

Event.register( { defines.events.on_built_entity, defines.events.on_robot_built_entity }, function(event)
  -- add waste box to list
  if event.created_entity.name == "waste-processor" or event.created_entity.name == "waste-liquid-processor" then
    table.insert( entity_list, event.created_entity )
  end
end)

Event.register(defines.events.on_entity_died, function(event)
  -- create unmanaged pollution
  local _pollution = math.ceil( event.entity.get_item_count() * Config.item_pollution.unmanaged )
  local _fluids = count_fluids( event.entity )
  if _fluids > 0.0 then
    _pollution = _pollution + math.ceil( _fluids * Config.fluid_pollution.unmanaged )
  end
  create_pollution_at( event.entity.position, event.entity.surface, _pollution )
end)

Event.register( { defines.events.on_preplayer_mined_item, defines.events.on_robot_pre_mined }, function(event)
  -- create unmanaged pollution on mining fluid boxes
  local _fluids = count_fluids( event.entity )
  if _fluids > 0.0 then
    create_pollution_at( event.entity.position, event.entity.surface, math.ceil( _fluids * Config.fluid_pollution.unmanaged ) )
  end
end)
