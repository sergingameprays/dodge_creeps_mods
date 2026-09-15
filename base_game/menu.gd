extends Node2D

const STAGE_SELECT_SCENE := "res://base_game/stage_select.tscn"

@onready var stars: Sprite2D = $Stars
@onready var far_planets: Sprite2D = $FarPlanets
@onready var big_planet: Sprite2D = $BigPlanet
@onready var ring_planet: Sprite2D = $RingPlanet
@onready var new_game_button: Button = $UI/Menu/NewGame

var _animation_time: float = 0.0
var _stars_origin := Vector2.ZERO
var _far_planets_origin := Vector2.ZERO
var _big_planet_origin := Vector2.ZERO
var _ring_planet_origin := Vector2.ZERO

func _ready() -> void:
	_cache_background_positions()
	new_game_button.grab_focus()

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

func _on_new_game_pressed() -> void:
	get_tree().change_scene_to_file(STAGE_SELECT_SCENE)

func _on_settings_pressed() -> void:
	# Reservado para uma futura tela de configurações.
	pass

func _on_quit_pressed() -> void:
	get_tree().quit()
