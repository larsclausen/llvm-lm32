add_llvm_library(LLVMObject
  Archive.cpp
  Binary.cpp
  COFFObjectFile.cpp
  ELFObjectFile.cpp
  Error.cpp
  MachOObject.cpp
  MachOObjectFile.cpp
  Object.cpp
  ObjectFile.cpp
  )

add_llvm_library_dependencies(LLVMObject
  LLVMCore
  LLVMSupport
  )
