extends Node2D


const OBJECT_SCENES: Dictionary[Constants.ObjectType, PackedScene] = {
	Constants.ObjectType.BULLET_PLAYER: preload("uid://patnsbb3rdpo"),
	Constants.ObjectType.BULLET_ENEMY: preload("uid://bt600i2f8xiol"),
	Constants.ObjectType.EXPLOSION: preload("uid://ck35b3ykguxey"),
	Constants.ObjectType.PICKUP: preload("uid://gvwdmqgt0abc")
}


func _enter_tree() -> void:
	SignalHub.create_bullet.connect(on_create_bullet)
	SignalHub.create_object.connect(on_create_object)
	

func on_create_bullet(new_position: Vector2, new_direction: Vector2, speed: float, ob_type: Constants.ObjectType) -> void:
	if !OBJECT_SCENES.has(ob_type):
		return
		
	var newBullet: Bullet = OBJECT_SCENES[ob_type].instantiate()
	newBullet.setup(new_position, new_direction, speed)
	call_deferred("add_child", newBullet)


func on_create_object(new_position: Vector2, ob_type: Constants.ObjectType) -> void:
	if !OBJECT_SCENES.has(ob_type):
		return
	
	var entity = OBJECT_SCENES[ob_type].instantiate()
	entity.global_position = new_position
	call_deferred("add_child", entity)
