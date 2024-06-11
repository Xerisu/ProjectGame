extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	text = "Przeciwnicy do pokonania: " + str(get_node("../../../Enemies").get_child_count())
