import os
import pydoc
import sys
from pkgutil import iter_modules

from setuptools import find_packages


# Copied from https://stackoverflow.com/questions/48879353/how-do-you-recursively-get-all-submodules-in-a-python-package
# and modified to be a generator
def find_modules(path):
    for pkg in find_packages(path):
        yield pkg
        pkgpath = path + '/' + pkg.replace('.', '/')
        if sys.version_info.major == 2 or (sys.version_info.major == 3 and sys.version_info.minor < 6):
            for _, name, ispkg in iter_modules([pkgpath]):
                if not ispkg:
                    yield pkg + '.' + name
        else:
            for info in iter_modules([pkgpath]):
                if not info.ispkg:
                    yield pkg + '.' + info.name


def generate_docs(module):
    def run_once(name):
        pydoc.writedoc(name)

    base = f'{module}.' if module != '.' else ''
    if base:
        run_once(module)
    for submodule in find_modules(module):
        run_once(base + submodule)


if __name__ == '__main__':
    generate_docs('.')
