@tool
extends EditorPlugin

enum MODE {
	NEW,
	EDIT
}

var toolbar
var init_tab_container:TabContainer
var init_button:Button
var data_row_container : VBoxContainer
var edit_data_button:Button
var current_data_sheet_submit_button :Button
var current_data_sheet_edit_submit_button : Button
var dataContainer:VBoxContainer
var edit_data_tab_container: TabContainer
var display_data_item_icon : Sprite2D

var selected_data_item : String = ""

var all_init_tab_child 
var all_edit_tab_child
var page_form_structure
var list_data_table = []
var path = "res://assets/resources/data_managements"
var init_game_db_flag : bool = true

var record_mode : MODE = MODE.NEW

func _enter_tree():
	page_form_structure = JSON.parse_string(FileAccess.open("res://assets/resources/data_managements/datastucture.json",FileAccess.READ).get_as_text())
	# Initialization of the plugin goes here.
	binding_form()
	add_control_to_dock(EditorPlugin.DOCK_SLOT_LEFT_UL,toolbar)
	

func binding_form():
	toolbar = preload("res://addons/GameDatabaseManager/addons_ui/GameDatabaseManager.tscn").instantiate()
	init_button = toolbar.find_child("InitialGameDatabaseButton")
	edit_data_button = toolbar.find_child("EditGeneratedDataFileButton")
	init_tab_container = toolbar.find_child("TabContainer")
	dataContainer = toolbar.find_child("DataContainer")
	edit_data_tab_container = toolbar.find_child("DataTabContainer")
	data_row_container = toolbar.find_child("DataRowContainer")
	display_data_item_icon = toolbar.find_child("IconImage")
	edit_data_button.disabled = init_game_db_flag
	#print("icon name : ",display_data_item_icon.name)
	# load existing generate data
	# retrieve class from blueprint.txt
	set_up_edit_existing_data()
	
	dataContainer.visible = false
	init_button.visible = true
	
	init_button.pressed.connect(
		initial_database_structure
	)
	edit_data_button.pressed.connect(
		edit_generated_data_file
	)

func _ready():
	print("start running plugin") 
	
func _process(delta: float):
	if record_mode == MODE.NEW :
		if all_init_tab_child != null :
			current_data_sheet_submit_button = \
			all_init_tab_child[init_tab_container.current_tab].find_child("SubmitButton")\
			if all_init_tab_child[init_tab_container.current_tab].find_child("SubmitButton") != null else null
			if current_data_sheet_submit_button != null \
			and not current_data_sheet_submit_button.pressed.is_connected(generate_asset_data) :
				current_data_sheet_submit_button.pressed.connect(
					generate_asset_data
				)
	elif record_mode == MODE.EDIT :
		if all_edit_tab_child != null :
			
			toolbar.find_child("DataHeaderLabel").text = "Summary : \\data_managements\\data\\"+all_edit_tab_child[edit_data_tab_container.current_tab].name
			toolbar.find_child("IconFilePathLabel").text = "file path : " + ProjectSettings.globalize_path("res://assets/resources/images/items/display/"+get_selected_data_item().replace(".json","")+".png")
			
			current_data_sheet_edit_submit_button = \
			all_edit_tab_child[edit_data_tab_container.current_tab].find_child("SubmitButton")\
			if all_edit_tab_child[edit_data_tab_container.current_tab].find_child("SubmitButton") != null else null
			
			#print("current_data_sheet_edit_submit_button ",current_data_sheet_edit_submit_button.text)
			if current_data_sheet_edit_submit_button != null \
			and not current_data_sheet_edit_submit_button.pressed.is_connected(edit_asset_data) :
				#print("all_edit_tab_child[edit_data_tab_container.current_tab] ",all_edit_tab_child[edit_data_tab_container.current_tab].name)
				current_data_sheet_edit_submit_button.pressed.connect(
					edit_asset_data
				)
			#print("found ",data_row_container.find_child("bottle"))
		
func check_exist_file():
	pass

func read_config_file():
	var file = FileAccess.open(	"res://assets/resources/data_managements/blueprint.txt", FileAccess.READ)
	list_data_table = file.get_as_text().split("\n")

