AMSTrailer = {}
AMSTrailer.Trailers = {
	['trailers'] = { x = 0.0, y = -7.8, z = -1.0, rx = 0.0, ry = 0.0, rz = 0.0 }, -- [nom de spawn de la remorque] = 3 premières valeurs = position, 3 dernière valeurs = Rotation
	['trailers2'] = { x = 0.0, y = -7.5, z = -1.0, rx = 0.0, ry = 0.0, rz = 0.0 },
	['docktrailer'] = { x = 0.0, y = -8.6, z = 0.5, rx = 0.0, ry = 0.0, rz = 0.0 }
}
--NE PAS TOUCHER--------
isAttached2 = false
attachedEntity2 = nil
local xoff = 0.0
local yoff = 0.0
local zoff = 0.0
local rxoff = 0.0
local ryoff = 0.0
local rzoff = 0.0
--NE PAS TOUCHER--------
CreateThread(function()
	while true do
		Wait(0)
		if IsControlJustPressed(0, 38) then -- E pour attacher/détacher
			if isAttached2 then -- Si le forklift est attaché
				local GotTrailer, TrailerHandle = GetVehicleTrailerVehicle(GetVehiclePedIsIn(PlayerPedId(), false))
				DetachEntity(attachedEntity2, true, true)
				local newVehiclesCoordsF = GetOffsetFromEntityInWorldCoords(TrailerHandle, 0.0, -10.0, 0.0)
				SetEntityCoords(attachedEntity2, newVehiclesCoordsF["x"], newVehiclesCoordsF["y"],
					newVehiclesCoordsF["z"], 1, 0, 0, 1)
				SetVehicleOnGroundProperly(attachedEntity2)

				attachedEntity2 = nil
				isAttached2 = false
			else -- Si le forklift n'est pas attaché
				-- Get si le forklift existe
				local pos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, -15.0, 0.0)
				local veh = GetClosestVehicle(pos, 10.001, 0x58E49664, 70)

				-- Si il existe
				if veh ~= 0 and IsPedInAnyVehicle(PlayerPedId(), false) then
					-- check si le joueur est dans un camion avec une remorque
					local GotTrailer, TrailerHandle = GetVehicleTrailerVehicle(GetVehiclePedIsIn(PlayerPedId(), false))
					if GotTrailer and isThisATrailer(TrailerHandle) then
						isAttached2 = true
						show2 = false
						attachedEntity2 = veh

						-- attacher le forklift à la remorque selon les offsets défini dans le config AMSTrailer.Trailers
						AttachEntityToEntity(veh, TrailerHandle, GetEntityBoneIndexByName(TrailerHandle, 'bodyshell'),
							0.0 + xoff, 0.0 + yoff,
							0.0 + zoff, 0.0 + rxoff, 0.0 + ryoff, 0.0 + rzoff, false, false, false, false, 2, true)
					end
				end
			end
		end
	end
end)
--- NE PAS TOUCHER
function isThisATrailer(trailer)
	local isValid = false
	for model, posOffset in pairs(AMS.Trailers) do
		if IsVehicleModel(trailer, model) then
			xoff = posOffset.x
			yoff = posOffset.y
			zoff = posOffset.z
			rxoff = posOffset.rx
			ryoff = posOffset.ry
			rzoff = posOffset.rz
			isValid = true
			break
		end
	end
	return isValid
end
--- NE PAS TOUCHER