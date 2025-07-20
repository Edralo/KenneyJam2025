# Coaster Part Hover System

This system allows players to hover over existing coaster parts with a held coaster part to preview replacement compatibility.

## Components

### 1. GameManager.gd (Singleton)
- Manages the currently held coaster part
- Contains methods to set, get, and clear held parts
- Registered as an autoload singleton

### 2. coaster_part.gd (Enhanced)
- Added hover detection using Area3D
- Shows preview of held part when hovering
- Green preview = compatible replacement (same size)
- Red preview = incompatible replacement (different size)

## How to Use

### Setting up a coaster part to be held:
```gdscript
# Example: Pick up a coaster part
var part_data = {
    "scene": preload("res://path/to/coaster_part.tscn"),
    "size": 1,  # Size must match for replacement
    "name": "Curved Track"
}
GameManager.set_held_coaster_part(part_data)
```

### Clearing the held part:
```gdscript
GameManager.clear_held_coaster_part()
```

### Checking if holding a part:
```gdscript
if GameManager.is_holding_coaster_part():
    # Player is holding something
    pass
```

## Features

- **Hover Detection**: Automatically detects when mouse hovers over coaster parts
- **Preview System**: Shows transparent preview of the held part
- **Compatibility Check**: Green for compatible, red for incompatible
- **Size-based Replacement**: Parts can only replace others of the same size
- **Click to Replace**: Left-click on a compatible part to replace it (TODO: implement actual replacement logic)

## Configuration

Each coaster part should have its `part_size` property set appropriately:
- Size 1: Standard single-tile parts
- Size 2: Double-length parts
- etc.

The hover detection area size can be adjusted in the `setup_hover_detection()` function by modifying the `box_shape.size` property.

## Integration with Roller Coaster System

The hover system works with the existing `roller_coaster.gd` that generates coaster parts in the editor. Each generated part will automatically have hover detection capabilities when the scene includes the updated `coaster_part.gd` script.
