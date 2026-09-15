extends Node2D
class_name Gun

@export_group("Projétil")
@export var bullet_scene: PackedScene
@export var bullet_speed: float = 800.0
@export var bullet_damage: int = 10

@export_group("Disparo")
@export var fire_rate: float = 0.2
@export var spawn_distance: float = 40.0

@onready var muzzle: Marker2D = $"Muzzle (marker2D)"

var _can_fire: bool = true

func configure(new_fire_rate: float, new_bullet_speed: float, new_bullet_damage: int) -> void:
	fire_rate = new_fire_rate
	bullet_speed = new_bullet_speed
	bullet_damage = new_bullet_damage

func fire() -> void:
	if not _can_fire or bullet_scene == null:
		return

	var direction := (get_global_mouse_position() - global_position).normalized()
	if direction == Vector2.ZERO:
		return

	var bullet := bullet_scene.instantiate() as Bullet
	if bullet == null:
		push_warning("A cena configurada em Gun não é um Bullet.")
		return

	_can_fire = false
	bullet.global_position = muzzle.global_position + direction * spawn_distance
	bullet.direction = direction
	bullet.speed = bullet_speed
	bullet.damage = bullet_damage
	get_tree().current_scene.add_child(bullet)

	await get_tree().create_timer(fire_rate, false).timeout
	_can_fire = true
