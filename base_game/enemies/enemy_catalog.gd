extends RefCounted

# Todos os inimigos desta lista passam a surgir em TODAS as fases.
# Para adicionar um novo, crie uma cena baseada em enemy_template.tscn e
# acrescente uma linha de preload aqui.
const EXTRA_ENEMY_SCENES: Array[PackedScene] = [
	# preload("res://base_game/enemies/meu_inimigo.tscn"),
]
