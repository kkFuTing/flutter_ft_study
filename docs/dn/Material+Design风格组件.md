Tags： flutter
# Material Design风格组件
[TOC]

---
##1. 概述
> Material Design是由谷歌推出的全新设计语言，这种设计语言旨在为手机、平板电脑、台式机和其他平台提供更一致、更广泛的外观和感觉。Material Design风格是一直非常有质感的设计风格，并会提供一些默认的交互动画。

##2. App结构和导航组件

###2.1 MaterialApp(应用组件)
MaterialApp代表使用Material Design风格的应用，里面包含了其他所需的基本控件。官方提供的示例demo就是从MaterialApp这个主组件开始的。

MaterialApp组件常见属性
|属性名|类型|说明|
|-|-|-|
|title|String|应用程序的标题。该标题出现在以下位置：Android：任务管理器的程序快照上； IOS：程序切换管理器中|
|theme|ThemeData|定义应用所使用的主题颜色，可以指定主题中每个控件的颜色|
|color|Color|应用的主要颜色值，即primary color|
|home|Widget|用来定义当前应用打开时所显示的界面|
|routes|Map&lt;String, WidgetBuilder&gt;|定义应用中页面跳转规则|
|initialRoute|String|初始化路由|
|onGenerateRoute|RouteFactory|路由回调函数。当通过Navigator.of(context).pushNamed跳转路由的时候，在routes查找不到时，会调用该方法|
|onLocaleChanged|-|当系统修改语言的时候，会触发这个回调|
|navigatorObservers|List&lt;NavigatorObserver&gt;|导航观察器|
|debugShowMaterialGrid|bool|是否显示布局网格，用来调试UI的工具|
|showPerformanceOverlay|bool|显示性能标签|

####2.1.1 设置主页
使用home属性设置应用的主页，即整个应用的主组件。

####2.1.2 路由处理
routes对象是一个Map&lt;String, WidgetBuilder&gt;。当使用Navigator.pushNamed来跳转路由的时候，通过routes查找路由名字，然后使用对应的WidgetBuilder来构造一个带有页面切换动画的MaterialPageRoute。如果应用只有一个界面，则不用设置整个属性，使用home即可。

####2.1.3 自定义主题
应用程序的主题，各种定制的颜色都可以设置，用于程序主题切换。

##2.2 Scaffold(脚手架组件)
Scaffold实现了基本的Material Design布局。只要是在Material Design中定义过的单个界面显示的布局组件元素，都可以使用Scaffold来绘制。

常用属性
|属性名|类型|说明|
|-|-|-|
|appBar|AppBar|显示在界面顶部的一个AppBar|
|body|Widget|当前界面所显示的主要内容|
|floatingActionButton|Widget|在Material Design中定义的一个功能按钮|
|persistentFooterButtons|List&lt; Widget&gt;|固定在下方显示的按钮|
|drawer|Widget|侧边栏组件|
|bottomNavigatorBar|Widget|显示在底部的导航栏|
|backgroudColor|Color|背景颜色|
|resizeToAvoidBottomPadding|bool|控制界面内容body是否重新布局来避免底部被覆盖，比如当键盘显示时，重新布局避免键盘盖住内容。默认为true|

##2.3 AppBar(应用按钮组件)
应用按钮组件有AppBar和SliverAppBar。它们是Material Design中的AppBar，也就是Android中的ToolBar。
AppBar和SliverAppBar都继承自StatefulWidget，两者的区别在于AppBar的位置是固定在应用最上面的；而SliverAppBar是可以跟随内容滚动的。

常用属性
|属性名|类型|默认值|说明|
|-|-|-|-|
|leading|Widget|null|在标题前面显示一个组件，在首页通常显示应用的logo；其他界面通常显示返回按钮|
|title|Widget|null|当前界面的标题|
|actions|List&lt;Widget&gt;|null|一个Widget列表，常用菜单通常使用IconButton，不常用的通常使用PopupMenuButton显示三个点，点击后弹出二级菜单|
|bottom|PreferredSizeWidget|null|通常是一个TabBar。用来在标题下方显示一个Tab导航栏|
|elevation|double|4|控制AppBar下方阴影的高度|
|flexibleSpace|Widget|null|一个显示在AppBar下方的组件，高度和AppBar一样，可以实现一些特殊的效果，该属性通常在SliverAppBar中使用|
|backgroundColor|Color|ThemeData.primaryColor|背景色|
|brightness|Brightness|ThemeData.primaryColorBrightness|AppBar的亮度，有白色和黑色两种主题|
|iconTheme|IconThemeData|ThemeData.primaryIconTheme|AppBar上图标的颜色、透明度和尺寸信息|
|textTheme|TextTheme|ThemeData.primaryTextTheme|AppBar上文字样式|
|centerTitle|bool|-|标题是否居中显示，不同操作系统，显示方式不一样|

