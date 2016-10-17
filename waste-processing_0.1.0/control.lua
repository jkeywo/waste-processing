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
    for _, _fluid_box in event.entity.fluidbox do
      _fluids = _fluids + _fluid_box.amount
    end
  end
  return _fluids
end

local function create_polution_at( position, surface, amount )
  -- immediatey create some air pollution
  surface.pollute(position, amount * Config.air_pollution_ratio)

  -- find some unpolluted ground to contaminate
  local _new_tiles = {}
  position = Tile.from_position(position)
  while amount > 0.0 do
    local _tile = surface.get_tile(position.x, position.y)
    if _tile.name ~= "waste" and not _tile.collides_with("water-tile") then
      table.insert( _new_tiles, { name = "waste", position = position } )
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
    end
    list_initialised = true
  end
  
  if (event.tick % Time.SECOND) ~= 0 then
    return
  end
  
  -- for each waste processor
  for _, _entity in pairs(entity_list) do
    if _entity.valid then
      local _existing_pollution = Entity.get_data(_entity) or 0.0
      _existing_pollution = _existing_pollution + _entity.get_item_count() * Config.item_polution.managed
      _entity.get_inventory(defines.inventory.chest).clear()
      if _existing_pollution >= 1.0 then
        create_polution_at( _entity.position, _entity.surface, math.floor(_existing_pollution) )
        _existing_pollution = _existing_pollution - math.floor(_existing_pollution)
      end
      Entity.set_data(_entity, _existing_pollution)
    end
  end
end)

Event.register( { defines.events.on_built_entity, defines.events.on_robot_built_entity }, function(event)
  -- add waste box to list
  if event.created_entity.name == "waste-processor" then
    table.insert( entity_list, event.created_entity )
  end
end)

Event.register(defines.events.on_entity_died, function(event)
  -- create unmanaged polution
  local _polution = math.ceil( event.entity.get_item_count() * Config.item_polution.unmanaged )
  local _fluids = count_fluids( event.entity )
  if _fluids > 0.0 then
    _polution = _polution + math.ceil( _fluids * Config.fluid_polution.unmanaged )
  end
  create_polution_at( event.entity.position, event.entity.surface, _polution )
end)

Event.register( { defines.events.on_entity_died, defines.events.on_entity_died }, function(event)
  -- create unmanaged polution on mining fluid boxes
  local _fluids = count_fluids( event.entity )
  if _fluids > 0.0 then
    create_polution_at( event.entity.position, event.entity.surface, math.ceil( _fluids * Config.fluid_polution.unmanaged ) )
  end
end)
