extends Node
class_name Plus

@export var player: CharacterBody2D

const PRIMARY_WEAPON := 0
const ALTERNATE_WEAPON := 1

func try_dash(move_direction: Vector2, aim_direction: Vector2) -> void:
	if player._dash_cooldown_left > 0.0:
		return

	player._dash_direction = move_direction.normalized()
	if player._dash_direction == Vector2.ZERO and aim_direction.length_squared() > 0.001:
		player._dash_direction = aim_direction.normalized()
	if player._dash_direction == Vector2.ZERO:
		return

	player._dash_time_left = player.dash_duration
	player._dash_cooldown_left = player.dash_cooldown
	player._dash_ready = false
	player.dash_ready_changed.emit(false)

func switch_weapon() -> void:
	var next_weapon := ALTERNATE_WEAPON if player.current_weapon == PRIMARY_WEAPON else PRIMARY_WEAPON
	apply_weapon(next_weapon)
	
func apply_weapon(index: int, emit_signal: bool = true) -> void:
	player.current_weapon = clampi(index, PRIMARY_WEAPON, ALTERNATE_WEAPON)
	player.alt_gun_sprite.visible = player.current_weapon == ALTERNATE_WEAPON

	if player.current_weapon == PRIMARY_WEAPON:
		player.gun.configure(player.primary_fire_rate, player.primary_bullet_speed, player.primary_bullet_damage)
	else:
		player.gun.configure(player.alternate_fire_rate, player.alternate_bullet_speed, player.alternate_bullet_damage)

	if emit_signal:
		player.weapon_changed.emit(player.current_weapon)


func use_potion() -> void:
	if not player.potion_available or player.character.is_full_health():
		return

	player.character.heal(player.potion_heal)
	player.potion_available = false
	player.potion_available_changed.emit(false)
	
