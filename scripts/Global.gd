extends Node

var inventory = []
var player_node: Node = null

@onready var INVENTORY_SLOT = preload("res://scenes/inventory_slot.tscn")

signal inventory_updated

func _ready() -> void:
	inventory.resize(30)

# 增加物品
func add_item(item):
	print("当前数组长度为：",inventory.size())
	for i in range(inventory.size()):
		if inventory[i] != null and inventory[i]["item_type"] == item["item_type"] and inventory[i]["item_effect"] == item["item_effect"]:
			inventory[i]["quantity"] += item["quantity"]
			inventory_updated.emit()
			print("进入物品堆叠数量修改！")
			return true
		elif inventory[i] == null:
			inventory[i] = item
			inventory_updated.emit()
			print("进入新增，当前数组值为：", inventory)
			return true
	return false

# 删除物品
func remove_item():
	inventory_updated.emit()

# 增加库存容量
func increase_inventory_size():
	inventory_updated.emit()

func set_player_reference(player):
	player_node = player
