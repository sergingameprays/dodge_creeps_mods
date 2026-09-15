extends Node2D
class_name Character

signal died

@export var max_health: int = 100

@onready var health_component: HealthComponent = $HealthComponent

func _ready() -> void:
	_sync_max_health()

func take_damage(amount: int) -> void:
	health_component.take_damage(amount)

func heal(amount: int) -> void:
	health_component.heal(amount)

func is_full_health() -> bool:
	return health_component.is_full()

func reset() -> void:
	_sync_max_health()

func _sync_max_health() -> void:
	health_component.max_health = max_health
	health_component.reset()

func _on_died() -> void:
	died.emit()
