---
title: 字符串
copyrighr: true
hide: true
date: 2024-04-17 17:37:39
tags:
    - Python
categories:
    - Python
---
# 字符串

## 字符串简介

字符串就是一系列字符。在Python中，用引号括起来的字符都是字符串，其中引号可以是单引号或双引号。

```
'Hello,World!'
"Hello,World!"
```

## 使用方法修改字符串的大小写

1. `upper()`: 这个方法将字符串中所有的字母转换为大写字母，并返回转换后的新字符串。例如：`"hello".upper()` 将返回 `"HELLO"`.
2. `lower()`: 这个方法将字符串中所有的字母转换为小写字母，并返回转换后的新字符串。例如：`"Hello".lower()` 将返回 `"hello"`.
3. `capitalize()`: 这个方法将字符串的第一个字母转换为大写，其他字母转换为小写，并返回转换后的新字符串。例如：`"hello world".capitalize()` 将返回 `"Hello world"`.
4. `title()`: 这个方法将字符串中每个单词的首字母转换为大写，并返回转换后的新字符串。例如：`"hello world".title()` 将返回 `"Hello World"`.
5. `swapcase()`: 这个方法将字符串中所有的大写字母转换为小写字母，所有的小写字母转换为大写字母，并返回转换后的新字符串。例如：`"Hello World".swapcase()` 将返回 `"hELLO wORLD"`.

```python
name = "james jnderson"
print(name.upper())
print(name.lower())
print(name.capitalize())
print(name.title())
print(name.swapcase())
```

输出结果如下

```
>>> print(name.upper())
JAMES JNDERSON
>>> print(name.lower())
james jnderson
>>> print(name.capitalize())
James jnderson
>>> print(name.title())
James Jnderson
>>> print(name.swapcase())
JAMES JNDERSON
>>> 
```

## 合并（拼接）字符串

使用`+`号来拼接字符串

```python
first_name = "James"
last_name = "Jnderson"
full_name = first_name + " " + last_name
print(full_name)
print("Hello, " + full_name.title() + "!")
message = "Hello, " + full_name.title() + "!"
print(message)
```

## 使用制表符或换行符添加空白

空白泛指任何非打印字符，如空格、制表符和换行符。可使用空白来组织输出，以使其更易读。

使用制表符

```python
print("\tHello,World")
```

使用换行符

```python
print("Languages:\n\tPython\n\tShell\n\tGo")
```

## 使用方法删除空白

在Python中，删除字符串两端的空白字符（空格、制表符、换行符等）通常使用 `strip()` 方法。这个方法会返回一个删除了两端空白字符的新字符串，原始字符串不会被改变。

```python
text = "  Hello, World!   "
new_text = text.strip()
print(new_text)  # 输出: "Hello, World!"
```

如果你只想删除字符串开头的空白字符，可以使用 `lstrip()` 方法；如果只想删除字符串末尾的空白字符，可以使用 `rstrip()` 方法。

```python
text = "  Hello, World!   "
new_text_start = text.lstrip()
new_text_end = text.rstrip()
print(new_text_start)  # 输出: "Hello, World!   "
print(new_text_end)    # 输出: "  Hello, World!"
```

如果想删除字符串内部的所有空白字符，可以使用 `replace()` 方法将空白字符替换为空字符串：

```python
text = "Hello,    World!"
new_text = text.replace(" ", "")
print(new_text)  # 输出: "Hello,World!"
```

## 格式化字符串

在Python中，格式化字符串是一种方便的方法，用于将变量、表达式或其他数据插入到字符串中。Python提供了多种方式来格式化字符串，包括旧式的`%`操作符、`str.format()`方法和最新的f-字符串（f-string）。

### 1. 使用`%`操作符进行字符串格式化（旧式）

```python
name = "Alice"
age = 30
formatted_string = "My name is %s and I am %d years old." % (name, age)
print(formatted_string)
```

### 2. 使用`str.format()`方法进行字符串格式化

```python
name = "Bob"
age = 25
formatted_string = "My name is {} and I am {} years old.".format(name, age)
print(formatted_string)
```

### 3. 使用f-字符串（f-string）进行字符串格式化（Python 3.6及以上版本）

```python
name = "Charlie"
age = 35
formatted_string = f"My name is {name} and I am {age} years old."
print(formatted_string)
```

### 格式化字符串的常见用法：

- **占位符**：例如 `%s`、`%d`，用于字符串和整数格式化。
- **精度和宽度**：控制浮点数的小数位数或整数的位数。
- **字典和列表**：可以使用字典或列表来传递参数进行格式化。

### 示例：

```python
# 精度和宽度
pi = 3.14159
print("Pi is {:.2f}".format(pi))  # 保留两位小数

# 使用字典和列表
person = {'name': 'David', 'age': 28}
print("My name is {name} and I am {age} years old.".format(**person))

languages = ['Python', 'Java', 'C++']
print("I like {}, {} and {}.".format(*languages))
```
