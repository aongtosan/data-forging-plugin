# 🚀 Data Forging Plugin - Complete Handbook

A comprehensive guide to the **Data Forging** (Game Database Manager) plugin for Godot Engine. This toolkit provides an EditorPlugin GUI for managing game data assets including RPG components like items, characters, recipes, skills, equipment, dungeons and loot tables in your project.


---
## Table of Contents

1. [Introduction](#introduction)
2. [Features Overview](#features-overview)
3. [Installation & Setup](#installation--setup)
4. [Configuration Files Explained](#configuration-files-explained)
5. [Usage Workflow Guide](#usage-workflow-guide)
6. [File Format Specifications](#file-format-specifications)
7. [Code Architecture Deep Dive](#code-architecture-deep-dive)
8. [Best Practices & Conventions](#best-practices--conventions)
9. [FAQ / Troubleshooting](#faq--troubleshooting)

---

## Introduction

### What is Data Forging?

Data Forging is a Godot EditorPlugin that streamlines the creation and management of game data assets through an intuitive text-based UI directly within the editor. It automatically generates:
- **Foundation Class Files** - GDScript resource classes for each asset type
- **Enum Definitions** - Type-safe enums with description maps  
- **JSON Asset Files** - Structured metadata storage in organized folders

### Who Is This For?

Developers building RPG games, visual novel projects, or any game requiring structured data management. The plugin helps maintain consistency across large codebases by auto-generating boilerplate and enforcing conventions.


---
## Features Overview

| Feature | Description |
|---------|-------------|
| **Text-Based UI** | No complex menus - everything accessible via toolbar dialogs in the editor |
| **Auto-Generate Classes** | Creates GDScript resource classes with proper attributes from JSON config |  
| **Enum Generation** | Automatically creates enum files for drop-down fields (e.g., rarity types, career paths) |
| **Visual Forms** | Pre-configured form layouts per tab - drag-and-drop input elements in UI preview |
| **JSON Storage** | Assets saved as individual `.json` files following naming conventions |  
| **Edit Existing Data** | Select generated assets to modify them before saving back to JSON |
| **Merge Functionality** | Combine scattered data into consolidated file (feature available but incomplete) |

### Supported Asset Types


Currently supported categories include:
- `items` - Equipment, consumables, key items with rarity and pricing  
- `characters` - NPCs with stats like STR/AGI/intelligence and career paths
  - passive, active skills 
    - Passive / Active skill types


---
## Installation & Setup

### Prerequisites

1. Godot Engine version 4.x (tested on v4.*)  
2. An existing or new Godot project with: 
   - `project.godot` file configured properly
   - Editor plugin directory structure (`addons/`) accessible

**No compilation step required!** The plugin installs directly into your Godot addons folder as a `.gd` script plus scene resources in the same parent path.


### Step-by-Step Installation

#### 1. Copy Plugin to Project Structure  
Place `GameDatabaseManager/` (including all subdirectories) inside:
```bash
YOUR_PROJECT/addons/GameDatabaseManager/
```

The plugin is a **single-file** EditorPlugin where everything loads from one `.gd` script (`GameDatabaseManager.gd`). The GUI toolbar is built from scene resources and added to the left side dock when activated.


#### 2. Configure Plugin Settings  
In Godot's editor, enable Data Forging in project settings:
1. **Project → Project Settings**
2. Navigate to `autoloads` section (or search for data_for) 
3. Locate plugin config file (`plugin.cfg`) entry under `[editor_plugins/enabled]`:
   ```ini
   [editor_plugins/enabled]
   
   path=addons/GameDatabaseManager/plugin.cfg
   name="Data-Forging"
   # or enable via project.godot: res://project.godot (add plugin.cfg line there instead)

```


#### 3. Create Required Directories  
The plugin expects these folders to exist before first use:
- `res://assets/resources/scripts/mapper/data_models/` — stores generated class files
- `res://assets/resources/data_managements/data/`     — archives JSON asset data per category  

> **Tip**: Use the toolbar → "Initial Game Database" button (shown in plugin docs) which auto-creates these directories and begins form building. The first-time initialization will call `_enter_tree()` which instantiates a new EditorPlugin, wire submit buttons to handlers (`generate_asset_data` / `edit_asset_data`) for New/Edit modes via shared state across scenes using same resource type with identical keys from JSON blob into class property (see code comments in GameDatabaseManager.gd around line 247-259).


#### 4. Create Configuration Files

##### a) Create Blueprint.txt  
Edit `assets/resources/data_managements/blueprint.txt`:
```ini
items
    
characters 
  
skills 
events  
recipes 

furniture
equipment    
dialogues
  
world_objects

