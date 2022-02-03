#include <lua.h>
#include <lauxlib.h>
#include <NowPlayingInfo.h>

static int app(lua_State *L) {
  const char *app = nowPlayingApplication();
  if (app[0] != '\0') {
    lua_pushstring(L, app);
  } else {
    lua_pushnil(L);
  }
  return 1;
}

static int title(lua_State *L) {
  const char *title = nowPlayingTitle();
  if (title[0] != '\0') {
    lua_pushstring(L, title);
  } else {
    lua_pushnil(L);
  }
  return 1;
}

static int artist(lua_State *L) {
  const char *artist = nowPlayingArtist();
  if (artist[0] != '\0') {
    lua_pushstring(L, artist);
  } else {
    lua_pushnil(L);
  }
  return 1;
}

static int album(lua_State *L) {
  const char *album = nowPlayingAlbum();
  if (album[0] != '\0') {
    lua_pushstring(L, album);
  } else {
    lua_pushnil(L);
  }
  return 1;
}

static luaL_Reg const nowplayinglib[] = {
  { "app", app },
  { "title", title },
  { "artist", artist },
  { "album", album },
  { NULL, NULL }
};

#ifndef NOWPLAYING_API
#define NOWPLAYING_API
#endif

NOWPLAYING_API int luaopen_nowplaying(lua_State *L) {
  luaL_newlib(L, nowplayinglib);
  return 1;
}
