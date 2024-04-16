---
title: 列表
copyrighr: true
hide: true
date: 2024-04-17 17:37:39
tags:
    - Python
categories:
    - Python
---
## 列表

## 创建列表

可以使用方括号 \([]\) 来创建一个列表，并在其中放入逗号分隔的元素。

```python
my_list = [1, 2, 3, 4, 5]
```

## 访问列表元素

可以使用索引来访问列表中的元素，索引从0开始。

```python
print(my_list[0])  # 输出 1
```

## 列表的长度

可以使用`len()`函数来获取列表中元素的个数。

```python
print(len(my_list))  # 输出 5
```

## 添加元素

可以使用`append()`方法向列表末尾添加新元素。

```python
my_list.append(6)
```

可以使用`insert`方法向指定位置添加新元素。

```
my_list.insert(0,6)  #指在下标为0的位置插入新元素6
```

## 删除元素

可以使用`del`语句删除或使用`remove()`方法删除指定的元素，或者使用`pop()`方法删除指定索引的元素。

```python
del my_list[0]     #删除索引为0的元素
my_list.remove(3)  # 删除元素3
my_list.pop(0)      # 删除索引为0的元素，不加索引则默认删除列表末尾的元素
```

## 切片

列表切片是指从一个列表中提取出一部分元素的操作。在Python中，可以使用列表切片来获取列表中的子列表。列表切片的基本语法是 `list[start:stop:step]`，其中：

- `start`：起始索引，表示切片的起始位置（包含该位置的元素）。
- `stop`：结束索引，表示切片的结束位置（不包含该位置的元素）。
- `step`：步长，表示从起始位置到结束位置的间隔，默认为1。

以下是一些示例：

```python
my_list = [1, 2, 3, 4, 5, 6, 7, 8, 9]

# 获取索引1到索引4之间的元素（不包括索引4）
slice1 = my_list[1:4]
print(slice1)  # Output: [2, 3, 4]

# 获取索引0到索引4之间的元素（不包含索引4）
slice2 = my_list[:4]
print(slice2)  # Output: [1,2,3,4]

# 获取从索引2开始到列表末尾的所有元素
slice2 = my_list[2:]
print(slice2)  # Output: [3, 4, 5, 6, 7, 8, 9]

# 获取从列表开头到索引5（不包括索引5）的所有元素，步长为2
slice3 = my_list[:5:2]
print(slice3)  # Output: [1, 3, 5]

# 使用负数索引，获取倒数第三个元素到倒数第一个元素
slice4 = my_list[-3:]
print(slice4)  # Output: [7, 8, 9]
```

通过使用不同的起始索引、结束索引和步长，可以灵活地对列表进行切片操作。

## 列表的修改

可以直接通过索引对列表元素进行修改。

```python
my_list[0] = 10
```

## 列表的循环

可以使用`for`循环遍历列表中的元素。

```python
for item in my_list:
    print(item)
```

## 列表的排序

可以使用`sort()`方法对列表进行排序。

```python
my_list.sort()
```

## 列表的复制

可以使用切片操作符`[:]`或者`copy()`方法复制一个列表。

```python
new_list = my_list[:]
```

## 创建数值列表

`range()`函数是Python中用来生成一系列数字的函数。它有几种不同的用法：

1. **只有一个参数**：`range(stop)` 会生成从 0 开始到 `stop-1` 结束的整数序列。

2. **两个参数**：`range(start, stop)` 会生成从 `start` 开始到 `stop-1` 结束的整数序列。
3. **三个参数**：`range(start, stop, step)` 会生成从 `start` 开始到 `stop-1` 结束的整数序列，步长为 `step`。

使用函数`range`生成数字

```
# 打印数字1-4
for value in range(1,5):
	print(value)
```

使用`list()`函数将`range()`生成的结果直接转换为列表

```
# 生成列表[1,2,3,4]
for value in list(range(1,5))
	print(value)
```

## 列表解析

列表解析（List comprehension）是一种简洁的方法，用于根据现有的列表创建新的列表。在Python中，列表解析允许您使用一行代码来创建新的列表，而不必使用传统的for循环和if语句。

下面是一个简单的示例，演示如何使用列表解析来创建一个包含原始列表中每个元素的平方的新列表：

```python
# 使用列表解析来创建一个包含原始列表中每个元素的平方的新列表
original_list = [1, 2, 3, 4, 5]
squared_list = [x**2 for x in original_list]
print(squared_list)
```

这将打印出`[1, 4, 9, 16, 25]`，即原始列表中每个元素的平方。

列表解析的一般语法如下：

```python
new_list = [expression for item in iterable if condition]
```

- `expression`：要对每个元素执行的操作。
- `item`：表示正在迭代的当前元素。
- `iterable`：要迭代的对象，如列表、元组、集合等。
- `condition`（可选）：用于筛选元素的条件。

