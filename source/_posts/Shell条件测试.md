---
title: Shell条件测试
copyrighr: true
hide: true
date: 2024-04-19 15:02:30
tags:
    - Linux
categories:
    - Shell
---
## Shell条件测试

在Shell脚本中，条件测试可以使用三种格式：

1. **格式1**：使用`test`命令。`test`命令允许您在Shell脚本中测试条件。例如：

```bash
if test $a -eq $b; then
    echo "a 等于 b"
else
    echo "a 不等于 b"
fi
```

2. **格式2**：使用方括号`[]`。方括号是`test`命令的等效符号。例如：

```bash
if [ $a -eq $b ]; then
    echo "a 等于 b"
else
    echo "a 不等于 b"
fi
```

3. **格式3**：使用双方括号`[[]]`。`[[]]`提供了更多的功能，比如模式匹配和正则表达式匹配，而不是仅仅测试变量是否存在或是否为空。例如：

```bash
if [[ $a -eq $b ]]; then
    echo "a 等于 b"
else
    echo "a 不等于 b"
fi
```

## 文件比较

- `-e file`: 检查文件是否存在。

- `-f file`: 检查文件是否是一个常规文件。

- `-d file`: 检查文件是否是一个目录。

- `-s file`: 检查文件是否非空。

- `-r file`: 检查文件是否可读。

- `-w file`: 检查文件是否可写。

- `-x file`: 检查文件是否可执行

**示例：**

文件测试条件是Shell脚本中常用的一种方式，用于检查文件的各种属性。以下是一些常见的文件测试条件及其用法：

1. **文件是否存在 (`-e`)：**
   ```bash
   if [ -e "$file" ]; then
       echo "File exists."
   fi
   ```

2. **文件是否是一个常规文件 (`-f`)：**
   ```bash
   if [ -f "$file" ]; then
       echo "File is a regular file."
   fi
   ```

3. **文件是否是一个目录 (`-d`)：**
   ```bash
   if [ -d "$file" ]; then
       echo "File is a directory."
   fi
   ```

4. **文件是否非空 (`-s`)：**
   ```bash
   if [ -s "$file" ]; then
       echo "File is not empty."
   fi
   ```

5. **文件是否可读 (`-r`)：**
   ```bash
   if [ -r "$file" ]; then
       echo "File is readable."
   fi
   ```

6. **文件是否可写 (`-w`)：**
   ```bash
   if [ -w "$file" ]; then
       echo "File is writable."
   fi
   ```

7. **文件是否可执行 (`-x`)：**
   ```bash
   if [ -x "$file" ]; then
       echo "File is executable."
   fi
   ```

## 数值比较

- 等于：`-eq`（equal）
- 不等于：`-ne`（not equal）
- 大于：`-gt`（greater than）
- 小于：`-lt`（less than）
- 大于等于：`-ge`（greater than or equal to）
- 小于等于：`-le`（less than or equal to）

**示例脚本：**

```shell
#!/bin/bash
value1=10
value2=11

if [ $value1 -gt $value2 ]
then
	echo "The test value $value1 is greater than $value2"
else
	echo "The test value $value1 is less than $value2"
fi

if [ $value1 -eq $value2 ]
then
	echo "The values are equal"
else
	echo "The values are different"
fi
```

## 字符串比较

- `str1 = str2 ` :  检查str1是否和str2相同
- `str1 != str2` :  检查str1是否和str2不同
- `str1 < str2 ` :  检查str1是否小于str2
- `str1 > str2` :  检查str1是否大于str2
- `-n str1` :  检查str1的长度是否不为0
- `-z str1 ` :  检查str1是否为0

**示例脚本：**

```shell
#!/bin/bash

# 定义两个字符串变量
str1="Hello"
str2="World"

# 比较两个字符串是否相等
if [ "$str1" = "$str2" ]; then
    echo "字符串相等"
else
    echo "字符串不相等"
fi

# 比较两个字符串是否不相等
if [ "$str1" != "$str2" ]; then
    echo "字符串不相等"
else
    echo "字符串相等"
fi

# 比较字符串的长度是否相等
if [ ${#str1} -eq ${#str2} ]; then
    echo "字符串长度相等"
else
    echo "字符串长度不相等"
fi

# 检查字符串是否为空
if [ -z "$str1" ]; then
    echo "字符串为空"
else
    echo "字符串不为空"
fi

# 检查字符串是否非空
if [ -n "$str1" ]; then
    echo "字符串不为空"
else
    echo "字符串为空"
fi

# 检查字符串是否以特定前缀开始
prefix="He"
if [ "${str1#$prefix}" != "$str1" ]; then
    echo "字符串以 $prefix 开始"
else
    echo "字符串不以 $prefix 开始"
fi

# 检查字符串是否以特定后缀结束
suffix="lo"
if [ "${str1%$suffix}" != "$str1" ]; then
    echo "字符串以 $suffix 结束"
else
    echo "字符串不以 $suffix 结束"
fi
```

## 复合条件测试

### AND 操作符（&&）

**语法：**

```
[ condition1 ] && [ condition2 ]
```

AND 操作符用于在两个条件都为真时返回真。

```bash
#!/bin/bash

# 定义两个变量
num1=5
num2=10

# 如果 num1 大于 0 并且 num2 大于 0，则输出消息
if [ $num1 -gt 0 ] && [ $num2 -gt 0 ]; then
    echo "Both numbers are greater than 0."
else
    echo "At least one number is not greater than 0."
fi
```

### OR 操作符（||）

**语法：**

```
[ condition1 ] || [ condition2 ]
```

OR 操作符用于在两个条件中至少有一个为真时返回真。

```bash
#!/bin/bash

# 定义两个变量
num1=5
num2=10

# 如果 num1 大于 0 或者 num2 大于 0，则输出消息
if [ $num1 -gt 0 ] || [ $num2 -gt 0 ]; then
    echo "At least one number is greater than 0."
else
    echo "Both numbers are not greater than 0."
fi
```



