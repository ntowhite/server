	function onCastSpell(cid, var)
		local waittime = 30 -- Tempo de exhaustion
		local storage = 115818
		local shuriken = 7838
	if exhaustion.check(cid, storage) then
		doPlayerSendCancel(cid, "You are exhausted")
		return false
		end
doPlayerAddItem(cid, shuriken, 10)
exhaustion.set(cid, storage, waittime)
return true
end
	