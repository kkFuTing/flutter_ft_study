##Widget

```dart
/// Describes the configuration for an [Element].
/// 为Element提供配置信息

///
/// Widgets are the central class hierarchy in the Flutter framework. A widget
/// is an immutable description of part of a user interface. Widgets can be
/// inflated into elements, which manage the underlying render tree.

/// Widgets是Flutter框架中的核心类。一个widget是用户界面的一部分,并且是不可变的。
/// Widget会被扩充到Elements,并由Elements管理底层渲染树。

/// Widgets themselves have no mutable state (all their fields must be final).
/// If you wish to associate mutable state with a widget, consider using a
/// [StatefulWidget], which creates a [State] object (via
/// [StatefulWidget.createState]) whenever it is inflated into an element and
/// incorporated into the tree.

/// Widget本身没有可变状态（所有的字段必须是final）。如果想要把可变状态与Widget关联起来，
/// 可以使用[StatefulWidget]，[StatefulWidget]通过使用[StatefulWidget.createState]
/// 方法创建一个[State]对象，并将之扩充到一个Element以及合并到树中。

/// A given widget can be included in the tree zero or more times. In particular
/// a given widget can be placed in the tree multiple times. Each time a widget
/// is placed in the tree, it is inflated into an [Element], which means a
/// widget that is incorporated into the tree multiple times will be inflated
/// multiple times.

/// 给定的Widget可以被包含在树中（零次或多次）。一个给定的Widget可以放置在树中多次。
/// 每次将一个Widget放入树中时，它都会被扩充到一个[Element]中，这也意味着多次并入树中的
/// Widget将会被多次扩充进对应的[Element]。
///
/// The [key] property controls how one widget replaces another widget in the
/// tree. If the [runtimeType] and [key] properties of the two widgets are
/// [operator==], respectively, then the new widget replaces the old widget by
/// updating the underlying element (i.e., by calling [Element.update] with the
/// new widget). Otherwise, the old element is removed from the tree, the new
/// widget is inflated into an element, and the new element is inserted into the
/// tree.

/// [key]这个属性控制一个Widget如何替换树中的另一个Widget。如果两个Widget的[runtimeType]
/// 和[key属性相等[operator==]，则新的widget通过更新Element（即通过使用新的Widget调用
/// [Element.update]）来替换旧的Widget。否则，旧的element将从树中被移除，新的Widget将被
/// 扩充到一个新的Element中，这个新的Element将被插入树中。

/// See also:
///
///  * [StatefulWidget] and [State], for widgets that can build differently
///    several times over their lifetime.
///  * [InheritedWidget], for widgets that introduce ambient state that can
///    be read by descendant widgets.
///  * [StatelessWidget], for widgets that always build the same way given a
///    particular configuration and ambient state.
@immutable//不可变的
abstract class Widget extends DiagnosticableTree {
```

##Element

