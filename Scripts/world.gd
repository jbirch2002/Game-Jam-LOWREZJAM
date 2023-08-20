extends Node2D

@onready var player = $Player
@onready var power_up = $DoubleJumpPowerUp


func _ready() -> void:
	pass


func _on_double_jump_power_up_double_jump_power():
	player.jump_max += 1

