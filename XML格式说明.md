# XML格式题目示例说明

## 文件说明

`示例题目.xml` 包含了所有题型的完整示例，包括：
- ✅ 单选题
- ✅ 多选题
- ✅ 判断题
- ✅ 填空题
- ✅ 带图片的题目（题干图片、选项图片、解析图片）

## XML结构说明

### 基本结构

```xml
<?xml version="1.0" encoding="UTF-8"?>
<questions>
  <question>
    <!-- 题目内容 -->
  </question>
</questions>
```

### 字段说明

| 字段 | 说明 | 是否必需 | 示例 |
|------|------|---------|------|
| `<stem>` | 题干 | ✅ 必需 | Flutter是由哪个公司开发的？ |
| `<type>` | 题型 | ❌ 可选 | single/multiple/judgment/fill |
| `<options>` | 选项容器 | ❌ 可选 | 见下方说明 |
| `<option>` | 单个选项 | ❌ 可选 | 见下方说明 |
| `<answer>` | 答案 | ✅ 必需 | A 或 A,B,C |
| `<analysis>` | 解析 | ❌ 可选 | Flutter是由Google开发的... |
| `<analysisImage>` | 解析图片 | ❌ 可选 | C:/images/analysis.jpg |
| `<category>` | 分类 | ❌ 可选 | Flutter基础 |
| `<tags>` | 标签容器 | ❌ 可选 | 见下方说明 |
| `<tag>` | 单个标签 | ❌ 可选 | Flutter |

### 选项结构

```xml
<options>
  <option label="A">选项内容</option>
  <option label="B">选项内容</option>
  <option label="A" image="图片路径">带图片的选项</option>
</options>
```

**选项属性：**
- `label`：选项标签（A、B、C、D）
- `image`：选项图片路径（可选）

### 标签结构

```xml
<tags>
  <tag>Flutter</tag>
  <tag>基础</tag>
</tags>
```

## 题型示例

### 1. 单选题

```xml
<question>
  <stem>Flutter是由哪个公司开发的？</stem>
  <type>single</type>
  <options>
    <option label="A">Google</option>
    <option label="B">Facebook</option>
    <option label="C">Microsoft</option>
    <option label="D">Apple</option>
  </options>
  <answer>A</answer>
  <analysis>Flutter是由Google开发的跨平台UI框架。</analysis>
</question>
```

### 2. 多选题

```xml
<question>
  <stem>以下哪些是Flutter的状态管理方案？</stem>
  <type>multiple</type>
  <options>
    <option label="A">Provider</option>
    <option label="B">GetX</option>
    <option label="C">Bloc</option>
    <option label="D">Redux</option>
  </options>
  <answer>A,B,C</answer>
  <analysis>Provider、GetX和Bloc都是Flutter常用的状态管理方案。</analysis>
</question>
```

### 3. 判断题

```xml
<question>
  <stem>Flutter使用Dart语言开发。</stem>
  <type>judgment</type>
  <options>
    <option label="A">正确</option>
    <option label="B">错误</option>
  </options>
  <answer>A</answer>
  <analysis>Flutter确实使用Dart语言开发。</analysis>
</question>
```

### 4. 填空题

```xml
<question>
  <stem>在Flutter中，使用______关键字可以创建无状态组件。</stem>
  <type>fill</type>
  <options/>
  <answer>StatelessWidget</answer>
  <analysis>StatelessWidget是Flutter中用于创建无状态组件的基类。</analysis>
</question>
```

### 5. 带图片的题目

```xml
<question>
  <stem>根据下面的代码截图，选择正确的答案。</stem>
  <stemImage>C:/images/code-screenshot.png</stemImage>
  <type>single</type>
  <options>
    <option label="A" image="C:/images/option_a.png">选项A</option>
    <option label="B" image="C:/images/option_b.png">选项B</option>
  </options>
  <answer>A</answer>
  <analysis>这是正确答案的详细解析。</analysis>
  <analysisImage>https://example.com/analysis.png</analysisImage>
</question>
```

## 图片支持

### 图片字段

- `<stemImage>`：题干图片
- `<option image="...">`：选项图片（作为option的属性）
- `<analysisImage>`：解析图片

### 图片路径格式

1. **本地路径**：
   ```xml
   <stemImage>C:/images/question1.jpg</stemImage>
   <option label="A" image="D:/pictures/option_a.png">选项A</option>
   ```

2. **网络URL**：
   ```xml
   <stemImage>https://example.com/image.jpg</stemImage>
   <analysisImage>https://example.com/analysis.png</analysisImage>
   ```

## 答案格式

### 单选题
```xml
<answer>A</answer>
```

### 多选题
```xml
<answer>A,B,C</answer>
```
多个答案用逗号分隔，**不要有空格**。

### 判断题
```xml
<answer>A</answer>  <!-- A表示正确 -->
<answer>B</answer>  <!-- B表示错误 -->
```

### 填空题
```xml
<answer>StatelessWidget</answer>
```
直接填写答案内容，如果有多个空，用逗号分隔：
```xml
<answer>StatefulWidget,StatelessWidget</answer>
```

## 题型值说明

| 题型 | type值 | 说明 |
|------|--------|------|
| 单选题 | `single` | 只能选择一个答案 |
| 多选题 | `multiple` | 可以选择多个答案 |
| 判断题 | `judgment` | 只有正确/错误两个选项 |
| 填空题 | `fill` | 不需要选项，直接填写答案 |

## 注意事项

1. **编码**：XML文件必须使用UTF-8编码
2. **格式**：确保XML格式正确，标签要闭合
3. **图片路径**：
   - 本地路径要使用绝对路径
   - 网络URL要完整（包含http://或https://）
4. **多选题答案**：用逗号分隔，不要有空格
5. **填空题**：`<options/>` 可以为空或省略

## 使用场景

这个XML文件可以用于：
1. **参考格式**：了解题目的完整结构
2. **数据交换**：如果未来需要支持XML导入
3. **数据备份**：以XML格式保存题目数据
4. **格式转换**：可以转换为Excel或CSV格式

## 转换为Excel/CSV

如果需要导入到应用中，可以：
1. 手动将XML内容转换为Excel格式
2. 或者使用工具将XML转换为CSV
3. 或者等待应用支持XML导入功能

