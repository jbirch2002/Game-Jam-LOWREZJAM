extends Node2D

@onready var collision_polygon_2d = $StaticBody2D/CollisionPolygon2D
@onready var polygon_2d = $StaticBody2D/CollisionPolygon2D/Polygon2D
@onready var player = $Player
@onready var power_up = $DoubleJumpPowerUp


func _ready() -> void:
	polygon_2d.polygon = collision_polygon_2d.polygon


func _on_double_jump_power_up_double_jump_power():
	player.jump_count = 2

