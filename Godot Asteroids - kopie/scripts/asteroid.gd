extends Area2D

var movement_vector := Vector2(0, -1)

enum AsteroidSize{LARGE, MEDIUM, SMALL}
@export var size := AsteroidSize.LARGE

var speed := 50

@onready var sprite =$Sprite2D
@onready var cshape =$CollisionShape2D


func _ready():
	rotation = randf_range(0, 2*PI)
	
	match size:
		AsteroidSize.LARGE:
			speed = randf_range(50,100)
			sprite.texture = preload("res://assets/textures/meteorGrey_big2.png")
			cshape.shape= preload("res://resources/asteroid_cshape_large.tres")
		AsteroidSize.MEDIUM:
			speed = randf_range(100,150)
			sprite.texture = preload("res://assets/textures/meteorGrey_med1.png")
			cshape.shape= preload("res://resources/asteroid_cshape_medium.tres")
		AsteroidSize.SMALL:
			speed = randf_range(100,200)
			sprite.texture = preload("res://assets/textures/meteorGrey_tiny1.png")
			cshape.shape= preload("res://resources/asteroid_cshape_small.tres")
	# print(speed) om te checken of de speed ook echt 'random' veranderd 

func _physics_process(delta):
	global_position += movement_vector.rotated(rotation) * speed * delta
	
	var radius = cshape.shape.radius
	var screen_size = get_viewport_rect().size
	if global_position.y + radius < 0 :
		global_position.y = screen_size.y + radius
		print(global_position)
	elif global_position.y-radius > screen_size.y :
		global_position.y = -radius
		print(global_position)
	if global_position.x+radius < 0 :
		global_position.x = screen_size.x+radius
		print(global_position)
	elif global_position.x-radius > screen_size.x :
		global_position.x = -radius
		print(global_position)


