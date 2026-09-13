extends RigidBody2D


@onready var character: Character ##added
@export var damage: int = 40
signal points_conquered(amount:int) ## added

@export var point_value: int = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var mob_types = Array($AnimatedSprite2D.sprite_frames.get_animation_names())
	$AnimatedSprite2D.animation = mob_types.pick_random()
	$AnimatedSprite2D.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
#added
func take_damage(amount: int) -> void:
	character = $Character 
	character.take_damage(amount)

##added, the body was originally in _on_body_entered(body: Node2D)
func _on_character_died() -> void:
	points_conquered.emit(point_value)
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
