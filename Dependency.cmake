# --- 외부 라이브러리 관리할 때 사용하는 파일 --

# ExternalProject 관련 명령어 셋 추가 ()
include(ExternalProject)

# Dependency 관련 변수 설정
set(DEP_INSTALL_DIR ${PROJECT_BINARY_DIR}/install)  # PROJECT_BINARY_DIR : build폴더
set(DEP_INCLUDE_DIR ${DEP_INSTALL_DIR}/include)
set(DEP_LIB_DIR ${DEP_INSTALL_DIR}/lib)

#spdlog: fast logger library (메소드기능: 링크(사용할라이브러리)에서 다운로드 후 cmake실행)
ExternalProject_Add(
    dep_spdlog  #대표이름
    GIT_REPOSITORY "https://github.com/gabime/spdlog.git"
    GIT_TAG "v1.x"  # 버전 세팅(branch이름 or Tag이름)
    GIT_SHALLOW 1   # 1: 활성화(true). 최신lib만 다운 0: 비활성화
    UPDATE_COMMAND ""  # 자동으로 최신코드로 변환하지 않을거면 ""
    PATCH_COMMAND ""
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${DEP_INSTALL_DIR} # 빌드했을 때의 저장경로 지정. // cmake configure 사용하므로 cmake arguments를 지정한다. // -D : 변수세팅(definition)
    TEST_COMMAND ""     # 자동 테스트 실행 스탭 활성화여부. 비활성화는 ""
)
# Dependency 리스트 및 라이브러리 파일 리스트 추가
set(DEP_LIST ${DEP_LIST} dep_spdlog)
set(DEP_LIBS ${DEP_LIBS} spdlog$<$<CONFIG:Debug>:d>)    #CONFIG가 'Debug'모드라면 이름 뒤에 'd'를 붙이고, 아니라면 'd'를 붙이지 않는다



# glfw
ExternalProject_Add(
    dep_glfw
    GIT_REPOSITORY "https://github.com/glfw/glfw.git"
    GIT_TAG "3.3.3"
    GIT_SHALLOW 1
    UPDATE_COMMAND ""
    PATCH_COMMAND ""
    TEST_COMMAND ""
    CMAKE_ARGS
        -DCMAKE_INSTALL_PREFIX=${DEP_INSTALL_DIR}
        -DGLFW_BUILD_EXAMPLES=OFF
        -DGLFW_BUILD_TESTS=OFF
        -DGLFW_BUILD_DOCS=OFF
)
set(DEP_LIST ${DEP_LIST} dep_glfw)
set(DEP_LIBS ${DEP_LIBS} glfw3)



# glad  (각 vendor마다 고유하게 제공하는 openGL function을 loading해주는 <function loader>이다. 함수 호출을 위해 전용<function loader>를 사용하는게 좋다)
ExternalProject_Add(
    dep_glad
    GIT_REPOSITORY "https://github.com/Dav1dde/glad"
    GIT_TAG "v0.1.34"
    GIT_SHALLOW 1
    UPDATE_COMMAND ""
    PATCH_COMMAND ""
    CMAKE_ARGS
        -DCMAKE_INSTALL_PREFIX=${DEP_INSTALL_DIR}
        -DGLAD_INSTALL=ON
    TEST_COMMAND ""
    )
set(DEP_LIST ${DEP_LIST} dep_glad)
set(DEP_LIBS ${DEP_LIBS} glad)


# stb
ExternalProject_Add(
    dep_stb
    GIT_REPOSITORY "https://github.com/nothings/stb"
    GIT_TAG "master"
    GIT_SHALLOW 1
    UPDATE_COMMAND ""
    PATCH_COMMAND ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    TEST_COMMAND ""
    INSTALL_COMMAND ${CMAKE_COMMAND} -E copy
        ${PROJECT_BINARY_DIR}/dep_stb-prefix/src/dep_stb/stb_image.h
        ${DEP_INSTALL_DIR}/include/stb/stb_image.h
    )
set(DEP_LIST ${DEP_LIST} dep_stb)


#glm
ExternalProject_Add(
  dep_glm
  GIT_REPOSITORY "https://github.com/g-truc/glm"
  GIT_TAG "0.9.9.8"
  GIT_SHALLOW 1
  UPDATE_COMMAND ""
  PATCH_COMMAND ""
  CONFIGURE_COMMAND ""
  BUILD_COMMAND ""
  TEST_COMMAND ""
  INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_directory
    ${PROJECT_BINARY_DIR}/dep_glm-prefix/src/dep_glm/glm
    ${DEP_INSTALL_DIR}/include/glm
    )   
set(DEP_LIST ${DEP_LIST} dep_glm)


add_library(imgui
    imgui/imgui_draw.cpp
    imgui/imgui_tables.cpp
    imgui/imgui_widgets.cpp
    imgui/imgui.cpp
    imgui/imgui_impl_glfw.cpp
    imgui/imgui_impl_opengl3.cpp
    )
target_include_directories(imgui PRIVATE ${DEP_INCLUDE_DIR})
add_dependencies(imgui ${DEP_LIST})
set(DEP_INCLUDE_DIR ${DEP_INCLUDE_DIR} ${CMAKE_CURRENT_SOURCE_DIR}/imgui)
set(DEP_LIST ${DEP_LIST} imgui)
set(DEP_LIBS ${DEP_LIBS} imgui)

# assimp
ExternalProject_Add(
  dep_assimp
  GIT_REPOSITORY "https://github.com/assimp/assimp"
  GIT_TAG "v5.0.1"
  GIT_SHALLOW 1
  UPDATE_COMMAND ""
  PATCH_COMMAND ""
  CMAKE_ARGS
    -DCMAKE_INSTALL_PREFIX=${DEP_INSTALL_DIR}
    -DBUILD_SHARED_LIBS=OFF
    -DASSIMP_BUILD_ASSIMP_TOOLS=OFF
    -DASSIMP_BUILD_TESTS=OFF
    -DASSIMP_INJECT_DEBUG_POSTFIX=OFF
    -DASSIMP_BUILD_ZLIB=ON
  TEST_COMMAND ""
  )
set(DEP_LIST ${DEP_LIST} dep_assimp)
set(DEP_LIBS ${DEP_LIBS}
    assimp-vc143-mt$<$<CONFIG:Debug>:d>
    zlibstatic$<$<CONFIG:Debug>:d>
    IrrXML$<$<CONFIG:Debug>:d>
    )