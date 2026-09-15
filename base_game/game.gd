extends Node

const EnemyCatalog = preload("res://base_game/enemies/enemy_catalog.gd")

@export_group("Inimigos")
@export var mob_scene: PackedScene

@onready var player: PlayerController = $Player
@onready var hud: GameHUD = $HUD
@onready var mob_timer: Timer = $MobTimer
@onready var score_timer: Timer = $ScoreTimer
@onready var start_timer: Timer = $StartTimer
@onready var start_position: Marker2D = $StartPosition
@onready var spawn_location: PathFollow2D = $MobPath/MobSpawnLocation

var elapsed_seconds: int = 0

func _ready() -> void:
	$HUD/StartButton.hide()
	player.weapon_changed.connect(hud.set_weapon)
	player.dash_ready_changed.connect(hud.set_dash_ready)
	player.potion_available_changed.connect(hud.set_potion_available)
	new_game()

func new_game() -> void:
	_clear_enemies()
	elapsed_seconds = 0
	score_timer.stop()
	mob_timer.stop()
	hud.reset_run()
	player.start(start_position.position)
	start_timer.start()
	hud.show_message("Prepare-se!")

func game_over() -> void:
	score_timer.stop()
	mob_timer.stop()
	hud.show_game_over()

func _clear_enemies() -> void:
	get_tree().call_group("mobs", "queue_free")

func _spawn_enemy() -> void:
	var enemy_scene := _pick_enemy_scene()
	if enemy_scene == null:
		push_warning("Nenhuma cena de inimigo foi configurada.")
		return

	var enemy := enemy_scene.instantiate() as Enemy
	if enemy == null:
		push_warning("A cena escolhida não usa o script de inimigo esperado.")
		return

	spawn_location.progress_ratio = randf()
	var direction := spawn_location.global_rotation + PI / 2.0
	direction += randf_range(-PI / 4.0, PI / 4.0)

	enemy.global_position = spawn_location.global_position
	enemy.rotation = direction
	enemy.linear_velocity = Vector2.RIGHT.rotated(direction) * enemy.get_spawn_speed()
	add_child(enemy)
	enemy.points_conquered.connect(hud.add_score)

func _pick_enemy_scene() -> PackedScene:
	var available_scenes: Array[PackedScene] = []
	if mob_scene != null:
		available_scenes.append(mob_scene)
	available_scenes.append_array(EnemyCatalog.EXTRA_ENEMY_SCENES)
	return null if available_scenes.is_empty() else available_scenes.pick_random() as PackedScene

func _on_mob_timer_timeout() -> void:
	_spawn_enemy()

func _on_score_timer_timeout() -> void:
	elapsed_seconds += 1
	hud.update_time(elapsed_seconds)

func _on_start_timer_timeout() -> void:
	mob_timer.start()
	score_timer.start()
