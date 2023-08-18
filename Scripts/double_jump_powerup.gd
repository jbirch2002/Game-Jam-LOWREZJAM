extends Area2D

signal double_jump_power

func _on_body_entered(body):
	print("Double jump power-up collected!")
	emit_signal("double_jump_power")
	queue_free()
