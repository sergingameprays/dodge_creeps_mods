extends CharacterBody2D
class_name PlayerController

signal hit
signal weapon_changed(index: int)
signal dash_ready_changed(is_ready: bool)
signal potion_available_changed(is_available: bool)

const PRIMARY_WEAPON := 0
const ALTERNATE_WEAPON := 1

@export_group("Movimento")
@export var speed: float = 400.0

@export_group("Dash")
@export var dash_speed: float = 950.0
@export var dash_duration: float = 0.14
@export var dash_cooldown: float = 0.85

@export_group("Poção")
@export var potion_heal: int = 50

@export_group("Arma principal")
@export var primary_fire_rate: float = 0.2
@export var primary_bullet_speed: float = 800.0
@export var primary_bullet_damage: int = 20

@export_group("Arma alternativa")
@export var alternate_fire_rate: float = 0.2
@export var alternate_bullet_speed: float = 800.0
@export var alternate_bullet_damage: int = 20

@onready var character: Character = $Character
@onready var gun: Gun = $Gun
@onready var alt_gun_sprite: Sprite2D = $AltGun
@onready var body_collision: CollisionShape2D = $CollisionShape2D
@onready var hurtbox_collision: CollisionShape2D = $Hurtbox/CollisionShape2D
@onready var utils: Node = $Utils

var current_weapon: int = PRIMARY_WEAPON
var potion_available: bool = true

var _dash_time_left: float = 0.0
var _dash_cooldown_left: float = 0.0
var _dash_direction := Vector2.ZERO
var _dash_ready: bool = true

func _ready() -> void:
	_set_active(false)
	utils.apply_weapon(PRIMARY_WEAPON, false)

func _physics_process(delta: float) -> void:
	_update_dash_cooldown(delta)

	var move_direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var mouse_position := get_global_mouse_position()
	var aim_direction := mouse_position - global_position

	_handle_actions(move_direction, aim_direction)
	_update_movement(move_direction, delta)
	_update_aim(mouse_position, aim_direction)

func _handle_actions(move_direction: Vector2, aim_direction: Vector2) -> void:
	if not character.visible:
		return

	if Input.is_action_just_pressed("dash"):
		utils.try_dash(move_direction, aim_direction)
	if Input.is_action_just_pressed("switch_weapon"):
		utils.switch_weapon()
	if Input.is_action_just_pressed("use_potion"):
		utils.use_potion()
	if Input.is_action_just_pressed("shoot"):
		gun.fire()

func _update_movement(move_direction: Vector2, delta: float) -> void:
	if _dash_time_left > 0.0:
		_dash_time_left = maxf(_dash_time_left - delta, 0.0)
		velocity = _dash_direction * dash_speed
	else:
		velocity = move_direction * speed
	move_and_slide()

func _update_aim(mouse_position: Vector2, aim_direction: Vector2) -> void:
	if aim_direction.length_squared() <= 0.001:
		return

	# O sprite original aponta para baixo. O -PI/2 alinha essa frente ao mouse.
	rotation = aim_direction.angle() - PI / 2.0
	gun.look_at(mouse_position)


func _update_dash_cooldown(delta: float) -> void:
	if _dash_cooldown_left <= 0.0:
		return

	_dash_cooldown_left = maxf(_dash_cooldown_left - delta, 0.0)
	if _dash_cooldown_left <= 0.0 and not _dash_ready:
		_dash_ready = true
		dash_ready_changed.emit(true)

func _on_hurtbox_body_entered(body: Node2D) -> void:
	var contact_damage = body.get("damage")
	if contact_damage != null:
		character.take_damage(int(contact_damage))

func start(pos: Vector2) -> void:
	character.reset()
	position = pos
	rotation = 0.0
	_reset_items()
	_set_active(true)

	weapon_changed.emit(current_weapon)
	dash_ready_changed.emit(true)
	potion_available_changed.emit(true)

func _reset_items() -> void:
	_dash_time_left = 0.0
	_dash_cooldown_left = 0.0
	_dash_direction = Vector2.ZERO
	_dash_ready = true
	potion_available = true
	utils.apply_weapon(PRIMARY_WEAPON, false)

func _set_active(is_active: bool) -> void:
	visible = is_active
	character.visible = is_active
	body_collision.set_deferred("disabled", not is_active)
	hurtbox_collision.set_deferred("disabled", not is_active)

func _on_character_died() -> void:
	_set_active(false)
	hit.emit()
