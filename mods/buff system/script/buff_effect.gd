## 效果影响 - 用于在特定时机被调用产生指定效果
class_name BuffEffect
extends Resource

func apply(buff_info:BuffInfo) -> void:
	print("========================")
	if buff_info.buff_permanent:
		print("效果永久")
	if buff_info.buff_data != null:
		print("效果 %s 生效" % buff_info.buff_data.buff_name)
	if buff_info.buff_target != null:
		print("效果目标 %s" % buff_info.buff_target.name)
	if buff_info.buff_source != null:
		print("效果来源 %s" % buff_info.buff_source.name)
	if buff_info.current_stack != 1:
		print("效果层数 %s" % buff_info.current_stack)
	if buff_info.current_tick_count != 0:
		print("间歇次数 %d" % buff_info.current_tick_count)
	print("========================")