func write_enum_godot_file(config_data:String):
	#res://assets/resources/scripts/enums/
	#print("size ",config_data.split("/")[2].split(",").size()," list ",config_data.split("/")[2].split(","))
	print("start create enum file for : ",config_data)
	if config_data.split("/").size() != 3:
		return
	if config_data.split("/")[1] != "drop_down":
		return
	if config_data.split("/")[2].split(",").size() == 1 and config_data.split("/")[2].split(",")[0] == "" :
		#print("size ",config_data.split("/")[2].split(",").size()," list ",config_data.split("/")[2].split(","))
		return
		
	var file_name = config_data.split("/")[0]
	var enum_list_input = config_data.split("/")[2].split(",")
	var save_path = ProjectSettings.globalize_path("res://assets/resources/scripts/enums/"+file_name+".gd")
	var file_writer = FileAccess.open(save_path,FileAccess.WRITE)
	var enum_list = ""
	var enum_desc_list = ""
	var enum_value_list = ""
	var start_blanket ="{"
	var end_blanket ="}"
	var enum_declare = "enum "+file_name
	var enum_variable = "const "+file_name.to_upper()+" = "+file_name
	var enum_variable_desc = "const "+file_name+"_desc"+"="+start_blanket+"\n"
	var enum_variable_value = "const "+file_name+"_value"+"="+start_blanket+"\n"
	
	var index = 0 
	for enum_item in enum_list_input:
		enum_list+="\t"+enum_item+",\n"\
		
		if index !=  enum_list_input.size()-1 \
		else "\t"+enum_item+"\n"
		
		enum_desc_list+="\t"+file_name+"."+enum_item+" : "+"\""+enum_item+"\""+",\n"\
		if index !=  enum_list_input.size()-1 \
		else "\t"+file_name+"."+enum_item+" : "+"\""+enum_item+"\""+"\n"
		
		enum_value_list+="\t\""+enum_item+"\""+" : "+file_name+"."+enum_item+",\n"\
		if index != enum_list_input.size()-1 \
		else "\t\""+enum_item+"\""+" : "+file_name+"."+enum_item+"\n"
		
		index+=1
	enum_declare += start_blanket \
	+ "\n"\
	+ enum_list\
	+ end_blanket\
	+ "\n"\
	+ enum_variable_desc\
	+ enum_desc_list \
	+ end_blanket \
	+ "\n"\
	+ enum_variable_value \
	+ enum_value_list \
	+ end_blanket
	
	file_writer.store_string(enum_declare)
	file_writer.close()
	
	print("enum [",file_name,".gd] file content : \n",enum_declare)
	
	pass	
		
func write_script_game_godot_file(file_name:String):
	if file_name == "" or file_name == null :
		print("File name must not empty")
		return
	
	var file_content = []
	var file_class_content = ""
	#print("page_form_structure[file_name] ",page_form_structure[file_name])
	for row in page_form_structure[file_name]:
		file_content.append(row.split("/")[0])
		write_enum_godot_file(row)
		print("write_script_data_game_godot_file row : ",row.split("/")[0])
		
	var save_path = ProjectSettings.globalize_path("res://assets/resources/scripts/mapper/data_models/"+file_name+".gd")
	var file_writer = FileAccess.open(save_path,FileAccess.WRITE)
	print("save godot entity class file : ",save_path)
	var header_file = "class_name "+file_name+"\n\n"
	var file_godot_attribute = ""
	var file_godot_constuctor = ""
	var file_godot_json_constuctor = ""
	var constructor_default = "\nfunc _init():\n"
	var constructor_json = "\nfunc _read_json(json_obj):\n"
	
	print("\n----------------------Log : file_content : ------------------------------\n")
	
	for attribute in file_content:
		file_godot_attribute+="var "+attribute+"\n"
		file_godot_constuctor+="\t"+attribute+" = "+"\"\""+"\n"
		file_godot_json_constuctor+="\t"+attribute+" = json_obj["+"\""+attribute+"\""+"]"+"\n"
		
	file_class_content += header_file\
	+file_godot_attribute\
	+constructor_default\
	+file_godot_constuctor\
	+constructor_json\
	+file_godot_json_constuctor
	
	print("[",file_name,".gd] file content : \n",file_class_content)
	file_writer.store_string(file_class_content)
	file_writer.close()
	pass
	

func write_data_game_json_file(file_name:String,dir:String,file_content:Array):
	if file_name == "" or file_name == null :
		print("File name must not empty")
		return
	var index = 0
	var save_path = ProjectSettings.globalize_path("res://assets/resources/data_managements/data/"+dir+"/"+file_name+".json")
	print("save json data : ",save_path)
	const top_enclosing = "{\n"
	const bot_enclosing = "}"
	var concat_content = ""
	for line in file_content:
		concat_content += line + ( ",\n" if index!= file_content.size()-1 else "\n" )	
		index+=1
	
	concat_content = top_enclosing+concat_content+bot_enclosing
	print("file content : ",concat_content)
	# Open the file for writing
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	if file:
		file.store_string(concat_content)
		file.close()
		print("JSON file saved successfully at: ", save_path)
	else:
		print("Failed to open file for writing.")
		
	#print("list json properties :",JSON.parse_string(concat_content).keys())
	
