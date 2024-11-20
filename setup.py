from setuptools import setup, Extension
from Cython.Build import cythonize

# Cython으로 빌드할 확장 모듈 정의
extensions = [
    Extension("Metamorphic.MorphAlyt", ["Metamorphic/MorphAlyt.pyx"]),
]

# setup 함수 정의
setup(
    name="MetaMorphic",
    version="0.0.2",
    author='fourchains_R&D',
    author_email='fourchainsrd@gmail.com',
    url='https://github.com/leechaeeyoung/Fc', 
    packages=['MetaMorphic'],
    long_description=open("README.md", encoding="utf-8").read(),
    ext_modules=cythonize(extensions, compiler_directives={'language_level': "3"}),    # Cython 컴파일 활성화
    package_data={
        "MetaMorphic": ["*.pxd", "*.c", "*.h", "*.pyd"],  # 포함할 파일 확장자 명시
    },
    include_package_data=True,
)