[[toc]]

When creating a multi-module project for Python, especially when coming from another language ecosystem, you may encounter issues importing code from other files, let's take a look at this

# The Modules

In our project, we've got the following files:

```
package1
  |- module1.py
package2
  |- namespace2
       |- module2.py
main.py
```

Let's say each of our modules export a function, here's the code for them:

`package1/module1.py`

```py
def hello_p1_m1():
  return "hello"
```

`package2/subpackage1/module1.py`

```py
def hello_p2_s1_m1():
  return "hello"
```

# The Main

Now that we've got our files with their functions separated, we try using them from the `main.py` file:

`main.py`

```py
import package1.module1 as p1m1
import package2.namespace1.module1 as p2s1m1

print(p1m1.hello_p1_m1())
print(p2n1m1.hello_p2_s1_m1())
```

# The Error

Now, we try to run this using `python`:

```sh
python main.py
```

And we get the following error:

```
Traceback (most recent call last):
  File "main.py", line 1, in <module>
    import package1.module1 as p1m1
ImportError: No module named package1.module1
```

# The Solution

Now, this can be pretty annoying, but the solution is very simple. Python identifies a `module` as a single file, and the assumption that leads to the issue above is that we assume a `package` has the same convention of just being a directory

However, a `packgage` requires an `__init__.py` file to be defined so that they are recognized correctly

So, we need to add two files:

- `package1/__init__.py`
- `package2/subpackage1/__init__.py`

Additionally, these files are completely empty, and only serve as information. Note that we don't need to include a file in `package2` directly as this directory does not contain any modules within it so is not really a package in itself and is simply a wrapper  `subpackage1`
