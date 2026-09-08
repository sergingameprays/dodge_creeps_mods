extends Node2D
class_name Character

signal died
## Needs a healthComponent to works
## this script will have the basis for the player and mobs modifications

@export var max_health: int = 100

@onready var health_component: HealthComponent

func _ready() -> void:
	health_component = $HealthComponent
	health_component.max_health = max_health
	health_component.died.connect(_on_died)

func take_damage(amount: int) -> void:
	health_component.take_damage(amount)

func reset() -> void:
	health_component._ready()
	

func _on_died() -> void:
	died.emit()
