cmake_minimum_required(VERSION 3.22)

project(seg_label_generate LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

add_definitions(-DCPU_ONLY)

# Recursively collect all .cpp files under src/ (no need for execute_process)
file(GLOB_RECURSE CXX_SRCS "${CMAKE_SOURCE_DIR}/src/*.cpp")

add_executable(${PROJECT_NAME} ${CXX_SRCS})

# Find OpenCV (required)
find_package(OpenCV REQUIRED COMPONENTS core highgui imgproc imgcodecs)

target_include_directories(${PROJECT_NAME} PUBLIC ${OpenCV_INCLUDE_DIRS})
target_link_libraries(${PROJECT_NAME} PRIVATE ${OpenCV_LIBS})

# Find OpenMP
find_package(OpenMP)
if(OpenMP_CXX_FOUND)
    message(STATUS "Building with OpenMP")
    target_link_libraries(${PROJECT_NAME} PRIVATE OpenMP::OpenMP_CXX)
endif()

# Include your project's include directory
target_include_directories(${PROJECT_NAME} PUBLIC "${CMAKE_SOURCE_DIR}/include")
