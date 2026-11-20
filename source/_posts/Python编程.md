---
title: Python编程
copyrighr: true
date: 2026-07-13 21:24:01
tags:
  - Python
categories:
  - Python
---

# Python 编程完整学习文档

```markdown
# Python 编程完整学习文档

> **适用版本：Python 3.10+**
>
> 从零基础到高级特性，覆盖 25 个核心主题，250+ 可运行代码示例。每个知识点都配有可直接运行的代码示例、易错点提示和最佳实践建议。

## 前置要求

| 项目 | 说明 |
|------|------|
| Python 版本 | 3.10+（推荐 3.12） |
| 编辑器 | VS Code + Python 插件 / PyCharm |
| 操作系统 | Windows / macOS / Linux |
| 前置知识 | 无，从零开始 |

---

## 目录

<!-- more -->

- [01 环境搭建与入门](#01-环境搭建与入门)
- [02 变量与数据类型](#02-变量与数据类型)
- [03 运算符详解](#03-运算符详解)
- [04 字符串操作](#04-字符串操作)
- [05 列表与元组](#05-列表与元组)
- [06 字典与集合](#06-字典与集合)
- [07 条件判断](#07-条件判断)
- [08 循环结构](#08-循环结构)
- [09 函数](#09-函数)
- [10 模块与包](#10-模块与包)
- [11 虚拟环境与包管理](#11-虚拟环境与包管理)
- [12 文件操作](#12-文件操作)
- [13 异常处理](#13-异常处理)
- [14 面向对象编程](#14-面向对象编程)
- [15 面向对象进阶](#15-面向对象进阶)
- [16 类型注解与静态分析](#16-类型注解与静态分析)
- [17 装饰器与闭包](#17-装饰器与闭包)
- [18 生成器与迭代器](#18-生成器与迭代器)
- [19 上下文管理器](#19-上下文管理器)
- [20 并发编程](#20-并发编程)
- [21 正则表达式](#21-正则表达式)
- [22 常用标准库](#22-常用标准库)
- [23 单元测试与调试](#23-单元测试与调试)
- [24 代码规范与项目工程化](#24-代码规范与项目工程化)
- [25 实战项目集](#25-实战项目集)
- [附录 A Python 3.10~3.13 新特性速查](#附录-a-python-3-103-13-新特性速查)
- [附录 B 常见陷阱与最佳实践](#附录-b-常见陷阱与最佳实践)

---

## 01 环境搭建与入门

Python 是一门优雅、简洁、功能强大的通用编程语言，由 Guido van Rossum 于 1991 年创造。它的设计哲学强调**代码可读性**和**简洁性**。

### 1.1 安装 Python

```bash
# ===== macOS =====
# 方式一：Homebrew（推荐）
brew install python@3.12

# 方式二：官方安装包
# 去 https://www.python.org/downloads/macos/ 下载 .pkg 安装

# ===== Ubuntu / Debian =====
sudo apt update
sudo apt install -y python3.12 python3.12-venv python3-pip

# ===== Fedora =====
sudo dnf install python3.12

# ===== Windows =====
# 去 https://www.python.org/downloads/ 下载安装包
# ⚠️ 安装时务必勾选 "Add Python to PATH"
# 或者通过 winget 安装：
winget install Python.Python.3.12

# ===== 验证安装 =====
python3 --version       # Python 3.12.x
python3 -m pip --version
```

### 1.2 第一个程序

```python
# hello.py —— 我的第一个 Python 程序

# 单行注释用 # 开头
"""
这是多行字符串，同时也是多行注释。
Python 没有专门的多行注释语法，
通常用三引号字符串来实现。
"""

print("Hello, World!")
print("你好，Python！")

# print() 的高级用法
print("Hello", "World", sep=", ")     # 自定义分隔符
print("加载中", end="...")              # 自定义结尾（不换行）
print("完成")                            # 输出: 加载中...完成

# 多行字符串的打印
print("""
╔══════════════════════════╗
║  Welcome to Python 3.12  ║
╚══════════════════════════╝
""")

# input() 获取用户输入
name = input("请输入你的名字: ")
print(f"你好, {name}! 欢迎学习 Python!")
```

### 1.3 Python 的运行方式

```bash
# 方式一：交互式解释器（REPL）—— 适合快速测试
python3
>>> 1 + 1
2
>>> "hello".upper()
'HELLO'
>>> exit()

# 方式二：执行脚本文件 —— 最常用
python3 hello.py

# 方式三：内联执行 -c
python3 -c "print('hello')"

# 方式四：模块运行 -m
python3 -m http.server 8080

# 方式五：Jupyter Notebook —— 适合数据分析和教学
pip install jupyter
jupyter notebook
```

### 1.4 Python 之禅

```python
import this
```

核心原则摘录：

- **优美优于丑陋**（Beautiful is better than ugly）
- **明了优于隐晦**（Explicit is better than implicit）
- **简单优于复杂**（Simple is better than complex）
- **可读性很重要**（Readability counts）
- **做一件事应该有且仅有一种显而易见的方式**

### 1.5 代码规范基础

```python
# ✅ Python 使用缩进表示代码块（通常 4 个空格，不要混用 Tab 和空格）
if True:
    print("缩进 4 个空格")
    if True:
        print("再缩进 4 个空格")

# ✅ 一行只写一条语句
x = 1
y = 2

# ⚠️ 一行多条语句（语法允许但不推荐）
x = 1; y = 2; z = 3

# ✅ 长行可以使用反斜杠换行（推荐用括号代替）
total = (1 + 2 + 3
         + 4 + 5 + 6)

# ✅ 命名规范
my_variable = 10        # 变量：小写 + 下划线（snake_case）
MY_CONSTANT = 3.14      # 常量：全大写
my_function = lambda: 0  # 函数：小写 + 下划线
MyClass = type("MyClass", (), {})  # 类：大写开头（PascalCase）
```

---

## 02 变量与数据类型

Python 是**动态类型**语言——变量不需要声明类型，赋值即创建，类型由值决定。

### 2.1 变量赋值

```python
# 基本赋值
name = "Alice"         # 字符串
age = 25                # 整数
height = 1.68           # 浮点数
is_student = True       # 布尔值

# 多变量赋值
a, b, c = 1, 2, 3
x = y = z = 0           # 链式赋值（多个变量指向同一个值）

# 变量交换（Pythonic 写法，不需要临时变量）
a, b = b, a

# 增量赋值
count = 0
count += 1              # 等价于 count = count + 1

# 查看类型
print(type(name))       # <class 'str'>
print(type(age))        # <class 'int'>
print(type(is_student)) # <class 'bool'>
```

### 2.2 基本数据类型

| 类型 | 关键字 | 示例 | 说明 |
|------|--------|------|------|
| 整数 | `int` | `42`, `-7`, `0xFF` | 无大小限制 |
| 浮点数 | `float` | `3.14`, `2.5e3`, `1e-4` | 双精度浮点 |
| 布尔 | `bool` | `True`, `False` | `int` 的子类 |
| 字符串 | `str` | `"hello"`, `'world'` | 不可变序列 |
| 空值 | `NoneType` | `None` | 表示"没有值" |
| 复数 | `complex` | `3+4j` | 工程计算 |

```python
# 整数 —— 没有溢出！
big = 9999999999999999999999999999
print(big ** 2)  # 正常运算

# 不同进制
print(0b1010)      # 二进制 → 10
print(0o17)        # 八进制 → 15
print(0xFF)        # 十六进制 → 255
print(1_000_000)   # 数字分隔符 → 1000000

# 浮点数精度问题
print(0.1 + 0.2)         # 0.30000000000000004（经典问题）
print(0.1 + 0.2 == 0.3)  # False！

# 解决方案
import math
print(math.isclose(0.1 + 0.2, 0.3))  # True

from decimal import Decimal
print(Decimal("0.1") + Decimal("0.2") == Decimal("0.3"))  # True

# 布尔值是 int 的子类
print(True + True)   # 2
print(True * 10)      # 10
print(isinstance(True, int))  # True
```

### 2.3 类型转换

```python
# 隐式类型转换（运算时自动提升）
result = 1 + 2.0   # int + float → float
print(result, type(result))  # 3.0 <class 'float'>

# 显式类型转换
s = "123"
print(int(s))         # 字符串 → 整数
print(float(s))       # 字符串 → 浮点数
print(str(42))         # 整数 → 字符串
print(bool(0))         # 0 → False
print(bool(""))        # 空字符串 → False
print(bool([]))         # 空列表 → False
print(bool(None))       # None → False
print(bool(42))         # 非零 → True
print(bool("hello"))    # 非空 → True

# ⚠️ 不合法的转换会报错
# int("hello")     → ValueError
# int("3.14")      → ValueError（不能直接转）
print(int(float("3.14")))  # 先转 float 再转 int → 3
```

### 2.4 None 与 is 运算符

```python
# None 是单例对象，用 is 判断
value = None

if value is None:
    print("value 是 None")       # ✅ 推荐用 is
if value is not None:
    print("value 不是 None")

# ⚠️ 不要用 == 判断 None
# 虽然 == 也能工作，但 is 更精确、更快

# 变量赋值演示
x = [1, 2]
y = x            # y 和 x 指向同一个对象
z = [1, 2]       # z 是新对象，和 x 值相同但地址不同

print(x == z)     # True  值相等
print(x is z)     # False 不是同一个对象
print(x is y)     # True  同一个对象
```

---

## 03 运算符详解

### 3.1 算术运算符

```python
a, b = 17, 5

