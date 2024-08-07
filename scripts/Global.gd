extends Node

var inventory = []
var player_node: Node = null

@onready var INVENTORY_SLOT = preload("res://scenes/inventory_slot.tscn")

signal inventory_updated

func _ready() -> void:
	inventory.resize(30)

# 增加物品
func add_item(item):
	for i in range(inventory.size()):
		if inventory[i] != null and inventory[i]["item_type"] == item["item_type"] and inventory[i]["item_effect"] == item["item_effect"]:
			inventory[i]["quantity"] += item["quantity"]
			inventory_updated.emit()
			print("进入物品堆叠数量修改！")
			return true
		elif inventory[i] == null:
			inventory[i] = item
			inventory_updated.emit()
			print("进入新增")
			return true
	return false

# 删除物品
func remove_item(item_type,item_effct):
	for i in range(inventory.size()):
		print("当前参数：" + item_type + "," + item_effct)
		print("------")
		print(inventory[i])
		if inventory[i] != null and inventory[i]["item_type"] == item_type and inventory[i]["item_effect"] == item_effct:
			print("------")
			print("对数据进行--")
			inventory[i]["quantity"] -= 1
			print("--完成")
			if inventory[i]["quantity"] <= 0:
				print("进入置空")
				inventory[i] = null
			inventory_updated.emit()
			return true
	return false

# 增加库存容量
func increase_inventory_size():
	inventory_updated.emit()

func set_player_reference(player):
	player_node = player

func adjust_drop_position(position):
	var radius = 100
	var nearby_items = get_tree().get_nodes_in_group("Items")
	for item in nearby_items:
		if item.global_position.distance_to(position) < radius:
			var random_offset = Vector2(randf_range(-radius,radius),randf_range(-radius,radius))
			position += random_offset
			break
	return position

# 丢弃物品
func drop_item(item_data,drop_position):
	var item_scene = load(item_data["scenes_path"])
	var item_instance = item_scene.instantiate()
	item_instance.set_item_data(item_data)
	drop_position = adjust_drop_position(drop_position)
	item_instance.global_position = drop_position
	get_tree().current_scene.add_child(item_instance)