func edit_asset_data():
	print("Enter Edit Assets Data")
	print("Edit Data In Class : ",toolbar.find_child("DataHeaderLabel").text)		
	edit_exist_asset_data()
	
	
func generate_asset_data():
	print("start procress : "+current_data_sheet_submit_button.text)
	print("current_tab : ",all_init_tab_child[init_tab_container.current_tab].name)	
	var file_contain =[]
	var save_dir = all_init_tab_child[init_tab_container.current_tab].name
	var data_file_name = ""
	for ele in all_init_tab_child[init_tab_container.current_tab].find_child("Frame").get_children():
		if ele.get_child_count() == 2:
			if ele.get_children()[0].text.find("_name") != -1 and data_file_name == "":
				data_file_name = ele.get_children()[1].text		
			file_contain.append("\t"+"\""+ele.get_children()[0].text+"\" : "+"\""+ele.get_children()[1].text+"\"")
			print("\t","\"",ele.get_children()[0].text,"\" : ","\"",ele.get_children()[1].text,"\"")
	write_data_game_json_file(data_file_name,save_dir,file_contain)	
	set_up_edit_existing_data()
# save data in path data/tab_name

func edit_exist_asset_data():
	print("start edit exist asset data procress : "+current_data_sheet_submit_button.text)
	print("current_tab : ",all_edit_tab_child[init_tab_container.current_tab].name)	
	var file_contain =[]
	var save_dir = all_edit_tab_child[init_tab_container.current_tab].name
	var data_file_name = ""
	for ele in all_edit_tab_child[init_tab_container.current_tab].find_child("Frame").get_children():
		if ele.get_child_count() == 2:
			if ele.get_children()[0].text.find("_name") != -1 and data_file_name == "":
				data_file_name = ele.get_children()[1].text		
			file_contain.append("\t"+"\""+ele.get_children()[0].text+"\" : "+"\""+ele.get_children()[1].text+"\"")
			print("\t","\"",ele.get_children()[0].text,"\" : ","\"",ele.get_children()[1].text,"\"")
	write_data_game_json_file(data_file_name,save_dir,file_contain)	


	
func initial_database_structure():
	print("start init")
	if all_init_tab_child == null:
		DirAccess.make_dir_recursive_absolute(path+"/data")
		var dir = DirAccess.open(path)
		var directory_list = dir.get_directories()
		#print('Position : ',dir.get_directories())
		#print("directory_list : ",directory_list)
		read_config_file()
		for list in list_data_table :
			form_build_data_dir(list)
			if list != "data" and list !="" :
				print("tab: ",list)
				form_data_building_ui(list)
				write_script_game_godot_file(list)
		all_init_tab_child = init_tab_container.get_children()
		all_edit_tab_child = edit_data_tab_container.get_children()
		
		init_game_db_flag = false
		edit_data_button.disabled = init_game_db_flag

func form_build_data_dir(list:String):
	var path = "res://assets/resources/data_managements/data"
	if DirAccess.dir_exists_absolute(path+"/"+list) :
		print("already path exist : ",path+"/"+list)
	else:
		print("start create directory : ",path+"/"+list)
		DirAccess.make_dir_recursive_absolute(path+"/"+list)
	pass		

func form_data_building_ui(list:String):
	var page_form = load("res://addons/GameDatabaseManager/addons_ui/PageSetUp.tscn")
	page_form = page_form.instantiate()
	if page_form_structure.has(list): 
		for input_row_text in page_form_structure[list]:
			#print("row : ",input_row_text)
			var input_row
			if  input_row_text.split("/")[1] == "input_text":
				input_row = load("res://addons/GameDatabaseManager/addons_ui/inputDataRow.tscn")
				input_row = input_row.instantiate()
			elif input_row_text.split("/")[1] == "drop_down":
				input_row = load("res://addons/GameDatabaseManager/addons_ui/inputDataRowDropDownList.tscn")
				input_row = input_row.instantiate()
				if input_row_text.split("/").size() ==3 and (input_row_text.split("/")[2] != "" or input_row_text.split("/")[1] == null) :
					for drop_down_item in input_row_text.split("/")[2].split(","):
						input_row.find_child("DropDownInputOptionButton").add_item(drop_down_item)
				input_row.find_child("DropDownInputOptionButton").select(-1)
			elif input_row_text.split("/")[1] == "input_rich_text":
				input_row = load("res://addons/GameDatabaseManager/addons_ui/inputDataText.tscn")
				input_row = input_row.instantiate()
			input_row.name = input_row_text.split("/")[0]
			input_row.find_child("RowLabel").text = input_row_text.split("/")[0]
			page_form.find_child("Frame").add_child(input_row)
			page_form.find_child("Frame").move_child(input_row,get_child_count()-2)
		pass
	page_form.name = list
	page_form.find_child("LabelHeader").text = list.capitalize() +" Data"
	page_form.find_child("SubmitButton").text = "Generate "+list.capitalize() +" Data"
	init_tab_container.add_child(page_form)
	edit_data_tab_container.add_child(page_form.duplicate())

