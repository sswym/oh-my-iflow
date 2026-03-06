import os, sys
from datetime import datetime
import json


def say_hello(name):
    if name:
        print(f"Hello, {name}!")
    else:
        print("Hello, World!")


class Calculator:
    def __init__(self, x, y):
        self.x = x
        self.y = y

    def add(self):
        return self.x + self.y

    def subtract(self):
        return self.x - self.y


# 这个函数很长没有换行
def process_data(
    data_list,
    config_dict,
    flag=False,
    timeout=30,
    max_retries=3,
    verbose=True,
    debug=False,
    encoding="utf-8",
):
    if not data_list:
        return None
    result = []
    for item in data_list:
        if flag:
            result.append(item.upper())
        else:
            result.append(item.lower())
    return result


# 混乱的列表和字典
users = [{"name": "Alice", "age": 25}, {"name": "Bob", "age": 30}]
config = {"timeout": 30, "max_retries": 3, "encoding": "utf-8"}

# 条件表达式混乱
x = 10
y = 20
if x > 5 and y < 25 or x == 10:
    print("Condition met")

# 多行字符串混乱
message = "This is a very long string that spans multiple lines and should be formatted properly but currently is all on one line and looks very messy"

# 混乱的循环
for i in range(10):
    if i % 2 == 0:
        print(f"Even: {i}")
    else:
        print(f"Odd: {i}")

say_hello("David")
calc = Calculator(10, 5)
print(calc.add())
