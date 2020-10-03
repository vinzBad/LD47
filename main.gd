extends Node2D


onready var rider = $rider
onready var track = $track

var t:float = 0

var current_segment:Segment
var last_segment:Segment
var offset = Vector2.ZERO
var last_up_segment:Segment

var do_loop_exit = false

var speed = 500

# Called when the node enters the scene tree for the first time.
func _ready():
	current_segment = track.get_first_segment()
	current_segment.color = Segment.COLOR_ACTIVE

	
func _process(_delta):
	
	t += speed * _delta
	
	if t>=current_segment.get_baked_length():		
		
		t = 0
		last_segment = current_segment		
		rider.space_sprite.visible = false
		
		if current_segment.type_name == Segment.CURVE_RIGHT_UP: # we're exiting an CURVE_RIGHT_UP segment
			last_up_segment = current_segment
				
		#if current_segment.type_name == Segment.CURVE_DOWN_RIGHT and do_loop_exit:
		#	speed += 50
		
		if current_segment.type_name == Segment.CURVE_DOWN_RIGHT and not do_loop_exit: 
			current_segment.color = Segment.COLOR_IDLE
			
			current_segment = last_up_segment
		else:
			current_segment = current_segment.next_segment
		
		#current_segment = current_segment.next_segment
		
		current_segment.prev_segment.color = Segment.COLOR_IDLE		
		current_segment.color = Segment.COLOR_ACTIVE
		do_loop_exit = false
		
		track.generate_segments()
		track.clear_old_segments(rider.position.x - get_viewport_rect().size.x) 

	rider.position = current_segment.position + current_segment.interpolate_baked(t) 
	
	if last_segment:
		last_segment.color = Segment.COLOR_ACTIVE.linear_interpolate(Segment.COLOR_IDLE, t / current_segment.get_baked_length())
	
	
	current_segment.next_segment.color = Segment.COLOR_IDLE
	if last_up_segment and last_up_segment != current_segment:
		last_up_segment.color = Segment.COLOR_IDLE
		
	if Input.is_key_pressed(KEY_SPACE):
		do_loop_exit = true
	
	var interpol_color = Segment.COLOR_IDLE.linear_interpolate(Segment.COLOR_ACTIVE, t / current_segment.get_baked_length())
	
	if current_segment.type_name == Segment.CURVE_DOWN_RIGHT and not do_loop_exit:	
		#rider.space_sprite.visible = true
		#last_up_segment.color = interpol_color
		pass
	else:
		rider.space_sprite.visible = false
		#current_segment.next_segment.color = interpol_color



