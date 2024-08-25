# -- 본인 소스코드 관리할 때 사용하는 파일 --

cmake_minimum_required(VERSION 3.13)

set(PROJECT_NAME opengl_example) # set명령 : 변수 생성
set(CMAKE_CXX_STANDARD 17)  # pre-defined변수 : C++ 버전 17으로 설정

set(WINDOW_NAME "OpenGL Example")
set(WINDOW_WIDTH 960)
set(WINDOW_HEIGHT 540)

project(${PROJECT_NAME})    # 프로젝트 세팅 시작
add_executable(${PROJECT_NAME} 
    src/main.cpp
    src/common.cpp src/common.h
    src/shader.cpp src/shader.h
    src/program.cpp src/program.h
    src/context.cpp src/context.h
    src/buffer.cpp src/buffer.h
    src/vertex_layout.cpp src/vertex_layout.h
    src/image.cpp src/image.h
    src/texture.cpp src/texture.h
    src/mesh.cpp src/mesh.h
    src/model.cpp src/model.h
    src/framebuffer.cpp src/framebuffer.h
  )    # 해당 cpp파일 컴파일해서 해당 이름으로 실행파일 생성

# 터미널명령: cmake -Bbuild . -DCMAKE_BUILD_TYPE=Debug   # [Debug|Release]
# 터미널명령: cmake --build build --config Debug
# 터미널명령: .\build\Debug\cmake_project_example.exe


include(Dependency.cmake)


# 우리 프로젝트에 include / lib 관련 옵션 추가
target_include_directories(${PROJECT_NAME} PUBLIC ${DEP_INCLUDE_DIR}) # 인수1: 컴파일대상(실행파일생성대상) 인수2: 컴파일 시 링크대상
target_link_directories(${PROJECT_NAME} PUBLIC ${DEP_LIB_DIR})
target_link_libraries(${PROJECT_NAME} PUBLIC ${DEP_LIBS})

target_compile_definitions(${PROJECT_NAME} PUBLIC       # 윈도우기본설정 커맨드 지정
WINDOW_NAME="${WINDOW_NAME}"
WINDOW_WIDTH=${WINDOW_WIDTH}
WINDOW_HEIGHT=${WINDOW_HEIGHT}
)


# Dependency들이 먼저 build 될 수 있게 관계 설정
add_dependencies(${PROJECT_NAME} ${DEP_LIST})   # 인수2를 먼저 컴파일한 후 인수1을 컴파일하게 설정. 안쓰면 병렬빌드해서 의존관계파일NotFound오류 가능성.


