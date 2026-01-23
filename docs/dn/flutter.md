## 视图树

### StatefulWidget

### State
两个重要的属性
widget ：表示与该State实例关联的widget实例
Context:BuildContext的一个实例

#### State生命周期
initState -> didChangeDependencies->build

调试时的放噶
reassemble-> didUpdateWidge -> build

从widger中移除StatefulWidget
deactive -> dispose
