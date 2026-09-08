class_name HealthComponent
extends Node

## Add as a child node (named "HealthComponent") on anything using
## character.gd. Keeps health logic out of your movement scripts.

signal died
signal health_changed(current: int, max: int)

@export var max_health: int = 100
@onready var health_bar = ProgressBar
var current_health: int

func _ready() -> void:
	health_bar = $ProgressBar
	current_health = max_health
	health_bar.value = current_health

func take_damage(amount: int) -> void:
	if current_health <= 0:
		return
	current_health = max(current_health - amount, 0)
	health_changed.emit(current_health, max_health)
	health_bar.value = current_health
	if current_health <= 0:
		died.emit()

func heal(amount: int) -> void:
	current_health = min(current_health + amount, max_health)
	health_changed.emit(current_health, max_health)
