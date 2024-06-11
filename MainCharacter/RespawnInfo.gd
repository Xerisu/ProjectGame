extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	self.modulate.a = 0




func _on_respawn_timeout():
	self.modulate.a = 0