print(a + b)    # 22       加法
print(a - b)    # 12       减法
print(a * b)    # 85       乘法
print(a / b)    # 3.4      真除法（结果始终是 float）
print(a // b)   # 3        整除（向下取整）
print(a % b)    # 2        取余（模运算）
print(a ** b)   # 1419857  幂运算

# ⚠️ 整除是向下取整，不是截断
print(-7 // 2)   # -4（不是 -3！）
print(7 // -2)   # -4

# divmod() 同时获取商和余数
q, r = divmod(17, 5)
print(q, r)      # 3 2

# 赋值运算符
x = 10
x += 5    # x = x + 5   → 15
x -= 3    # x = x - 3   → 12
x *= 2    # x = x * 2   → 24
x //= 5   # x = x // 5  → 4
x **= 3   # x = x ** 3  → 64
```

### 3.2 比较运算符

```python
print(5 == 5)      # True   等于
print(5 != 3)      # True   不等于
print(5 > 3)       # True   大于
print(5 < 3)       # False  小于
print(5 >= 5)      # True   大于等于
print(5 <= 3)       # False  小于等于

# 链式比较（Python 独有！）
x = 5
print(1 < x < 10)          # True（等价于 1 < x and x < 10）
print(0 <= x <= 100)       # True
print(1 < 2 < 3 < 4 < 5)   # True
```

### 3.3 逻辑运算符

```python
# and / or / not
print(True and False)    # False
print(True or False)     # True
print(not True)           # False

# ⚠️ and 和 or 返回的不是 True/False，而是操作数本身！
# or 返回第一个为真的值
print(0 or [] or "hello" or "world")   # "hello"
print("" or "default")                   # "default"

# and 返回最后一个为真的值，或第一个为假的值
print(1 and 2 and 3)      # 3
print(1 and 0 and 3)       # 0

# 实际应用：提供默认值
name = user_input or "匿名用户"
config = config or load_default_config()

# 短路求值：or 遇到真值就停止，and 遇到假值就停止
def side_effect(msg):
    print(msg)
    return True

False and side_effect("不会执行")   # 短路，不执行 side_effect
True or side_effect("不会执行")     # 短路，不执行 side_effect
```

### 3.4 身份运算符与成员运算符

```python
# is —— 判断是否是同一个对象（比较内存地址）
# == —— 判断值是否相等

a = [1, 2, 3]
b = [1, 2, 3]
c = a

print(a == b)     # True  值相等
print(a is b)     # False 不是同一个对象
print(a is c)     # True  同一个对象

# ✅ 永远用 is 判断 None
if a is None:
    pass
if a is not None:
    pass

# in —— 成员判断
print("py" in "python")        # True
print(3 in [1, 2, 3])          # True
print("key" in {"key": "val"}) # True（检查键）

# 字符串的 in 是子串搜索（O(n)）
# 集合/字典的 in 是哈希查找（O(1)）
```

### 3.5 位运算符

```python
a, b = 0b1010, 0b1100   # 10, 12

print(bin(a &  b))   # 0b1000 (8)    按位与
print(bin(a |  b))   # 0b1110 (14)   按位或
print(bin(a ^  b))   # 0b0110 (6)    按位异或
print(bin(~a))        # -11           按位取反
print(bin(a << 2))   # 0b101000 (40) 左移
print(bin(a >> 1))   # 0b101 (5)     右移

# 实用场景：权限管理
READ    = 0b100  # 4
WRITE   = 0b010  # 2
EXECUTE = 0b001  # 1

permission = READ | WRITE           # 赋予读写权限
print(permission & READ)             # 非零 → 有读权限
print(permission & EXECUTE)           # 零 → 无执行权限
permission |= EXECUTE                # 添加执行权限
print(bin(permission))                # 0b111
```

### 3.6 运算符优先级

从高到低：

| 优先级 | 运算符 | 说明 |
|--------|--------|------|
| 1 | `**` | 幂运算 |
| 2 | `+x`, `-x`, `~x` | 一元正号、取反、按位取反 |
| 3 | `*`, `/`, `//`, `%` | 乘、除、整除、取余 |
| 4 | `+`, `-` | 加、减 |
| 5 | `<<`, `>>` | 移位 |
| 6 | `&` | 按位与 |
| 7 | `^` | 按位异或 |
| 8 | `\|` | 按位或 |
| 9 | `==`, `!=`, `<`, `<=`, `>`, `>=`, `is`, `in` | 比较 |
| 10 | `not` | 逻辑非 |
| 11 | `and` | 逻辑与 |
| 12 | `or` | 逻辑或 |

> **💡 建议**：记不清优先级时，用括号明确表达意图。代码可读性永远比省几行代码更重要。

---

## 04 字符串操作

字符串是 Python 中最常用的数据类型。Python 字符串是**不可变的 Unicode 序列**。

### 4.1 创建字符串

```python
s1 = 'hello'         # 单引号
s2 = "hello"         # 双引号（和单引号完全等价）
s3 = '''多行           # 三引号：保留换行
字符串'''
s4 = """也是
多行字符串"""

# 含有引号的情况
s5 = "He said 'hello'"       # 双引号内嵌单引号
s6 = 'He said "hello"'       # 单引号内嵌双引号
s7 = "He said \"hello\""     # 转义字符

# 原始字符串（忽略转义）
path = r"C:\Users\test\new"  # 不会把 \n 解释为换行
regex = r"\d+\.\d+"
```

### 4.2 索引与切片

```python
s = "Python"
#     012345
#    -654321

# 索引
print(s[0])      # P（第一个字符）
print(s[-1])     # n（最后一个字符）

# 切片 [start:stop:step]
print(s[0:3])    # Pyt（索引 0、1、2）
print(s[2:])     # thon（从索引 2 到末尾）
print(s[:4])     # Pyth（从开头到索引 3）
print(s[::2])    # Pto（每隔一个取一个）
print(s[::-1])   # nohtyP（反转！）

# ⚠️ 切片不会越界，索引会越界
print(s[0:100])  # "Python"（安全）
# print(s[100])  # IndexError!
```

### 4.3 f-string 格式化（推荐）

```python
name = "Alice"
age = 25
pi = 3.14159

# 基本用法
print(f"我叫 {name}，今年 {age} 岁")

# 表达式
print(f"明年 {age + 1} 岁")
print(f"大写: {name.upper()}")

# 数字格式化
print(f"圆周率: {pi:.2f}")       # 3.14
print(f"百分比: {0.856:.1%}")     # 85.6%
print(f"千分位: {1000000:,}")    # 1,000,000
print(f"二进制: {42:b}")          # 101010
print(f"八进制: {42:o}")          # 52
print(f"十六进制: {255:#x}")      # 0xff
print(f"科学记数: {1234567.89:.2e}")  # 1.23e+06

# 对齐与填充
print(f"{'左对齐':<10}!")    # 左对齐      !
print(f"{'右对齐':>10}!")    #       右对齐!
print(f"{'居中':^10}!")      #    居中    !
print(f"{'填充':*^10}")      # ***填充****

# 调试技巧（Python 3.8+）
x, y = 10, 20
print(f"{x=}, {y=}, {x+y=}")  # x=10, y=20, x+y=30
```

### 4.4 常用方法

```python
s = "  Hello, World!  "

# 大小写
print(s.upper())          # "  HELLO, WORLD!  "
print(s.lower())          # "  hello, world!  "
print(s.title())          # "  Hello, World!  "
print(s.swapcase())       # "  hELLO, wORLD!  "
print(s.capitalize())     # "  hello, world!  "

# 去空白
print(s.strip())           # "Hello, World!"
print(s.lstrip())          # "Hello, World!  "
print(s.rstrip())          # "  Hello, World!"
print("***hello***".strip("*"))  # "hello"

# 查找
s2 = "Hello, World!"
print(s2.find("World"))    # 7（索引位置）
print(s2.find("xyz"))      # -1（未找到）
print(s2.index("World"))   # 7（同 find，但未找到时抛 ValueError）
print(s2.count("l"))       # 3
print(s2.startswith("He"))  # True
print(s2.endswith("!"))     # True

# 替换
print(s2.replace("World", "Python"))      # "Hello, Python!"
print(s2.replace("l", "L", 1))             # "HeLlo, World!"（只替换第一个）

# 分割与连接
csv = "apple,banana,cherry"
fruits = csv.split(",")          # ['apple', 'banana', 'cherry']
result = " | ".join(fruits)     # "apple | banana | cherry"
lines = "one\ntwo\nthree".splitlines()  # ['one', 'two', 'three']

# 判断
print("abc123".isalnum())   # True  字母或数字
print("abc".isalpha())      # True  纯字母
print("123".isdigit())      # True  纯数字
print("  ".isspace())        # True  纯空白
print("Hello".istitle())    # True  标题格式
print("HELLO".isupper())    # True
```

### 4.5 字符串不可变性

```python
s = "hello"
# s[0] = "H"  # TypeError! 字符串不可修改

# 需要修改时，创建新字符串
s = "H" + s[1:]        # "Hello"
s = s.replace("e", "E")  # "HEllo"
```

---

## 05 列表与元组

列表（list）是**可变的有序序列**，元组（tuple）是**不可变的有序序列**。它们是 Python 中最常用的数据容器。

### 5.1 列表基础

```python
# 创建列表
fruits = ["apple", "banana", "cherry"]
mixed = [1, "hello", 3.14, True, None, [1, 2]]  # 可以混合类型
empty = []
nums = list(range(1, 6))       # [1, 2, 3, 4, 5]
repeated = [0] * 5               # [0, 0, 0, 0, 0]

# 长度
print(len(fruits))   # 3
```

### 5.2 增删改查

```python
fruits = ["apple", "banana", "cherry"]

# ===== 增 =====
fruits.append("date")              # 末尾追加一个元素
fruits.insert(1, "avocado")      # 在索引 1 处插入
fruits.extend(["elderberry"])     # 扩展列表（添加多个）
fruits += ["fig"]                   # 等价于 extend

# ===== 删 =====
fruits.remove("banana")          # 按值删除（第一个匹配）
popped = fruits.pop()              # 弹出末尾元素并返回
popped = fruits.pop(0)             # 弹出指定索引
del fruits[0]                       # 删除指定索引
fruits.clear()                      # 清空列表

# ===== 改 =====
fruits = ["apple", "banana", "cherry"]
fruits[0] = "apricot"             # 修改指定索引
fruits[1:3] = ["blueberry"]       # 切片赋值（可以改变长度）

# ===== 查 =====
fruits = ["apple", "banana", "cherry", "banana"]
print(fruits.index("banana"))       # 1（第一个匹配的索引）
print(fruits.index("banana", 2))  # 3（从索引 2 开始查找）
print(fruits.count("banana"))       # 2
print("apple" in fruits)             # True
print("grape" not in fruits)         # True
```

### 5.3 排序与反转

```python
nums = [3, 1, 4, 1, 5, 9, 2, 6]

# sort() —— 原地排序（修改原列表）
nums.sort()                   # 升序
nums.sort(reverse=True)       # 降序

# 自定义排序规则
words = ["banana", "apple", "cherry", "date"]
words.sort(key=len)             # 按长度排序
words.sort(key=str.lower)       # 按字母排序（忽略大小写）

# sorted() —— 返回新列表（不修改原列表）
original = [3, 1, 4, 1, 5]
new_sorted = sorted(original)
print(original)      # [3, 1, 4, 1, 5]（不变）
print(new_sorted)   # [1, 1, 3, 4, 5]

# reverse()
nums = [1, 2, 3]
nums.reverse()     # 原地反转 → [3, 2, 1]
print(list(reversed(nums)))   # reversed() 返回迭代器
```

### 5.4 列表推导式

```python
# 基本语法: [表达式 for 变量 in 可迭代对象]
squares = [x**2 for x in range(10)]
# [0, 1, 4, 9, 16, 25, 36, 49, 64, 81]

# 带条件过滤: [表达式 for 变量 in 可迭代对象 if 条件]
evens = [x for x in range(20) if x % 2 == 0]
# [0, 2, 4, 6, 8, 10, 12, 14, 16, 18]

# 嵌套循环
matrix = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
flat = [num for row in matrix for num in row]
# [1, 2, 3, 4, 5, 6, 7, 8, 9]

# 带 if-else（注意位置不同）
labels = ["偶" if x % 2 == 0 else "奇" for x in range(5)]
# ['偶', '奇', '偶', '奇', '偶']

# 实用示例
words = ["hello", "WORLD", "Python"]
lower_words = [w.lower() for w in words]
long_words = [w for w in words if len(w) > 4]
matrix_t = [[row[i] for row in matrix] for i in range(3)]  # 转置
```

### 5.5 元组

```python
# 创建元组
point = (3, 4)
single = (42,)         # ⚠️ 必须有逗号！否则只是普通括号
t = tuple([1, 2, 3])

# 操作（比列表少，因为不可变）
print(point[0])         # 3
print(point[1:])        # (4,)
print(len(point))        # 2
print(point.count(3))   # 1
print(point.index(4))   # 1

# 解包
x, y = point
print(x, y)   # 3 4

# 扩展解包
first, *rest = [1, 2, 3, 4, 5]
# first=1, rest=[2, 3, 4, 5]

first, *middle, last = (1, 2, 3, 4, 5)
# first=1, middle=[2, 3, 4], last=5

# ⚠️ 元组不可修改
# point[0] = 10  # TypeError!

# 命名元组
from collections import namedtuple
Point = namedtuple("Point", ["x", "y"])
p = Point(3, 4)
print(p.x, p.y)       # 3 4
print(p[0], p[1])     # 3 4

# typing.NamedTuple（推荐，支持类型注解）
from typing import NamedTuple

class Student(NamedTuple):
    name: str
    age: int
    grade: float = 4.0  # 默认值

s = Student("Alice", 20)
print(s.name, s.grade)  # Alice 4.0
```

### 5.6 list vs tuple 选择指南

| 特性 | list | tuple |
|------|------|-------|
| 可变 | ✅ | ❌ |
| 可作为字典的键 | ❌ | ✅ |
| 可放入集合 | ❌ | ✅ |
| 内存占用 | 较大 | 较小 |
| 创建速度 | 较慢 | 较快 |
| 适用场景 | 需要增删改的集合 | 固定结构的记录 |

> **💡 经验法则**：如果数据不需要修改，用 tuple。函数返回多个值时用 tuple。当做字典的键时用 tuple。

---

## 06 字典与集合

### 6.1 字典基础

```python
# 创建字典
user = {
    "name": "Alice",
    "age": 25,
    "city": "Beijing",
    "skills": ["Python", "SQL"],
}

# 构造函数
d1 = dict(name="Alice", age=25)
d2 = dict([("name", "Alice"), ("age", 25)])
d3 = dict.fromkeys(["a", "b", "c"], 0)  # {'a': 0, 'b': 0, 'c': 0}

# 访问
print(user["name"])                      # Alice
print(user.get("phone"))                  # None（键不存在不报错）
print(user.get("phone", "无"))           # "无"（默认值）

# ⚠️ 直接访问不存在的键会报 KeyError
# print(user["phone"])  # KeyError!
```

### 6.2 增删改查

```python
user = {"name": "Alice", "age": 25}

# 增 / 改
user["email"] = "alice@example.com"    # 新增
user["age"] = 26                        # 修改

# setdefault —— 键不存在时才设置
user.setdefault("city", "Beijing")     # 键不存在，设置
user.setdefault("age", 30)             # 键已存在，不修改

# update —— 批量更新
user.update({"age": 27, "phone": "123"})

# 删除
del user["phone"]                       # 删除键
email = user.pop("email")              # 弹出并返回
user.pop("xxx", None)                  # 不存在时不报错
last = user.popitem()                  # 弹出最后一个键值对
user.clear()                            # 清空

# 遍历
user = {"name": "Alice", "age": 25, "city": "Beijing"}

for key in user:                       # 遍历键
    print(key)

for value in user.values():            # 遍历值
    print(value)

for key, value in user.items():        # 遍历键值对
    print(f"{key}: {value}")

# 判断键是否存在
print("name" in user)        # True
print("phone" not in user)   # True
```

### 6.3 字典推导式

```python
# {key: value for 变量 in 可迭代对象}
squares = {x: x**2 for x in range(6)}
# {0: 0, 1: 1, 2: 4, 3: 9, 4: 16, 5: 25}

# 带条件
even_sq = {x: x**2 for x in range(10) if x % 2 == 0}

# 键值反转
original = {"a": 1, "b": 2, "c": 3}
flipped = {v: k for k, v in original.items()}
# {1: 'a', 2: 'b', 3: 'c'}

# 从两个列表创建字典
keys = ["name", "age", "city"]
values = ["Alice", 25, "Beijing"]
person = dict(zip(keys, values))
```

### 6.4 字典合并（Python 3.9+）

```python
d1 = {"a": 1, "b": 2}
d2 = {"b": 3, "c": 4}

# | 运算符（创建新字典）
merged = d1 | d2   # {'a': 1, 'b': 3, 'c': 4}

# |= 原地更新
d1 |= d2   # d1 变为 {'a': 1, 'b': 3, 'c': 4}
```

### 6.5 集合

```python
# 创建集合
s1 = {1, 2, 3, 4, 5}
s2 = set([3, 4, 5, 6, 7])
s3 = {1, 2, 2, 3, 3, 3}   # 自动去重 → {1, 2, 3}

# ⚠️ 空集合必须用 set()，{} 是空字典！
empty_set = set()
empty_dict = {}

# 集合运算
print(s1 | s2)    # 并集 {1, 2, 3, 4, 5, 6, 7}
print(s1 & s2)    # 交集 {3, 4, 5}
print(s1 - s2)    # 差集 {1, 2}（在 s1 中但不在 s2 中）
print(s1 ^ s2)    # 对称差集 {1, 2, 6, 7}

# 增删
s1.add(10)
s1.remove(1)      # 不存在则 KeyError
s1.discard(99)    # 不存在也不报错
s1.pop()           # 弹出一个元素

# 判断
print(3 in s1)
print({1, 2}.issubset({1, 2, 3}))     # True
print({1, 2, 3}.issuperset({1, 2}))    # True
print({1, 2}.isdisjoint({3, 4}))       # True（无交集）

# 集合推导式
sq_set = {x**2 for x in range(10)}
```

> **⚠️ 集合元素必须是可哈希的（不可变类型）**
>
> 列表、字典、集合不能放入集合中。元组可以（前提是元素也都是不可变的）。

---

## 07 条件判断

### 7.1 if / elif / else

```python
score = 85

if score >= 90:
    grade = "A"
elif score >= 80:
    grade = "B"
elif score >= 70:
    grade = "C"
elif score >= 60:
    grade = "D"
else:
    grade = "F"

print(f"成绩: {score}，等级: {grade}")  # 成绩: 85，等级: B
```

### 7.2 三元表达式

```python
age = 20

# 语法: 值1 if 条件 else 值2
status = "成年" if age >= 18 else "未成年"
print(status)   # 成年

# 三元表达式可以嵌套（但不推荐太深，影响可读性）
score = 85
level = ("优秀" if score >= 90 else
          "良好" if score >= 80 else
          "及格" if score >= 60 else
          "不及格")
```

### 7.3 match / case（Python 3.10+）

```python
# 结构化模式匹配
def handle_response(status_code: int):
    match status_code:
        case 200:
            return "成功"
        case 400:
            return "请求错误"
        case 401:
            return "未授权"
        case 404:
            return "未找到"
        case 500:
            return "服务器错误"
        case _:                       # _ 是通配符，匹配所有
            return f"未知状态码: {status_code}"

print(handle_response(404))   # 未找到

# 匹配多个值
match status_code:
    case 200 | 201 | 204:
        return "成功"
    case 400 | 401 | 403 | 404:
        return "客户端错误"

# 解构匹配
match command:
    case ["quit"]:
        print("退出")
    case ["go", direction]:
        print(f"走向 {direction}")
    case ["pick", *items]:
        print(f"拾取 {items}")
```

### 7.4 真值判断

```python
# 以下值被视为 False:
# False, 0, 0.0, "", [], {}, set(), None, 0j

# 其他所有值都是 True

# 推荐的 Pythonic 判断方式
items = []
if not items:         # ✅ 比 if len(items) == 0 更 Pythonic
    print("列表为空")

name = ""
if not name:
    print("名字为空")

data = None
if data is None:      # ✅ None 用 is 判断
    print("数据为空")
```

---

## 08 循环结构

### 8.1 for 循环

```python
# 遍历列表
for fruit in ["apple", "banana", "cherry"]:
    print(fruit)

# range() —— 生成数字序列
for i in range(5):           # 0, 1, 2, 3, 4
    print(i)
for i in range(2, 10):       # 2, 3, ..., 9
    pass
for i in range(0, 10, 2):    # 0, 2, 4, 6, 8（步长 2）
    pass
for i in range(10, 0, -1):   # 10, 9, ..., 1（倒序）
    pass

# enumerate() —— 同时获取索引和值
for index, fruit in enumerate(["apple", "banana"]):
    print(f"{index}: {fruit}")
# 0: apple
# 1: banana

# enumerate 第二个参数可以指定起始索引
for i, line in enumerate(lines, start=1):
    print(f"第 {i} 行: {line}")

# zip() —— 并行遍历多个序列
names = ["Alice", "Bob", "Charlie"]
ages = [25, 30, 35]
cities = ["Beijing", "Shanghai", "Shenzhen"]

for name, age, city in zip(names, ages, cities):
    print(f"{name}, {age}, {city}")

# zip 以最短的为准，zip_longest 以最长的为准
from itertools import zip_longest
for a, b in zip_longest([1, 2, 3], ["a", "b"], fillvalue="?"):
    print(a, b)
```

### 8.2 while 循环

```python
# 基本 while
count = 0
while count < 5:
    print(count)
    count += 1

# break —— 立即退出循环
while True:
    text = input("输入 quit 退出: ")
    if text == "quit":
        break

# continue —— 跳过本次迭代
for i in range(10):
    if i % 2 == 0:
        continue
    print(i)  # 1 3 5 7 9

# else —— 循环正常结束时执行（没有被 break）
for n in range(2, 20):
    for i in range(2, n):
        if n % i == 0:
            break
    else:
        print(f"{n} 是质数")
```

### 8.3 循环技巧

```python
# enumerate + zip 组合
for i, (name, age) in enumerate(zip(names, ages)):
    print(f"{i}: {name} is {age}")

# 反向遍历
for item in reversed([1, 2, 3]):
    print(item)

# 排序遍历（不修改原列表）
for item in sorted([3, 1, 2]):
    print(item)

# 字典排序遍历
d = {"b": 2, "a": 1, "c": 3}
for k, v in sorted(d.items()):
    print(k, v)

# 列表推导式替代简单循环
squares = [x**2 for x in range(10)]        # ✅ 更 Pythonic
# 等价于：
# squares = []
# for x in range(10):
#     squares.append(x**2)

# ⚠️ 列表推导式不宜太复杂，超过两层循环或多个条件就用普通循环
```

---

## 09 函数

### 9.1 定义与调用

```python
def greet(name: str) -> str:
    """向指定的人打招呼。

    Args:
        name: 人名

    Returns:
        打招呼的字符串
    """
    return f"你好, {name}!"

print(greet("Alice"))  # 你好, Alice!

# 没有 return 的函数返回 None
def say_hello():
    print("Hello")

result = say_hello()
print(result)  # None

# 多返回值（本质是返回元组）
def min_max(nums: list) -> tuple:
    return min(nums), max(nums)

lo, hi = min_max([3, 1, 4, 1, 5])
print(lo, hi)   # 1 5
```

### 9.2 参数类型

```python
# ===== 位置参数 =====
def power(base, exp):
    return base ** exp

power(2, 10)     # 1024

# ===== 默认参数 =====
def power(base, exp=2):     # exp 默认值为 2
    return base ** exp

power(3)          # 9（默认平方）
power(2, 10)     # 1024

# ===== 仅限关键字参数（* 之后） =====
def connect(host, port, *, ssl=False, timeout=30):
    pass

connect("localhost", 8080, ssl=True)       # ✅
# connect("localhost", 8080, True)         # ❌ TypeError

# ===== *args —— 可变位置参数（收集为元组） =====
def sum_all(*args):
    print(type(args))  # <class 'tuple'>
    return sum(args)

sum_all(1, 2, 3, 4)    # 10

# ===== **kwargs —— 可变关键字参数（收集为字典） =====
def show_info(**kwargs):
    for key, value in kwargs.items():
        print(f"{key}: {value}")

show_info(name="Alice", age=25)

# ===== 参数组合顺序 =====
# 位置参数 → 默认参数 → *args → 仅限关键字参数 → **kwargs
def func(a, b=10, *args, c, d=20, **kwargs):
    pass
```

### 9.3 参数解包

```python
def add(a, b, c):
    return a + b + c

# 列表/元组解包
nums = [1, 2, 3]
print(add(*nums))      # 6

# 字典解包
params = {"a": 1, "b": 2, "c": 3}
print(add(**params))   # 6
```

### 9.4 Lambda 匿名函数

```python
# lambda 参数: 表达式
square = lambda x: x ** 2
print(square(5))   # 25

# 常与高阶函数配合
nums = [1, 2, 3, 4, 5]

# map() —— 对每个元素应用函数
doubled = list(map(lambda x: x * 2, nums))
# [2, 4, 6, 8, 10]

# filter() —— 过滤元素
evens = list(filter(lambda x: x % 2 == 0, nums))
# [2, 4]

# reduce() —— 累积计算
from functools import reduce
total = reduce(lambda a, b: a + b, nums)  # 15

# sorted() 的 key 参数
students = [("Alice", 85), ("Bob", 92), ("Eve", 78)]
by_score = sorted(students, key=lambda s: s[1], reverse=True)
# [('Bob', 92), ('Alice', 85), ('Eve', 78)]

# ⚠️ lambda 只能包含单个表达式，不能有语句
# 如果逻辑复杂，请用 def 定义命名函数
```

### 9.5 闭包与作用域

```python
# LEGB 作用域规则: Local → Enclosing → Global → Built-in

x = "global"
def outer():
    x = "enclosing"
    def inner():
        x = "local"
        print(x)
    inner()

outer()   # "local"

# 闭包 —— 内部函数捕获外部变量
def make_counter():
    count = 0
    def counter():
        nonlocal count  # 声明使用外层变量
        count += 1
        return count
    return counter

c = make_counter()
print(c())   # 1
print(c())   # 2
print(c())   # 3

# 闭包的实际应用：装饰器、回调、工厂函数
```

> **⚠️ 可变默认参数陷阱**

```python
# ❌ 错误示范
def bad_append(item, lst=[]):
    lst.append(item)
    return lst

print(bad_append(1))   # [1]
print(bad_append(2))   # [1, 2]  —— 意料之外！默认列表被共享了

# ✅ 正确做法
def good_append(item, lst=None):
    if lst is None:
        lst = []
    lst.append(item)
    return lst
```

### 9.6 递归

```python
# 阶乘
def factorial(n: int) -> int:
    if n <= 1:
        return 1
    return n * factorial(n - 1)

print(factorial(5))  # 120

# 斐波那契数列（带缓存）
from functools import lru_cache

@lru_cache(maxsize=None)
def fib(n: int) -> int:
    if n < 2:
        return n
    return fib(n - 1) + fib(n - 2)

print(fib(100))  # 354224848179261915075（瞬间计算）

# ⚠️ Python 默认递归深度限制为 1000
import sys
sys.setrecursionlimit(5000)
```

---

## 10 模块与包

### 10.1 导入方式

```python
# 导入整个模块
import math
print(math.sqrt(16))   # 4.0

# 导入特定成员
from math import sqrt, pi
print(sqrt(25))          # 5.0
print(pi)                  # 3.141592653589793

# 别名
import numpy as np
from collections import defaultdict as dd

# ⚠️ 不推荐：from math import *（污染命名空间）
```

### 10.2 创建模块和包

```
myproject/
├── main.py
├── utils.py              # 单文件模块
└── mypackage/            # 包目录
    ├── __init__.py       # 标识为包
    ├── math_tools.py
    ├── string_tools.py
    └── sub_package/      # 子包
        └── __init__.py
```

```python
# utils.py
def clamp(value, min_val, max_val):
    return max(min_val, min(value, max_val))

# __name__ 保护：只在直接运行时执行
if __name__ == "__main__":
    print(clamp(15, 0, 10))  # 10
```

```python
# main.py 中导入
from utils import clamp
from mypackage.math_tools import some_function
```

---

## 11 虚拟环境与包管理

### 11.1 venv 虚拟环境

```bash
# 创建虚拟环境
python3 -m venv .venv

# 激活
source .venv/bin/activate      # macOS / Linux
.venv\Scripts\activate          # Windows

# 退出
deactivate

# ⚠️ 最佳实践：每个项目一个独立虚拟环境，将 .venv 加入 .gitignore
```

### 11.2 pip 包管理

```bash
# 安装 / 升级 / 卸载
pip install requests
pip install requests==2.31.0
pip install "requests>=2.28,<3.0"   # 版本范围
pip install --upgrade requests
pip uninstall requests

# 批量安装
pip install -r requirements.txt

# 导出依赖
pip freeze > requirements.txt

# 查看
pip list
pip show requests

# 国内镜像加速
pip install -i https://pypi.tuna.tsinghua.edu.cn/simple requests

# 全局配置镜像
pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
```

### 11.3 现代工具链

```bash
# uv —— 极速 Python 包管理器（Rust 实现，比 pip 快 10-100 倍）
pip install uv
uv pip install requests
uv venv
uv pip compile requirements.in    # 锁定版本

# poetry —— 依赖管理 + 打包发布
pip install poetry
poetry new myproject
poetry add requests
poetry install
poetry build
```

---

## 12 文件操作

### 12.1 文本文件读写

```python
# ===== with 语句自动关闭文件（推荐！） =====

# 写入
with open("data.txt", "w", encoding="utf-8") as f:
    f.write("第一行\n")
    f.write("第二行\n")
    f.writelines(["第三行\n", "第四行\n"])

# 追加
with open("data.txt", "a", encoding="utf-8") as f:
    f.write("追加内容\n")

# 读取全部
with open("data.txt", "r", encoding="utf-8") as f:
    content = f.read()

# 读取所有行（列表）
with open("data.txt", "r", encoding="utf-8") as f:
    lines = f.readlines()  # ['第一行\n', '第二行\n', ...]

# 逐行遍历（内存友好，推荐读取大文件）
with open("data.txt", "r", encoding="utf-8") as f:
    for line in f:
        print(line.strip())
```

| 模式 | 说明 | 文件不存在 | 文件已存在 |
|------|------|-----------|-----------|
| `'r'` | 只读 | 报错 | — |
| `'w'` | 写入 | 创建 | **清空** |
| `'a'` | 追加 | 创建 | 保留 |
| `'x'` | 创建 | 创建 | **报错** |
| `'r+'` | 读写 | 报错 | 保留 |
| `'rb'` | 二进制读 | 报错 | — |

### 12.2 pathlib 路径操作（推荐）

```python
from pathlib import Path

# 创建路径
p = Path("data") / "output" / "result.txt"
print(p)        # data/output/result.txt
print(p.parent)  # data/output

# 判断
p.exists()
p.is_file()
p.is_dir()

# 属性
p.name          # result.txt
p.stem          # result
p.suffix        # .txt
p.parent        # data/output

# 创建目录
p.parent.mkdir(parents=True, exist_ok=True)

# 遍历
for f in Path(".").glob("*.py"):       # 当前目录
    print(f)
for f in Path(".").rglob("*.json"):    # 递归遍历
    print(f)

# 快捷读写
Path("note.txt").write_text("hello", encoding="utf-8")
content = Path("note.txt").read_text(encoding="utf-8")

Path("data.bin").write_bytes(b"\x00\x01")
data = Path("data.bin").read_bytes()
```

### 12.3 CSV 操作

```python
import csv

# 写入
with open("data.csv", "w", newline="", encoding="utf-8") as f:
    writer = csv.writer(f)
    writer.writerow(["姓名", "年龄", "城市"])
    writer.writerow(["Alice", 25, "Beijing"])
    writer.writerow(["Bob", 30, "Shanghai"])

# 字典方式写入
with open("data.csv", "w", newline="", encoding="utf-8") as f:
    fieldnames = ["姓名", "年龄", "城市"]
    writer = csv.DictWriter(f, fieldnames=fieldnames)
    writer.writeheader()
    writer.writerow({"姓名": "Alice", "年龄": 25, "城市": "Beijing"})

# 读取
with open("data.csv", "r", encoding="utf-8") as f:
    reader = csv.DictReader(f)
    for row in reader:
        print(row["姓名"], row["城市"])
```

### 12.4 JSON 操作

```python
import json

data = {"name": "Alice", "age": 25, "skills": ["Python", "SQL"]}

# 序列化（Python → JSON 字符串）
json_str = json.dumps(data, ensure_ascii=False, indent=2)
print(json_str)

# 反序列化（JSON 字符串 → Python）
obj = json.loads(json_str)

# 写入文件
with open("data.json", "w", encoding="utf-8") as f:
    json.dump(data, f, ensure_ascii=False, indent=2)

# 从文件读取
with open("data.json", "r", encoding="utf-8") as f:
    loaded = json.load(f)

# 处理自定义类型
class User:
    def __init__(self, name, age):
        self.name = name
        self.age = age

def user_encoder(obj):
    if isinstance(obj, User):
        return {"name": obj.name, "age": obj.age}
    raise TypeError(f"Object of type {type(obj)} is not JSON serializable")

user = User("Alice", 25)
print(json.dumps(user, default=user_encoder))
```

---

## 13 异常处理

### 13.1 try / except / finally

```python
try:
    result = 10 / 0
except ZeroDivisionError:
    print("不能除以零！")
except (TypeError, ValueError) as e:
    print(f"错误: {e}")
except Exception as e:
    print(f"未知错误: {e}")
else:
    # 没有异常时执行
    print(f"结果: {result}")
finally:
    # 无论如何都执行（通常用于清理资源）
    print("处理完成")
```

### 13.2 常见异常类型

| 异常 | 说明 | 示例 |
|------|------|------|
| `ValueError` | 值不合法 | `int("abc")` |
| `TypeError` | 类型错误 | `"1" + 2` |
| `KeyError` | 字典键不存在 | `d["missing"]` |
| `IndexError` | 索引越界 | `[1,2][5]` |
| `FileNotFoundError` | 文件不存在 | `open("no.txt")` |
| `AttributeError` | 属性不存在 | `None.upper()` |
| `ImportError` | 导入失败 | `import noexist` |
| `StopIteration` | 迭代器耗尽 | `next(iter([]))` |
| `RecursionError` | 递归过深 | 无限递归 |
| `MemoryError` | 内存不足 | `[0] * 10**10` |
| `RuntimeError` | 运行时错误 | 修改迭代中的集合 |

### 13.3 自定义异常

```python
class AppError(Exception):
    """应用基础异常"""
    pass

class InsufficientFundsError(AppError):
    def __init__(self, balance, amount):
        self.balance = balance
        self.amount = amount
        super().__init__(
            f"余额不足: 余额 {balance}，需要 {amount}"
        )

class InvalidAccountError(AppError):
    pass

# 使用 raise 抛出异常
def withdraw(balance, amount):
    if amount <= 0:
        raise ValueError("取款金额必须为正数")
    if amount > balance:
        raise InsufficientFundsError(balance, amount)
    return balance - amount

# 异常链（保留原始异常上下文）
try:
    withdraw(100, 200)
except InsufficientFundsError as e:
    print(e)  # 余额不足: 余额 100，需要 200
    raise AppError("交易失败") from e  # 异常链
```

### 13.4 实用模式

```python
# EAFP 风格（先做再说，出错处理）
try:
    value = d[key]
except KeyError:
    value = default

# LBYL 风格（先检查再做）
if key in d:
    value = d[key]
else:
    value = default

# Python 推崇 EAFP（请求原谅比获得许可更容易）

# suppress —— 忽略特定异常
from contextlib import suppress

with suppress(FileNotFoundError):
    os.remove("temp.txt")  # 文件不存在也不报错
```

---

## 14 面向对象编程

### 14.1 类与实例

```python
class Dog:
    """一只狗的类"""

    # 类属性（所有实例共享）
    species = "Canis lupus"

    def __init__(self, name: str, age: int):
        # 实例属性（每个实例独有）
        self.name = name
        self.age = age

    # 实例方法
    def bark(self) -> str:
        return f"{self.name} says: Woof!"

    # 特殊方法：字符串表示
    def __repr__(self):
        return f"Dog('{self.name}', {self.age})"

    def __str__(self):
        return f"{self.name} ({self.age}岁)"

# 创建实例
dog = Dog("Buddy", 3)
print(dog.bark())      # Buddy says: Woof!
print(dog.species)      # Canis lupus
print(repr(dog))         # Dog('Buddy', 3)
print(str(dog))          # Buddy (3岁)
```

### 14.2 继承

```python
class Animal:
    def __init__(self, name: str):
        self.name = name

    def speak(self) -> str:
        raise NotImplementedError("子类必须实现 speak")

    def info(self) -> str:
        return f"{self.__class__.__name__}: {self.name}"

class Cat(Animal):
    def __init__(self, name: str, indoor: bool = True):
        super().__init__(name)   # 调用父类构造器
        self.indoor = indoor

    def speak(self) -> str:
        return f"{self.name}: Meow!"

class Duck(Animal):
    def speak(self) -> str:
        return f"{self.name}: Quack!"

class Dog(Animal):
    def __init__(self, name: str, breed: str):
        super().__init__(name)
        self.breed = breed

    def speak(self) -> str:
        return f"{self.name}: Woof!"

# 多态
for animal in [Cat("Kitty"), Duck("Donald"), Dog("Buddy", "金毛")]:
    print(animal.speak())
    print(animal.info())

# isinstance 和 issubclass
c = Cat("Kitty")
print(isinstance(c, Cat))        # True
print(isinstance(c, Animal))      # True（Cat 继承自 Animal）
print(issubclass(Cat, Animal))    # True
print(issubclass(Cat, object))    # True（所有类都继承自 object）
```

### 14.3 访问控制

```python
class Person:
    def __init__(self, name, age, password):
        self.name = name             # 公开属性
        self._title = "Mr."           # 约定私有（单下划线，仅命名约定）
        self.__password = password    # 名称改编（双下划线）
        self._age = age

    # @property —— 将方法伪装为属性
    @property
    def age(self):
        return self._age

    @age.setter
    def age(self, value):
        if not isinstance(value, int):
            raise TypeError("年龄必须是整数")
        if value < 0 or value > 150:
            raise ValueError("年龄必须在 0~150 之间")
        self._age = value

    @property
    def is_adult(self) -> bool:
        return self._age >= 18

p = Person("Alice", 25, "secret")
p.age = 30                    # 通过 setter 赋值（会校验）
print(p.age)                   # 30
print(p.is_adult)              # True
print(p._title)                # 可以访问（但约定不要这样做）
# print(p.__password)          # AttributeError!
print(p._Person__password)     # 强制访问（不要这样做！）
```

### 14.4 类方法与静态方法

```python
class Date:
    def __init__(self, year, month, day):
        self.year = year
        self.month = month
        self.day = day

    # 实例方法：操作实例
    def format(self) -> str:
        return f"{self.year}-{self.month:02d}-{self.day:02d}"

    # 类方法：操作类本身，常用于工厂方法
    @classmethod
    def from_string(cls, date_str: str):
        year, month, day = map(int, date_str.split("-"))
        return cls(year, month, day)

    # 静态方法：与类和实例都无关的工具函数
    @staticmethod
    def is_valid(date_str: str) -> bool:
        try:
            parts = date_str.split("-")
            return len(parts) == 3 and all(p.isdigit() for p in parts)
        except Exception:
            return False

# 使用
d1 = Date(2024, 1, 15)
d2 = Date.from_string("2024-06-01")    # 工厂方法
print(d1.format())                        # 2024-01-15
print(Date.is_valid("2024-01-15"))       # True
```

### 14.5 魔法方法

```python
class Vector:
    def __init__(self, x: float, y: float):
        self.x = x
        self.y = y

    def __repr__(self):
        return f"Vector({self.x}, {self.y})"

    def __str__(self):
        return f"({self.x}, {self.y})"

    def __add__(self, other):
        return Vector(self.x + other.x, self.y + other.y)

    def __sub__(self, other):
        return Vector(self.x - other.x, self.y - other.y)

    def __mul__(self, scalar):
        return Vector(self.x * scalar, self.y * scalar)

    def __rmul__(self, scalar):    # 支持 3 * v
        return self.__mul__(scalar)

    def __eq__(self, other):
        return self.x == other.x and self.y == other.y

    def __abs__(self):
        return (self.x**2 + self.y**2) ** 0.5

    def __bool__(self):
        return self.x != 0 or self.y != 0

    def __len__(self):
        return 2

# 使用
v1 = Vector(3, 4)
v2 = Vector(1, 2)
print(v1 + v2)       # (4, 6)
print(v1 * 3)         # (9, 12)
print(3 * v1)         # (9, 12)
print(abs(v1))         # 5.0
print(v1 == Vector(3, 4))  # True
```

常用魔法方法速查：

| 方法 | 触发方式 | 说明 |
|------|----------|------|
| `__init__` | `Class()` | 初始化 |
| `__repr__` | `repr(obj)` | 开发者字符串 |
| `__str__` | `print(obj)` | 用户字符串 |
| `__len__` | `len(obj)` | 长度 |
| `__getitem__` | `obj[key]` | 索引访问 |
| `__setitem__` | `obj[key] = val` | 索引设置 |
| `__delitem__` | `del obj[key]` | 索引删除 |
| `__contains__` | `x in obj` | 成员判断 |
| `__iter__` | `for x in obj` | 迭代 |
| `__next__` | `next(obj)` | 取下一个值 |
| `__add__` | `a + b` | 加法 |
| `__eq__` | `a == b` | 相等判断 |
| `__lt__` | `a < b` | 小于 |
| `__call__` | `obj()` | 使实例可调用 |
| `__enter__` / `__exit__` | `with obj:` | 上下文管理器 |

---

## 15 面向对象进阶

### 15.1 dataclass（Python 3.7+）

```python
from dataclasses import dataclass, field

@dataclass
class Point:
    x: float
    y: float

    def distance(self) -> float:
        return (self.x**2 + self.y**2) ** 0.5

p = Point(3, 4)
print(p)              # Point(x=3, y=4)（自动生成 __repr__）
print(p.distance())    # 5.0

@dataclass(order=True)  # 自动生成比较方法
class Student:
    sort_index: float = field(init=False, repr=False)
    name: str
    grade: float
    age: int = 18

    def __post_init__(self):
        self.sort_index = self.grade   # 排序用成绩

students = [
    Student("Alice", 85),
    Student("Bob", 92),
    Student("Eve", 78),
]
print(sorted(students))   # 按成绩排序

# dataclass 的关键参数
@dataclass(frozen=True)   # 不可变！
class Config:
    host: str = "localhost"
    port: int = 8080
```

### 15.2 抽象基类

```python
from abc import ABC, abstractmethod

class Shape(ABC):
    @abstractmethod
    def area(self) -> float:
        pass

    @abstractmethod
    def perimeter(self) -> float:
        pass

    def describe(self) -> str:
        return f"{self.__class__.__name__}: area={self.area():.2f}"

class Circle(Shape):
    def __init__(self, radius: float):
        self.radius = radius

    def area(self) -> float:
        import math
        return math.pi * self.radius ** 2

    def perimeter(self) -> float:
        import math
        return 2 * math.pi * self.radius

# s = Shape()   # TypeError! 不能实例化抽象类
c = Circle(5)
print(c.describe())   # Circle: area=78.54
```

### 15.3 多重继承与 MRO

```python
# 方法解析顺序（MRO）—— C3 线性化算法
class A:
    def greet(self):
        return "A"

class B(A):
    def greet(self):
        return "B"

class C(A):
    def greet(self):
        return "C"

class D(B, C):
    pass

d = D()
print(d.greet())         # B
print(D.__mro__)
# (<class 'D'>, <class 'B'>, <class 'C'>, <class 'A'>, <class 'object'>)

# super() 按 MRO 链调用
class Base:
    def __init__(self):
        print("Base")

class Left(Base):
    def __init__(self):
        super().__init__()
        print("Left")

class Right(Base):
    def __init__(self):
        super().__init__()
        print("Right")

class Child(Left, Right):
    def __init__(self):
        super().__init__()
        print("Child")

Child()
# 输出: Right → Left → Base → Child （按 MRO 顺序）
```

### 15.4 Slots

```python
# __slots__ 限制属性，减少内存占用
class Point:
    __slots__ = ("x", "y")

    def __init__(self, x, y):
        self.x = x
        self.y = y

p = Point(3, 4)
print(p.x, p.y)      # 3 4
# p.z = 5             # AttributeError! 不允许添加新属性

# ⚠️ 使用 __slots__ 后不能使用普通 __dict__
```

### 15.5 描述符

```python
# 描述符：控制属性的访问行为
class PositiveNumber:
    def __set_name__(self, owner, name):
        self.name = name

    def __get__(self, obj, objtype=None):
        if obj is None:
            return self
        return getattr(obj, f"_{self.name}", 0)

    def __set__(self, obj, value):
        if value < 0:
            raise ValueError(f"{self.name} 必须为非负数")
        setattr(obj, f"_{self.name}", value)

class Account:
    balance = PositiveNumber()   # 使用描述符

    def __init__(self, balance):
        self.balance = balance

acc = Account(100)
print(acc.balance)      # 100
# acc.balance = -50     # ValueError: balance 必须为非负数
```

---

## 16 类型注解与静态分析

Python 是动态类型语言，但 3.5+ 支持类型注解，配合 mypy 等工具进行静态类型检查。

### 16.1 基础类型注解

```python
# 变量注解
name: str = "Alice"
age: int = 25
height: float = 1.68
is_active: bool = True

# 函数注解
def greet(name: str, times: int = 1) -> str:
    return f"Hello, {name}! " * times

# 复合类型
from typing import Optional, Union, Any

def find_user(user_id: int) -> Optional[str]:
    """可能返回 None"""
    ...

def process(value: Union[int, str]) -> None:
    """接受 int 或 str"""
    ...

def flexible(x: Any) -> Any:
    """接受任意类型"""
    ...
```

### 16.2 容器类型注解

```python
from typing import List, Dict, Tuple, Set, Sequence, Mapping

# 基本容器
names: List[str] = ["Alice", "Bob"]
scores: Dict[str, int] = {"Alice": 95, "Bob": 87}
point: Tuple[int, int] = (3, 4)
tags: Set[str] = {"python", "coding"}

# Python 3.9+ 可以直接用内置类型
names: list[str] = ["Alice", "Bob"]
scores: dict[str, int] = {"Alice": 95}

# 嵌套
matrix: list[list[int]] = [[1, 2], [3, 4]]
data: dict[str, list[int]] = {"a": [1, 2]}

# 通用类型（Sequence, Mapping 等只读抽象）
def first(items: Sequence[int]) -> int:
    return items[0]   # 接受 list, tuple, range 等
```

### 16.3 高级类型

```python
from typing import (
    Callable, Iterator, Generator, Literal,
    TypeVar, Generic, Protocol, TypeAlias
)

# 回调函数
Handler = Callable[[str, int], bool]
def on_event(handler: Handler) -> None: ...

# 字面量类型
def set_mode(mode: Literal["read", "write", "append"]) -> None: ...

# TypeVar —— 泛型
T = TypeVar("T")

def first(items: list[T]) -> T:
    return items[0]

# Generic 类
class Stack(Generic[T]):
    def __init__(self) -> None:
        self._items: list[T] = []

    def push(self, item: T) -> None:
        self._items.append(item)

    def pop(self) -> T:
        return self._items.pop()

s: Stack[int] = Stack()
s.push(1)

# Python 3.12+ 新语法
def first[T](items: list[T]) -> T:
    return items[0]

class Stack[T]:
    def __init__(self) -> None:
        self._items: list[T] = []
```

### 16.4 Protocol（结构化子类型）

```python
from typing import Protocol

# 定义协议（类似 Go 的 interface）
class Drawable(Protocol):
    def draw(self) -> str: ...
    @property
    def color(self) -> str: ...

# 只要实现了 draw() 和 color 属性，就是 Drawable（不需要显式继承）
class Circle:
    def __init__(self, color: str):
        self._color = color

    def draw(self) -> str:
        return "Drawing circle"

    @property
    def color(self) -> str:
        return self._color

def render(obj: Drawable) -> None:
    print(obj.draw(), obj.color)

render(Circle("red"))  # ✅ Circle 实现了 Drawable 协议
```

### 16.5 使用 mypy 进行静态检查

```bash
pip install mypy
mypy my_script.py --strict

# 常见配置（pyproject.toml）
# [tool.mypy]
# python_version = "3.12"
# warn_return_any = true
# warn_unused_configs = true
# disallow_untyped_defs = true
```

---

## 17 装饰器与闭包

### 17.1 闭包回顾

```python
def make_multiplier(factor):
    def multiply(x):
        return x * factor
    return multiply

double = make_multiplier(2)
triple = make_multiplier(3)
print(double(5))   # 10
print(triple(5))   # 15
```

### 17.2 装饰器基础

```python
import time
from functools import wraps

def timer(func):
    """计时装饰器"""
    @wraps(func)   # 保留原函数的元信息
    def wrapper(*args, **kwargs):
        start = time.perf_counter()
        result = func(*args, **kwargs)
        elapsed = time.perf_counter() - start
        print(f"⏱ {func.__name__} 耗时: {elapsed:.4f}s")
        return result
    return wrapper

@timer
def compute():
    time.sleep(0.5)
    return "done"

result = compute()   # ⏱ compute 耗时: 0.5012s
print(result)          # done
print(compute.__name__)  # compute（因为 @wraps）
```

### 17.3 带参数的装饰器

```python
def retry(max_retries=3, delay=1):
    """重试装饰器"""
    def decorator(func):
        @wraps(func)
        def wrapper(*args, **kwargs):
            for attempt in range(1, max_retries + 1):
                try:
                    return func(*args, **kwargs)
                except Exception as e:
                    print(f"第 {attempt} 次尝试失败: {e}")
                    if attempt < max_retries:
                        time.sleep(delay)
                    else:
                        raise
        return wrapper
    return decorator

@retry(max_retries=3, delay=0.5)
def fetch_data():
    import random
    if random.random() < 0.7:
        raise ConnectionError("网络错误")
    return "数据"
```

### 17.4 类装饰器

```python
# 类作为装饰器（实现 __call__）
class CountCalls:
    def __init__(self, func):
        self.func = func
        self.count = 0

    def __call__(self, *args, **kwargs):
        self.count += 1
        print(f"{self.func.__name__} 被调用了 {self.count} 次")
        return self.func(*args, **kwargs)

@CountCalls
def say_hello():
    print("Hello!")

say_hello()   # say_hello 被调用了 1 次 \n Hello!
say_hello()   # say_hello 被调用了 2 次 \n Hello!
```

### 17.5 内置装饰器

```python
class MyClass:
    # @staticmethod —— 不需要 self 或 cls
    @staticmethod
    def utility(x, y):
        return x + y

    # @classmethod —— 接收类作为第一个参数
    @classmethod
    def create(cls):
        return cls()

    # @property —— 将方法变为属性
    @property
    def name(self):
        return self._name
```

### 17.6 常用标准库装饰器

```python
from functools import lru_cache, singledispatch

# lru_cache —— 自动缓存（备忘录模式）
@lru_cache(maxsize=128)
def fibonacci(n):
    if n < 2:
        return n
    return fibonacci(n - 1) + fibonacci(n - 2)

# singledispatch —— 类型分派
@singledispatch
def process(data):
    raise NotImplementedError(f"不支持 {type(data)}")

@process.register(int)
def _(data):
    print(f"处理整数: {data}")

@process.register(str)
def _(data):
    print(f"处理字符串: {data}")

@process.register(list)
def _(data):
    print(f"处理列表: {data}")

process(42)          # 处理整数: 42
process("hello")     # 处理字符串: hello
process([1, 2, 3])   # 处理列表: [1, 2, 3]
```

---

## 18 生成器与迭代器

### 18.1 迭代器协议

```python
# 迭代器：实现了 __iter__() 和 __next__() 的对象
class Countdown:
    def __init__(self, start):
        self.start = start

    def __iter__(self):
        self.current = self.start
        return self

    def __next__(self):
        if self.current <= 0:
            raise StopIteration
        self.current -= 1
        return self.current + 1

for num in Countdown(5):
    print(num, end=" ")   # 5 4 3 2 1

# iter() 和 next() 内置函数
nums = iter([1, 2, 3])
print(next(nums))  # 1
print(next(nums))  # 2
print(next(nums))  # 3
# print(next(nums))  # StopIteration
```

### 18.2 生成器函数

```python
# 用 yield 代替 return
def fibonacci(n):
    a, b = 0, 1
    for _ in range(n):
        yield a
        a, b = b, a + b

# 生成器是惰性的——逐个产生值
for num in fibonacci(10):
    print(num, end=" ")
# 0 1 1 2 3 5 8 13 21 34

# 可以转换为列表
fib_list = list(fibonacci(10))

# yield from —— 委托子生成器
def flatten(nested):
    for item in nested:
        if isinstance(item, (list, tuple)):
            yield from flatten(item)
        else:
            yield item

data = [1, [2, 3], [4, [5, 6]]]
print(list(flatten(data)))   # [1, 2, 3, 4, 5, 6]
```

### 18.3 生成器表达式

```python
# 列表推导式用 []，生成器表达式用 ()
squares_list = [x**2 for x in range(1000000)]  # 占大量内存
squares_gen  = (x**2 for x in range(1000000))  # 几乎不占内存

# 直接在函数中使用
total = sum(x**2 for x in range(1000000))
max_val = max(x**2 for x in range(1000))
```

> **💡 生成器 vs 列表**
>
> - **列表**：所有元素立即生成，存在内存中
> - **生成器**：每次调用 `next()` 才产生下一个值
> - 数据量大或不需要全部元素时，优先用生成器

### 18.4 send() 和 close()

```python
def accumulator():
    total = 0
    while True:
        value = yield total
        if value is None:
            break
        total += value

gen = accumulator()
next(gen)             # 启动生成器（必须先调用一次）
print(gen.send(10))   # 10
print(gen.send(20))   # 30
print(gen.send(5))    # 35
gen.close()             # 关闭生成器
```

---

## 19 上下文管理器

### 19.1 基本用法

```python
# 最常见的上下文管理器：with open(...)
with open("data.txt", "w") as f:
    f.write("hello")
# 离开 with 块后，文件自动关闭
```

### 19.2 类实现

```python
import time

class Timer:
    def __enter__(self):
        self.start = time.perf_counter()
        return self   # 返回值赋给 as 后的变量

    def __exit__(self, exc_type, exc_val, exc_tb):
        self.elapsed = time.perf_counter() - self.start
        print(f"⏱ 耗时: {self.elapsed:.4f}s")
        # 返回 True 会吞掉异常，返回 False/None 会传播异常
        return False

with Timer() as t:
    time.sleep(0.3)
print(f"代码块耗时: {t.elapsed:.4f}s")
```

### 19.3 contextmanager 装饰器

```python
from contextlib import contextmanager

@contextmanager
def timer():
    start = time.perf_counter()
    yield   # yield 之前是 __enter__，yield 之后是 __exit__
    print(f"⏱ 耗时: {time.perf_counter() - start:.4f}s")

with timer():
    time.sleep(0.3)

# 更复杂的示例：临时修改目录
import os

@contextmanager
def change_dir(path):
    old_dir = os.getcwd()
    os.chdir(path)
    try:
        yield
    finally:
        os.chdir(old_dir)   # 确保恢复

with change_dir("/tmp"):
    print(os.getcwd())   # /tmp
print(os.getcwd())        # 回到原目录
```

### 19.4 ExitStack

```python
from contextlib import ExitStack

# 动态管理多个上下文管理器
with ExitStack() as stack:
    files = [
        stack.enter_context(open(f"file{i}.txt", "w"))
        for i in range(3)
    ]
    for f in files:
        f.write("hello")
# 所有文件都自动关闭
```

---

## 20 并发编程

### 20.1 多线程（threading）

```python
import threading
import time

def worker(name: str, delay: float):
    print(f"[{name}] 开始")
    time.sleep(delay)
    print(f"[{name}] 完成")

# 创建线程
t1 = threading.Thread(target=worker, args=("A", 2))
t2 = threading.Thread(target=worker, args=("B", 1))

t1.start()
t2.start()
t1.join()    # 等待线程完成
t2.join()
print("全部完成")

# 线程锁（避免竞态条件）
lock = threading.Lock()
counter = 0

def safe_increment():
    global counter
    for _ in range(100000):
        with lock:
            counter += 1
```

> **⚠️ GIL 限制**
>
> Python 的全局解释器锁（GIL）确保同一时刻只有一个线程执行 Python 字节码。**多线程适合 I/O 密集型任务**（网络请求、文件读写），**不适合 CPU 密集型任务**（大量计算）。

### 20.2 多进程（multiprocessing）

```python
from multiprocessing import Process, Pool
import os

def heavy_task(n):
    """CPU 密集型任务"""
    total = sum(i * i for i in range(n))
    return total

# 基本使用
if __name__ == "__main__":
    p = Process(target=heavy_task, args=(10_000_000,))
    p.start()
    p.join()

    # 进程池
    with Pool(4) as pool:
        results = pool.map(heavy_task, [10_000_000] * 4)
        print(results)
```

### 20.3 异步编程（asyncio）

```python
import asyncio

async def fetch_data(name: str, delay: float) -> str:
    print(f"[{name}] 开始获取数据...")
    await asyncio.sleep(delay)      # 模拟 I/O 操作
    print(f"[{name}] 数据获取完成")
    return f"{name}_data"

async def main():
    # 并发执行多个协程
    results = await asyncio.gather(
        fetch_data("API-1", 2),
        fetch_data("API-2", 1),
        fetch_data("API-3", 1.5),
    )
    print(f"结果: {results}")

asyncio.run(main())
# 总耗时约 2 秒（最长的那个），而不是 4.5 秒
```

### 20.4 异步上下文管理器与迭代器

```python
import asyncio
import aiofiles   # pip install aiofiles

# 异步上下文管理器
async def read_file():
    async with aiofiles.open("data.txt", "r") as f:
        content = await f.read()
        print(content)

# 异步迭代器
async def async_range(n):
    for i in range(n):
        await asyncio.sleep(0.1)
        yield i

async def main():
    async for num in async_range(5):
        print(num)
```

### 20.5 concurrent.futures

```python
from concurrent.futures import ThreadPoolExecutor, ProcessPoolExecutor

# 线程池（适合 I/O 密集型）
with ThreadPoolExecutor(max_workers=4) as executor:
    futures = [executor.submit(download_url, url) for url in urls]
    results = [f.result() for f in futures]

# 进程池（适合 CPU 密集型）
with ProcessPoolExecutor(max_workers=4) as executor:
    results = list(executor.map(heavy_computation, data_list))
```

并发方案选择：

| 场景 | 推荐方案 | 原因 |
|------|----------|------|
| I/O 密集型 | `asyncio` / `ThreadPoolExecutor` | GIL 不影响 I/O 等待 |
| CPU 密集型 | `multiprocessing` / `ProcessPoolExecutor` | 绕过 GIL，利用多核 |
| 高并发网络 | `asyncio` + `aiohttp` | 单线程高并发，低开销 |
| 简单并行 | `concurrent.futures` | 接口统一，使用简单 |

---

## 21 正则表达式

### 21.1 基础语法

```python
import re

text = "我的邮箱是 alice@example.com，电话是 138-0000-1234"

# 常用元字符
# .    匹配任意字符（除换行）
# \d   匹配数字 [0-9]
# \w   匹配字母数字下划线 [a-zA-Z0-9_]
# \s   匹配空白字符
# \b   匹配单词边界
# ^    行首
# $    行尾
# *    0 次或多次
# +    1 次或多次
# ?    0 次或 1 次
# {n,m} n 到 m 次
```

### 21.2 常用函数

```python
text = "Hello 123 World 456 Python789"

# search —— 查找第一个匹配
m = re.search(r'\d+', text)
print(m.group())   # "123"
print(m.start())   # 6
print(m.end())     # 9

# match —— 从字符串开头匹配
m = re.match(r'\d+', text)
print(m)   # None（开头不是数字）

# fullmatch —— 整个字符串完全匹配
m = re.fullmatch(r'\d+', "12345")

# findall —— 查找所有匹配
nums = re.findall(r'\d+', text)
print(nums)   # ['123', '456', '789']

# finditer —— 返回迭代器（包含位置信息）
for m in re.finditer(r'\d+', text):
    print(f"'{m.group()}' at {m.start()}-{m.end()}")

# sub —— 替换
cleaned = re.sub(r'\d+', '*', text)
print(cleaned)   # "Hello * World * Python*"

# split —— 分割
parts = re.split(r'[,;\s]+', "hello, world; python  java")
print(parts)   # ['hello', 'world', 'python', 'java']
```

### 21.3 分组捕获

```python
# 基本分组
text = "2024-01-15"
m = re.match(r'(\d{4})-(\d{2})-(\d{2})', text)
if m:
    print(m.group(0))   # '2024-01-15'（整个匹配）
    print(m.group(1))   # '2024'（第一组）
    print(m.group(2))   # '01'（第二组）
    print(m.group(3))   # '15'（第三组）

# 命名分组
m = re.match(r'(?P<year>\d{4})-(?P<month>\d{2})-(?P<day>\d{2})', text)
if m:
    print(m.group('year'))   # '2024'
    print(m.groupdict())      # {'year': '2024', 'month': '01', 'day': '15'}

# 非捕获分组 (?:...)
m = re.findall(r'(?:https?://)?([\w.]+)', "https://www.example.com http://test.org")

# 前瞻断言
# (?=...)  正向前瞻（后面跟着...）
# (?!...)  负向前瞻（后面不跟...）
# (?<=...) 正向后顾（前面是...）
# (?<!...) 负向后顾（前面不是...）

# 提取价格数字
prices = "苹果 $3.50，香蕉 ¥5.00"
dollar_prices = re.findall(r'\$(\d+\.\d{2})', prices)
print(dollar_prices)   # ['3.50']
```

### 21.4 编译正则（提高性能）

```python
# 多次使用同一正则时，编译可提高性能
EMAIL_PATTERN = re.compile(r'[\w.+-]+@[\w-]+\.[\w.]+')
PHONE_PATTERN = re.compile(r'1[3-9]\d{9}')

text = "联系我 alice@example.com 或 13812345678"
emails = EMAIL_PATTERN.findall(text)
phones = PHONE_PATTERN.findall(text)

# 常用标志
re.IGNORECASE   # re.I  忽略大小写
re.MULTILINE    # re.M  ^ $ 匹配每行
re.DOTALL       # re.S  . 匹配换行符
re.VERBOSE      # re.X  允许注释和换行

# VERBOSE 模式示例
pattern = re.compile(r"""
    (?P<year>\d{4})    # 年
    [-/.]               # 分隔符
    (?P<month>\d{2})    # 月
    [-/.]               # 分隔符
    (?P<day>\d{2})      # 日
""", re.VERBOSE)
```

### 21.5 常用正则模板

```python
# 邮箱
r'[\w.+-]+@[\w-]+\.[\w.]+'

# 中国大陆手机号
r'1[3-9]\d{9}'

# IPv4 地址
r'\b(?:\d{1,3}\.){3}\d{1,3}\b'

# URL
r'https?://[\w./-]+'

# 身份证号（18 位）
r'\d{17}[\dXx]'

# 中文字符
r'[\u4e00-\u9fff]+'

# HTML 标签
r'<[^>]+>'
```

---

## 22 常用标准库

### 22.1 collections — 高级容器

```python
from collections import Counter, defaultdict, deque, OrderedDict, ChainMap

# Counter —— 计数器
words = "hello world hello python hello world".split()
count = Counter(words)
print(count.most_common(2))   # [('hello', 3), ('world', 2)]
print(count["hello"])           # 3
count.update(["hello", "new"])  # 更新

# defaultdict —— 带默认值的字典
dd = defaultdict(list)
for word in ["apple", "banana", "avocado", "blueberry"]:
    dd[word[0]].append(word)
# {'a': ['apple', 'avocado'], 'b': ['banana', 'blueberry']}

# deque —— 双端队列（O(1) 的两端操作）
dq = deque([1, 2, 3], maxlen=5)   # 限制最大长度
dq.appendleft(0)                    # 左侧添加
dq.pop()                             # 右侧弹出
dq.rotate(2)                        # 旋转

# ChainMap —— 链接多个字典
defaults = {"color": "red", "size": "medium"}
custom = {"color": "blue"}
config = ChainMap(custom, defaults)
print(config["color"])   # blue（优先查 custom）
print(config["size"])     # medium（回退到 defaults）
```

### 22.2 itertools — 迭代工具

```python
import itertools

# 无限迭代器
for i in itertools.count(10):
    if i > 14: break
    print(i, end=" ")   # 10 11 12 13 14

for item in itertools.cycle(["A", "B"]):
    if ...: break   # 无限循环 A B A B ...

list(itertools.repeat("hello", 3))   # ['hello', 'hello', 'hello']

# 组合
list(itertools.permutations("ABC", 2))
# [('A','B'), ('A','C'), ('B','A'), ('B','C'), ('C','A'), ('C','B')]

list(itertools.combinations("ABC", 2))
# [('A','B'), ('A','C'), ('B','C')]

list(itertools.product("AB", repeat=2))
# [('A','A'), ('A','B'), ('B','A'), ('B','B')]

# chain —— 连接迭代器
list(itertools.chain([1,2], [3,4], [5]))   # [1,2,3,4,5]

# groupby —— 分组
data = [("A", 1), ("A", 2), ("B", 3), ("B", 4)]
for key, group in itertools.groupby(data, key=lambda x: x[0]):
    print(key, list(group))

# islice —— 迭代器切片
list(itertools.islice(range(100), 5, 15))

# accumulate —— 累积
list(itertools.accumulate([1, 2, 3, 4]))   # [1, 3, 6, 10]

# pairwise（Python 3.10+）
list(itertools.pairwise("ABC"))   # [('A','B'), ('B','C')]
```

### 22.3 datetime — 日期时间

```python
from datetime import datetime, date, time, timedelta

# 获取当前时间
now = datetime.now()
today = date.today()

# 格式化
print(now.strftime("%Y-%m-%d %H:%M:%S"))
# 2024-01-15 14:30:00

print(now.strftime("%Y年%m月%d日 %A"))
# 2024年01月15日 Monday

# 解析字符串
dt = datetime.strptime("2024-01-15 14:30", "%Y-%m-%d %H:%M")

# 时间加减
tomorrow = now + timedelta(days=1)
last_week = now - timedelta(weeks=1)
two_hours_later = now + timedelta(hours=2)

# 时间差
diff = datetime(2024, 12, 31) - datetime(2024, 1, 1)
print(diff.days)   # 365

# 时间戳
timestamp = now.timestamp()
from_timestamp = datetime.fromtimestamp(timestamp)
```

### 22.4 os 和 sys

```python
import os
import sys

# os —— 操作系统交互
os.getcwd()                    # 当前目录
os.listdir(".")                # 列出目录内容
os.makedirs("a/b/c", exist_ok=True)  # 递归创建目录
os.rename("old.txt", "new.txt")
os.remove("file.txt")
os.environ["HOME"]             # 环境变量
os.path.join("a", "b", "c")   # 跨平台路径拼接

# sys —— 系统参数
sys.argv            # 命令行参数
sys.version         # Python 版本
sys.path            # 模块搜索路径
sys.exit(0)         # 退出程序
sys.getsizeof(obj)  # 对象内存大小
```

### 22.5 logging — 日志

```python
import logging

# 基本配置
logging.basicConfig(
    level=logging.DEBUG,
    format="%(asctime)s [%(levelname)s] %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S",
    handlers=[
        logging.FileHandler("app.log", encoding="utf-8"),
        logging.StreamHandler(),
    ]
)

logger = logging.getLogger(__name__)

# 使用
logger.debug("调试信息")
logger.info("普通信息")
logger.warning("警告")
logger.error("错误")
logger.critical("严重错误")

# 异常日志（自动记录堆栈）
try:
    1 / 0
except Exception:
    logger.exception("发生异常")
```

### 22.6 hashlib — 哈希摘要

```python
import hashlib

# MD5
md5 = hashlib.md5("hello".encode()).hexdigest()
print(md5)   # 5d41402abc4b2a76b9719d911017c592

# SHA-256
sha256 = hashlib.sha256("hello".encode()).hexdigest()
print(sha256)

# 文件哈希
def file_hash(filepath, algorithm="sha256"):
    h = hashlib.new(algorithm)
    with open(filepath, "rb") as f:
        while chunk := f.read(8192):
            h.update(chunk)
    return h.hexdigest()
```

### 22.7 random — 随机数

```python
import random

random.randint(1, 10)           # 1~10 的随机整数
random.random()                   # 0~1 的随机浮点数
random.uniform(1.0, 10.0)       # 1.0~10.0 的随机浮点数
random.choice(["a", "b", "c"])  # 随机选择一个
random.sample(range(100), 5)    # 不重复抽 5 个
random.shuffle(my_list)          # 原地打乱

# 安全随机数（用于密码学）
import secrets
token = secrets.token_hex(16)   # 32 字符的随机十六进制
secure_num = secrets.randbelow(100)
```

### 22.8 argparse — 命令行参数

```python
import argparse

parser = argparse.ArgumentParser(description="文件处理工具")
parser.add_argument("input", help="输入文件路径")
parser.add_argument("-o", "--output", default="output.txt", help="输出路径")
parser.add_argument("-n", "--number", type=int, default=10, help="数量")
parser.add_argument("-v", "--verbose", action="store_true", help="详细模式")

args = parser.parse_args()

if args.verbose:
    print(f"处理文件: {args.input}")
    print(f"数量: {args.number}")
```

```bash
python tool.py input.txt -o result.txt -n 20 -v
```

---

## 23 单元测试与调试

### 23.1 unittest

```python
import unittest

def add(a, b):
    return a + b

def divide(a, b):
    if b == 0:
        raise ValueError("除数不能为零")
    return a / b

class TestMath(unittest.TestCase):
    def setUp(self):
        """每个测试方法前执行"""
        self.data = [1, 2, 3, 4, 5]

    def test_add(self):
        self.assertEqual(add(1, 2), 3)
        self.assertEqual(add(-1, 1), 0)
        self.assertEqual(add(0, 0), 0)

    def test_divide(self):
        self.assertAlmostEqual(divide(10, 3), 3.3333, places=3)
        self.assertRaises(ValueError, divide, 10, 0)
        # 或者用上下文管理器
        with self.assertRaises(ValueError):
            divide(10, 0)

    def test_list_operations(self):
        self.assertIn(3, self.data)
        self.assertNotIn(6, self.data)
        self.assertTrue(all(x > 0 for x in self.data))

    def tearDown(self):
        """每个测试方法后执行"""
        pass

if __name__ == "__main__":
    unittest.main()
```

### 23.2 pytest（推荐）

```python
# pip install pytest
# test_math.py

def add(a, b):
    return a + b

def test_add_basic():
    assert add(1, 2) == 3

def test_add_negative():
    assert add(-1, -1) == -2

def test_add_zero():
    assert add(0, 0) == 0

# 参数化测试
import pytest

@pytest.mark.parametrize("a,b,expected", [
    (1, 2, 3),
    (0, 0, 0),
    (-1, 1, 0),
    (100, -100, 0),
])
def test_add_parametrize(a, b, expected):
    assert add(a, b) == expected

# fixture（测试装置）
@pytest.fixture
def sample_list():
    return [1, 2, 3, 4, 5]

def test_sum(sample_list):
    assert sum(sample_list) == 15

def test_max(sample_list):
    assert max(sample_list) == 5

# 异常测试
def test_divide_by_zero():
    with pytest.raises(ValueError, match="除数不能为零"):
        divide(10, 0)
```

```bash
# 运行测试
pytest test_math.py -v
pytest --tb=short
pytest -k "add"            # 只运行名字含 "add" 的测试
```

### 23.3 调试技巧

```python
# 1. print 调试（简单直接但不优雅）
print(f"DEBUG: {variable=}")

# 2. assert 断言
assert x > 0, f"x 应该大于 0，实际值为 {x}"

# 3. breakpoint()（Python 3.7+，会启动 pdb 调试器）
def problematic_function():
    x = 10
    breakpoint()     # 程序会在此暂停
    y = x + 20
    return y

# pdb 常用命令:
# n (next)     — 下一行
# s (step)     — 进入函数
# c (continue) — 继续执行
# p variable   — 打印变量
# l (list)     — 显示代码
# q (quit)     — 退出

# 4. icecream（第三方库，更好的 print 调试）
# pip install icecream
from icecream import ic
ic(variable)        # 输出: ic| variable: 42

# 5. logging（生产环境推荐）
import logging
logging.debug(f"变量值: {variable}")
```

### 23.4 doctest

```python
def factorial(n):
    """
    计算 n 的阶乘。

    >>> factorial(0)
    1
    >>> factorial(1)
    1
    >>> factorial(5)
    120
    >>> factorial(10)
    3628800
    """
    if n <= 1:
        return 1
    return n * factorial(n - 1)

if __name__ == "__main__":
    import doctest
    doctest.testmod()   # 自动运行 docstring 中的测试
```

---

## 24 代码规范与项目工程化

### 24.1 PEP 8 代码风格

```python
# ✅ 命名规范
variable_name = 10        # 变量：snake_case
CONSTANT_VALUE = 3.14     # 常量：UPPER_CASE
def function_name():       # 函数：snake_case
    pass
class ClassName:           # 类：PascalCase
    _private = True        # 约定私有：单下划线
    __mangled = True       # 名称改编：双下划线

# ✅ 导入规范（每行一个，分组排列）
# 标准库
import os
import sys

# 第三方库
import requests
import numpy as np

# 本地模块
from mypackage import module

# ✅ 适当的空行
# 顶层定义之间：两个空行
# 类内方法之间：一个空行

# ✅ 行长度不超过 79 字符（代码）/ 72 字符（注释/文档）
```

### 24.2 格式化工具

```bash
# black —— 不妥协的代码格式化器
pip install black
black my_script.py
black --line-length 88 .

# ruff —— 极速 Python linter（Rust 实现）
pip install ruff
ruff check .               # 检查
ruff check --fix .          # 自动修复
ruff format .               # 格式化

# isort —— import 排序
pip install isort
isort .

# mypy —— 静态类型检查
pip install mypy
mypy --strict .
```

### 24.3 项目结构

```
myproject/
├── pyproject.toml          # 项目配置（取代 setup.py）
├── README.md
├── LICENSE
├── .gitignore
├── .env                     # 环境变量（不提交到 git）
│
├── src/
│   └── mypackage/
│       ├── __init__.py
│       ├── core.py
│       ├── utils.py
│       └── models/
│           ├── __init__.py
│           └── user.py
│
├── tests/
│   ├── __init__.py
│   ├── test_core.py
│   └── test_utils.py
│
├── docs/
│   └── api.md
│
└── scripts/
    └── setup.sh
```

### 24.4 pyproject.toml

```toml
[project]
name = "myproject"
version = "0.1.0"
description = "My awesome project"
readme = "README.md"
requires-python = ">=3.10"
dependencies = [
    "requests>=2.28",
    "pydantic>=2.0",
]

[project.optional-dependencies]
dev = [
    "pytest>=7.0",
    "black",
    "ruff",
    "mypy",
]

[tool.black]
line-length = 88

[tool.ruff]
line-length = 88
select = ["E", "F", "I", "UP", "B"]

[tool.mypy]
python_version = "3.12"
strict = true

[tool.pytest.ini_options]
testpaths = ["tests"]
```

### 24.5 Docstring 规范（Google 风格）

```python
def fetch_user(user_id: int, include_posts: bool = False) -> dict:
    """从 API 获取用户信息。

    根据用户 ID 从远程 API 获取用户详情。可选择是否包含
    用户的帖子列表。

    Args:
        user_id: 用户的唯一标识符，必须为正整数。
        include_posts: 是否包含用户的帖子列表，默认 False。

    Returns:
        包含用户信息的字典，格式如下:
        {
            "id": int,
            "name": str,
            "email": str,
            "posts": list[dict] (如果 include_posts 为 True)
        }

    Raises:
        ValueError: 当 user_id 不是正整数时。
        ConnectionError: 当 API 请求失败时。

    Examples:
        >>> user = fetch_user(1)
        >>> print(user["name"])
        'Alice'

        >>> user = fetch_user(1, include_posts=True)
        >>> len(user["posts"])
        5
    """
    ...
```

---

## 25 实战项目集

### 25.1 命令行待办清单

```python
"""命令行待办清单 —— 综合练习
覆盖：文件 I/O、JSON、异常处理、函数、控制流
"""
import json
from pathlib import Path
from datetime import datetime

DATA_FILE = Path("todos.json")

def load_todos() -> list[dict]:
    if DATA_FILE.exists():
        return json.loads(DATA_FILE.read_text(encoding="utf-8"))
    return []

def save_todos(todos: list[dict]) -> None:
    DATA_FILE.write_text(
        json.dumps(todos, ensure_ascii=False, indent=2),
        encoding="utf-8"
    )

def add_todo(todos: list[dict], text: str) -> None:
    todos.append({
        "text": text,
        "done": False,
        "created": datetime.now().isoformat()
    })
    save_todos(todos)

def list_todos(todos: list[dict]) -> None:
    if not todos:
        print("  （暂无待办事项）")
        return
    for i, t in enumerate(todos, 1):
        mark = "✓" if t["done"] else "○"
        print(f"  {i}. [{mark}] {t['text']}")

def main() -> None:
    todos = load_todos()
    print("📋 待办清单（输入 help 查看命令）")
    commands = {
        "list": "显示所有待办",
        "add <text>": "添加待办",
        "done <num>": "标记完成",
        "delete <num>": "删除待办",
        "quit": "退出程序",
    }
    while True:
        try:
            cmd = input("> ").strip()
        except (EOFError, KeyboardInterrupt):
            break
        if not cmd:
            continue
        if cmd == "quit":
            break
        elif cmd == "help":
            for k, v in commands.items():
                print(f"  {k:<15} {v}")
        elif cmd == "list":
            list_todos(todos)
        elif cmd.startswith("add "):
            add_todo(todos, cmd[4:])
            print("  已添加 ✓")
        elif cmd.startswith("done "):
            try:
                idx = int(cmd[5:]) - 1
                todos[idx]["done"] = True
                save_todos(todos)
                print("  已完成 ✓")
            except (IndexError, ValueError):
                print("  无效编号")
        elif cmd.startswith("delete "):
            try:
                idx = int(cmd[7:]) - 1
                todos.pop(idx)
                save_todos(todos)
                print("  已删除 ✓")
            except (IndexError, ValueError):
                print("  无效编号")
        else:
            print("  未知命令，输入 help 查看帮助")

if __name__ == "__main__":
    main()
```

### 25.2 Web 爬虫基础

```python
"""简单网页爬虫 —— requests + BeautifulSoup
覆盖：HTTP 请求、HTML 解析、异常处理、数据存储
"""
import json
import time
import logging
from pathlib import Path
from dataclasses import dataclass, asdict

import requests
from bs4 import BeautifulSoup   # pip install beautifulsoup4

logging.basicConfig(level=logging.INFO, format="%(asctime)s %(message)s")
logger = logging.getLogger(__name__)

@dataclass
class Quote:
    text: str
    author: str
    tags: list[str]

def scrape_quotes(url: str, max_pages: int = 5) -> list[Quote]:
    quotes = []

    for page in range(1, max_pages + 1):
        page_url = f"{url}/page/{page}/"
        logger.info(f"正在爬取: {page_url}")

        try:
            resp = requests.get(page_url, timeout=10)
            resp.raise_for_status()
        except requests.RequestException as e:
            logger.error(f"请求失败: {e}")
            break

        soup = BeautifulSoup(resp.text, "html.parser")
        quote_divs = soup.find_all("div", class_="quote")

        if not quote_divs:
            logger.info("没有更多数据")
            break

        for div in quote_divs:
            text = div.find("span", class_="text").get_text()
            author = div.find("small", class_="author").get_text()
            tags = [t.get_text() for t in div.find_all("a", class_="tag")]
            quotes.append(Quote(text=text, author=author, tags=tags))

        time.sleep(1)  # 礼貌性延迟

    return quotes

def save_quotes(quotes: list[Quote], filepath: str = "quotes.json") -> None:
    data = [asdict(q) for q in quotes]
    Path(filepath).write_text(
        json.dumps(data, ensure_ascii=False, indent=2),
        encoding="utf-8"
    )
    logger.info(f"已保存 {len(quotes)} 条数据到 {filepath}")

if __name__ == "__main__":
    url = "https://quotes.toscrape.com"
    quotes = scrape_quotes(url, max_pages=3)
    save_quotes(quotes)
    for q in quotes[:3]:
        print(f"「{q.text}」 —— {q.author}")
```

### 25.3 数据分析脚本

```python
"""CSV 销售数据分析
覆盖：CSV 读取、collections、排序、格式化输出
"""
import csv
from collections import Counter, defaultdict
from dataclasses import dataclass

@dataclass
class SaleRecord:
    product: str
    category: str
    price: float
    quantity: int

    @property
    def revenue(self) -> float:
        return self.price * self.quantity

def analyze_sales(filepath: str) -> None:
    records: list[SaleRecord] = []

    with open(filepath, "r", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for row in reader:
            records.append(SaleRecord(
                product=row["product"],
                category=row["category"],
                price=float(row["price"]),
                quantity=int(row["quantity"]),
            ))

    total_revenue = sum(r.revenue for r in records)
    total_orders = len(records)
    avg_order = total_revenue / total_orders if total_orders else 0

    # 品类分析
    by_category: dict[str, float] = defaultdict(float)
    for r in records:
        by_category[r.category] += r.revenue

    # 产品销量
    product_count = Counter(r.product for r in records)

    # 输出报告
    print(f"{'='*50}")
    print(f"  销售分析报告")
    print(f"{'='*50}")
    print(f"  总营收:   ¥{total_revenue:>12,.2f}")
    print(f"  总订单:   {total_orders:>12,}")
    print(f"  平均单价: ¥{avg_order:>12,.2f}")
    print(f"\n  {'品类营收':-^40}")

    for cat, rev in sorted(by_category.items(),
                            key=lambda x: x[1], reverse=True):
        pct = rev / total_revenue * 100
        bar = "█" * int(pct / 2)
        print(f"  {cat:<8} ¥{rev:>10,.2f}  {pct:5.1f}% {bar}")

    print(f"\n  {'热销 Top 5':-^40}")
    for product, cnt in product_count.most_common(5):
        print(f"  {product:<15} {cnt} 单")

if __name__ == "__main__":
    analyze_sales("sales.csv")
```

### 25.4 简易 HTTP API 服务器

```python
"""简易 REST API 服务器（标准库实现）
覆盖：HTTP 协议、JSON、路由、异常处理
"""
import json
import logging
from http.server import HTTPServer, BaseHTTPRequestHandler
from urllib.parse import urlparse, parse_qs
from dataclasses import dataclass, asdict, field

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

@dataclass
class Todo:
    id: int
    title: str
    done: bool = False

class TodoStore:
    def __init__(self):
        self._todos: dict[int, Todo] = {}
        self._next_id = 1

    def add(self, title: str) -> Todo:
        todo = Todo(id=self._next_id, title=title)
        self._todos[todo.id] = todo
        self._next_id += 1
        return todo

    def get_all(self) -> list[Todo]:
        return list(self._todos.values())

    def get(self, todo_id: int) -> Todo | None:
        return self._todos.get(todo_id)

    def update(self, todo_id: int, **kwargs) -> Todo | None:
        todo = self._todos.get(todo_id)
        if todo:
            for k, v in kwargs.items():
                setattr(todo, k, v)
        return todo

    def delete(self, todo_id: int) -> bool:
        return self._todos.pop(todo_id, None) is not None

store = TodoStore()

class TodoHandler(BaseHTTPRequestHandler):
    def _json_response(self, data, status=200):
        self.send_response(status)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.end_headers()
        self.wfile.write(json.dumps(data, ensure_ascii=False, default=str).encode())

    def _read_body(self) -> dict:
        length = int(self.headers.get("Content-Length", 0))
        return json.loads(self.rfile.read(length)) if length else {}

    def _send_404(self):
        self._json_response({"error": "Not Found"}, 404)

    def do_GET(self):
        parsed = urlparse(self.path)
        if parsed.path == "/todos":
            todos = [asdict(t) for t in store.get_all()]
            self._json_response(todos)
        elif parsed.path.startswith("/todos/"):
            try:
                todo_id = int(parsed.path.split("/")[-1])
                todo = store.get(todo_id)
                self._json_response(asdict(todo) if todo else self._send_404())
            except ValueError:
                self._send_404()
        else:
            self._send_404()

    def do_POST(self):
        if self.path == "/todos":
            body = self._read_body()
            todo = store.add(body.get("title", "无标题"))
            self._json_response(asdict(todo), 201)
        else:
            self._send_404()

    def do_DELETE(self):
        if self.path.startswith("/todos/"):
            todo_id = int(self.path.split("/")[-1])
            if store.delete(todo_id):
                self._json_response({"message": "已删除"})
            else:
                self._send_404()

    def log_message(self, format, *args):
        logger.info(f"{self.address_string()} {format % args}")

if __name__ == "__main__":
    server = HTTPServer(("localhost", 8000), TodoHandler)
    print("🚀 Server running on http://localhost:8000")
    print("  GET    /todos       — 获取所有待办")
    print("  POST   /todos       — 创建待办 (body: {\"title\": \"...\"})")
    print("  DELETE /todos/<id>   — 删除待办")
    server.serve_forever()
```

### 25.5 密码管理器（加密）

```python
"""简单密码管理器 —— 学习加密与安全
覆盖：加密、文件 I/O、base64、异常处理
"""
import json
import base64
import secrets
import hashlib
from pathlib import Path
from getpass import getpass

# pip install cryptography
from cryptography.fernet import Fernet
from cryptography.hazmat.primitives.kdf.pbkdf2 import PBKDF2HMAC
from cryptography.hazmat.primitives import hashes

VAULT_FILE = Path("vault.enc")
SALT_SIZE = 16

def derive_key(master_password: str, salt: bytes) -> bytes:
    """从主密码派生加密密钥"""
    kdf = PBKDF2HMAC(
        algorithm=hashes.SHA256(),
        length=32,
        salt=salt,
        iterations=480000,
    )
    return base64.urlsafe_b64encode(kdf.derive(master_password.encode()))

def load_vault(master_password: str) -> dict:
    if not VAULT_FILE.exists():
        return {}

    raw = VAULT_FILE.read_bytes()
    salt = raw[:SALT_SIZE]
    encrypted = raw[SALT_SIZE:]

    key = derive_key(master_password, salt)
    f = Fernet(key)

    try:
        decrypted = f.decrypt(encrypted)
        return json.loads(decrypted)
    except Exception:
        raise ValueError("主密码错误或数据已损坏")

def save_vault(data: dict, master_password: str) -> None:
    salt = secrets.token_bytes(SALT_SIZE)
    key = derive_key(master_password, salt)
    f = Fernet(key)

    plaintext = json.dumps(data, ensure_ascii=False).encode()
    encrypted = f.encrypt(plaintext)

    VAULT_FILE.write_bytes(salt + encrypted)

def main() -> None:
    master = getpass("请输入主密码: ")

    try:
        vault = load_vault(master)
    except ValueError:
        if VAULT_FILE.exists():
            print("密码错误！")
            return
        vault = {}

    print(f"已加载 {len(vault)} 条记录")

    while True:
        cmd = input("\n(list/add/get/quit) > ").strip()
        if cmd == "quit":
            break
        elif cmd == "list":
            for name in vault:
                print(f"  • {name}")
        elif cmd == "add":
            name = input("  服务名: ")
            username = input("  用户名: ")
            password = getpass("  密码: ")
            vault[name] = {"username": username, "password": password}
            save_vault(vault, master)
            print("  已保存 ✓")
        elif cmd == "get":
            name = input("  服务名: ")
            if name in vault:
                print(f"  用户名: {vault[name]['username']}")
                print(f"  密码:   {vault[name]['password']}")
            else:
                print("  未找到")

if __name__ == "__main__":
    main()
```

---

## 附录 A Python 3.10~3.13 新特性速查

### Python 3.10（2021）

```python
# 1. match / case 模式匹配
match command:
    case ["quit"]:
        print("退出")
    case ["go", direction]:
        print(f"走向 {direction}")

# 2. 更精确的错误消息
# 现在会精确指出括号/引号未闭合的位置

# 3. 联合类型简化（用 | 代替 Union）
def func(x: int | str) -> bool: ...
```

### Python 3.11（2022）

```python
# 1. 异常组（ExceptionGroup）
try:
    raise ExceptionGroup("多个错误", [
        ValueError("错误1"),
        TypeError("错误2"),
    ])
except* ValueError as eg:
    print(f"ValueError: {eg.exceptions}")
except* TypeError as eg:
    print(f"TypeError: {eg.exceptions}")

# 2. 更快的 CPython（10-60% 性能提升）

# 3. 改进的错误消息（带建议）
# Did you mean 'append'?

# 4. 标准库新模块：tomllib（解析 TOML）
import tomllib
```

### Python 3.12（2023）

```python
# 1. f-string 增强（可以嵌套引号）
f"{'hello':>10}"   # 之前某些情况下会报错，现在完全支持

# 2. 类型参数语法（TypeVar 简化）
def first[T](items: list[T]) -> T:
    return items[0]

type Point = tuple[float, float]   # 类型别名

# 3. *args 改进
def func[*T](*args: *T) -> tuple[*T]: ...

# 4. 推导式改进（不再有变量泄漏）
x = "outer"
result = [x for x in range(5)]
print(x)   # "outer"（Python 3.12 修复了循环变量泄漏）
```

### Python 3.13（2024）

```python
# 1. 交互式解释器改进（支持多行编辑、语法高亮）

# 2. free-threaded CPython（实验性，无 GIL 版本）
# 构建时加 --disable-gil

# 3. JIT 编译器（实验性）

# 4. 更好的错误消息
```

---

## 附录 B 常见陷阱与最佳实践

### 陷阱 1：可变默认参数

```python
# ❌
def bad(x, lst=[]):
    lst.append(x)
    return lst

# ✅
def good(x, lst=None):
    if lst is None:
        lst = []
    lst.append(x)
    return lst
```

### 陷阱 2：浮点数精度

```python
# ❌
0.1 + 0.2 == 0.3  # False

# ✅
import math
math.isclose(0.1 + 0.2, 0.3)  # True
```

### 陷阱 3：闭包中的循环变量

```python
# ❌ 所有函数都引用同一个变量 i
funcs = [lambda: i for i in range(5)]
print([f() for f in funcs])  # [4, 4, 4, 4, 4]

# ✅ 用默认参数捕获当前值
funcs = [lambda i=i: i for i in range(5)]
print([f() for f in funcs])  # [0, 1, 2, 3, 4]
```

### 陷阱 4：浅拷贝 vs 深拷贝

```python
import copy

a = [[1, 2], [3, 4]]
b = a.copy()        # 浅拷贝 —— 内层列表是共享的
c = copy.deepcopy(a)  # 深拷贝 —— 完全独立

b[0][0] = 99
print(a[0][0])   # 99（a 也被修改了！）

c[0][0] = 0
print(a[0][0])   # 99（a 不受影响）
```

### 陷阱 5：字典遍历时修改

```python
d = {"a": 1, "b": 2, "c": 3}

# ❌ RuntimeError: 在遍历时修改字典
# for k, v in d.items():
#     if v < 2:
#         del d[k]

# ✅ 先收集要删除的键
to_delete = [k for k, v in d.items() if v < 2]
for k in to_delete:
    del d[k]
```

### 最佳实践总结

| 建议 | 说明 |
|------|------|
| 用 `is` 判断 `None` | `if x is None` 比 `== None` 更精确 |
| 用 EAFP | 先做再说（try/except），而不是先检查再做 |
| 用 pathlib | 比 os.path 更面向对象、更优雅 |
| 用 f-string | 比 `%` 和 `.format()` 更可读 |
| 用 dataclass | 减少样板代码，自动生成方法 |
| 用 with 管理资源 | 确保文件、锁等资源被正确释放 |
| 用生成器处理大数据 | 惰性求值，不占内存 |
| 用虚拟环境 | 隔离项目依赖 |
| 写类型注解 | 提高可读性，配合 mypy 提前发现 bug |
| 用 pytest | 比 unittest 更简洁、更强大 |

---

*Python 完整学习文档 —— 25 个核心主题 · 250+ 代码示例 · 从入门到实战*

*最后更新: 2024-01 · 适用版本: Python 3.10+*
```