class_name Player extends CharacterBody2D

const SPEED = 60.0
var direction: Vector2 = Vector2.ZERO
var cardinal_direction: Vector2 = Vector2.DOWN 
var state: String = "idle"

var enable_to_move: bool = true

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	Bus.subscribe(OpenElectrod, make_player_invalid)
	Bus.subscribe(CloseElectrod, make_player_great_again)
	
func make_player_invalid(e):
	enable_to_move = false
	
func make_player_great_again(e):
	enable_to_move = true

func _physics_process(delta: float) -> void:
	direction = Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_up", "ui_down")
	).normalized() 
	
	if not enable_to_move:
		direction = Vector2.ZERO
	
	if SetState() or SetDirection():
		UpdateAnimation()

	velocity = direction * SPEED
	
	
	move_and_slide()
		
		
func SetDirection() -> bool:
	if direction == Vector2.ZERO:
		return false 
	
	var new_dir: Vector2 = cardinal_direction
	
	if abs(direction.x) > abs(direction.y):
		new_dir = Vector2.LEFT if direction.x < 0 else Vector2.RIGHT
	else:
		new_dir = Vector2.UP if direction.y < 0 else Vector2.DOWN
	
	if new_dir == cardinal_direction:
		return false
	
	cardinal_direction = new_dir

	if cardinal_direction.x != 0 and enable_to_move:
		animated_sprite.scale.x = -1.0 if cardinal_direction == Vector2.LEFT else 1.0
		
	return true

		
func SetState() -> bool:
	var new_state: String = "idle" if direction == Vector2.ZERO else "walk"
	if new_state == state:
		return false
	
	if new_state == "walk":
		Bus.create_event(PlayerStartMove.new())
	else:
		Bus.create_event(PlayerStopMove.new())
		
	state = new_state
	return true


func UpdateAnimation() -> void:
	var anim_name: String = state + "_" + AnimDirection()
	
	if animated_sprite.sprite_frames.has_animation(anim_name):
		animated_sprite.play(anim_name)
	else:
		animated_sprite.play("idle_down")


func AnimDirection() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"
