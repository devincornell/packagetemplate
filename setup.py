
from setuptools import setup, find_packages


package_name = 'mypackage'
repo_name = 'mypackage'
version = '0.1'
description = 'This is a new package.'

with open("README.md", "r") as fh:
    long_description = fh.read()

setup(name=package_name,
    version='{}'.format(version),
    description=description,
    long_description=long_description,
    long_description_content_type="text/markdown",
    url=f'https://github.com/devincornell/{repo_name}',
    author='Devin J. Cornell',
    author_email='devin@devinjcornell.com',
    license='MIT',
    packages=find_packages(include=[package_name, f'{package_name}.*']),
    install_requires=['setuptools',],# 'sqlalchemy >= 2.0', 'pandas', 'numpy', 'pymongo'],
    zip_safe=False,
    download_url=f'https://github.com/devincornell/{package_name}/archive/v{version}.tar.gz',
)


