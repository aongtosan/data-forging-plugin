
# 🔧 Data Forging Plugin for Godot

---

## 🚧 Status

This plugin is **in early development**. Expect more features and improvements soon.

---

**⚠️ Please read this README before using the plugin.**

---

## 🎯 Purpose

This toolkit supports **Game Data Assets Management** in Godot.

- Generates foundation class and enum files
- Generated files are editable/customizable
- Plugin is still in development ("cooking")

---

## 🧩 Features – Text-Based UI Plugin

- Configurable via JSON for a list of class files to create
- Supports:
  - Reconstructing class attributes
  - Generating attributes and methods compatible with JSON data
- Also configurable via plain text file

---

## 🧰 Setup Before Use

### 1. Create directories:

```bash
res://assets/resources/scripts/mapper/data_models/        # For generated Godot classes
res://assets/resources/data_managements/data/             # For archived game data (JSON)
```

---

### 2. Create `blueprint.txt`

> Used for UI display tabs

```
tab1
tab2
...
```

---

### 3. Create `datastructure.json`

> Used for UI form layout and class file structure

```json
{
  "tab1": [
    "attribute_name/input_type",        // Used to construct form field and class variable
    "attribute_name/drop_down",
    "attribute_name/input_rich_text"
  ]
}
```

---

## ⚙️ Conventions & Rules

> Please follow these conventions when using the plugin:

### File Configuration

- Uses **two files**:
  - `blueprint.txt`
  - `datastructure.json`

### Filename Patterns

- At least one field must end with `_name`
- Example:

```json
"recipes": [
  "id",
  "recipes_name",            // <- Required pattern (*_name)
  "recipes_description",
  "recipes_type",
  "recipes_ingredients",
  "rarity"
]
```

### Naming Style for Values

- Values under `*_name` keys should use **underscores** (`_`) instead of **spaces**
- Example:

```json
{
  "id": "1",
  "items_name": "crystal_ore",          // <- Use underscores, not spaces
  "items_desc": "Crystal Ore is quite popular among artisans and magi for crafting and alchemy. Found in caves, caverns, or dropped by monsters.",
  "item_type": "consumable_item",
  "item_tag": "",
  "item_rarity": "uncommon",
  "price": "5000"
}
```



