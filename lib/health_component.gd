class_name HealthComponent
extends Node

signal died
signal health_changed(current: int, maximum: int)

@export var max_health: int = 100

@onready var health_bar: ProgressBar = get_node_or_null("ProgressBar") as ProgressBar

var current_health: int = 0

func _ready() -> void:
	reset()

func take_damage(amount: int) -> void:
	if current_health <= 0:
		return
	_set_health(current_health - amount)
	if current_health <= 0:
		died.emit()

func heal(amount: int) -> void:
	if current_health <= 0:
		return
	_set_health(current_health + amount)

func reset() -> void:
	_set_health(max_health)

func is_full() -> bool:
	return current_health >= max_health

func _set_health(value: int) -> void:
	current_health = clampi(value, 0, max_health)
	if health_bar != null:
		health_bar.max_value = max_health
		health_bar.value = current_health
	health_changed.emit(current_health, max_health)
