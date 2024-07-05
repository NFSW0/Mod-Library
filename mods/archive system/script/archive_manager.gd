class_name ArchiveManager

enum ARCHIVE_TYPE{ player, world, entity, achievement, setting }

const archive_path = "user://archive"
const archive_pass = "example_password"

static func get_archive_array() -> PackedStringArray:
	var dir = DirAccess.open(archive_path)
	if dir:
		return dir.get_directories()
	return [] # user://archive/...

static func get_archive_data(archive_name:String,archive_type:ARCHIVE_TYPE) -> Dictionary:
	var archive_data_path = archive_path.path_join(archive_name).path_join(str(archive_type) + ".json")
	if FileAccess.file_exists(archive_data_path):
		var file_access = FileAccess.open_encrypted_with_pass(archive_data_path,FileAccess.READ,archive_pass)
		var json_data = file_access.get_as_text()
		return JSON.parse_string(json_data)
	return {} # user://archive/.../....json

static func save_archive_data(archive_name:String,archive_type:ARCHIVE_TYPE,data:Dictionary) -> void:
	# 目录检查
	var archive_data_directory_path = archive_path.path_join(archive_name)
	if not DirAccess.dir_exists_absolute(archive_data_directory_path):
		DirAccess.make_dir_recursive_absolute(archive_data_directory_path)
	# 数据添加
	var archive_data_path = archive_data_directory_path.path_join(str(archive_type) + ".json")
	var file_access = FileAccess.open_encrypted_with_pass(archive_data_path,FileAccess.WRITE,archive_pass)
	file_access.store_string(JSON.stringify(data))
