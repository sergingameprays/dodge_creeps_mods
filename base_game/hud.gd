extends CanvasLayer
class_name GameHUD

signal start_game

const PRIMARY_WEAPON_ICON := preload("res://art/hud/gun_primary.png")
const ALT_WEAPON_ICON := preload("res://art/hud/gun_alt.png")
const DISABLED_ITEM_COLOR := Color(0.35, 0.35, 0.35, 0.5)

var kill_score: int = 0

func _ready() -> void:
	reset_run()

func reset_run() -> void:
	kill_score = 0
	%ScoreValue.text = "000"
	%TimeValue.text = "000"
	set_weapon(0)
	set_dash_ready(true)
	set_potion_available(true)

func add_score(amount: int) -> void:
	kill_score = maxi(kill_score + amount, 0)
	%ScoreValue.text = "%03d" % mini(kill_score, 999)

func update_time(seconds: int) -> void:
	%TimeValue.text = "%03d" % mini(seconds, 999)

func set_weapon(index: int) -> void:
	%WeaponIcon.texture = PRIMARY_WEAPON_ICON if index == 0 else ALT_WEAPON_ICON

func set_dash_ready(is_ready: bool) -> void:
	%DashIcon.modulate = Color.WHITE if is_ready else DISABLED_ITEM_COLOR

func set_potion_available(is_available: bool) -> void:
	%PotionIcon.modulate = Color.WHITE if is_available else DISABLED_ITEM_COLOR

func show_message(text: String) -> void:
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over() -> void:
	show_message("Fim de Jogo")
	await $MessageTimer.timeout
	$Message.text = "Destrua as Naves!"
	$Message.show()
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()

func _on_start_button_pressed() -> void:
	$StartButton.hide()
	start_game.emit()

func _on_message_timer_timeout() -> void:
	$Message.hide()
