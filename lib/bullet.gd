extends Area2D #is better for bullets because we can manage the physics better
class_name Bullet

@export var speed: float = 800.0
@export var damage: float = 10.0
@export var lifetime: float = 2.0

var direction: Vector2 = Vector2.RIGHT

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rotation = direction.angle()
	
	get_tree().create_timer(lifetime).timeout.connect(queue_free)
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position += direction * speed * delta
	
func _on_body_entered(body: Node2D) -> void:
	_handle_hit(body)
	
func _on_area_entered(body: Node2D) -> void:
	_handle_hit(body)
		
func _handle_hit(target: Node) -> void:
	if target.has_method("take_damage"):
		target.take_damage(damage)
	queue_free()
	
	
	
