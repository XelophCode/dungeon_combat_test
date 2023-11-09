extends CharacterBody3D


@export_group("node references")
@export var input_port : Node
@export var collision_port : Node
@export var editor_body : CSGCylinder3D
@export var editor_camera_direction : CSGBox3D
@export var camera_rotation : Node3D
@export var camera_pitch : Node3D
@export var states : Node
@export var hands : Node3D
@export var main_camera : Camera3D
@export var hand_camera : Camera3D

const camera_sensitivity : float = 0.05
const camera_max_pitch : float = 80.0
const move_speed : float = 3.0
const jump_strength : float = 10.0
const gravity_strength : float = 30.0
const terminal_velocity : float = -40.0
const top_run_speed : float = 2.0
const dodge_speed : float = 12.0
const hands_procedural_anim_strength : Vector3 = Vector3(0.2, 0.2, 0.05)
const hands_procedural_anim_range : Vector3 = Vector3(0.1, 0.1, 0.05)


var mouse_relative : Vector2

# These variables are influenced by state actions
var move_direction : Vector2
var dodge_direction : Vector2
var run_speed : float = 1.0
var applied_gravity : float = 0


func _ready():
	Globals.player = self
	editor_body.hide()
	editor_camera_direction.hide()
	
	camera_rotation.rotation.y = rotation.y
	rotation.y = 0
	
	InputManager.focus(self)


func _process(delta):
	if InputManager.check(self):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			states.check_for_state_change()
			states.current._loop(delta)
			
			for action_node in states.current.available_actions:
				action_node._action(delta)
			
			move_and_slide_calculation()
			camera_move(delta)
			
			hands_procedural_animations(delta)
	
	hand_camera.global_transform = main_camera.global_transform


# Used to retrieve the velocity of the player's mouse movements
func _input(event):
	if event is InputEventMouseMotion:
		mouse_relative = event.relative


# Pulls mouse movement velocity from '_input()' and rotates the 'Rotation' and 'Pitch' nodes for the camera
func camera_move(delta):
	camera_rotation.rotation_degrees.y += (-mouse_relative.x * camera_sensitivity)
	camera_pitch.rotation_degrees.x += (-mouse_relative.y * camera_sensitivity)
	camera_pitch.rotation_degrees.x = clamp(camera_pitch.rotation_degrees.x,-camera_max_pitch,camera_max_pitch)
	mouse_relative = Vector2.ZERO


# Takes parameters from the move, jump, run, etc. actions and mixes them for a final move_and_slide output.
func move_and_slide_calculation():
	move_direction *= move_speed
	move_direction *= run_speed
	
	Debug.player_speed.text = str(snapped(run_speed,0.01) - 1.0)
	
	velocity.x = move_direction.x + (dodge_direction.x * dodge_speed)
	velocity.z = move_direction.y + (dodge_direction.y * dodge_speed)
	
	velocity.y = applied_gravity
	
	move_and_slide()


# Moves hand objects based on player movement.
func hands_procedural_animations(delta):
	reset_hands_position(delta)
	offset_hands_position(delta)


func reset_hands_position(delta):
	if move_direction == Vector2.ZERO:
		hands.position.x = lerp(hands.position.x,0.0,0.1)
		hands.position.z = lerp(hands.position.z,0.0,0.1)
	if applied_gravity == 0:
		hands.position.y = lerp(hands.position.y,0.0,0.1)


func offset_hands_position(delta):
	var offset_dir = move_direction.rotated(camera_rotation.rotation.y)
	
	hands.position.x -= (offset_dir.x * hands_procedural_anim_strength.x) * delta
	hands.position.z -= (offset_dir.y * hands_procedural_anim_strength.z) * delta
	hands.position.y -= (applied_gravity * hands_procedural_anim_strength.y) * delta
	
	hands.position.x = clamp(hands.position.x, -hands_procedural_anim_range.x, hands_procedural_anim_range.x)
	hands.position.z = clamp(hands.position.z, -hands_procedural_anim_range.z * run_speed, hands_procedural_anim_range.z * run_speed)
	hands.position.y = clamp(hands.position.y, -hands_procedural_anim_range.y, hands_procedural_anim_range.y)













