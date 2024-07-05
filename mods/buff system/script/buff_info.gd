## 用于存储已存在的效果,通常不作为参数传递
class_name BuffInfo
extends Resource

var buff_data:BuffData ## 效果数据
var buff_target:Node ## 效果目标
var buff_source:Node ## 效果来源
var buff_permanent:bool ## 是否永久
var current_stack:int ## 当前效果叠层
var current_tick_count:int ## 当前间歇已触发次数
var current_tick_remain:float ## 当前剩余的间歇时间
var current_duration_remain:float ## 当前剩余的持续时间

func _init(
	_buff_data:BuffData,
	_buff_target:Node,
	_buff_source:Node,
	_buff_permanent:bool,
	_buff_stack:int,
	_tick_count:int,
	_tick_remain:float,
	_duration_remain:float,
	):
	buff_data = _buff_data
	buff_target = _buff_target
	buff_source = _buff_source
	buff_permanent = _buff_permanent
	current_stack = _buff_stack
	current_tick_count = _tick_count
	current_tick_remain = _tick_remain
	current_duration_remain = _duration_remain
