extends RigidBody2D

onready var sprite = $AnimatedSprite

export var flip_h = false
export var flip_v = false

func _ready():
	sprite.animation = "default"
	sprite.flip_h = flip_h
	sprite.flip_v = flip_v

func _on_Villager_body_entered(body):
	if body.has_method("get_type"):
		if body.type == "Player":
			Sound.play_sound("Hit")
			sprite.animation = "death"
			set_collision_layer_bit(0,false)
			set_collision_mask_bit(0,false)

func _on_AnimatedSprite_animation_finished():
	if sprite.animation == "death":
		print(String(sprite.animation))
		sprite.play("birth")
		Sound.play_sound("Spawn")
	elif sprite.animation == "birth":
		set_collision_layer_bit(0,true)
		set_collision_mask_bit(0,true)
		
		sprite.play("default")
