extends Area2D

signal hit

@export var speed = 400
var screen_size

@onready var character: Character ##added
@onready var gun: Gun = $Gun

func _ready() -> void:
	character = $Character ##added
	screen_size = get_viewport_rect().size
	character.hide() # to not fire without started the game
	hide()

func _process(delta: float) -> void:
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0
		
	gun.look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("shoot") and character.visible:
		gun.fire()

func _on_body_entered(body: Node2D) -> void:
	character = $Character #added
	character.take_damage(body.damage) ## added

	
func start(pos):
	character.reset() ## added
	position = pos
	character.show() ##added to dont fire without started
	show()
	$CollisionShape2D.disabled = false

##added, the body was originally in _on_body_entered(body: Node2D)
func _on_character_died() -> void:
	character.hide() # to not fire without started the game
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)
