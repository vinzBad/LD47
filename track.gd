extends Node2D

const C = 0.551915024494

var segment_scene = preload("segment.tscn")

var segments = []

# Called when the node enters the scene tree for the first time.
func _ready():
	var s = 100
	segments = create_loop(s) 
	segments += create_loop(s * 1.4)
	segments += create_loop(s * .9)
	segments += create_loop(s * .7)
	segments += create_loop(s * .5)
	segments += create_loop(s * .4)
	segments += [straight(500)]
	segments += create_loop(s * .4)
	segments += [straight(500)]
	segments += create_loop(s * .4)
	segments += [straight(500)]
	segments += create_loop(s * .4)
	
	var last_point = Vector2.ZERO
	for segment in segments:
		segment.position = last_point
		last_point = segment.to_global(segment.last_point())
		add_child(segment)
		segment.update()

func create_loop(s):
	return [
		straight(s*2),
		curve_up(s),
		loop_back(s),
		curve_down(s),
		straight(s),
	]

func curve_up(s):
	var c = C * s
	var curve = segment_scene.instance()
	curve.type_name  = Segment.CURVE_UP
	
	curve.add_point(Vector2.ZERO, Vector2.ZERO, Vector2(c,0))
	curve.add_point(Vector2(s, -s), Vector2(0, c))
	return curve

func straight(s):
	var curve = segment_scene.instance()
	curve.type_name  = Segment.STRAIGHT

	curve.add_point(Vector2.ZERO)
	curve.add_point(Vector2(s, 0))
	return curve

func loop_back(s):
	var c = C * s
	var curve = segment_scene.instance()
	curve.type_name  = Segment.LOOP_BACK
	
	curve.add_point(Vector2.ZERO, Vector2.ZERO, Vector2(0, -c))
	curve.add_point(Vector2(-s, -s), Vector2(c, 0), Vector2(-c, 0))
	curve.add_point(Vector2(-2*s, 0), Vector2(0, -c))
	return curve

func curve_down(s):
	var c = C * s
	var curve = segment_scene.instance()
	curve.type_name  = Segment.CURVE_DOWN
	
	curve.add_point(Vector2.ZERO, Vector2.ZERO, Vector2(0, c))
	curve.add_point(Vector2(s,s), Vector2(-c, 0))
	return curve
