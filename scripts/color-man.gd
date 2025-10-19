class_name ColorMan

const CATPPUCCIN_HEAT: Dictionary = {
    COOL = Color("89B4FA"),
    NEUTRAL = Color("94E2D5"),
    WARM = Color("F9E2AF"),
    HOT = Color("F38BA8"),
}


## Heat map inspired by Catppuccin Mocha Theme
static func get_heat_color(level: float) -> Color:
    level = clamp(level, 0.0, 1.0)
    if level < 0.33:
        return CATPPUCCIN_HEAT.COOL.lerp(CATPPUCCIN_HEAT.NEUTRAL, level / 0.33)
    elif level < 0.66:
        return CATPPUCCIN_HEAT.NEUTRAL.lerp(CATPPUCCIN_HEAT.WARM, (level - 0.33) / 0.33)
    else:
        return CATPPUCCIN_HEAT.WARM.lerp(CATPPUCCIN_HEAT.HOT, (level - 0.66) / 0.34)