****************** please read ReadMe.md before use **********************

=== Purpose Plugin For Being Prepare tool kit Support Game Data Assests Management ===
	|__. for prepare generate foundation file class and enum after gen
	|__. you can modify generated file as you want 
	|__. plugin still brewing new feature still cook
	
---Text base UI Plugin
	|__. config by JSON For List Class File to Create
	|__. reconstruct class attribute
	|__. generate class attribute
	|__. generate method for compatable with json data
	|__. config by Text File For Class Structure

---Prepare step before use this plugin
	|__. create directory for store godot class file at res:// follow path
		|__. res://assets/resources/scripts/mapper/data_models/
	|__. create directory for archrive json game assets at res:// follow path
		|__. res://assets/resources/data_managements/data/
			|__. create File blueprint.txt
				.----------------------------------.
				|__tab1____________________________| ---> for display at ui
				|__tab2____________________________|
				|__________________________________|
				|__________________________________|
				|__________________________________|
				|__________________________________|
				|__________________________________|
				|__________________________________|
				|__________________________________|
				.----------------------------------.
			|__. create File datastructure.json
				.-----------------------------------.
				|__{________________________________|
				|"tab1":[___________________________|
				|___"attribute_name/input_type",____| ---> for display at ui and construct class file
				|___"attribute_name/drop_down",_____|
				|___"attribute_name/input_rich_text"|
				|__]________________________________|
				|__}________________________________|
				|___________________________________|
				|___________________________________|
				|___________________________________|
				|___________________________________|
				|___________________________________|
				|___________________________________|
				.-----------------------------------.
	|__.convention rule pls read before use this plugin
		|__.please read convention rule for use this plugin		
		|__.config by two file 
			|__.blueprint.txt
			|__.datastruceture.json
		|__.filename base on field that pattern name is  *_name
		|__.filename base on field that pattern name is  *_name must have one field
			ex. 
				"recipes": [
					"id",
					"recipes_name", --------------> on field for this pattern ( *_name )
					"recipes_description",
					"recipes_type",
					"recipes_ingidents",
					"recipes_rarity/drop_down/unidentify,common,uncommon,rare,special,epic,legendary,relic,mythical"  ---------> in case of dropdown value script will create enum file by split with delimiter "," comma
				]
		|__.value in key *_name should be "name_space" instead of "name space" when generate data
			ex.
				{
					"id" : "1",
					"items_name" : "cystal_ore", -----> name
					"items_desc" : "Cystal Ore is quiet popular material for artisan and magus for crafting and alchemy it can be found in deep cave , cavern and mine or monster",
					"item_type" : "consumeable_item",
					"item_tag" : "",
					"item_rarity" : "uncommon",
					"price" : "5000"
				}
		|__.convention preview data icon from plugin 
			# For Your Information : This is minor feature it will not impact plugin performance. It is cosmetic featuew or can be use as a guildline for archive and manage item image storage
			Use Condition (Rule & Conventioning)
			|__. Create Directory Path for image
 				- - - Absolute Path : Drive://project_location/godot_project/assets/resources/images/(tab_name)/display/(data_json.png)
 				- --Project Path : res://assets/resources/images/(tab_name)/display/(data_json.png)
			|__. Image sizing should be 128 * 128 pixel
				
