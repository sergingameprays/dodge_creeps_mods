extends Node
class_name Plus

@export var player: CharacterBody2D

const PRIMARY_WEAPON := 0
const ALTERNATE_WEAPON := 1

func try_dash(move_direction: Vector2, aim_direction: Vector2) -> void:
	pass

func switch_weapon() -> void:
	pass
	
func apply_weapon(index: int, emit_signal: bool = true) -> void:
	pass


func use_potion() -> void:
	pass
	
