extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var rider = $rider
onready var track = $track

var t:float = 0
var current_segment_idx = 0
var offset = Vector2.ZERO
var last_up_segment
var last_segment

var do_loop_exit = false

var speed = 250

# Called when the node enters the scene tree for the first time.
func _ready():
	track.segments[current_segment_idx].color = track.COLOR_ACTIVE


func next_segment():
	var seg =  track.segments[(current_segment_idx + 1) % len(track.segments)]
	if track.segments[current_segment_idx].type_name == track.CURVE_DOWN:
		if !do_loop_exit:
			seg = last_up_segment[2]
	return seg
	
func _process(_delta):	
	var segment = track.segments[current_segment_idx]
	
	t += speed * _delta
	if t>=segment.get_baked_length():
		t = 0
		rider.space_sprite.visible = false
		
		if segment.type_name == track.CURVE_UP: # we're exiting an CURVE_UP segment
			last_up_segment = [current_segment_idx, offset, segment]
		
		var tessellated_points = segment.tessellate()
		offset += tessellated_points[len(tessellated_points) - 1]
		
		if segment.type_name == track.CURVE_DOWN and do_loop_exit:
			speed += 50
		
		if segment.type_name == track.CURVE_DOWN and not do_loop_exit: # we're exiting an CURVE_DOWN segment
			# TODO: check if switch track action was pressed			
			# restart on last CURVE_UP segment
			segment.color = track.COLOR_IDLE
			current_segment_idx = last_up_segment[0]
			offset = last_up_segment[1]
		else:
			current_segment_idx += 1
			current_segment_idx %= len(track.segments) # wraparound for now
			if current_segment_idx == 0:
				offset = Vector2.ZERO # reset offset for wraparound
		
		segment.color = track.COLOR_IDLE
		segment = track.segments[current_segment_idx]
		segment.color = track.COLOR_ACTIVE
		do_loop_exit = false
		track.update()
		
	rider.position = offset + segment.interpolate_baked(t) 
	
	if t > segment.get_baked_length() / 2:
		next_segment().color = track.COLOR_IDLE
		
		if Input.is_key_pressed(KEY_SPACE):
			do_loop_exit = true
		
		if track.segments[current_segment_idx].type_name == track.CURVE_DOWN and next_segment().type_name == track.CURVE_UP:
			rider.space_sprite.visible = true
			
			
		next_segment().color = track.COLOR_IDLE.linear_interpolate(track.COLOR_ACTIVE, t / segment.get_baked_length())
		
		track.update()
	
