extends Sprite2D
class_name ReflectionComponent

@export var sprite_to_reflect: Sprite2D

func _process(delta):
	frame = sprite_to_reflect.frame
	offset.y = -sprite_to_reflect.offset.y if flip_v else offset.y#sprite_to_reflect.offset.y
