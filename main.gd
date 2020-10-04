extends Node2D

const MAX_SPEED = 1150

onready var rider = $rider
onready var track = $track

onready var ouch = $audio/ouch
onready var ouch2 = $audio/ouch2
onready var success = $audio/success


onready var lose_screen = $gui/lose_screen
onready var speed_label = $gui/stats/vbox/speed
onready var score_label  = $gui/stats/vbox/score
onready var final_score_label = $gui/lose_screen/MarginContainer/VBoxContainer/final_score

onready var hearts = [
	$gui/heart1,
	$gui/heart2,
	$gui/heart3
]

var t:float = 0
var score = 0
var health = 0
var current_segment:Segment
var last_segment:Segment
var offset = Vector2.ZERO
var last_up_segment:Segment

var do_loop_exit = false

var speed = 750

# Called when the node enters the scene tree for the first time.
func _ready():
	current_segment = track.get_first_segment()
	current_segment.color = Segment.COLOR_ACTIVE
	for heart in hearts:
		health += 1

func lose_health():
	
	hearts[health-1].visible = false
	health -= 1
	if health < 0:
		ouch2.play()
		speed = 0
		final_score_label.text = "Final Score: " + str(score)
		lose_screen.visible = true		
	else:
		ouch.play()
	
func _process(_delta):
	
	t += speed * _delta
	
	if t>=current_segment.get_baked_length():		
		
		t = 0
		last_segment = current_segment		
		rider.space_sprite.visible = false
		
		if current_segment.type_name == Segment.CURVE_RIGHT_UP: # we're exiting an CURVE_RIGHT_UP segment
			last_up_segment = current_segment
				
		if current_segment.type_name == Segment.CURVE_DOWN_RIGHT and do_loop_exit:
			success.play()
			score += round(current_segment.score_multi * speed)
			speed += 25
			speed = clamp(speed, 500, MAX_SPEED)
			speed_label.text = "Speed: " + str(speed)
			score_label.text = "Score: " + str(score)
		
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
		rider.draw_attention_circle(1)

	rider.position = current_segment.position + current_segment.interpolate_baked(t) 
	
	if last_segment:
		last_segment.color = Segment.COLOR_ACTIVE.linear_interpolate(Segment.COLOR_IDLE, t / current_segment.get_baked_length())
	
	
	current_segment.next_segment.color = Segment.COLOR_IDLE
	if last_up_segment and last_up_segment != current_segment:
		last_up_segment.color = Segment.COLOR_IDLE
		
	if Input.is_action_just_pressed("change_route"):
		if current_segment.type_name == Segment.CURVE_DOWN_RIGHT:
			do_loop_exit = true
		else:
			if current_segment.type_name == Segment.STRAIGHT:
				pass
			else:
				lose_health()
	
	var interpol_color = Segment.COLOR_IDLE.linear_interpolate(Segment.COLOR_ACTIVE, t / current_segment.get_baked_length())
	
	if current_segment.type_name == Segment.CURVE_DOWN_RIGHT and not do_loop_exit:	
		#rider.space_sprite.visible = true
		rider.draw_attention_circle(t / current_segment.get_baked_length())
	else:
		rider.space_sprite.visible = false
		#current_segment.next_segment.color = interpol_color





func _on_ok_button_pressed():
	get_tree().reload_current_scene()


func _on_intro_hide_timer_timeout():
	$gui/introduction.visible = false
