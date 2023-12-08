local game = remodel.readPlaceFile(".remodel/Assets.rbxl") -- Do whatever you need to read this file

local function clearTextures(model)
	for _, instance in ipairs(model:GetDescendants()) do
		if instance.ClassName == "Texture" then
			instance:Destroy()
		end
	end
end

local function prepareInstance(instance)
	if instance.ClassName == "Model" then
		clearTextures(instance)
	end

	return instance
end

local function populateAssetsWithInstances(folder, assets, path)
	path = path or (folder.Name .. "/")

	for _, v in folder:GetChildren() do
		if not string.find(v.Name, "_RemodelIgnore") then
			if v.ClassName == "Folder" then
				local newPath = path .. v.Name .. "/"
				if not pcall(remodel.isDir, "src/" .. newPath) then
					local explorerPath = newPath:gsub("/", "."):sub(1, -2)
					error(
						"Found a folder 'game.Workspace."
							.. explorerPath
							.. "', but a directory 'src/"
							.. newPath
							.. "' does not exist. If you are modifying the Asset place, make sure the DataModel reflects the project's architecture."
					)
				else
					populateAssetsWithInstances(v, assets, newPath)
				end
			else
				local newPath = "src/" .. path .. v.Name
				assets.files[newPath] = prepareInstance(v)
			end
		end
	end

	return assets
end

local function removeDescendantInstances(dir)
	for k, v in remodel.readDir(dir) do
		local newPath = dir .. v
		if remodel.isDir(newPath) then
			if string.find(v, "_REMODEL") then
				print("\tREMOVING DIRECTORY " .. newPath)
				remodel.removeDir(newPath .. "/")
			else
				removeDescendantInstances(newPath .. "/")
			end
		elseif string.find(v, "_REMODEL") or string.find(v, ".rbxm") or string.find(v, ".rbxmx") then
			print("\tREMOVING FILE " .. newPath)
			remodel.removeFile(newPath)
		end
	end
end

local function addDescendantInstances(assets)
	for _, dir in ipairs(assets.directories) do
		print("\tADDING DIRECTORY " .. dir)
		remodel.createDirAll(dir)
	end

	for path, instance in pairs(assets.files) do
		print("\tADDING FILE " .. path .. ".rbxm")
		remodel.writeModelFile(path .. ".rbxm", instance)
	end
end

-- Actual logic now

local assets = {
	directories = {},
	files = {},
}

for _, name in ipairs({
	"ReplicatedStorage",
	"ServerScriptService",
	"ServerStorage",
	"ReplicatedFirst",
	"StarterGui",
	"StarterPack",
}) do
	if pcall(remodel.isDir, "src/" .. name .. "/") then
		local service = game.Workspace:FindFirstChild(name)
		if service then
			populateAssetsWithInstances(service, assets)
		else
			error("There is no folder named 'game.Workspace." .. name .. "'")
		end
	else
		error("There is no directory named 'src/" .. name .. "/'")
	end
end

if not next(assets.files) then
	error("Unable to find any assets, most likely because there are no service folders under game.Workspace")
end

removeDescendantInstances("src/")

addDescendantInstances(assets)