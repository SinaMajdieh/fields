extends Node2D
class_name Charge

enum Type {
    ELECTRON,
    PROTON,
}

const K: float = 8.9875517923e9  # Coulomb constant

@export var charge_position: Vector2 = Vector2.ZERO
@export var type: Type = Type.ELECTRON
# Scales the computed electric field strength for visualization purposes.
# Real-world values are extremely small (~10^-19 C), so this multiplier brings them
@export var strength_multiplier: float = 10e-7 

func get_electric_field_at(pos: Vector2) -> Vector2:
    var r: Vector2 = pos - charge_position
    var r_length_sq: float = r.length_squared()
    
    # Avoid singularity
    if r_length_sq < 1.0:
        return Vector2.ZERO
    
    var q: float = _get_scaled_charge()
    return (K * q / r_length_sq) * r.normalized() * strength_multiplier


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