from setuptools import setup, Extension
from Cython.Build import cythonize

# Cython으로 빌드할 확장 모듈 정의
extensions = [
    Extension("PyMorph.MorphAlyt", ["PyMorph/MorphAlyt.pyx"]),
]

# setup 함수 정의
setup(
    name="PyMorph",
    version="0.0.1",
    long_description=open("README.md", encoding="utf-8").read(),
    ext_modules=cythonize(extensions, compiler_directives={'language_level': "3"}),    # Cython 컴파일 활성화
    package_data={
        "PyMorph": ["*.pxd", "*.c", "*.h", "*.pyd"],  # 포함할 파일 확장자 명시
    },
    include_package_data=True,
)
