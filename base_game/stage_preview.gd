extends SubViewportContainer
class_name StagePreview

@export_file("*.tscn") var stage_path: String
@export var world_size := Vector2(1080.0, 720.0)

@onready var viewport: SubViewport = $SubViewport
@onready var preview_world: Node2D = $SubViewport/PreviewWorld

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	resized.connect(_fit_preview)
	if not stage_path.is_empty():
		load_stage(stage_path)
	_fit_preview()

func load_stage(new_stage_path: String) -> void:
	stage_path = new_stage_path
	_clear_preview()

	if stage_path.is_empty():
		return
	var packed_scene := load(stage_path) as PackedScene
	if packed_scene == null:
		push_warning("Não foi possível carregar a fase para preview: %s" % stage_path)
		return

	var stage := packed_scene.instantiate()
	_copy_visual_node(stage, "Background")
	_copy_visual_node(stage, "BackgroundTiles")
	stage.free()
	_fit_preview()

func _copy_visual_node(stage: Node, node_name: String) -> void:
	var visual := stage.get_node_or_null(node_name)
	if visual == null:
		return
	stage.remove_child(visual)
	visual.set_script(null)
	preview_world.add_child(visual)

func _clear_preview() -> void:
	if preview_world == null:
		return
	for child in preview_world.get_children():
		child.queue_free()

func _fit_preview() -> void:
	if viewport == null or preview_world == null or size.x <= 0.0 or size.y <= 0.0:
		return

	viewport.size = Vector2i(maxi(1, roundi(size.x)), maxi(1, roundi(size.y)))
	var preview_size := Vector2(viewport.size)
	var scale_factor := maxf(preview_size.x / world_size.x, preview_size.y / world_size.y)
	preview_world.scale = Vector2.ONE * scale_factor
	preview_world.position = (preview_size - world_size * scale_factor) * 0.5
