extends CharacterBody2D

@export var speed: float = 120.0
@export var acceleration: float = 0.05
@export var target_player_path: NodePath

var target_player: Node2D = null
var players_in_range: Array[Node2D] = []

func _ready() -> void:
	if target_player_path != NodePath(""):
		target_player = get_node_or_null(target_player_path) as Node2D

	if target_player == null:
		_pick_nearest_player()

func _physics_process(_delta: float) -> void:
	if target_player == null or not is_instance_valid(target_player):
		_pick_nearest_player()

	var should_chase := target_player != null and players_in_range.has(target_player)

	if should_chase:
		var direction := (target_player.global_position - global_position).normalized()
		velocity = velocity.lerp(direction * speed, acceleration)
	else:
		velocity = velocity.lerp(Vector2.ZERO, acceleration)

	move_and_slide()

func _on_detection_zone_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return

	if not players_in_range.has(body):
		players_in_range.append(body)

	# If no explicit target was set, prefer the nearest player currently in range.
	if target_player_path == NodePath(""):
		target_player = _get_nearest_from(players_in_range)

func _on_detection_zone_body_exited(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return

	players_in_range.erase(body)

	if body == target_player:
		if players_in_range.size() > 0:
			target_player = _get_nearest_from(players_in_range)
		else:
			target_player = null

func _pick_nearest_player() -> void:
	var all_players := get_tree().get_nodes_in_group("player")
	target_player = _get_nearest_from(all_players)

func _get_nearest_from(list: Array) -> Node2D:
	var nearest: Node2D = null
	var nearest_dist := INF

	for node in list:
		if node is Node2D and is_instance_valid(node):
			var d := global_position.distance_squared_to(node.global_position)
			if d < nearest_dist:
				nearest_dist = d
				nearest = node

	return nearest
