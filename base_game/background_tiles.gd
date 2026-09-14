@tool
extends TileMapLayer

const TILE_SIZE := Vector2i(32, 32)
const SOURCE_ID := 0
const ATLAS_TEXTURE := preload("res://art/scifitiles-sheet.png")

func _ready() -> void:
	_build_tileset()

func _build_tileset() -> void:
	var new_tile_set := TileSet.new()
	new_tile_set.tile_size = TILE_SIZE
	var atlas := TileSetAtlasSource.new()
	atlas.texture = ATLAS_TEXTURE
	atlas.texture_region_size = TILE_SIZE
	for y in range(6):
		for x in range(14):
			atlas.create_tile(Vector2i(x, y))
	new_tile_set.add_source(atlas, SOURCE_ID)
	tile_set = new_tile_set
