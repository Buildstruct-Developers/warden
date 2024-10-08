Warden.PermissionList = {} --these should reset when the file reloads, otherwise they accumulate keys
Warden.PermissionIDs = {}

Warden.Permissions = Warden.Permissions or {}

function Warden.CreatePermission(id, name, desc, adminLevel, worldPerm, icon, iconFallback)
	local mat
	if CLIENT then
		if icon then
			mat = Material(icon)
		end
		if iconFallback and (not icon or mat:IsError()) then
			mat = Material(iconFallback)
		end
		if (not iconFallback and not icon) or mat:IsError() then
			mat = Material("icon16/star.png")
		end
	end

	local index = table.insert(Warden.PermissionList, {
		id = id,
		name = name,
		description = desc,
		defaultAdminLevel = adminLevel,
		defaultWorldPerm = worldPerm,
		icon = mat
	})
	if index == nil then return end

	Warden.PermissionIDs[id] = index
	CreateConVar("warden_admin_level_" .. id, -1, FCVAR_REPLICATED, "Set the admin level needed for admins to override this permission.", -1, 99)
	CreateConVar("warden_world_" .. id, -1, FCVAR_REPLICATED, "Set whether the world has this permission", -1, 1)

	return index
end

function Warden.GetPermissionByID(id)
	return Warden.PermissionIDs[id]
end

function Warden.GetPermissionInfo(id)
	return Warden.PermissionList[Warden.PermissionIDs[id]]
end

Warden.PERMISSION_ALL     = Warden.CreatePermission("whitelist", "Whitelist", "Grants full permissions.", 3)
Warden.PERMISSION_PHYSGUN = Warden.CreatePermission("physgun", "Physgun", "Allows users to pickup your stuff with the physgun.", 1, nil, "bs/aegis_physgun.png", "icon16/flag_blue.png")
Warden.PERMISSION_GRAVGUN = Warden.CreatePermission("gravgun", "Gravgun", "Allows users to pickup your stuff with the gravgun.", 1, true, "bs/aegis_gravgun.png", "icon16/flag_orange.png")
Warden.PERMISSION_TOOL    = Warden.CreatePermission("tool", "Toolgun", "Allows users to use the toogun on your stuff.", 2, nil, "bs/aegis_tool.png", "icon16/cup.png")
Warden.PERMISSION_USE     = Warden.CreatePermission("use", "Use (E)", "Allows users to sit in your seats, use your wire buttons, etc.", 1, true, "bs/aegis_use.png", "icon16/mouse.png")
Warden.PERMISSION_DAMAGE  = Warden.CreatePermission("damage", "Damage", "Allows users to damage you and your stuff (excluding ACF).", 2, true, "bs/aegis_damage.png", "icon16/sport_raquet.png")

