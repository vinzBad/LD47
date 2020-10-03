extends Node2D

onready var space_sprite = $space

var radius = 12
var color = Color("fca652")
var attention_radius = 12
var attention_radius_max = radius * 4

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func draw_attention_circle(t):
	attention_radius = lerp(attention_radius_max, radius, t)
	update()

func _draw():
	draw_circle(Vector2.ZERO, attention_radius, color)
	draw_circle(Vector2.ZERO, radius, color )
	
	
