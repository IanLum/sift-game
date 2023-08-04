class_name HurtboxComponent
extends Area2D

@export var health_component: HealthComponent
signal effect_applied

func damage(attack: Attack):
	if health_component:
		health_component.damage(attack)
		if not attack.effects.is_empty():
			emit_signal("effect_applied", attack.effects)