##2.4 BottomNavigatorBar(底部导航栏)
BottomNavigatorBar是底部导航栏，可以很容易地在tab之间切换和浏览顶级视图。

常见属性
|属性名|类型|说明|
|-|-|-|
|currentIndex|int|当前索引|
|fixedColor|Color|选中按钮的颜色。不指定则使用系统主题色|
|iconSize|double|按钮图形大小|
|items|List&lt;BottomNavigatorBarItem&gt;|底部导航栏按钮集。每一项是一个BottomNavigatorBarItem，包含icon图标和title文本|
|onTap|ValueChanged&lt;int&gt;|按下按钮的回调事件。需要根据返回的索引设置当前索引|

##2.5 TabBar(水平选项卡及视图组件)
TabBar是一个显示水平选项卡的Material Design组件，通常需要配套Tab选项组件及TabBarView页面视图组件一起使用。
TabBar常见属性
|属性名|类型|说明|
|-|-|-|
|isScrolled|bool|是否可以水平滚动|
|tabs|List&lt;Widget&gt;|Tab选项列表|

Tab常见属性
|属性名|类型|说明|
|-|-|-|
|icon|Widget|Tab图标|
|text|String|Tab文本|

TabBarView常见属性
|属性名|类型|说明|
|-|-|-|
|controller|TabController|指定视图的控制器|
|childrens|List&lt;Widget&gt;|视图组件的child为一个列表，一个选项卡对应一个视图|

##2.6 Drawer(抽屉组件)
Drawer可以实现类似抽屉拉入推出的效果，通常与ListView组合使用。

Drawer常用属性
|属性名|类型|默认值|说明|
|-|-|-|-|
|child|Widget|-|Drawer的child可以放置任意可显示的组件|
|elevation|double|16|阴影尺寸|

Drawer可以添加头部效果：
>* DrawerHeader：展示基本信息
>* UserAccountsDrawerHeader：展示用户头像、用户名、Email等信息

DrawerHeader常用属性
|属性名|类型|说明|
|-|-|-|
|decoration|Decoration|header区域的decoration，通常用来设置背景颜色或背景图片|
|curve|Curve|如果decoration发生了变化，则会使用curve设置的变化曲线和duration设置的动画时间来做一个动画效果|
|child|Widget|Header里面所显示的内容控件|
|padding|EdgeInsetsGeometry|Header里面内容控件的padding值，如果child为null，该值无效|
|margin|EdgeInsetsGeometry|Header四周的间隙|

UserAccountsDrawerHeader常用属性
|属性名|类型|说明|
|-|-|-|
|margin|EdgeInsetsGeometry|Header四周的间隙|
|decoration|Decoration|header区域的decoration，通常用来设置背景颜色或背景图片|
|currentAccountPicture|Widget|用来设置当前用户的头像|
|otherAccountsPicture|Widget|用来设置当前用户其他账号的头像|
|accountName|Widget|当前用户的名字|
|accountEmail|Widget|当前用户的Email|
|onDetailsPressed|VoidCallback|当accountName或者accountEmail被点击的时候所触发的回调函数，可以用来显示其他额外的信息|

##3. 按钮和提示组件
###3.1 FloatingActionButton(悬停按钮组件)
FloatingActionButton对应一个圆形图标按钮，悬停在内容之上，以展示应用程序中的主要动作。类似IOS里的小白点。

FloatingActionButton常用属性
|属性名|类型|默认值|说明|
|-|-|-|-|
|child|-|-|-|
|tooltip|-|-|-|
|foregroundColor|-|-|-|
|backgroundColor|-|-|-|
|elevation|-|-|-|
|highlightElevation|-|-|-|
|onPressed|-|-|-|
|shape|-|-|-|

