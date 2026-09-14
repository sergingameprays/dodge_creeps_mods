extends Node2D

var time := 0.0
var stars_origin := Vector2.ZERO
var far_planets_origin := Vector2.ZERO
var big_planet_origin := Vector2.ZERO
var ring_planet_origin := Vector2.ZERO

func _ready() -> void:
	stars_origin = $Stars.position
	far_planets_origin = $FarPlanets.position
	big_planet_origin = $BigPlanet.position
	ring_planet_origin = $RingPlanet.position
	$UI/Menu/NewGame.grab_focus()

func _process(delta: float) -> void:
	time += delta
	$Stars.position = stars_origin + Vector2(sin(time * 0.20) * 18.0, cos(time * 0.16) * 5.0)
	$FarPlanets.position = far_planets_origin + Vector2(sin(time * 0.11) * 8.0, cos(time * 0.13) * 3.0)
	$BigPlanet.position = big_planet_origin + Vector2(sin(time * 0.16) * 5.0, sin(time * 0.32) * 8.0)
	$RingPlanet.position = ring_planet_origin + Vector2(cos(time * 0.14) * 6.0, sin(time * 0.27 + 1.2) * 10.0)

func _on_new_game_pressed() -> void:
	get_tree().change_scene_to_file("res://base_game/stage_select.tscn")

func _on_settings_pressed() -> void:
	pass

func _on_quit_pressed() -> void:
	get_tree().quit()
