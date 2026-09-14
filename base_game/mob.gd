extends RigidBody2D

@onready var character: Character = $Character
@export var damage: int = 40
@export var point_value: int = 1

signal points_conquered(amount: int)

func take_damage(amount: int) -> void:
	character.take_damage(amount)

func _on_character_died() -> void:
	points_conquered.emit(point_value)
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
