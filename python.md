# Python

## packaging

```text
path_entry/ 
|   ^-- sys.path.append('path_entry') | sys.path.extend(['path_entry'])
|       or `export PYTHONPATH=path_entry`
|       or `from .path_entry import smth`
|       or just `from . import smth`
|       or `from ..parent import smth`
|
|
|___-__main__.py
|       ^--- (ZIPped) package start point
|
|___my_package/
    |___ __init__.py <-- `path_entry.__file__`
    |___ test
        |___ __init__.py
        |___ test_code.py
```


```python
d = dict(key='value', b=2)
print('{key}{b}'.format(**d)) # value2
print('{0}{1}'.format(*d)) #bkey
print('{}'.format(*d.items())) # value list
```

```python
class MyClass:
  def __init__(self):
    self.myVar = {}
  def __call__(self, *args, **keywordArgs):
    # MyClass()(param1, param2, key=word)
    # for arg in args: # may be \__(o_0)__/
  
    # myClass = MyClass()
    # myClass(*[param1, param2]) ==> myClass(param1, param2)
```

```python
def myDecorator(f):
    def wrap(*args, **kwargs):
        # pre-call
        result = f(*arg, **kwargs)
        # post-call
        return result
        
    return wrap
    
@myDecorator
def func():
    #...
```


## functions

+ `callable(fun)`: [True|False]

### string
+ `splitext(del)`
