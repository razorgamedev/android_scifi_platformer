local assets = {}

function addAsset(asset, id)
	assert(assets[id] == nil, "ERROR::ASSETS the asset "..id.." already exists!")
	assets[id] = asset
	return asset
end

function getAsset(id)
	return assets[id]
end
