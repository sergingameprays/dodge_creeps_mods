extends Node2D

var time := 0.0
var stars_origin := Vector2.ZERO
var far_planets_origin := Vector2.ZERO
var big_planet_origin := Vector2.ZERO
var ring_planet_origin := Vector2.ZERO

const STAGES := {
	1: "res://base_game/stages/stage_1.tscn",
	2: "res://base_game/stages/stage_2.tscn",
	3: "res://base_game/stages/stage_3.tscn",
	4: "res://base_game/stages/stage_4.tscn",
	5: "res://base_game/stages/stage_5.tscn",
}

func _ready() -> void:
	stars_origin = $Stars.position
	far_planets_origin = $FarPlanets.position
	big_planet_origin = $BigPlanet.position
	ring_planet_origin = $RingPlanet.position
	$UI/StageGrid/Stage1.grab_focus()

func _process(delta: float) -> void:
	time += delta
	$Stars.position = stars_origin + Vector2(sin(time * 0.20) * 18.0, cos(time * 0.16) * 5.0)
	$FarPlanets.position = far_planets_origin + Vector2(sin(time * 0.11) * 8.0, cos(time * 0.13) * 3.0)
	$BigPlanet.position = big_planet_origin + Vector2(sin(time * 0.16) * 5.0, sin(time * 0.32) * 8.0)
	$RingPlanet.position = ring_planet_origin + Vector2(cos(time * 0.14) * 6.0, sin(time * 0.27 + 1.2) * 10.0)

func _open_stage(stage_number: int) -> void:
	var scene_path: String = STAGES.get(stage_number, "")
	if scene_path.is_empty():
		return
	get_tree().change_scene_to_file(scene_path)

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

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://base_game/menu.tscn")
