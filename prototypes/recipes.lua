--[[ BURN RECYCLING
  Adds smelting recipes to regain iron, steel and similars from outdated and non-upgradable components. Updated from vanatteveldt's original mod.

  Notes:
  * Candidates for smelting are outdated techs without change for upgrading, and furnaces (because xkcd 1821)
    - This excludes stuff like heat pipes, which never become outclassed by a straight upgrade
    - Stone furnaces are the biggest exception because you normally craft a TON of them
  * Tiered unlocking for when the recipe is relevant (game start, steel furnaces, electric furnaces)
  * For iron plates, the recipe is original plates + gears (2 in normal, 4 in expensive)
  * Copper/brick is usually discarted, usually because it's <= than the iron/steel in the recipe
    - Specially noticeable on the pistol as it's a 50/50 split... but who crafts pistols anyway? 😝
--]]

local tier0 = {}
local tier1 = {}
local tier2 = {}

local metatier = {}
function metatier.__add(f1, f2)
  f1[f2.name] = f2
  return f1
end
function metatier.__sub(f1, f2)
  f1[f2.name] = nil
  return f1
end

setmetatable(tier0, metatier)
setmetatable(tier1, metatier)
setmetatable(tier2, metatier)

-- Burner Tech
tier0 = tier0 + {
  type = "recipe",
  name = "burncycle-burner-inserter",
  category = "smelting",
  normal = {
    ingredients = {{"burner-inserter", 1}},
    energy_required = 7,
    results = {{type="item", name="iron-plate", amount=1+2*1}}
  },
  expensive = {
    ingredients = {{"burner-inserter", 1}},
    energy_required = 7,
    results = {{type="item", name="iron-plate", amount=1+4*1}}
  },
  enabled = false,
  hidden = true
} + {
  type = "recipe",
  name = "burncycle-burner-mining-drill",
  category = "smelting",
  normal = {
    ingredients = {{"burner-mining-drill", 1}},
    energy_required = 7,
    results = {{type="item", name="iron-plate", amount=3+2*3}}
  },
  expensive = {
    ingredients = {{"burner-mining-drill", 1}},
    energy_required = 7,
    results = {{type="item", name="iron-plate", amount=6+4*6}}
  },
  enabled = false,
  hidden = true
}

-- Military
tier0 = tier0 + {
  type = "recipe",
  name = "burncycle-pistol",
  category = "smelting",
  ingredients = {{"pistol", 1}},
  energy_required = 7,
  results = {{type="item", name="iron-plate", amount=5}},
  enabled = false,
  hidden = true
}

tier2 = tier2 + {
  type = "recipe",
  name = "burncycle-shotgun",
  category = "smelting",
  normal = {
    ingredients = {{"shotgun", 1}},
    energy_required = 7,
    results = {{type="item", name="iron-plate", amount=15+2*5}}
  },
  expensive = {
    ingredients = {{"shotgun", 1}},
    energy_required = 7,
    results = {{type="item", name="iron-plate", amount=15+4*5}}
  },
  enabled = false,
  hidden = true
}

-- Storage
tier1 = tier1 + {
  type = "recipe",
  name = "burncycle-iron-chest",
  category = "smelting",
  energy_required = 7,
  ingredients = {{"iron-chest", 1}},
  results = {{type="item", name="iron-plate", amount=8}},
  enabled = false,
  hidden = true
}

-- Furnaces
tier1 = tier1 + {
  type = "recipe",
  name = "burncycle-stone-furnace",
  category = "smelting",
  energy_required = 10.5,
  ingredients = {{"stone-furnace", 2}},
  results = {{type="item", name="stone-brick", amount=5}},
  enabled = false,
  hidden = true
}

tier2 = tier2 + {
  type = "recipe",
  name = "burncycle-steel-furnace",
  category = "smelting",
  energy_required = 10.5,
  ingredients = {{"steel-furnace", 1}},
  results = {{type="item", name="steel-plate", amount=6}},
  enabled = false,
  hidden = true
}

-- Mod compat
--- Bob's Furnaces
if mods.bobplates then
  if data.raw["assembling-machine"]["chemical-boiler"] then
    tier1 = tier1 + {
      type = "recipe",
      name = "burncycle-chemical-boiler",
      category = "smelting",
      energy_required = 10.5,
      ingredients = {{"chemical-boiler", 1}},
      -- we ignore the pipe here, sorry iron afficionados
      results = {{type="item", name="stone-brick", amount=5}},
      enabled = false,
      hidden = true
    }
  end

  if data.raw["assembling-machine"]["mixing-furnace"] then
    tier1 = tier1 + {
      type = "recipe",
      name = "burncycle-mixing-furnace",
      category = "smelting",
      energy_required = 10.5,
      ingredients = {{"mixing-furnace", 1}},
      results = {{type="item", name="stone-brick", amount=5}},
      enabled = false,
      hidden = true
    }
  end

  if data.raw["assembling-machine"]["chemical-steel-furnace"] then
    tier2 = tier2 + {
      type = "recipe",
      name = "burncycle-chemical-steel-furnace",
      category = "smelting",
      energy_required = 10.5,
      ingredients = {{"chemical-steel-furnace", 1}},
      -- steel pipes, 1 steel plate per pipe
      results = {{type="item", name="steel-plate", amount=6+1*5}},
      enabled = false,
      hidden = true
    }
  end

  if data.raw["assembling-machine"]["mixing-steel-furnace"] then
    tier2 = tier2 + {
      type = "recipe",
      name = "burncycle-mixing-steel-furnace",
      category = "smelting",
      energy_required = 10.5,
      ingredients = {{"mixing-steel-furnace", 1}},
      -- steel pipes, 1 steel plate per pipe
      results = {{type="item", name="steel-plate", amount=6}},
      enabled = false,
      hidden = true
    }
  end
end

for _,recipe in pairs(tier0) do
  recipe.enabled = true
  data:extend{recipe}
end

-- final setup
for k,recipe in pairs(tier1) do
  data:extend{recipe}
  recipe.enabled = false
  table.insert(data.raw["technology"]["advanced-material-processing"].effects, {type = "unlock-recipe", recipe = k})
end

for k,recipe in pairs(tier2) do
  data:extend{recipe}
  recipe.enabled = false
  table.insert(data.raw["technology"]["advanced-material-processing-2"].effects, {type = "unlock-recipe", recipe = k})
end