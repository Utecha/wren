option(
  BUILD_EXAMPLES
  "Build the examples."
  ON
)
message(STATUS "[ Examples ] Build Examples: ${BUILD_EXAMPLES}")

option(
  WREN_NAN_TAGGING
  "Enable the NaN tagging optimization."
  ON
)
message(STATUS "[ Option ] NaN Tagging: ${WREN_NAN_TAGGING}")

option(
  WREN_COMPUTED_GOTO
  "Enable the use of computed gotos for the interpreter loop."
  ON
)
message(STATUS "[ Option ] Computed Goto: ${WREN_COMPUTED_GOTO}")

option(
  WREN_OPT_META
  "Includes the optional 'meta' module."
  ON
)
message(STATUS "[ Option ] Optional 'Meta' Module: ${WREN_OPT_META}")

option(
  WREN_OPT_RANDOM
  "Includes the optional 'random' module."
  ON
)
message(STATUS "[ Option ] Optional 'Random' Module: ${WREN_OPT_RANDOM}")

# NOTE: The following only apply to debug builds!

option(
  WREN_DEBUG_GC_STRESS
  "Runs the garbage collector after every allocation to ensure memory is always \
  correctly reachable."
  OFF
)
message(STATUS "[ Debug Flag ] Stress GC: ${WREN_DEBUG_GC_STRESS}")

option(
  WREN_DEBUG_TRACE_MEMORY
  "Logs memory operations as they occur."
  OFF
)
message(STATUS "[ Debug Flag ] Memory Trace: ${WREN_DEBUG_TRACE_MEMORY}")

option(
  WREN_DEBUG_TRACE_GC
  "Logs garbage collections as they occur."
  OFF
)
message(STATUS "[ Debug Flag ] GC Trace: ${WREN_DEBUG_TRACE_GC}")

option(
  WREN_DEBUG_DUMP_COMPILED_CODE
  "Prints the compiled bytecode of each function."
  OFF
)
message(STATUS "[ Debug Flag ] Dump Compiled Code: ${WREN_DEBUG_DUMP_COMPILED_CODE}")

option(
  WREN_DEBUG_TRACE_INSTRUCTIONS
  "Traces each instruction as it executes, meaning it dumps the current \
  instruction and a visual of the state of the VM's stack as each \
  instruction executes."
  OFF
)
message(STATUS "[ Debug Flag ] Trace Instructions: ${WREN_DEBUG_TRACE_INSTRUCTIONS}")
