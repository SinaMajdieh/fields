extends Node2D
class_name Charges

@export var charges_numbers: int = 1
var charges: Array[Charge]

func _ready() -> void:
    generate_random_charges(charges_numbers)

func _process(_delta: float) -> void:
    update_charges_velocity()

func get_total_electric_field_at(pos: Vector2, ignore: Charge = null) -> Vector2:
    var total_field: Vector2 = Vector2.ZERO
    for charge: Charge in charges:
        if ignore == charge:
            continue
        if not charge:
            continue
        total_field += charge.get_electric_field_at(pos)
    return total_field

func update_charges_velocity() -> void:
    for charge: Charge in charges:
        if not charge:
            continue
        var electric_field: Vector2 = get_total_electric_field_at(charge.charge_position, charge)
        charge.velocity += charge._get_scaled_charge() / charge.mass * electric_field


func generate_random_charges(num: int = 1) -> void:
    for i: int in range(num):
        var charge: Charge = Charge.create(
            randi_range(0, 1),
            Vector2(
                randf() * get_viewport_rect().size.x,
                randf() * get_viewport_rect().size.y,            
            ),
        )
        charges.append(charge)
        add_child(charge)