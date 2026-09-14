extends SubViewportContainer

@export_file("*.tscn") var stage_path: String
@export var world_size := Vector2(1080.0, 720.0)

@onready var viewport: SubViewport = $SubViewport
@onready var preview_world: Node2D = $SubViewport/PreviewWorld

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_load_stage_visuals()
	_fit_preview()
	resized.connect(_fit_preview)

func _load_stage_visuals() -> void:
	if stage_path.is_empty():
		return

	var packed_scene := load(stage_path) as PackedScene
	if packed_scene == null:
		push_warning("Não foi possível carregar a fase para preview: %s" % stage_path)
		return

	var stage := packed_scene.instantiate()
	var background := stage.get_node_or_null("Background")
	var tiles := stage.get_node_or_null("BackgroundTiles")

	if background != null:
		stage.remove_child(background)
		background.set_script(null)
		preview_world.add_child(background)

	if tiles != null:
		stage.remove_child(tiles)
		tiles.set_script(null)
		preview_world.add_child(tiles)

	stage.free()

func _fit_preview() -> void:
	if viewport == null or preview_world == null or size.x <= 0.0 or size.y <= 0.0:
		return

	viewport.size = Vector2i(maxi(1, roundi(size.x)), maxi(1, roundi(size.y)))
	var preview_size := Vector2(viewport.size)
	var scale_factor := maxf(preview_size.x / world_size.x, preview_size.y / world_size.y)
	preview_world.scale = Vector2.ONE * scale_factor
	preview_world.position = (preview_size - world_size * scale_factor) * 0.5
