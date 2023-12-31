extends State

@export var animation_player: AnimationPlayer

@onready var attack_radius: Area2D = $AttackRadius
@onready var attack_box: Area2D = $AttackBox
@onready var attack_collider: CollisionShape2D = $AttackBox/CollisionShape2D

var bomber_attack: Attack = Attack.new("bomber attack", 1)
var player: CharacterBody2D
var insta_det = false

func recieve_args(from_hit):
	insta_det = from_hit

func _ready():
	attack_box.area_entered.connect(_on_hit)

func enter():
	character.velocity = Vector2()
	if insta_det:
		animation_player.play("Attack_insta")
	else:
		find_player()
		match Directions.direction_four_diagonal(direction_to_player()):
			Directions.Direction.DOWN_RIGHT: animation_player.play("Attack_down_right")
			Directions.Direction.DOWN_LEFT: animation_player.play("Attack_down_left")
			Directions.Direction.UP_RIGHT: animation_player.play("Attack_up_right")
			Directions.Direction.UP_LEFT: animation_player.play("Attack_up_left")

func exit():
	character.queue_free()

func _on_hit(area):
	if area.is_in_group("player_hurtbox") or area.is_in_group("enemy_hurtbox"):
		bomber_attack.effects = [
			KnockedBackEffect.new(0.1, 200, area.global_position-self.global_position),
			StunnedEffect.new(0.25),
		]
		area.damage(bomber_attack)

func find_player():
	for body in attack_radius.get_overlapping_bodies():
		if body.name == "player":
			player = body

func direction_to_player():
	return(player.global_position - character.global_position).normalized()
