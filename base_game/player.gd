extends CharacterBody2D

signal hit

@export var speed: float = 400.0

@onready var character: Character = $Character
@onready var gun: Gun = $Gun
@onready var body_collision: CollisionShape2D = $CollisionShape2D
@onready var hurtbox_collision: CollisionShape2D = $Hurtbox/CollisionShape2D

func _ready() -> void:
	character.hide()
	hide()
	body_collision.disabled = true
	hurtbox_collision.disabled = true

func _physics_process(_delta: float) -> void:
	var input_direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_direction * speed
	move_and_slide()

	var mouse_position := get_global_mouse_position()
	var aim_direction := mouse_position - global_position
	if aim_direction.length_squared() > 0.001:
		# O sprite original aponta para baixo; -PI/2 alinha essa frente ao mouse.
		rotation = aim_direction.angle() - PI / 2.0
		gun.look_at(mouse_position)

	if Input.is_action_just_pressed("shoot") and character.visible:
		gun.fire()

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.get("damage") != null:
		character.take_damage(body.damage)

func start(pos: Vector2) -> void:
	character.reset()
	position = pos
	rotation = 0.0
	character.show()
	show()
	body_collision.set_deferred("disabled", false)
	hurtbox_collision.set_deferred("disabled", false)

func _on_character_died() -> void:
	character.hide()
	hide()
	hit.emit()
	body_collision.set_deferred("disabled", true)
	hurtbox_collision.set_deferred("disabled", true)
