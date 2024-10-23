from setuptools import setup, find_packages

setup(
    name='your_package_name',
    version='0.0.1',
    description='ECHC statistics algorithm',
    long_description=open('README.md').read(),
    long_description_content_type='text/markdown',
    author='fourchains_R&D',
    author_email='zs1397@naver.com',
    url='https://github.com/leechaeeyoung/ECHC_statistic',
    packages=find_packages(),
    install_requires=[
        'package1>=0.0.0',
    ],
    classifiers=[
        'Programming Language :: Python :: 3',
        'License :: OSI Approved :: MIT License',
        'Operating System :: OS Independent',
    ],
    python_requires='>=3.6',
)
