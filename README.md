<!-- MarkdownTOC -->

- [iOS Development Technology](#ios-development-technology)
	- [UI](#ui)
		- [UITableView](#uitableview)
		- [事件传递与视图响应链](#事件传递与视图响应链)
		- [图像显示原理](#图像显示原理)
		- [卡顿与掉帧](#卡顿与掉帧)
		- [绘制原理与异步绘制](#绘制原理与异步绘制)
	- [Objective-C language](#objective-c-language)
		- [Category](#category)
		- [Associated object关联对象](#associatedobject关联对象)
		- [Extension](#extension)
		- [Delegate](#delegate)
		- [Notification](#notification)
		- [KVO](#kvo)
		- [KVC](#kvc)
		- [Property关键字](#property关键字)
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


# iOS Development Technology
![ESSENTIAL ROADMAP](/Assets/ESSENTIALROADMAP.png)
***

## UI

### UITableView
- 重用机制
	![TableView_Reuse](/Assets/TableView_Reuse.png)
	- [索引条实现](/UI/TableVIew_Reuse)
- 数据源同步
	- 并发访问,数据拷贝
	![Concurrent_CopyData](/Assets/Concurrent_CopyData.png)
		- PS:进行数据拷贝会占用内存空间,数据量大的时候存在内存开销问题	- 串行访问
	![Serial_dataSync](/Assets/Serial_dataSync.png)
		- PS:需要等待子线程处理任务,耗时任务时会导致延时
 
### 事件传递与视图响应链
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

### 图像显示原理
![Display_concept](/Assets/Display_concept.png)
CPU 和 GPU 两个硬件是通过总线连接起来. CPU 输出位图, 经由总线在合适的时间上传给 GPU, GPU 会做相应的图层渲染,纹理合成, 之后把结果放到帧缓冲区当中,由视频控制器根据 V-Sync(垂直同步) 信号在指定时间之前去提取对应帧缓冲区当中的屏幕显示内容,然后最终显示到屏幕上面
![Display_overall](/Assets/Display_overall.png)

- CPU 工作内容
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

### 卡顿与掉帧
- UI 卡顿,掉帧的原因:
	![Delay_reason](/Assets/Delay_reason.png)
	- 没有在 16.7ms 内准备好下一帧的画面
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

### 绘制原理与异步绘制
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
***

## Objective-C language

### Category
- 运用场景
	- 声明私有方法
	- 分解体积庞大的类文件
	- 把 Framework 的私有方法公开
- 特点
	- 运行时决议
	- 可以为系统类添加分类
- 可添加内容
	- 实例方法
	- 类方法
	- 协议
	- 属性, 只声明了 setter 和 getter 方法,不添加实例变量  

	```objectivec
	typedef struct category_t *Category;
	
	struct category_t {
   		const char *name;	//category名称
   		classref_t cls; 	//要拓展的类
    	struct method_list_t *instanceMethods; //给类添加的实例方法的列表
    	struct method_list_t *classMethods;  //给类添加的类方法的列表
    	struct protocol_list_t *protocols;  //给类添加的协议的列表
    	struct property_list_t *instanceProperties;  //给类添加的属性的列表
	};
	```
- 加载调用栈

	```objectivec
	void _objc_init(void);	//runtime 初始化
	└── void map_2_images(...);	//映射到镜像
		 └── void map_images_nolock(...);	//镜像解锁
	   		  └── void _read_images(...);	//读取镜像
   	   		    	└── static void remethodizeClass(Class cls); //重构方法
   	       		 		└──attachCategories(Class cls, category_list *cats, 	bool flush_caches);

	```
- 源码分析
	- remethodizeClass 源码
	
	```objectivec
	static void remethodizeClass(Class cls)
	{
	    category_list *cats;
	    bool isMeta;
	
	    runtimeLock.assertWriting();
	
	    /*
	     判断是否类方法,这里假设 isMeta == NO
	    */
	    isMeta = cls->isMetaClass();
	
	    // Re-methodizing: check for more categories
	    //获取 cls 中未完成整合的所有分类
	    if ((cats = unattachedCategoriesForClass(cls, false/*not realizing*/))) {
	        if (PrintConnecting) {
	            _objc_inform("CLASS: attaching categories to class '%s' %s", cls->nameForLogging(), isMeta ? "(meta)" : "");
    	    	}
		
		//将分类 cats 拼接到 cls 宿主类上
	        attachCategories(cls, cats, true /*flush caches*/);        
        	free(cats);
 	   }
	}
	``` 
	- attachCategories 源码

	```objectivec
	static void 
	attachCategories(Class cls, category_list *cats, bool flush_caches)
	{
	    if (!cats) return;
	    if (PrintReplacedMethods) printReplacements(cls, cats);
	
	    // 这里假设 isMeta == NO
	    bool isMeta = cls->isMetaClass();
	
	    // fixme rearrange to remove these intermediate allocations
	    /*  二维数组
   	     [[method_t,method_t,...], [method_t], [method_t,method_t,method_t],...]
  	   */
  	  method_list_t **mlists = (method_list_t **)
  	      malloc(cats->count * sizeof(*mlists));
  	  property_list_t **proplists = (property_list_t **)
  	      malloc(cats->count * sizeof(*proplists));
  	  protocol_list_t **protolists = (protocol_list_t **)
  	      malloc(cats->count * sizeof(*protolists));
	
 	   // Count backwards through cats to get newest categories first
  	  int mcount = 0; //  方法参数
  	  int propcount = 0;  //  属性参数
  	  int protocount = 0; //  协议参数
  	  int i = cats->count;    //  宿主类的分类总数
  	  bool fromBundle = NO;
  	  while (i--) {   //这里是倒叙遍历,最先访问最后编译 cats 中的分类
  	      //  获取一个分类
  	      auto& entry = cats->list[i];
	
 	       //  获取该分类的方法列表
 	       method_list_t *mlist = entry.cat->methodsForMeta(isMeta);
  	      if (mlist) {
  	          //  将方法依次添加到二维数组列表中, 最后编译的分类最先添加
        	    mlists[mcount++] = mlist;
  	          fromBundle |= entry.hi->isBundle();
	        }
	
	        //  属性列表添加规则 同方法列表添加规则
        	property_list_t *proplist = entry.cat->propertiesForMeta(isMeta);
        	if (proplist) {
	            proplists[propcount++] = proplist;
	        }
	
	        //  协议列表添加规则 同方法列表添加规则
	        protocol_list_t *protolist = entry.cat->protocols;
	        if (protolist) {
	            protolists[protocount++] = protolist;
	        }
	    }
    	
	    //  获取宿主类当中的 rw 数据, 其中包含宿主类的方法列表信息
	    auto rw = cls->data();
	
	    //  主要是针对分类中有关内存管理相关方法情况下的一些特殊处理
	    prepareMethodLists(cls, mlists, mcount, NO, fromBundle);
	    /*
	     rw 代表类
	     methods 代表类的方法列表
	     attachLists 方法的含义是 将含有 mcount 个元素的 mlists 拼接到 rw 的 methods 上
	     */
	    rw->methods.attachLists(mlists, mcount);
	    free(mlists);
	    if (flush_caches  &&  mcount > 0) flushCaches(cls);
	
	    rw->properties.attachLists(proplists, propcount);
	    free(proplists);
	
	    rw->protocols.attachLists(protolists, protocount);
	    free(protolists);
	}
	```
	- attachLists 源码
	
	```objectivec
    	/*
    	    addedLists 传递过来的二维数组
    	 [[method_t,method_t,...], [method_t], [method_t,method_t,method_t],...]
    	 -----------------------   ---------   ---------------------------------
    	    分类 A 中的方法列表(A)        B                     C
    	    addedCount = 3
    	*/
    	void attachLists(List* const * addedLists, uint32_t addedCount) {\
    	    	if (addedCount == 0) return;
		
	        if (hasArray()) {
	            // many lists -> many lists
	            // 列表中原有元素总数 oldCount = 2
	            uint32_t oldCount = array()->count;
	            // 拼接之后的元素总数
	            uint32_t newCount = oldCount + addedCount;
	            // 根据新总数重新分配内存
	            setArray((array_t *)realloc(array(), array_t::byteSize(newCount)));
	            // 重新设置元素总数
	            array()->count = newCount;
	            /*
	                内存移动
	                [[], [], [], [原有的第一个元素], [原有的第二个元素]]
	             */
	            memmove(array()->lists + addedCount, array()->lists, 
	                    oldCount * sizeof(array()->lists[0]));
	            /*
	                内存拷贝
	                [
	                    A   --->    [addedLists 中的第一个元素],
	                    B   --->    [addedLists 中的第二个元素],
	                    C   --->    [addedLists 中的第三个元素],
	                    [原有的第一个元素],
	                    [原有的第二个元素]
	                ]
	             
	                这也是分类方法会"覆盖"宿主类方法的原因
	             */
	            memcpy(array()->lists, addedLists, 
	                   addedCount * sizeof(array()->lists[0]));
	        }
	
		...	//后面省略
	}
	```	
- 总结
	-  分类添加的方法可以"覆盖"原类方法
	-  同名分类方法谁能生效取决于编译顺序
	-  名字相同的分类会引起编译报错

### AssociatedObject关联对象
category 的属性不能生成成员变量和 getter、setter 方法的实现，我们要自己实现 getter 和 setter 方法，需借助关联对象来实现

- 关联对象来实现提供三个接口 **objc_setAssociatedObject**,**objc_getAssociatedObject**,**objc_removeAssociatedObjects**,他们分别调用的是

	```objectivec
	id objc_getAssociatedObject(id object, const void *key) {
	    return _object_get_associative_reference(object, (void *)key);
	}
	void objc_setAssociatedObject(id object, const void *key, id value, objc_AssociationPolicy policy) {
	    _object_set_associative_reference(object, (void *)key, value, policy);
	}
	void objc_removeAssociatedObjects(id object) 
	{
	    if (object && object->hasAssociatedObjects()) {
	        _object_remove_assocations(object);
	    }
	}
	```
- 他们调用的接口都位于 objc-references.mm文件中,
	- **_object_get_associative_reference** 源码 

	```objectivec
	id _object_get_associative_reference(id object, void *key) {
	    id value = nil;
	    uintptr_t policy = OBJC_ASSOCIATION_ASSIGN;
	    {
	        AssociationsManager manager;
	        AssociationsHashMap &associations(manager.associations());
	        disguised_ptr_t disguised_object = DISGUISE(object);
	        AssociationsHashMap::iterator i = associations.find(disguised_object);
	        if (i != associations.end()) {
	            ObjectAssociationMap *refs = i->second;
        	    ObjectAssociationMap::iterator j = refs->find(key);
        	    if (j != refs->end()) {
        	        ObjcAssociation &entry = j->second;
        	        value = entry.value();
        	        policy = entry.policy();
        	        if (policy & OBJC_ASSOCIATION_GETTER_RETAIN) {
                	    objc_retain(value);
                	}
	            }
        	}
	    }
	    if (value && (policy & OBJC_ASSOCIATION_GETTER_AUTORELEASE)) {
	        objc_autorelease(value);
	    }
	    return value;
	}
	```
	- 这段代码引用的类型有:
		- AssociationsManager
		- AssociationsHashMap
		- ObjcAssociationMap
		- ObjcAssociation
	
	```objectivec
	spinlock_t AssociationsManagerLock;
	class AssociationsManager {
	    static AssociationsHashMap *_map;
	public:
	    // 初始化时候
	    AssociationsManager()   { AssociationsManagerLock.lock(); }
	    // 析构的时候
	    ~AssociationsManager()  { AssociationsManagerLock.unlock(); }
	    
	    // associations 方法用于取得一个全局的 AssociationsHashMap 单例
	    AssociationsHashMap &associations() {
	        if (_map == NULL)
	            _map = new AssociationsHashMap();
	        return *_map;
	    }
	};
	```
	- **AssociationsManager** 初始化一个 AssociationsHashMap 的单例，用自旋锁 AssociationsManagerLock 保证线程安全
	
	```objectivec
	class AssociationsHashMap : public unordered_map<disguised_ptr_t, ObjectAssociationMap *, DisguisedPointerHash, 	DisguisedPointerEqual, AssociationsHashMapAllocator> {
	    public:
	        void *operator new(size_t n) { return ::malloc(n); }
	        void operator delete(void *ptr) { ::free(ptr); }
	    };
		```
	- **AssociationsHashMap** 是一个map类型，用于保存对象的对象的 disguised_ptr_t 到 ObjectAssociationMap 的映射
		
	```objectivec
	class ObjectAssociationMap : public std::map<void *, ObjcAssociation, ObjectPointerLess, ObjectAssociationMapAllocator> {
	    public:
	        void *operator new(size_t n) { return ::malloc(n); }
	        void operator delete(void *ptr) { ::free(ptr); }
	};
	```	
	- **ObjectAssociationMap** 则保存了从 key 到关联对象 ObjcAssociation 的映射，这个数据结构保存了当前对象对应的所有关联对象
	
	```objectivec
	class ObjcAssociation {
	        uintptr_t _policy;
	        id _value;
	    public:
	        ObjcAssociation(uintptr_t policy, id value) : _policy(policy), _value(value) {}
	        ObjcAssociation() : _policy(0), _value(nil) {}
	
	        uintptr_t policy() const { return _policy; }
	        id value() const { return _value; }
	        
	        bool hasValue() { return _value != nil; }
	};
	```
	- **ObjcAssociation** 就是真正的关联对象的类，上面的所有数据结构只是为了更好的存储它。最关键的 ObjcAssociation 包含了 policy 以及 value
	- 用一张图解释他们的关系就是：
	![ObjcAssociationa_relationship](/Assets/ObjcAssociationa_relationship.png)
	- 从上图我们不难看出 _object_get_associative_reference 获取关联对象的步骤是：
		- AssociationsHashMap &associations(manager.associations()) 获取 AssociationsHashMap 的单例对象 associations
		- disguised_ptr_t disguised_object = DISGUISE(object) 获取对象的地址
		- 通过对象的地址在 associations 中获取 AssociationsHashMap迭代器
		- 通过 key获取到 ObjectAssociationMap的迭代器
		- 最后得出关联对象类 ObjcAssociation 的实例 entry，再获取到 value 和 policy 的值
	- **_object_set_associative_reference** 源码
	
	```objectivec
	void _object_set_associative_reference(id object, void *key, id value, uintptr_t policy) {
	    // retain the new value (if any) outside the lock.
	    uintptr_t old_policy = 0; // NOTE:  old_policy is always assigned to when old_value is non-nil.
	    id new_value = value ? acquireValue(value, policy) : nil, old_value = nil; // 调用 acquireValue 对 value 进行 retain 或者 copy
	    {
	
	        // & 取地址 *是指针，就是地址的内容
	        AssociationsManager manager;  // 初始化一个 AssociationsManager 类型的变量 manager
	        AssociationsHashMap &associations(manager.associations());   // 取得一个全局的 AssociationsHashMap 单例
       	 if (new_value) {
	
	            // 如果new_value不为空，开始遍历associations指向的map，查找object对象是否存在保存联合存储数据的ObjectAssociationMap对象
	
        	    // 查找map中是否包含某个关键字条目，用 find() 方法，传入的参数是要查找的key（被关联对象的内存地址），在这里需要提到的是begin()和end()两个成员，分别代表map对象中第一个条目和最后一个条目，这两个数据的类型是iterator.
	            // 定义一个条目变量 i (实际是指针)
        	    AssociationsHashMap::iterator i = associations.find(object);  // AssociationsHashMap 是一个无序的哈希表，维护了从对象地址到 ObjectAssociationMap 的映射；
	
	
        	    // iterator是 C++ 中的迭代器 ， 这句话是定义一个 AssociationsHashMap::iterator 类型的变量 i，初始化为 associations.find(object) ， associations是AssociationsHashMap类型对象。
	
        	    // 通过map对象的方法获取的iterator数据类型 是一个std::pair对象
	            // 根据对象地址获取起对应的 ObjectAssociationMap对象
	            if (i != associations.end()) {
	                // 存在
	
	                // object对象在associations指向的map中存在一个ObjectAssociationMap对象refs
	
	                // ObjectAssociationMap 是一个 C++ 中的 map ，维护了从 key（就是外界传入的key） 到 ObjcAssociation 的映射，即关联记录
        	        ObjectAssociationMap *refs = i->second;              //  指针 调用方法 需要用 ->   i 是 AssociationsHashMap    i->second 表示ObjectAssociationMap  i->first 表示对象的地址
                	ObjectAssociationMap::iterator j = refs->find(key);  //  根据传入的关联对象的key（一个地址）获取其对应的关联对象  ObjectAssociationMap
	
	
        	        // 关联对象是否存在
                	if (j != refs->end()) {
                    	// 使用过该key保存value，用新的value和policy替换掉原来的值
                    	// 如果存在 持有旧的关联对象
                    	ObjcAssociation &old_entry = j->second;  
                    	old_policy = old_entry.policy;
                    	old_value = old_entry.value;
	
                    	// 存入新的关联对象
                    	old_entry.policy = policy;
                    	old_entry.value = new_value;
	                } else {
	                    // 没用使用过该key保存value，将value和policy保存到key映射的map中
	                    // 如果不存在 直接存入新的关联对象
	                    (*refs)[key] = ObjcAssociation(policy, new_value);   // 对map 插入元素
	                }
       		     }
	            else {
	
        	        // 不存在
                	// 没有object就创建
	                // create the new association (first time).
	                ObjectAssociationMap *refs = new ObjectAssociationMap;
	                associations[object] = refs;
	                (*refs)[key] = ObjcAssociation(policy, new_value);
	                _class_setInstancesHaveAssociatedObjects(_object_getClass(object));
	            }
	        } else {
	            // setting the association to nil breaks the association.
	            AssociationsHashMap::iterator i = associations.find(object);
	            if (i !=  associations.end()) {
	                ObjectAssociationMap *refs = i->second;
	                ObjectAssociationMap::iterator j = refs->find(key);
	                if (j != refs->end()) {
	                    ObjcAssociation &old_entry = j->second;
	                    old_policy = old_entry.policy;
	                    old_value = (id) old_entry.value;
	
	                    // 从 map中删除该项
	                    refs->erase(j);
	                }
	            }
	        }
	    }

	    // 旧的关联对象是否存在，如果存在，释放旧的关联对象。
	    // release the old value (outside of the lock).
	    if (old_value) releaseValue(old_value, old_policy);
	}
	```
	- **_object_set_associative_reference**设置关联对象的流程参照图片：
	![Associaticve_reference](/Assets/Associaticve_reference.png)
- **关联策略**
	- 在给一个对象添加关联对象时有五种关联策略可供选择：

	|  关联策略   |  等价属性  |	说明 |
	| :------:  | :------: | :------: |
	|  OBJC_ASSOCIATION_ASSIGN| @property (assign) or @property (unsafe_unretained) | 弱引用关联对象 |
	|  OBJC_ASSOCIATION_RETAIN_NONATOMIC | @property (strong, nonatomic)| 强引用关联对象，且为非原子操作 |
	|  OBJC_ASSOCIATION_COPY_NONATOMIC| @property (copy, nonatomic)	| 复制关联对象，且为非原子操作 |
	|  OBJC_ASSOCIATION_RETAIN	 | @property (strong, atomic)	  |	强引用关联对象，且为原子操作 |
	|  OBJC_ASSOCIATION_COPY | @property (copy, atomic) | 复制关联对象，且为原子操作 |
	- **_object_remove_assocations** 源码
	
	```objectivec
	void _object_remove_assocations(id object) {
	    vector< ObjcAssociation,ObjcAllocator<ObjcAssociation> > elements;
	    {
        	AssociationsManager manager;
	        AssociationsHashMap &associations(manager.associations());
	        if (associations.size() == 0) return;
        	disguised_ptr_t disguised_object = DISGUISE(object);
	        AssociationsHashMap::iterator i = associations.find(disguised_object);
        	if (i != associations.end()) {
	            // 获取到所有的关联对象的associations实例
	            ObjectAssociationMap *refs = i->second;
	            for (ObjectAssociationMap::iterator j = refs->begin(), end = refs->end(); j != end; ++j) {
	                elements.push_back(j->second);
	            }
	            delete refs;    //删除ObjectAssociationMap
	            associations.erase(i);//删除AssociationsHashMap
	        }
	    }
	    //删除elements集合中的所有ObjcAssociation元素
	    for_each(elements.begin(), elements.end(), ReleaseValue());
	}
	```
	- 删除关联对象的流程相对就比较简单了，将获取到的关联对象ObjcAssociation的实例放入一个 vector中，删除对应的 ObjectAssociationMap 和 AssociationsHashMap,最后对 vector 中每个 ObjcAssociation 实例做release操作

- 参考
	- 作者：西木中堂
	- 链接：https://juejin.im/post/5a9d14856fb9a028e52d5568
	
### Extension
- 特点
	- 编译时决议
	- 只以声明的形式存在,多数情况下寄生于宿主类的 .m 中
	- 不能为系统类添加扩展

### Delegate
- 特点
	- **代理模式**是一种软件设计模式, 在 iOS 当中以**@protocol**的形式体现
	- 传递方式是**一对一**的
- 工作流程
	![Delegate_flow](/Assets/Delegate_flow.png)
- 一般声明为 weak 以规避循环引用
	![Delegate_declare](/Assets/Delegate_declare.png)

### Notification
- 特点
	- 是使用**观察者模式**来实现的用于**跨层传递消息**的机制
	- 传递方式是**一对多**
- 通知的实现机制 *(NS 开头的系统文件不开源,无法得知具体实现)*
	![Notification_realized](/Assets/Notification_realized.png)
	- NSNotificaitonCenter 中维护一个 Notificaton_Map 字典
	- notificationName 通知名
	- observers_List 观察者数组列表
	- observer 内容应包含观察者以及观察相应的响应方法

### KVO
- 特点
	- KVO 是对**观察者设计模式**的有一实现
	- 使用了 isa (**isa-swizzling**) 混写技术来实现
	![KVO_flow](/Assets/KVO_flow.png)
- [KVO实现](/Objective-C/KVO_test)
	- 使用 setter 方法改变值 KVO 才会生效
	- 使用 setValue:forKey: 改变值 KVO 才会生效
	- 成员变量直接修改需**手动添加** KVO 才会生效

### KVC
- KVC 即 Key-value coding
	
	```objectivec
	-(id)valueForKey:(NSString*)key
	-(void)setValue:(id)value forKey:(NSString*)key
	```
	- 可以访问/设置私有变量,违背了面向对象编程思想
- valueForKey: 流程
	![ValueForKey_flow](/Assets/ValueForKey_flow.png)
	- Accessor Method 该 Key 相应的实例方法
		- < getKey >
		- < Key>
		- < isKey >
	- Instance var 相似名称的实例变量
		- _key
		- _isKey
		- key
		- isKey
	- accessInstanceVariablesDirectly 默认返回 YES,是否访问同名的实例变量 (可以手动设为 NO,体现了对面向对象编程思想的支持)
- setValue:forKey: 流程
	![SetValueForKey_flow](/Assets/SetValueForKey_flow.png)

***

### Property关键字
- 分类
	- 读写权限
		- readonly
		- **readwrite**
	- 原子性
		- **atomic**
		- nonatomic
	- 引用计数
		- retain/**strong**
		- unsafe_unretained/**assign**
		- weak
		- copy
- asign 和 weak
	- assign
		- 修饰基本数据类型,如 int,BOOL 等
		- 修饰对象类型时,不改变其引用计数
		- 会产生悬垂指针.修饰的对象释放后 assign 指针仍指向原内存地址,继续访问对象可能导致内存泄漏程序异常
	- weak
		- 只能修饰对象
		- 不改变被修饰对象的引用计数
		- 所指对象在被释放后会自动置为 nil
- copy
	- 浅拷贝
		- 是对内存地址的复制,让目标指针和源对象指针指向**同一片**内存空间
		- 增加对象的引用计数
		- 无新的内存分配
	- 深拷贝
		- 让目标对象指针和源对象指针指向**两片**内容相同的内存空间
		- 不增加引用计数
		- 开辟新内存空间
	- copy 关键字

	| 源对象类型 | 拷贝方式 | 目标对象类型 | 拷贝类型 |
	| :------:  | :------: | :------: | :------: |
	| mutable 对象 | copy | 不可变 | 深拷贝 | 
	| mutable 对象 | mutablecopy | 可变 | 深拷贝 | 
	| immutable 对象 | copy | 不可变 | 浅拷贝 | 
	| immutable 对象 | mutablecopy | 可变 | 深拷贝 | 
	- 总结
		- 可变对象的 copy 和 mutableCopy 都是深拷贝
		- 不可变对象的 copy 是浅拷贝, mutableCopy 都是深拷贝
		- copy 方法返回的都是不可变对象

## Runtime
### //TODO

## Memory management
### //TODO

## Block
### //TODO

## MultiThreading
### //TODO

## RunLoop
### //TODO

## Network
### //TODO

## Design patterns
### //TODO

## Architecture patterns
### //TODO

## Algorithm
### //TODO

## Third-party libraries
### //TODO

# Development Process
## Full App Development Process
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

## SDK Release Process
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

## Development
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

# Development Tools
## Environment
- [VPS+Shadowsocks](https://teddysun.com/486.html)
"Across the Great Wall we can reach every corner of the world."

## Development
- [Postman](https://www.getpostman.com)
A tool to debug and test the RESTful API.
- [APNS-Tool](https://itunes.apple.com/cn/app/apns-tool/id963558865?l=en&mt=12)
A simple application to test Apple Push Notification Service (APNS).
- [Charles](https://www.charlesproxy.com)
Charles is an HTTP proxy / HTTP monitor / Reverse Proxy that enables a developer to view all of the HTTP and SSL / HTTPS traffic between their machine and the Internet. This includes requests, responses and the HTTP headers (which contain the cookies and caching information).

## Documentation
- [Markdown](https://github.com/younghz/Markdown)
 A plain text formatting syntax designed so that it can optionally be converted to HTML.
- [Sublime Text](https://github.com/jikeytang/sublime-text)
A sophisticated text editor for code, markup and prose.
- [Web sequence diagram](https://www.websequencediagrams.com)
An online web tool to generate sequence diagram.