###3.2 FlatButton(扁平按钮组件)
FlatButton是一个扁平的Material Design风格的按钮，点击时会有一个阴影效果。

###3.3 PopupMenuButton(弹出菜单组件)
PopupMenuButton一般放在应用右上角，表示更多操作，菜单项使用PopupMenuItem组件。

PopupMenuButton常用属性
|属性名|类型|说明|
|-|-|-|
|child|-|-|
|icon|-|-|
|itemBuilder|-|-|
|onSelected|-|-|

###3.4 SimpleDialog(简单对话框组件)
SimpleDialog用于设计简单的对话框，可以显示附加的提示或操作。SimpleDialog通常需要配合SimpleDialogOption组件一起使用。

SimpleDialog常用属性
|属性名|类型|说明|
|-|-|-|
|children|List&lt;Widget&gt;|对话框子项|
|title|Widget|通常是一个文本控件|
|contentPadding|EdgeInsetsGeometry|内容部分间距|
|titlePadding|EdgeInsetsGeometry|标题部分间距|

>* 通常对话框都是由某个动作来触发渲染的，比如点击按钮，点击菜单等。所以对话框一般要封装在一个方法里实现。
>* 另外这个过程是异步的需要加入async/await处理。

###3.5 AlertDialog(提示对话框组件)
AlertDialog比SimpleDialog对话框又复杂一些，不仅有提示内容，还有一些操作按钮，如确定和取消等，内容部分可以用SingleChildScrollView进行包裹。

AlertDialog常用属性
|属性名|类型|说明|
|-|-|-|
|actions|List&lt;Widget&gt;|对话框底部操作按钮，如确定、取消等|
|title|Widget|通常是一个文本控件|
|contentPadding|EdgeInsetsGeometry|内容部分间距|
|content|Widget|内容部分，通常为对话框的提示内容|
|titlePadding|EdgeInsetsGeometry|标题部分间距|

###3.6 SnackBar(轻量提示组件)
SnackBar是一个轻量级消息提示组件，在屏幕底部显示。

SnackBar常用属性
|属性名|类型|默认值|说明|
|-|-|-|-|
|action|SnackBarAction|-|提示消息里执行的动作，比如用户想撤销时可以点击操作|
|animation|Animation&lt;double&gt;|-|给组件添加动画效果|
|content|Widget|-|提示消息内容，通常为文本组件|
|duration|Duration|4.0秒|动画执行的时长|
|backgroundColor|Color|-|消息面板的背景色|

##4. 其他组件
###4.1 TextField(文本框组件)
TextField就是用来做文本输入的组件。
>* 注意与Text组件区分，Text主要用于显示文本，不接受文本输入。

TextField常用属性
|属性名|类型|说明|
|-|-|-|
|maxLength|int|最大长度|
|maxLines|int|最大行数|
|autocorrect|bool|是否自动更正|
|autofocus|bool|是否自动对焦|
|obscureText|bool|是否是密码|
|textAlign|TextAlign|文本对齐方式|
|style|TextStyle|文本的样式|
|inputFormatters|List&lt;TextInputFormatter&gt;|允许的输入格式|
|onChanged|VoidChanged&lt;String&gt;|内容改变时回调|
|onSubmitted|VoidChanged&lt;String&gt;|内容提交时回调|
|enabled|bool|是否禁用|

###4.2 Card(卡片组件)
Card内容可以由大多数类型的组件构成，但通常与ListTitle一起使用。Card有一个child，但可以是支持多个child的Row、Column、ListView、GridView或其他小部件。默认情况下，Card将其大小缩小为0像素。可以使用SizedBox来限制Card的大小。

Card常用属性
|属性名|类型|默认值|说明|
|-|-|-|-|
|child|Widget|-|组件的子元素，任意Widget都可以|
|margin|EdgeInsetsGeometry|-|围绕在decoration和child之外的空白区域，不属于内容区域|
|shape|ShapeBorder|RoundedRectangleBorder|Card的阴影效果，默认的阴影效果为圆角的长方形边。弧度为4.0|