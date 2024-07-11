---
title: 分支语句
copyrighr: true
hide: true
date: 2024-04-18 15:46:39
tags:
    - Python
categories:
    - Python
---
# 分支语句

## if结构

在Python中，`if`语句用于执行一个代码块，只有在指定条件为真时才执行。`if`语句的一般形式如下：

```python
if condition:
    # 如果条件为真，则执行这里的代码块
```

- `condition`是一个表达式，如果该表达式的值为`True`，则执行`if`语句下面的代码块，否则跳过该代码块。

以下是一些示例，演示了`if`语法结构的使用：

示例1：

```python
x = 10

if x > 5:
    print("x is greater than 5")
```

在这个示例中，如果变量`x`的值大于5，程序将输出"x is greater than 5"。如果`x`的值小于或等于5，`print`语句将不会执行。

示例2：

```
# conding=utf-8
import sys

score = int(sys.argv[1])

if score >= 85:
	print("你真优秀！")

if score < 60:
    print("你需要加倍努力！")

if (score >= 60) and (score < 85):
    print("你的成绩适中，仍需继续努力！")
```

在这个示例中，根据用户输入的数字进行判断。执行方式`python 脚本名称  参数` ,如用户输出参数为85，则会输出你真优秀。

## if-else结构

在Python中，`if-else`语法结构用于在程序中进行简单的条件判断。它的一般形式如下：

```python
if condition:
    # 如果条件为真，则执行这里的代码块
else:
    # 如果条件为假，则执行这里的代码块
```

- `condition`是一个表达式，如果该表达式的值为`True`，则执行`if`语句下面的代码块，否则执行`else`语句下面的代码块。

以下是一些示例，演示了`if-else`语法结构的使用：

示例1：

```python
x = 10

if x > 5:
    print("x is greater than 5")
else:
    print("x is less than or equal to 5")
```

在这个示例中，如果变量`x`的值大于5，程序将输出"x is greater than 5"；否则，程序将输出"x is less than or equal to 5"。

示例2：

```
# conding=utf-8
import sys

score = int(sys.argv[1])

if score >= 60:
    print("及格")
    if score >= 90:
        print("优秀")
else:
    print("不及格")
```

在这个示例中，使用了嵌套if进行判断。执行方式`python 脚本名称  参数` ,根据用户输入的参数进行判断，如果输入的数据大于等于60且小于90则输出及格，如果大于等于90则输出优秀，否则输出不合格。

## if-elif-else结构

语法示例：

```python
if condition1:
    # 执行条件1为真时的代码块
elif condition2:
    # 执行条件2为真时的代码块
else:
    # 所有条件都不为真时执行的代码块
```

- `if`语句用于检查一个条件是否为真，如果为真，则执行相应的代码块。
- `elif`语句用于检查另一个条件是否为真，如果前面的条件都不为真且该条件为真，则执行相应的代码块。
- `else`语句用于处理所有条件都不为真的情况，执行相应的代码块。

以下是一些示例，演示了`if-elif-else`语法结构的使用：

示例1：

```python
x = 10

if x > 10:
    print("x is greater than 10")
elif x < 10:
    print("x is less than 10")
else:
    print("x is equal to 10")
```

在这个示例中，根据变量`x`的值，程序将输出不同的消息。

示例2：

```
# conding=utf-8

import  sys

acore = int(sys.argv[1])

if acore >= 90:
    print("优秀")
elif acore >= 80:
    print("中等")
else:
    print("淘汰")
```

执行方式`python 脚本名称  参数` ,根据用户输入的参数进行判断，如果用户输入大于等于90则输入优秀。输出内容大于等于80小于90则输入中等。小于80则输入淘汰。

## 扩展

1.**多个条件的判断**:

```python
x = 10
y = 5
if x > 5 and y > 2:
    print("x大于5且y大于2")
```

2.**嵌套的`if`语句**:

```python
x = 10
if x > 5:
    if x < 15:
        print("x大于5且小于15")
```

3.**使用`in`关键字检查元素是否在列表中**:

```python
fruits = ['apple', 'banana', 'orange']
if 'apple' in fruits:
    print("苹果在水果列表中")
```

4.**使用`not`关键字取反**:

```python
x = 10
if not x == 5:
    print("x不等于5")
```



