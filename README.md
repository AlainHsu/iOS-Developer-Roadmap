# iOS Developer Roadmap

## Table of contents
<!-- MarkdownTOC -->

- [iOS Development Technology](#ios-development-technology)
    - [UI](#ui)
    - [Objective-C language](#objective-c-language)
    - [Runtime](#runtime)
    - [Memory management](#memory-management)
    - [Block](#block)
    - [MultiThreading](#multithreading)
    - [RunLoop](#runloop)
    - [Network](#network)
    - [Design patterns](#design-patterns)
    - [Architecture patterns](#architecture-patterns)
    - [Algorithm](#algorithm)
    - [Third-party libraries](#third-party-libraries)
- [Development Process](#development-process)
    - [Full App Development Process](#full-app-development-process)
    - [SDK Release Process](#sdk-release-process)
    - [Development](#development)
- [Development Tools](#development-tools)

<!-- /MarkdownTOC -->


## iOS Development Technology
![ESSENTIAL ROADMAP](\Assets/ESSENTIALROADMAP.png)
### UI
- UITableView
	- 重用机制
		![TableView_Reuse](\Assets/TableView_Reuse.png)
		- [索引条实现](\UI/TableVIew_Reuse)
	- 数据源同步
		- 并发访问,数据拷贝
		![Concurrent_CopyData](\Assets/Concurrent_CopyData.png)
			- PS:进行数据拷贝会占用内存空间,数据量大的时候存在内存开销问题
		- 串行访问
		![Serial_dataSync](\Assets/Serial_dataSync.png)
			- PS:需要等待子线程处理任务,耗时任务时会导致延时
- 事件传递&视图响应链
	- UIView&CALayer
		- UIView为其提供内容,以及负责处理触摸等事件,参与响应链; CALayer 负责显示内容 contents
		- 体现了系统在设计上运用了单一职责原则
	- 事件传递
	
		```objectivec
		-(UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event;
		-(BOOL)pointInside(CGPoint)point withEvent:(UIEvent*)event;
		```
		- 系统实现
		![HitTest_Flow](\Assets/HitTest_Flow.png)
			- PS:倒序遍历子视图
	- 视图响应链
		
		```objectivec
		-(Void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event;
		-(Void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event;
		-(Void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event;
		```
		- 系统实现
		![Responder_Chain](\Assets/Responder_Chain.png)
		
	- 例子
	![View_Event](\Assets/View_Event.png)
		- 事件传递顺序: UIApplication -> UIWindow -> View A -> View B2 -> View C2
		- 响应链传递顺序: View C2 -> View B2 -> View A -> ... -> UIApplication -> Ignore
- 图像显示原理
	- 
- 卡顿&掉帧
- 绘制原理&异步绘制

### Objective-C language
- //TODO

### Runtime
- //TODO

### Memory management
- //TODO

### Block
- //TODO

### MultiThreading
- //TODO

### RunLoop
- //TODO

### Network
- //TODO

### Design patterns
- //TODO

### Architecture patterns
- //TODO

### Algorithm
- //TODO

### Third-party libraries
- //TODO

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

