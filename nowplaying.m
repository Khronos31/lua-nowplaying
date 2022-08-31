#include <lua.h>
#include <lauxlib.h>
#include <NowPlayingInfo.h>
#import <Foundation/Foundation.h>

static int app(lua_State *L) {
  NowPlayingInfo *np = [NowPlayingInfo sharedInstance];
  NSString *npApp = [np nowPlayingApplication][@"displayName"];
  const char *app = npApp.UTF8String;
  if (app[0] != '\0') {
    lua_pushstring(L, app);
  } else {
    lua_pushnil(L);
  }
  return 1;
}

static int title(lua_State *L) {
  NowPlayingInfo *np = [NowPlayingInfo sharedInstance];
  const char *title = np.title.UTF8String;
  if (title[0] != '\0') {
    lua_pushstring(L, title);
  } else {
    lua_pushnil(L);
  }
  return 1;
}

static int artist(lua_State *L) {
  NowPlayingInfo *np = [NowPlayingInfo sharedInstance];
  const char *artist = np.artist.UTF8String;
  if (artist[0] != '\0') {
    lua_pushstring(L, artist);
  } else {
    lua_pushnil(L);
  }
  return 1;
}

static int album(lua_State *L) {
  NowPlayingInfo *np = [NowPlayingInfo sharedInstance];
  const char *album = np.album.UTF8String;
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
