extends Control

const STAGE_SELECT_SCENE := "res://base_game/stage_select.tscn"
const MAIN_MENU_SCENE := "res://base_game/menu.tscn"

func _ready() -> void:
	hide()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.echo:
		return
	if not event.is_action_pressed("pause_menu"):
		return

	_toggle_pause()
	get_viewport().set_input_as_handled()

func _toggle_pause() -> void:
	if visible:
		_resume_game()
	else:
		_open_pause()

func _open_pause() -> void:
	show()
	get_tree().paused = true
	%ResumeButton.grab_focus()

func _resume_game() -> void:
	hide()
	get_tree().paused = false

func _change_scene(scene_path: String) -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(scene_path)

func _on_resume_pressed() -> void:
	_resume_game()

func _on_stage_select_pressed() -> void:
	_change_scene(STAGE_SELECT_SCENE)

func _on_settings_pressed() -> void:
	# Reservado para uma futura tela de configurações.
	pass

func _on_main_menu_pressed() -> void:
	_change_scene(MAIN_MENU_SCENE)

func _exit_tree() -> void:
	get_tree().paused = false
