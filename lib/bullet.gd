extends Area2D
class_name Bullet

@export var speed: float = 800.0
@export var damage: int = 10
@export var lifetime: float = 2.0

var direction: Vector2 = Vector2.RIGHT

func _ready() -> void:
	rotation = direction.angle()
	get_tree().create_timer(lifetime, false).timeout.connect(queue_free)
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)

func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
	_handle_hit(body)

func _on_area_entered(area: Area2D) -> void:
	_handle_hit(area)

func _handle_hit(target: Node) -> void:
	if target.has_method("take_damage"):
		target.take_damage(damage)
	queue_free()
