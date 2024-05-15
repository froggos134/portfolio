extends CharacterBody2D

signal laser_shot(laser)

@export var acceleration := 10.0
@export var max_speed := 350.0
@export var rotation_speed := 250.0
# @export is zodat deze waardes snel en makkelijk bewerkt kunnen worden in het scherm 
# hiernaast onder 'player.gd' het wordt geexporteerd naar buiten de script om 
# makkelijk het te kunnen veranderen

@onready var muzzle = $Muzzle
# @onready begint laad alleen als er mee geïnteract wordt, 
# de muzzle functie hoeft alleen aanwezig te zijn als de bullet geschoten wordt
#aangezien dit de begin positie aangeeft van de bullet

var laser_scene = preload("res://scenes/laser.tscn")
# dit laadt  de scene van de laser die wordt gerbuikt bij het schieten

var shoot_cd = false 
var rate_of_fire = 0.15
# aangegeven interval hieronder gebruikt

func _process(delta):
	if Input.is_action_pressed("shoot"):
		if !shoot_cd:
			shoot_cd = true
			shoot_laser()
			await get_tree().create_timer(rate_of_fire).timeout
			shoot_cd = false
			# zorgt voor een burst van lasers met de aangegeven interval van 0.15 seconden
			# zodat de lasers in een gecontrolelerde hoeveelheid schieten 
			# terwijl dat je de space bar vast houdt om te schieten


func _physics_process(delta):
	var input_vector := Vector2(0, Input.get_axis("move_forward", "move_backward")) 
	# vector geeft de richting van boven of onder aan (0,("-1" , "1")) 
	
	velocity += input_vector.rotated(rotation) * acceleration 
	# om de player naar de kant te laten bewegen van de ingedrukte richting
	# pakt de draaing van hieronder aangegeven (rg.19 t/m 22)
	velocity = velocity.limit_length(max_speed)
	# om te zorgen dat het schip niet oneindig kan versnellen
	
	if Input.is_action_pressed("rotate_right"):
		rotate(deg_to_rad(rotation_speed*delta))
	if Input.is_action_pressed("rotate_left"):
		rotate(deg_to_rad(-rotation_speed*delta))
	# om de player te laten draaien, - is om de waarde negatief te maken en dus 
	# de player naar links te laten draaien (delta is for een 'independent frame rate'
	# zo zien alle frames er overal hetzelfde uit, ongeacht het device.
		

	if input_vector.y == 0:
		velocity = velocity.move_toward(Vector2.ZERO, 3)
	# Vector2(0,y) > y is of forward of backward, als y geen van beide is dan is  
	# y 0> y= geen waarde. De snelheid waarmee de velocity af neemt is aangegeveen met 3
	
	move_and_slide()
	
	var screen_size = get_viewport_rect().size
	if global_position.y < 0 :
		global_position.y = screen_size.y
	elif global_position.y > screen_size.y :
		global_position.y = 0
		
	if global_position.x < 0 :
		global_position.x = screen_size.x
	elif global_position.x > screen_size.x :
		global_position.x = 0
	#zodat het schip binnen het scherm blijft

	

func shoot_laser():
	var l = laser_scene.instantiate()
	l.global_position = muzzle.global_position
	l.rotation = rotation
	emit_signal("laser_shot", l)
	# crëert de laser, vanaf het aangegeven punt en rotatie van het schip zelf
	
	







