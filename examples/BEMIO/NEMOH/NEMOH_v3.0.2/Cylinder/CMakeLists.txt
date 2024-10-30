file(COPY ${CMAKE_CURRENT_SOURCE_DIR}/. DESTINATION ${CMAKE_CURRENT_BINARY_DIR})
set_number_of_frequencies(${CMAKE_CURRENT_BINARY_DIR} 10)

get_filename_component(TEST_NAME ${CMAKE_CURRENT_SOURCE_DIR} NAME)

add_test(NAME ${TEST_NAME}_preProc COMMAND preProc .)
add_test(NAME ${TEST_NAME}_solver COMMAND solver .)
add_test(NAME ${TEST_NAME}_postProc COMMAND postProc .)

set_tests_properties(${TEST_NAME}_preProc PROPERTIES LABELS "NEMOH1;PREPROC")
set_tests_properties(${TEST_NAME}_solver PROPERTIES DEPENDS ${TEST_NAME}_preProc LABELS "NEMOH1;SOLVER")
set_tests_properties(${TEST_NAME}_postProc PROPERTIES DEPENDS ${TEST_NAME}_solver LABELS "NEMOH1;POSTPROC")