extends Node2D
class_name Gun

@export var bullet_scene: PackedScene
@export var fire_rate: float = 0.2
@export var bullet_speed: float = 800.0
@export var bullet_damage: float = 10.0

@onready var muzzle: Marker2D = $"Muzzle (marker2D)"

var _can_fire: bool = true

func fire() -> void:
	if not _can_fire or bullet_scene == null:
		return
	
	_can_fire = false
	var look_direction = (get_global_mouse_position() - global_position).normalized()
	var spawn_distance = 40.0
	
	var bullet := bullet_scene.instantiate() as Bullet

	bullet.global_position = muzzle.global_position + (look_direction * spawn_distance)
	bullet.direction = Vector2.RIGHT.rotated(global_rotation)
	bullet.speed = bullet_speed
	bullet.damage = bullet_damage
	bullet.rotation = look_direction.angle()
	
	get_tree().current_scene.add_child(bullet)
	
	await get_tree().create_timer(fire_rate).timeout
	_can_fire = true
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


## remember to add in some* function of the player/enemy/whatever you want the gun:
# @onready var...
# in function:
#    gun.look_at(get_global_mouse_position())
#	 if Input.is_action_pressed("shoot"*):
#	     gun.fire()
