extends Node2D

const C = 0.551915024494

var segment_scene = preload("segment.tscn")

var segments = []

# Called when the node enters the scene tree for the first time.
func _ready():
	var s = 100
	straight(40)
	create_loop(s) 
	create_loop(s * 1.4)
	create_loop(s * .9)
	create_loop(s * .7)
	create_loop(s * .5)
	create_loop(s * .4)
	straight(50)
	create_loop(s * .4)
	straight(50)
	create_loop(s * .4)
	straight(50)
	create_loop(s * .4)

func create_loop(s):
		straight(2*s)
		curve_up(s)
		loop_back(s)
		curve_down(s)
		straight(2*s)

func add_segment(segment:Segment):
	var last_point = Vector2.ZERO
	if len(segments) != 0:
		var last_segment = segments.back()
		last_segment.next_segment = segment
		segment.prev_segment = last_segment
		last_point = last_segment.to_global(last_segment.last_point())	
	
	segment.position = last_point
	segments.append(segment)
	add_child(segment)
	
func curve_up(s):
	var c = C * s
	var curve = segment_scene.instance()
	curve.type_name  = Segment.CURVE_UP
	
	curve.add_point(Vector2.ZERO, Vector2.ZERO, Vector2(c,0))
	curve.add_point(Vector2(s, -s), Vector2(0, c))
	add_segment(curve)

func straight(s):
	var curve = segment_scene.instance()
	curve.type_name  = Segment.STRAIGHT

	curve.add_point(Vector2.ZERO)
	curve.add_point(Vector2(s, 0))
	add_segment(curve)

func loop_back(s):
	var c = C * s
	var curve = segment_scene.instance()
	curve.type_name  = Segment.LOOP_BACK
	
	curve.add_point(Vector2.ZERO, Vector2.ZERO, Vector2(0, -c))
	curve.add_point(Vector2(-s, -s), Vector2(c, 0), Vector2(-c, 0))
	curve.add_point(Vector2(-2*s, 0), Vector2(0, -c))
	add_segment(curve)

func curve_down(s):
	var c = C * s
	var curve = segment_scene.instance()
	curve.type_name  = Segment.CURVE_DOWN
	
	curve.add_point(Vector2.ZERO, Vector2.ZERO, Vector2(0, c))
	curve.add_point(Vector2(s,s), Vector2(-c, 0))
	add_segment(curve)
