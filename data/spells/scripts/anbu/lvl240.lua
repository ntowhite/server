local combat = createCombatObject()
setCombatParam(combat, COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
setCombatFormula(combat, COMBAT_FORMULA_LEVELMAGIC, -6.2, 1, -8.2, 1)

function onCastSpell(cid, var)
local waittime = 0.8 -- Tempo de exhaustion
local storage = 115818

if exhaustion.check(cid, storage) then
    doPlayerSendCancel(cid, "You are exhausted")
return false
end
local position1 = {x=getThingPosition(getCreatureTarget(cid)).x+1, y=getThingPosition(getCreatureTarget(cid)).y, z=getThingPosition(getCreatureTarget(cid)).z}
local target = getCreatureTarget(cid)
local pos = getCreaturePosition(target)
addEvent(doSendMagicEffect, 1, {x = pos.x+0, y = pos.y+0, z = pos.z}, 132)
addEvent(doSendMagicEffect, 1, {x = pos.x+1, y = pos.y+0, z = pos.z}, 132)
addEvent(doSendMagicEffect, 1, {x = pos.x-1, y = pos.y+0, z = pos.z}, 132)
addEvent(doSendMagicEffect, 1, {x = pos.x+0, y = pos.y+1, z = pos.z}, 132)
addEvent(doSendMagicEffect, 1, {x = pos.x+0, y = pos.y-1, z = pos.z}, 132)
addEvent(doSendMagicEffect, 50, {x = pos.x+2, y = pos.y+1, z = pos.z}, 31)
addEvent(doSendMagicEffect, 100, {x = pos.x+2, y = pos.y+1, z = pos.z}, 31)
addEvent(doSendMagicEffect, 150, {x = pos.x+2, y = pos.y+1, z = pos.z}, 31)
addEvent(doSendMagicEffect, 200, {x = pos.x+2, y = pos.y+1, z = pos.z}, 31)
exhaustion.set(cid, storage, waittime)
return doCombat(cid, combat, var)
end
