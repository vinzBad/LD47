extends Node2D

const C = 0.551915024494

var segment_scene = preload("segment.tscn")

var next_segments = []

# Called when the node enters the scene tree for the first time.
func _ready():
	var s = 100
	add_segment(straight(100))
	generate_segments()

func create_loop(s):
	return [
		straight(2*s),
		curve_right_up(s),
		curve_up_left(s),
		curve_left_down(s),
		curve_down_right(s),
		straight(2*s)
		]

func add_segment(segment:Segment):
	var last_point = Vector2.ZERO
	if get_child_count() != 0:
		var last_segment = get_last_segment()
		last_segment.next_segment = segment
		segment.prev_segment = last_segment
		last_point = last_segment.to_global(last_segment.last_point())	
	
	segment.position = last_point

	add_child(segment)
	
func get_first_segment():
	return get_children().front()
	
func get_last_segment():
	return get_children().back()
	
func generate_segments():
	if get_child_count() < 64:
		if randi() % 2 == 0:
			next_segments.append(straight((randi() % 4 + 1) * 50))
		else:
			next_segments += create_loop(rand_range(.4, 1.2) * 100)
		for seg in next_segments:
			add_segment(seg)
		next_segments.clear()
		
	
func clear_old_segments(xmin:float):
	for segment in get_children():
		if segment.position.x < xmin:
			segment.queue_free()
	
func curve_right_up(s):
	var c = C * s
	var curve = segment_scene.instance()
	curve.type_name  = Segment.CURVE_RIGHT_UP
	
	curve.add_point(Vector2.ZERO, Vector2.ZERO, Vector2(c,0))
	curve.add_point(Vector2(s, -s), Vector2(0, c))
	return curve
	

func curve_up_left(s):
	var c = C * s
	var curve = segment_scene.instance()
	curve.type_name  = Segment.CURVE_UP_LEFT
	
	curve.add_point(Vector2.ZERO, Vector2.ZERO, Vector2(0,-c))
	curve.add_point(Vector2(-s, -s), Vector2(c, 0))
	return curve
	
func curve_left_down(s):
	var c = C * s
	var curve = segment_scene.instance()
	curve.type_name  = Segment.CURVE_LEFT_DOWN
	
	curve.add_point(Vector2.ZERO, Vector2.ZERO, Vector2(-c,0))
	curve.add_point(Vector2(-s, s), Vector2(0, -c))
	return curve
	

func curve_down_right(s):
	var c = C * s
	var curve = segment_scene.instance()
	curve.type_name  = Segment.CURVE_DOWN_RIGHT
	
	curve.add_point(Vector2.ZERO, Vector2.ZERO, Vector2(0, c))
	curve.add_point(Vector2(s,s), Vector2(-c, 0))
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

