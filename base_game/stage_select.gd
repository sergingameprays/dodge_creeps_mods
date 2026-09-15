extends Node2D

const STAGE_PREVIEW_SCENE := preload("res://base_game/stage_preview.tscn")
const MAIN_MENU_SCENE := "res://base_game/menu.tscn"

@onready var stars: Sprite2D = $Stars
@onready var far_planets: Sprite2D = $FarPlanets
@onready var big_planet: Sprite2D = $BigPlanet
@onready var ring_planet: Sprite2D = $RingPlanet
@onready var stage_6_button: Button = $UI/StageGrid/Stage6
@onready var stage_6_black_preview: ColorRect = $UI/StageGrid/Stage6/BlackPreview
@onready var stage_6_question: Label = $UI/StageGrid/Stage6/Question

var _stage_paths := {
	1: "res://base_game/stages/stage_1.tscn",
	2: "res://base_game/stages/stage_2.tscn",
	3: "res://base_game/stages/stage_3.tscn",
	4: "res://base_game/stages/stage_4.tscn",
	5: "res://base_game/stages/stage_5.tscn",
}

var _animation_time: float = 0.0
var _stars_origin := Vector2.ZERO
var _far_planets_origin := Vector2.ZERO
var _big_planet_origin := Vector2.ZERO
var _ring_planet_origin := Vector2.ZERO

func _ready() -> void:
	_cache_background_positions()
	$UI/StageGrid/Stage1.grab_focus()

func _process(delta: float) -> void:
	_animation_time += delta
	_animate_background()

func _cache_background_positions() -> void:
	_stars_origin = stars.position
	_far_planets_origin = far_planets.position
	_big_planet_origin = big_planet.position
	_ring_planet_origin = ring_planet.position

func _animate_background() -> void:
	stars.position = _stars_origin + Vector2(sin(_animation_time * 0.20) * 18.0, cos(_animation_time * 0.16) * 5.0)
	far_planets.position = _far_planets_origin + Vector2(sin(_animation_time * 0.11) * 8.0, cos(_animation_time * 0.13) * 3.0)
	big_planet.position = _big_planet_origin + Vector2(sin(_animation_time * 0.16) * 5.0, sin(_animation_time * 0.32) * 8.0)
	ring_planet.position = _ring_planet_origin + Vector2(cos(_animation_time * 0.14) * 6.0, sin(_animation_time * 0.27 + 1.2) * 10.0)

func _open_stage(stage_number: int) -> void:
	var scene_path: String = _stage_paths.get(stage_number, "")
	if scene_path.is_empty():
		return
	get_tree().change_scene_to_file(scene_path)

# Esta função deixa a futura Fase 6 simples de integrar: crie a cena e chame
# _unlock_stage_6("res://base_game/stages/stage_6.tscn").
func _unlock_stage_6(scene_path: String) -> void:
	if not ResourceLoader.exists(scene_path):
		push_warning("A cena da Fase 6 ainda não existe: %s" % scene_path)
		return

	_stage_paths[6] = scene_path
	stage_6_button.disabled = false
	stage_6_button.focus_mode = Control.FOCUS_ALL
	stage_6_black_preview.hide()
	stage_6_question.hide()

	var preview := STAGE_PREVIEW_SCENE.instantiate() as StagePreview
	stage_6_button.add_child(preview)
	preview.position = Vector2(12.0, 12.0)
	preview.size = Vector2(266.0, 119.0)
	stage_6_button.move_child(preview, 0)
	preview.load_stage(scene_path)

func _on_stage_1_pressed() -> void:
	_open_stage(1)

func _on_stage_2_pressed() -> void:
	_open_stage(2)

func _on_stage_3_pressed() -> void:
	_open_stage(3)

func _on_stage_4_pressed() -> void:
	_open_stage(4)

func _on_stage_5_pressed() -> void:
	_open_stage(5)

func _on_stage_6_pressed() -> void:
	_open_stage(6)

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file(MAIN_MENU_SCENE)