```dart
/// An instantiation of a [Widget] at a particular location in the tree.
/// Element是在树中特定位置Widget的实例

/// Widgets describe how to configure a subtree but the same widget can be used
/// to configure multiple subtrees simultaneously because widgets are immutable.
/// An [Element] represents the use of a widget to configure a specific location
/// in the tree. Over time, the widget associated with a given element can
/// change, for example, if the parent widget rebuilds and creates a new widget
/// for this location.
/// Widget描述如何配置子树，但由于Widget是不可变的，因此可以使用相同的Widget同时配置多个子树。
/// Element表示Widget配置树中的特定位置的实例。随着时间的推移，与给定Element关联的Widget可能
/// 随时会发生变化，例如，如果父Widget重建并为此位置创建新的Widget。

/// Elements form a tree. Most elements have a unique child, but some widgets
/// (e.g., subclasses of [RenderObjectElement]) can have multiple children.
/// Element构成一棵树。大多数Element都有一个唯一的子Element，但是一些Widget
/// （例如RenderObjectElement的子类）可以有多个子Element。

/// Elements have the following lifecycle:
/// Element具有以下生命周期：
///
///  * The framework creates an element by calling [Widget.createElement] on the
///    widget that will be used as the element's initial configuration.
///    框架层通过调用即将被用来作为Element的初始化配置信息的Widget的[Widget.createElement]
///	   方法来创建Element; 

///  * The framework calls [mount] to add the newly created element to the tree
///    at a given slot in a given parent. The [mount] method is responsible for
///    inflating any child widgets and calling [attachRenderObject] as
///    necessary to attach any associated render objects to the render tree.
///    框架层通过调用[mount]方法来将新创建的Element添加到给定父级中给定槽点的树上。 
///    mount方法负责将任何Widget扩充到Widget并根据需要调用attachRenderObject，
///    以将任何关联的渲染对象附加到渲染树上。

///  * At this point, the element is considered "active" and might appear on
///    screen.
///    此时，Element被视为“激活的”，并可能出现在屏幕上。

///  * At some point, the parent might decide to change the widget used to
///    configure this element, for example because the parent rebuilt with new
///    state. When this happens, the framework will call [update] with the new
///    widget. The new widget will always have the same [runtimeType] and key as
///    old widget. If the parent wishes to change the [runtimeType] or key of
///    the widget at this location in the tree, can do so by unmounting this
///    element and inflating the new widget at this location.
///    在某些情况下，父(Element)可能会更改用于配置此Element的Widget，例如因为
///    父Element重新创建了新状态。发生这种情况时，框架层将调用新的Widget的update方法。
///    新Widget将始终具有与旧Widget相同的runtimeType和key属性。如果父Element希望在
///    树中的此位置更改Widget的runtimeType或key，可以通过unmounting(卸载)此Element
///    并在此位置扩充新Widget来实现。

///  * At some point, an ancestor might decide to remove this element (or an
///    intermediate ancestor) from the tree, which the ancestor does by calling
///    [deactivateChild] on itself. Deactivating the intermediate ancestor will
///    remove that element's render object from the render tree and add this
///    element to the [owner]'s list of inactive elements, causing the framework
///    to call [deactivate] on this element.
///    在某些时候，祖先Element可能会决定从树中移除该Element（或中间祖先Element），
///    祖先Element自己通过调用[deactivateChild]来完成该操作。停用中间祖先将从渲染树中
///    移除该Element的渲染对象，并将此Element添加到[owner]属性中的非活动元素列表中，
///    从而让框架层调用[deactivate]方法作用在此Element上。

///  * At this point, the element is considered "inactive" and will not appear
///    on screen. An element can remain in the inactive state only until
///    the end of the current animation frame. At the end of the animation
///    frame, any elements that are still inactive will be unmounted.
///    此时，该Element被视为“无效状态”，并且不会出现在屏幕上。一个Element可以保持
///    "非活动"状态，直到当前动画帧结束。在动画帧结束时，任何仍处于非活动状态的
///    Element都将被卸载。

///  * If the element gets reincorporated into the tree (e.g., because it or one
///    of its ancestors has a global key that is reused), the framework will
///    remove the element from the [owner]'s list of inactive elements, call
///    [activate] on the element, and reattach the element's render object to
///    the render tree. (At this point, the element is again considered "active"
///    and might appear on screen.)
///    如果Element被重新组合到树中（例如，因为它或其祖先之一有一个全局键(global key)被重用），
///    框架层将从[owner]属性中的非活动Element列表中移除该Element，并调用该Element的
///    [activate]方法，并重新附加Element的渲染对象到渲染树。
///    （此时，Element再次被视为“活动状态”并可能出现在屏幕上。）

///  * If the element does not get reincorporated into the tree by the end of
///    the current animation frame, the framework will call [unmount] on the
///    element.
///    如果Element在当前动画帧的末尾没有被重新组合到树中，则框架层将调用该元素的unmount方法。

///  * At this point, the element is considered "defunct" and will not be
///    incorporated into the tree in the future.
///    此时，该元素被视为“已停用”，并且将来不会并入树中。
abstract class Element extends DiagnosticableTree implements BuildContext {
```