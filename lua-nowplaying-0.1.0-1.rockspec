rockspec_format = "3.0"
package = "lua-nowplaying"
version = "0.1.0-1"
source = {
   url = "git+https://github.com/Khronos31/lua-nowplaying",
   tag = "v0.1.0"
}
description = {
   homepage = "https://github.com/Khronos31/lua-nowplaying",
   license = "MIT"
}
dependencies = {
   "lua >= 5.3"
}
build_dependencies = {
   "luarocks-build-extended"
}
build = {
   type = "extended",
   modules = {
      nowplaying = {
         variables = {
            CFLAG_EXTRAS = {"-fobjc-arc"},
            LIBFLAG_EXTRAS = {"-framework", "Foundation"}
         },
         sources = "nowplaying.m",
         libraries = "nowplaying"
      }
   }
}
