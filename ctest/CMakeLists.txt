add_executable(p1_test p1_test.c)

target_link_directories(p1_test
  PUBLIC
    # "${CMAKE_SOURCE_DIR}/lib"
    "${CMAKE_SOURCE_DIR}/build/arc"
)

TARGET_LINK_LIBRARIES(
  p1_test
    lua_static
    m
    dl
)

target_include_directories(p1_test
  PUBLIC 
    "${CMAKE_SOURCE_DIR}/src"
)

target_compile_options(p1_test
  PUBLIC
    # -fsanitize=address
    # -fno-omit-frame-pointer #可以在错误信息中提取更有意义的栈帧信息
    # 为了获取完美的栈帧信息，可能需要禁用内联（仅使用 -O1）和跟踪调用消除（-fno-optimize-sibling-calls）
)

target_link_options(p1_test
  PUBLIC
    "-Wl,-E" # When creating a dynamically linked executable, using the -E option or the --export-dynamic option causes the linker to add all symbols to the dynamic symbol table. The dynamic symbol table is the set of symbols which are visible from dynamic objects at run time.
    # -fuse-ld=lld # use lld 链接器链接目标文件
    # -fsanitize=address
)

# list(REMOVE_ITEM CXX_FEATURE_SRC
#     ./coroutines_test.cpp
# )

