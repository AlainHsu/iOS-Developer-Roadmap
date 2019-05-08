[TOC]

# iOS Developer Roadmap

## Table of contents


## iOS Development Technology
![ESSENTIAL ROADMAP](/Assets/ESSENTIALROADMAP.png)
### UI
#### UITableView
- 重用机制
	![TableView_Reuse](/Assets/TableView_Reuse.png)
	- [索引条实现](/UI/TableVIew_Reuse)
- 数据源同步
	- 并发访问,数据拷贝
	![Concurrent_CopyData](/Assets/Concurrent_CopyData.png)
		- PS:进行数据拷贝会占用内存空间,数据量大的时候存在内存开销问题	- 串行访问
	![Serial_dataSync](/Assets/Serial_dataSync.png)
		- PS:需要等待子线程处理任务,耗时任务时会导致延时

#### 事件传递&视图响应链
- UIView&CALayer
	- UIView为其提供内容,以及负责处理触摸等事件,参与响应链; CALayer 负责显示内容 contents
	- 体现了系统在设计上运用了单一职责原则
- 事件传递
	
	```objectivec
	-(UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event;
	-(BOOL)pointInside(CGPoint)point withEvent:(UIEvent*)event;
	```
	- 系统实现
	![HitTest_Flow](/Assets/HitTest_Flow.png)
		- PS:倒序遍历子视图
- 视图响应链
		
	```objectivec
	-(Void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event;
	-(Void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event;
	-(Void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event;
	```
	- 系统实现
	![Responder_Chain](/Assets/Responder_Chain.png)
		
- 例子
	![View_Event](/Assets/View_Event.png)
	
	- 事件传递顺序: UIApplication -> UIWindow -> View A -> View B2 -> View C2
	- 响应链传递顺序: View C2 -> View B2 -> View A -> ... -> UIApplication -> Ignore

#### 图像显示原理
![Display_concept](/Assets/Display_concept.png)
- CPU 和 GPU 两个硬件是通过总线连接起来. CPU 输出位图, 经由总线在合适的时间上传给 GPU, GPU 会做相应的图层渲染,纹理合成, 之后把结果放到帧缓冲区当中,由视频控制器根据 V-Sync(垂直同步) 信号在指定时间之前去提取对应帧缓冲区当中的屏幕显示内容,然后最终显示到屏幕上面
![Display_overall](/Assets/Display_overall.png)
- CPU 工作
	- Layout
		- UI 布局
		- 文本计算 (frame, etc.)
	- Display
		- 绘制 (drawRect)
	- Prepare
		- 图片编解码 (image 不能直接显示到 UIImageView 需要解码)
	- Commit
		- CoreAnimation 提交最终位图
- GPU 渲染管线
	- 经过 顶点着色 -> 图元装配 -> 光栅化 -> 片段着色 -> 片段处理 将最终的像素点提交到对应的帧缓冲区当中

#### 卡顿&掉帧
- UI 卡顿,掉帧的原因: 没有在 16.7ms 内准备好下一帧的画面
	![Delay_reason](/Assets/Delay_reason.png)
- 滑动优化方案
	- CPU
		- 在子线程中做 对象创建,调整,销毁
		- 预排班(在子线程中做布局计算,文本计算)
		- 预渲染(文本等异步绘制,图片编解码等)
	- GPU
		- 纹理渲染(避免离屛渲染,因为会增加 GPU 工作量,可能导致 CPU 和 GPU 工作总耗时超过16.7ms 导致掉帧)
			- On-Screen Rendering
				- 在当前屏幕渲染,指的是 GPU 的渲染操作是在当前用于显示的屏幕缓冲区中进行的
			- Off-Screen Rendering
				- 离屛渲染,指的是 GPU 在当前屏幕缓冲区以外新开辟一个缓冲区进行渲染操作
				- 触发场景
					- 圆角(当和 maskToBouns 一起使用时)
					- 图层蒙版
					- 阴影
					- 光栅化
		- 视图混合(减小图层复杂性)

