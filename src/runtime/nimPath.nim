import std/os

# Allocate memory on the C heap so the string survives the function return
# I think this might be a problem for the echo function

proc jjoinPath(p: cstring, o: cstring): cstring {.exportc, cdecl.} =
    let pathStr = joinPath($p, $o)
    result = cast[cstring](alloc(pathStr.len + 1))
    copyMem(result, addr(pathStr[0]), pathStr.len + 1)

proc pparentDir(p: cstring): cstring {.exportc, cdecl.} =
    let parentPath = parentDir($p)
    result = cast[cstring](alloc(parentPath.len + 1))
    copyMem(result, addr(parentPath[0]), parentPath.len + 1)

proc bbasename(p: cstring): cstring {.exportc, cdecl.} =
    let tail = splitPath($p).tail
    result = cast[cstring](alloc(tail.len + 1))
    copyMem(result, addr(tail[0]), tail.len + 1)

proc sstem(p: cstring): cstring {.exportc, cdecl.} =
    let name = splitFile($p).name
    result = cast[cstring](alloc(name.len + 1))
    copyMem(result, addr(name[0]), name.len + 1)

proc eext(p: cstring): cstring {.exportc, cdecl.} =
    let ext = splitFile($p).ext
    result = cast[cstring](alloc(ext.len + 1))
    copyMem(result, addr(ext[0]), ext.len + 1)