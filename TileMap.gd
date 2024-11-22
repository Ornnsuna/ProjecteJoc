extends TileMap

func _ready():
	
	var tile_set = tile_set
	var tile_ids = []
	
	if tile_set:

		for id in tile_set.get_tiles_ids():
			tile_ids.append(id)  

