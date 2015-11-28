更新至 11.23

已实现功能：
1.初次启动自动定位当前地点，生成第一页；
2.页面更新，增加，删除；
3.重复添加页面时会有提示。

已知问题：
1.添加页面尚未实现搜索功能；
2.启动后的需要手动第一次更新；
3.背景不会根据天气信息进行切换。

开发日志

11/19
1.Area 要进行归档，用数组存储城市记录来加快加载。
2.尽可能想办法存储天气数据
3，地区搜索算法和添加界面

11/22
更新:
1.地区归档完成。
2.整合了实时天气和每日天气的数据类型，采用统一的数据接口。
3.增加搜索页面。在固定数据为北京时，页面跳转，增加新页面，处理重复添加都没有问题。

TODO:
1 搜索页面
1.1 搜索算法还存在问题。
1.2 页面的点击触发也没有完成，没有办法添加所选城市。
1.3 地区按字母分组。
2 数据
2.1由于实时天气数据不提供发布时间，要自行计算。
2.2 申请一个私用接口，并限定更新频率，避免频繁刷新导致数据异常。
2.2.1忽略过于频繁的刷新
3 背景
3.1 实现切换逻辑
3.2 改用AvPlayer,优化性能
4 等待
4.1 刷新页面时更新按钮旋转
5 线程
5.1 优化更新数据线程
5.2 在保持快速进入应用的前提下，实现启动后自动进行第一次更新，现在要手动。

处理顺序
1.2 / 2.2.1  /3.1/ 2.1/ 3.2 /1.1 /4.1/5.2 / 2.1 / 1.3/ 5.1

预想处理思路
1.2
(1)didSelectRowOfIndexpath
(2)_tableSource objOfIndex
(3)dismissWithActionBlock
(3)self.pagedelegate addArea

2.2.1
(1)static NSDate* lastUpdateTime = dateSince1970:0
(2)if(lastUpadteTime > secondOfHour) {
	     upadateDateAndPage;
		      lastUpdateTime = dateSinceNow:0
}else{
}

3.1
(1)int  sourceNum =   currentWeather.weatid;
(2)(NSString*)sourceNameByNum
(3)_backgronud setSourceName

2.1  page.time = lastUpdateTime (首次更新完之

3.2
(1)信息收集 AvPlayer  Assert Replace
(2)TestBackground测试类，单元测试
(3)重构Background,测试

1.1
(1)单元测试，调试遍历搜索
(2)禁用模糊搜索，调试主搜索算法，以及页面表现
(3)单元测试模糊搜索，调试
(4)主搜索添加模糊搜索，单元测试
(5)测试页面表现

4.1
layer anime

11.23
跟新：
1.实现点击添加
2.忽略过于频繁的更新
3.现在周天气会根据获取的数据来动态调整显示



//do something to test
