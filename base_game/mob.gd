@tool
extends RigidBody2D
class_name Enemy

signal points_conquered(amount: int)

@export_group("Identificação")
@export var enemy_name: String = "Inimigo"

@export_group("Visual")
@export var sprite_texture: Texture2D:
	set(value):
		sprite_texture = value
		_refresh_visual_preview()
@export_range(0.1, 5.0, 0.1) var sprite_scale: float = 1.6:
	set(value):
		sprite_scale = value
		_refresh_visual_preview()
@export_range(-360.0, 360.0, 1.0) var sprite_rotation_degrees: float = 90.0:
	set(value):
		sprite_rotation_degrees = value
		_refresh_visual_preview()

@export_group("Atributos")
@export var max_health: int = 100
@export var damage: int = 40
@export var point_value: int = 1

@export_group("Movimento")
@export var minimum_speed: float = 150.0
@export var maximum_speed: float = 250.0

@export_group("Colisão")
@export_range(1.0, 128.0, 1.0) var collision_radius: float = 26.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var character: Character = $Character

func _ready() -> void:
	_apply_visual_settings()
	if Engine.is_editor_hint():
		return
	_apply_gameplay_settings()

func get_spawn_speed() -> float:
	var low := minf(minimum_speed, maximum_speed)
	var high := maxf(minimum_speed, maximum_speed)
	return randf_range(low, high)

func take_damage(amount: int) -> void:
	character.take_damage(amount)

func _apply_visual_settings() -> void:
	if sprite_texture != null:
		sprite.texture = sprite_texture
	sprite.scale = Vector2.ONE * sprite_scale
	sprite.rotation = deg_to_rad(sprite_rotation_degrees)

func _apply_gameplay_settings() -> void:
	character.max_health = max_health
	character.reset()

	var circle := collision_shape.shape as CircleShape2D
	if circle != null:
		collision_shape.shape = circle.duplicate()
		(collision_shape.shape as CircleShape2D).radius = collision_radius

func _refresh_visual_preview() -> void:
	if not is_inside_tree():
		return
	var sprite_node := get_node_or_null("Sprite2D") as Sprite2D
	if sprite_node == null:
		return
	if sprite_texture != null:
		sprite_node.texture = sprite_texture
	sprite_node.scale = Vector2.ONE * sprite_scale
	sprite_node.rotation = deg_to_rad(sprite_rotation_degrees)

func _on_character_died() -> void:
	points_conquered.emit(point_value)
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
