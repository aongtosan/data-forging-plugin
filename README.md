****************** please read ReadMe.md before use ********************** <br/>
<br/>
=== Purpose Plugin For Being Prepare tool kit Support Game Data Assests Management === <br/>
	|. for prepare generate foundation file class and enum after gen <br/>
	|__. you can modify generated file as you want <br/>
	|__. plugin still brewing new feature still cook <br/>
<br/>	
---Text base UI Plugin <br/>
	|__. config by JSON For List Class File to Create <br/>
	|__. reconstruct class attribute <br/>
	|__. generate class attribute <br/>
	|__. generate method for compatable with json data <br/>
	|__. config by Text File For Class Structure <br/>
<br/>
---Prepare step before use this plugin <br/>
	|__. create directory for store godot class file at res:// follow path <br/>
		|__. res://assets/resources/scripts/mapper/data_models/ <br/>
	|__. create directory for archrive json game assets at res:// follow path <br/>
		|__. res://assets/resources/data_managements/data/ <br/>
			|__. create File blueprint.txt <br/>
				.----------------------------------. <br/>
				|__tab1____________________________| ---> for display at ui <br/>
				|__tab2____________________________| <br/>
				|__________________________________| <br/>
				|__________________________________| <br/>
				|__________________________________| <br/>
				|__________________________________| <br/>
				|__________________________________| <br/>
				|__________________________________| <br/>
				|__________________________________| <br/>
				.----------------------------------. <br/>
			|__. create File datastructure.json <br/>
				.-----------------------------------. <br/>
				|__{________________________________| <br/>
				|"tab1":[___________________________| <br/>
				|___"attribute_name/input_type",____| ---> for display at ui and construct class file <br/>
				|___"attribute_name/drop_down",_____| <br/>
				|___"attribute_name/input_rich_text"| <br/>
				|__]________________________________| <br/>
				|__}________________________________| <br/>
				|___________________________________| <br/>
				|___________________________________| <br/>
				|___________________________________| <br/>
				|___________________________________| <br/>
				|___________________________________| <br/>
				|___________________________________| <br/>
				.-----------------------------------. <br/> 
	|__.convention rule pls read before use this plugin <br/>
		|__.please read convention rule for use this plugin		<br/>
		|__.config by two file <br/>
			|__.blueprint.txt <br/>
			|__.datastruceture.json <br/> 
		|__.filename base on field that pattern name is  *_name <br/>
		|__.filename base on field that pattern name is  *_name must have one field <br/> 
			ex. <br/> 
				"recipes": [ <br/>
					"id", <br/>
					"recipes_name", --------------> on field for this pattern ( *_name ) <br/>
					"recipes_description", <br/>
					"recipes_type", <br/>
					"recipes_ingidents", <br/>
					"rarity" <br/>
				] <br/>
		|__.value in key *_name should be "name_space" instead of "name space" when generate data <br/>
			ex. <br/>
				{ <br/>
					"id" : "1", <br/>
					"items_name" : "cystal_ore", -----> name <br/>
					"items_desc" : "Cystal Ore is quiet popular material for artisan and magus for crafting and alchemy it can be found in deep cave , cavern and mine or monster", <br/>
					"item_type" : "consumeable_item", <br/>
					"item_tag" : "", <br/>
					"item_rarity" : "uncommon", <br/>
					"price" : "5000" <br/>
				} <br/>
				