#### 绘制原理&异步绘制
- 绘制原理
	![Draw_overall_flow](/Assets/Draw_overall_flow.png)
	- 不会立即调用 setNeedsDisplay, 会等到下一个 Runloop
- 系统绘制流程
	![Draw_system_draw](/Assets/Draw_system_draw.png)
- 异步绘制流程
	- 当 layer 的代理实现 displayLayer 方法的时候出发异步绘制

	```objectivec
	-[layer.delegate displayLayer:]
	```
	- 代理负责生成对应的 bitmap
	- 设置该 bitmap 作为 layer.contents 属性的值
	![Draw_async_draw](/Assets/Draw_async_draw.png)

### Objective-C language
#### //TODO

### Runtime
#### //TODO

### Memory management
#### //TODO

### Block
#### //TODO

### MultiThreading
#### //TODO

### RunLoop
#### //TODO

### Network
#### //TODO

### Design patterns
#### //TODO

### Architecture patterns
#### //TODO

### Algorithm
#### //TODO

### Third-party libraries
#### //TODO

## Development Process
### Full App Development Process
- Project Kickoff
    - Responsibility Matrix
        + Sign-off with all involved parties
    - High Level Product Requirement Documents
        + Feature list
        + UI Concepts / Wireframe / UI design first draft
        + Sign-off by Customer
    - Timeline -  Milestones
        + Aligned with product schedule
        + Sign-off by SW PM
    - Resource allocation
       + Sign-off by SW PM
- Pre-Alpha
    - Technical Design Document
        + High level technical design
        + First draft
     - Test Plan
- Alpha
    - UI/UX Review Cycle 
        + Customer / UI/UX designer review and feedback
     - QA Cycle
- Beta
    - Feature freeze
    - IOP(interoperability) Plan
- Goldmaster
    - IOP(interoperability) report
    - Known issues list
    - Code freeze
    - Apple App Store approval materials
    - App store / Google Play Store / Amazon App Store metadata and artworks
    - Distribution Certificate
    - Stakeholders sign off

### SDK Release Process
- SDK Alpha Release (Initial release for Developer Preview. Multiple cycle)
    1. SDK libraries 

- SDK Beta Release (APIs freeze. Document stable. Could be Multple cycles)¶
    1. SDK Libraries
    2. APIs / Interface Document
    3. Programming Guide (with specification)

- SDK Final Release (Stable release)
    1. SDK Libraries
    2. API / Interface Document
    3. Programming Guide (With specification)
    4. Technical Design Document

### Development
- [Code Standard](https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/CodingGuidelines/CodingGuidelines.html)
- [Versioning](https://semver.org)
- Source Control Management (Version Control)
    + Commit Often
    + Push Often
    + Always left master as the stable branch. NEVER DEVELOP ON MASTER.
- Unit Testing
    + [OCMock for Objective-C](http://ocmock.org)
- Documentation
    + [AppleDoc](http//github.com/tomaz/appledoc.git)
    + [C4 model for visualising software architecture](https://c4model.com)
- Continuous Integration / Continuous Deployment
    + Jenkins

## Development Tools
### Environment
- [VPS+Shadowsocks](https://teddysun.com/486.html)
"Across the Great Wall we can reach every corner of the world."

### Development
- [Postman](https://www.getpostman.com)
A tool to debug and test the RESTful API.
- [APNS-Tool](https://itunes.apple.com/cn/app/apns-tool/id963558865?l=en&mt=12)
A simple application to test Apple Push Notification Service (APNS).
- [Charles](https://www.charlesproxy.com)
Charles is an HTTP proxy / HTTP monitor / Reverse Proxy that enables a developer to view all of the HTTP and SSL / HTTPS traffic between their machine and the Internet. This includes requests, responses and the HTTP headers (which contain the cookies and caching information).

### Documentation
- [Markdown](https://github.com/younghz/Markdown)
 A plain text formatting syntax designed so that it can optionally be converted to HTML.
- [Sublime Text](https://github.com/jikeytang/sublime-text)
A sophisticated text editor for code, markup and prose.
- [Web sequence diagram](https://www.websequencediagrams.com)
An online web tool to generate sequence diagram.

