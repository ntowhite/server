local config = {
pos = {x=1074, y=523, z=7}, -- posição que será teleportado
tempo = 7, -- tempo pra voltar
effect1 = 75, -- efeito ao ser teleportado
effect2 = 75, -- efeito ao voltar
storage = 19329, -- storage que fica guardado o cooldown
from = {x=1068, y=518, z=7}, --- quina do kamui (pra impedir players de usarem o kamui dentro do kamui)
to = {x=1081, y=529, z=7}, --- quina do kamui (pra impedir players de usarem o kamui dentro do kamui)
cooldown = 120, --- tempo entre um uso e outro (após usar a spell vc vai ficar X segundos sem poder usar ela novamente)
msg = "Tzukuyomi Out!" -- mensagem ao sair do kamui
}


local exceptions = {'training monk', 'gamabunta', 'elite anbu', 'sasori', 'deidara', 'kisame', 'itachi', 'hidan', 'kakuzu'} --- nome das criaturas que não poderão ser levadas pro kamui (sempre em minúsculo e entre aspas)


function canEffect(pos, pz, proj) -- Night Wolf based on Nord
if getTileThingByPos({x = pos.x, y = pos.y, z = pos.z, stackpos = 0}).itemid == 0 then return false end
if getTilePzInfo(pos) and not pz then return false end
local n = not proj and 3 or 2
for i = 0, 255 do
pos.stackpos = i
local tile = getTileThingByPos(pos)
if tile.itemid ~= 0 and not isCreature(tile.uid) then
if hasProperty(tile.uid, n) or hasProperty(tile.uid, 7) then
return false
end
end
end
return true
end




function onCastSpell(cid, var)
local pos = getPlayerPosition(cid)


if isInRange(pos, config.from, config.to) then
doPlayerSendCancel(cid, "You cannot use Tsukuyomi spell inside the Tsukuyomi!")
return false
end


if os.time() - getPlayerStorageValue(cid, config.storage) >= config.cooldown then
doPlayerSetStorageValue(cid, config.storage, os.time())
if isCreature(getCreatureTarget(cid)) then
target = getCreatureTarget(cid)
for i = 1, #exceptions do
if getCreatureName(target):lower() == exceptions[i] then
doPlayerSendCancel(cid, "You can't take ".. getCreatureName(target) .." to Tsukuyomi.")
return false
end
end
--------------- PLAYER-----------
addEvent(doTeleportThing, 1000*config.tempo, cid, pos, true)
addEvent(doCreatureSay, 1000*config.tempo, cid, config.msg, 20, false)
addEvent(doSendMagicEffect, 1000*config.tempo, pos, config.effect2)
doSendMagicEffect(pos, config.effect1)
doTeleportThing(cid, config.pos)
-------------------- OPONENTE ----------------
addEvent(doTeleportThing, 1000*config.tempo, target, getThingPos(target), true)
addEvent(doSendMagicEffect, 1000*config.tempo, getThingPos(target), config.effect2)
doSendMagicEffect(getThingPos(target), config.effect1)
doTeleportThing(target, config.pos)
-------------------------------------
if isPlayer(target) and isCreature(cid) then
doPlayerSendTextMessage(target, 27, "You were teleported by ".. getCreatureName(cid) ..".")
end
if isPlayer(cid) and isCreature(target) then
doPlayerSendTextMessage(cid, 27, "You teleported ".. getCreatureName(target) .."!")
end
for i = 1,config.tempo  do
addEvent(function()
if isPlayer(target) then
doPlayerSendTextMessage(target,25,"You'll be back in " .. config.tempo -i +1 .. " second(s)")
end
if isPlayer(cid) then
doPlayerSendTextMessage(cid,25,"You'll be back in " .. config.tempo -i +1 .. " second(s)")
end
end, 1000*i)
end
else
---------- levar quem tá em volta do player ---------------
local teleportPosition = {
{x = pos.x, y = pos.y - 1, z = pos.z},
{x = pos.x, y = pos.y + 1, z = pos.z},
{x = pos.x - 1, y = pos.y, z = pos.z},
{x = pos.x + 1, y = pos.y, z = pos.z},
{x = pos.x - 1, y = pos.y + 1, z = pos.z},
{x = pos.x - 1, y = pos.y - 1, z = pos.z},
{x = pos.x + 1, y = pos.y - 1, z = pos.z},
{x = pos.x + 1, y = pos.y + 1, z = pos.z}
}


local mobas = {}
local checker = 0


 for _, tPos in ipairs(teleportPosition) do
doSendMagicEffect(tPos, config.effect2)
local mob = getTopCreature(tPos).uid
    if canEffect (tPos) and mob ~= 0 and (isMonster(mob) or isPlayer(mob)) then
for i = 1, #exceptions do
if getCreatureName(mob):lower() == exceptions[i] then
checker = 1
break
end
end
if checker ~= 1 then
table.insert(mobas, mob) 
end
end
end


if #mobas > 0 then
for _, pid in ipairs(mobas) do
addEvent(doTeleportThing, 1000*config.tempo, pid, getThingPos(pid), true)
addEvent(doSendMagicEffect, 1000*config.tempo, getThingPos(pid), config.effect2)
doSendMagicEffect(getThingPos(pid), config.effect1)
doTeleportThing(pid, config.pos)
if isPlayer(pid) and isCreature(cid) then
doPlayerSendTextMessage(pid, 27, "You were teleported by ".. getCreatureName(cid) ..".")
end
for i = 1,config.tempo  do
addEvent(function()
if isPlayer(pid) then
doPlayerSendTextMessage(pid,25,"You'll be back in " .. config.tempo -i +1 .. " second(s)")
end
end, 1000*i)
end
end
end
----------------------------
addEvent(doTeleportThing, 1000*config.tempo, cid, pos, true)
addEvent(doCreatureSay, 1000*config.tempo, cid, config.msg, 20, false)
addEvent(doSendMagicEffect, 1000*config.tempo, pos, config.effect2)
doSendMagicEffect(pos, config.effect1)
doTeleportThing(cid, config.pos)
if isPlayer(cid) then
doPlayerSendTextMessage(cid, 27, "You teleported yourself.")
end
for i = 1,config.tempo do
addEvent(function()
if isPlayer(cid) then
doPlayerSendTextMessage(cid,25,"You'll be back in " .. config.tempo -i +1 .. " second(s)")
end
end, 1000*i)
end
end
else
doPlayerSendCancel(cid, "Your skill is in cooldown, you must wait "..(config.cooldown - (os.time() - getPlayerStorageValue(cid, config.storage))).." seconds.")
end
return true
end