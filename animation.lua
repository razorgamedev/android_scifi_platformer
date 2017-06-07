function new_animation(id, image, frames)
	assert(id and image and frames, "ERROR:: animation requires an id an image and a list of frames")
	local anim = {
		image  = image,
		frames = frames,
		id 	   = id,
		speed  = 0.1
	}

	return anim
end
