extends Node2D
class_name Charge

enum Type {
    ELECTRON,
    PROTON,
}

const K: float = 8.9875517923e9  # Coulomb constant
const MU_0: float = 4 * PI * 1e-7  # Magnetic constant

@export var charge_position: Vector2 = Vector2.ZERO
@export var type: Type = Type.ELECTRON
@export var velocity: Vector2 = Vector2.ZERO
@export var mass: float = 1.0  # Optional, for force-based motion

# Scales the computed electric field strength for visualization purposes.
# Real-world values are extremely small (~10^-19 C), so this multiplier brings them into a usable range.
@export var strength_multiplier: float = 10e-6

static func create(
    type_: Type = Type.ELECTRON, 
    pos: Vector2 = Vector2.ZERO, 
    velocity_: Vector2 = Vector2.ZERO
) -> Charge:
    var charge: Charge = Charge.new()
    charge.type = type_
    charge.charge_position = pos
    charge.velocity = velocity_
    return charge

func get_electric_field_at(pos: Vector2) -> Vector2:
    var r: Vector2 = pos - charge_position
    var r_length_sq: float = r.length_squared()
    
    # Avoid singularity
    if r_length_sq < 1.0:
        return Vector2.ZERO
    
    var q: float = _get_scaled_charge()
    return (K * q / r_length_sq) * r.normalized() * strength_multiplier

func _process(delta: float) -> void:
    update_position(delta)

func update_position(delta: float) -> void:
    charge_position += velocity * delta
    keep_in_bounds()    # for testing purposes

## Not scientifically accurate
## For testing purposes
func keep_in_bounds() -> void:
    var bounds: Vector2 = get_viewport_rect().size
    if charge_position.x < 0 or charge_position.x > bounds.x:
        charge_position.x = clamp(charge_position.x, 0.0, bounds.x)
    if charge_position.y < 0 or charge_position.y > bounds.y:
        charge_position.y = clamp(charge_position.y, 0.0, bounds.y)

# === Helpers ===

func _get_scaled_charge() -> float:
    return get_scaled_charge(type)


static func get_scaled_charge(charge_type: Type) -> float:
    match charge_type:
        Type.ELECTRON:
            # Returns a scaled charge value for simulation purposes.
            # Real charge is ~1.6e-19 C, but we use -1.6 and scale later for visual clarity.
            return -1.6
        Type.PROTON:
            return 1.0
        _:
            return 0.0