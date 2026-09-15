@tool
extends TileMapLayer

const TILE_SIZE := Vector2i(32, 32)
const SOURCE_ID := 0
const ATLAS_COLUMNS := 14
const ATLAS_ROWS := 6
const ATLAS_TEXTURE := preload("res://art/scifitiles-sheet.png")

func _ready() -> void:
	_build_tileset()

func _build_tileset() -> void:
	var generated_tileset := TileSet.new()
	generated_tileset.tile_size = TILE_SIZE

	var atlas := TileSetAtlasSource.new()
	atlas.texture = ATLAS_TEXTURE
	atlas.texture_region_size = TILE_SIZE

	for y in range(ATLAS_ROWS):
		for x in range(ATLAS_COLUMNS):
			atlas.create_tile(Vector2i(x, y))

	generated_tileset.add_source(atlas, SOURCE_ID)
	tile_set = generated_tileset
