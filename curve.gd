extends Node2D
tool


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var path = $path


# Called when the node enters the scene tree for the first time.
func _ready():
	path.curve = Curve2D.new()


func create_loop(crv:Curve2D):
	var s = 10.0
	var c = 0.551915024494 * s  # ~MAGIC~ -> https://spencermortensen.com/articles/bezier-circle/
	# segment 0 top left
	crv.add_point(Vector2(0, 0))
	crv.add_point(Vector2(2*s, 0), Vector2.ZERO, Vector2(c, 0))
	crv.add_point(Vector2(3*s, -s), Vector2(0, c), Vector2(0, -c))
	crv.add_point(Vector2(2*s, -2*s), Vector2(c, 0), Vector2(-c, 0))
	crv.add_point(Vector2(s, -s), Vector2(0, -c), Vector2(0, c))
	crv.add_point(Vector2(2*s, 0), Vector2(-c, 0))
	crv.add_point(Vector2(4*s, 0))
	# segment 1 bottom left
	#crv.add_point(Vector2(0, -s), Vector2(-c, 0), Vector2(c, 0))
	# segment 2 bottom right
	#crv.add_point(Vector2(-s, 0), Vector2(0, -c), Vector2(0, c))
	# segment 3 top right
	#crv.add_point(Vector2(0, s), Vector2(-c, 0), Vector2.ZERO)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	path.curve.clear_points()
	create_loop(path.curve)
