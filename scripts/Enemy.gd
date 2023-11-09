extends CharacterBody3D

@export var collision_port : Node




func _on_alert_area_body_entered(body):
	if Macros.in_and_not_null("collision_port",body):
		match body.collision_port.id:
			"PLAYER":
				pass