# Set up Edit Label button in case of Edit Existing data
	for edit_tab_page in edit_data_tab_container.get_children():
		edit_tab_page.find_child("SubmitButton").text = edit_tab_page.find_child("SubmitButton").text.replace("Generate","Edit")
		print("edit_tab_page : ",edit_tab_page)
		print("edit_tab_page button : ",edit_tab_page.find_child("SubmitButton").text)

func edit_generated_data_file():
	dataContainer.visible = !dataContainer.visible
	init_tab_container.visible = !init_tab_container.visible
	edit_data_button.text = "Edit Generated Data File" if record_mode == MODE.EDIT else "Add New Generated Data File"
	print("Current MODE ",record_mode)
	record_mode += 1
	record_mode = record_mode % 2
	

func set_up_edit_existing_data():
	read_config_file()
	for row in data_row_container.get_children() :
		row.free()
	if list_data_table != null :
		for sub_dir in list_data_table :
			var data_category_path = "res://assets/resources/data_managements/data/"+sub_dir
			print("list file in ",sub_dir,"\n",DirAccess.get_files_at(ProjectSettings.globalize_path(data_category_path)))
			for data_file in DirAccess.get_files_at(ProjectSettings.globalize_path(data_category_path)) :
				print("data in ",sub_dir," -> file name : ",data_file)
				var data_button : Button = Button.new()
				data_button.text = data_file.replace(".json","").replace("_"," ")
				data_button.name = data_file.replace(".json","")
				data_button.pressed.connect(
					func(): 
						set_selected_data_item(data_file)
						set_current_tab_by_select_data(sub_dir,data_category_path+"/"+data_file)
						print("start to select ",data_file," for edit")
				)
				data_row_container.add_child(data_button)
	elif list_data_table == null :
		print("Generate Data not Exist")
	pass

func set_selected_data_item(data_item_name) : 
	selected_data_item = data_item_name
	
# need to fix and refine logic
func set_current_tab_by_select_data(tab_name,file_path) :
	var index = 0
	var json_data_file = JSON.parse_string(FileAccess.open(file_path,FileAccess.READ).get_as_text())
	print("file godot location : ",file_path)
	print("originate file locatio : ",ProjectSettings.globalize_path(file_path))
	print("file data : ",json_data_file)
	for tab in edit_data_tab_container.get_children() :
			if tab.name == tab_name :
				edit_data_tab_container.current_tab = index
				break
			index+=1
	for data_row in all_edit_tab_child[edit_data_tab_container.current_tab].get_child(0).get_children() : 
		# skip header footer
		if data_row.name != "LabelHeader" and data_row.name != "SubmitButton" :
			#print("row name ",data_row.name)
			#print("row label ",data_row.get_child(0).text)
			for key in json_data_file :
				if key == data_row.name :
					data_row.get_child(1).text = json_data_file[key]
					if data_row.name.contains("_name") :
						data_row.get_child(1).editable = false	
	display_data_item_icon.texture = set_icon_image(file_path.split("/")[file_path.split("/").size()-1].replace(".json",".png"))
		
func get_selected_data_item() : 
	return selected_data_item	
	
func set_icon_image(item_name):
	var icon_image = Image.new()
	var item_display_image_texture = ImageTexture.new()
	var result = icon_image.load("res://assets/resources/images/items/display/"+item_name)
	if result == OK :
		return item_display_image_texture.create_from_image(icon_image)
	else :
		result = icon_image.load("res://addons/GameDatabaseManager/addons_ui/defaultImage.png")
		return item_display_image_texture.create_from_image(icon_image)
		
func _exit_tree():
	# Clean-up of the plugin goes here.
	remove_control_from_docks(toolbar)
	#remove_control_from_container(EditorPlugin.CONTAINER_TOOLBAR,toolbar)
	toolbar.free()
	pass
