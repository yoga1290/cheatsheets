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
class MyClass(parentClass1, parentClass2,..):
    def __init__(self):
        self.myVar = {}
    def __call__(self, *args, **keywordArgs):
        # MyClass()(param1, param2, key=word)
        # for arg in args: # may be \__(o_0)__/

        # myClass = MyClass()
        # myClass(*[param1, param2]) ==> myClass(param1, param2)
    def __repr__(self):
        # triggered by repr(myObject)
        # reprlib.repr(myObject)
    def __str__(self):
        # invoked by str(myObject)
        # falls back to __str__()
    def __format__(format_spec):
        # invoked '{:format_spec_value}'.format(myObject)
        # falls back to __str__()
    @staticmethod
    def mystaticmethod():
        # no need for `self` parameter
    @classmethod
    def myClassMethod(cls, param1):
        return cls(param1,..) # triggers __init(param1,..)__
        
    @property
    def toBeValidated(self):
        # getter
        return self._v
    @toBeValidated.setter
    def toBeValidated(self, value):
        # setter; validation for `self.toBeValidated`
        if not (min <= value <= max):
            raise ValueError("..")
        self._v = value

```
## Decorators
```python
import functools
def myDecorator(f):
        @functools.wraps(f)
        def wrap():
            # pre-call
            result = f()
            # post-call
            return result
        return wrap
    return myDecorator
```

### Passing parameters to decorator

```python
import functools
def myDecorator3(param1, param2):
    def myDecorator(f):
        def wrap(*args, **kwargs):
            # pre-call
            result = f(*arg, **kwargs)
            # post-call
            return result
        # forward the original name/doc
        wrap.__name__ = f.__name__
        wrap.__doc__ = f.__doc__
        return wrap
    return myDecorator
```

### Decimal

```python
from decimal import Decimal

Decimal('0.8') - Decimal('0.7') # Decimal('0.1')
Decimal(-7) % Decimal(3) # Decimal(-1) # >-6, instead of 2
```

### 

## functions

+ `callable(fun)`: [True|False]

### string
+ `splitext(del)`


## Numpy
```
import numpy as np

np.random.randn(N[,D])
np.array([...]).T 
np.array([...]).mean()
np.array([...]).std()
np.array([...]).dot([])
np.zeros( (N [, D]) )
N, D = np.array(..).shape
np.concatenate()
```

## Pandas
```
import pandas as pd

df = pd.read_csv('file.csv', [index_col=0, skiprows=1])
df[df['column1'] > 0 & df['column1'] < 100]].loc[0].name
df.head()
df.as_matrix()
```

###  Series

+ `pd.Series(['a', 'b', 'c'])`
+ `pd.Series({})`
+ `df['columnName'].iloc[i]`
+ `df.iloc[i].name #index`


# Interactive Python Notebook
+ [Markdown for IPyNB](https://www.ibm.com/support/knowledgecenter/SSQNUZ_current/com.ibm.icpdata.doc/dsx/markd-jupyter.html)
