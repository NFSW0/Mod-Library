## 效果数据 - 用于定义一个效果的静态数据
class_name BuffData extends Resource

enum BuffTag{}

@export var buff_id:int ## 效果编号
@export var buff_name:String ## 效果名称
@export var buff_icon:Texture2D ## 效果图标
@export var buff_tags:Array[String] ## 效果标签
@export var buff_max_stack:int ## 效果最大叠层
@export var buff_description:String ## 效果描述
@export var buff_max_duration:float ## 效果最大持续时间
@export var buff_tick_interval:float ## 效果间歇时间

@export var buff_effect_on_append:Array[BuffEffect] ## 效果添加事件
@export var buff_effect_on_tick:Array[BuffEffect] ## 效果间歇事件
@export var buff_effect_on_erase:Array[BuffEffect] ## 效果移除事件
