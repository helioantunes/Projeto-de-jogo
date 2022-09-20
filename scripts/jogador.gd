extends KinematicBody2D

var velocity = Vector2.ZERO
var moveSpeed = 480
var gravity = 1200
var jumpForce = -720
var is_grounded
onready var raycasts = $raycasts

func _physics_process(delta : float) -> void:
	velocity.y += gravity * delta
	
	_get_input()
	
	is_grounded = _check_is_ground()		
	_set_animation()

func _get_input(): 
	velocity.x = 0
	var moveDirection = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	velocity.x = lerp(velocity.x,  moveSpeed * moveDirection, 0.2)
	
	if moveDirection != 0:
		$Texture.scale.x = moveDirection
	
	move_and_slide(velocity)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("jump") and is_grounded:
		velocity.y = jumpForce / 2
		
func _check_is_ground():
	for raycast in raycasts.get_children():
		if raycast.is_colliding():
			return true
	return false
	
func _set_animation():
	var anim = "idle"
	
	if !is_grounded:
		anim = "jump"
	elif velocity.x != 0:
		anim = "run"
	
	if $anim.assigned_animation != anim:
		$anim.play(anim)
	
