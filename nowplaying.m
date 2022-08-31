#import <lua.h>
#import <lauxlib.h>
#import <NowPlayingInfo.h>
#import <Foundation/Foundation.h>

static void lua_pushnsarray(lua_State *, NSArray *);
static void lua_pushnsdict(lua_State *, NSDictionary *);

static void lua_pushnsarray(lua_State *L, NSArray *arr) {
  if (arr) {
    lua_newtable(L);
    [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
      lua_pushnumber(L, idx + 1);
      if ([obj isKindOfClass:NSString.class]) {
        NSString *str = obj;
        lua_pushstring(L, str.UTF8String);
      } else if ([obj isKindOfClass:NSNumber.class]) {
        NSNumber *num = obj;
        if ([NSStringFromClass(num.class) isEqualToString:@"__NSCFBoolean"]) {
          lua_pushboolean(L, num.boolValue);
        } else {
          if ([num.stringValue rangeOfString:@"."].length > 0) {
            lua_pushnumber(L, num.doubleValue);
          } else {
            lua_pushinteger(L, num.longLongValue);
          }
        }
      } else if ([obj isKindOfClass:NSData.class]) {
        NSData *data = obj;
        lua_pushlstring(L, data.bytes, data.length);
      } else if ([obj isKindOfClass:NSDate.class]) {
        NSDate *date = obj;
        lua_pushnumber(L, date.timeIntervalSince1970);
      } else if ([obj isKindOfClass:NSArray.class]) {
        lua_pushnsarray(L, obj);
      } else if ([obj isKindOfClass:NSDictionary.class]) {
        lua_pushnsdict(L, obj);
      }
      lua_settable(L, -3);
    }];
  } else {
    lua_pushnil(L);
  }
}

static void lua_pushnsdict(lua_State *L, NSDictionary *dict) {
  if (dict) {
    lua_newtable(L);
    [dict enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
      lua_pushstring(L, key.UTF8String);
      if ([obj isKindOfClass:NSString.class]) {
        NSString *str = obj;
        lua_pushstring(L, str.UTF8String);
      } else if ([obj isKindOfClass:NSNumber.class]) {
        NSNumber *num = obj;
        if ([NSStringFromClass(num.class) isEqualToString:@"__NSCFBoolean"]) {
          lua_pushboolean(L, num.boolValue);
        } else {
          if ([num.stringValue rangeOfString:@"."].length > 0) {
            lua_pushnumber(L, num.doubleValue);
          } else {
            lua_pushinteger(L, num.longLongValue);
          }
        }
      } else if ([obj isKindOfClass:NSData.class]) {
        NSData *data = obj;
        lua_pushlstring(L, data.bytes, data.length);
      } else if ([obj isKindOfClass:NSDate.class]) {
        NSDate *date = obj;
        lua_pushnumber(L, date.timeIntervalSince1970);
      } else if ([obj isKindOfClass:NSArray.class]) {
        lua_pushnsarray(L, obj);
      } else if ([obj isKindOfClass:NSDictionary.class]) {
        lua_pushnsdict(L, obj);
      }
      lua_settable(L, -3);
    }];
  } else {
    lua_pushnil(L);
  }
}

static int isplaying(lua_State *L) {
  lua_pushboolean(L, [NowPlayingInfo sharedInstance].isPlaying);
  return 1;
}

static int info(lua_State *L) {
  NSDictionary *npInfo = [NowPlayingInfo sharedInstance].nowPlayingInfo;
  if (npInfo) {
    lua_pushnsdict(L, npInfo);
  } else {
    lua_pushnil(L);
  }
  return 1;
}

static int app(lua_State *L) {
  NSDictionary *npApp = [NowPlayingInfo sharedInstance].nowPlayingApplication;
  if (npApp) {
    lua_pushnsdict(L, npApp);
  } else {
    lua_pushnil(L);
  }
  return 1;
}

static int title(lua_State *L) {
  NSString *title = [NowPlayingInfo sharedInstance].title;
  if (title) {
    lua_pushstring(L, title.UTF8String);
  } else {
    lua_pushnil(L);
  }
  return 1;
}

static int artist(lua_State *L) {
  NSString *artist = [NowPlayingInfo sharedInstance].artist;
  if (artist) {
    lua_pushstring(L, artist.UTF8String);
  } else {
    lua_pushnil(L);
  }
  return 1;
}

static int album(lua_State *L) {
  NSString *album = [NowPlayingInfo sharedInstance].album;
  if (album) {
    lua_pushstring(L, album.UTF8String);
  } else {
    lua_pushnil(L);
  }
  return 1;
}

static int artwork(lua_State *L) {
  NSData *artwork = [NowPlayingInfo sharedInstance].artwork;
  if (artwork) {
    lua_pushlstring(L, artwork.bytes, artwork.length);
  } else {
    lua_pushnil(L);
  }
  return 1;
}

static int artwork_type(lua_State *L) {
  NSString *artworkType = [NowPlayingInfo sharedInstance].artworkType;
  if (artworkType) {
    lua_pushstring(L, artworkType.UTF8String);
  } else {
    lua_pushnil(L);
  }
  return 1;
}

static luaL_Reg const nowplayinglib[] = {
  { "isplaying", isplaying },
  { "info", info },
  { "app", app },
  { "title", title },
  { "artist", artist },
  { "album", album },
  { "artwork", artwork },
  { "artwork_type", artwork_type },
  { NULL, NULL }
};

#ifndef NOWPLAYING_API
#define NOWPLAYING_API
#endif

NOWPLAYING_API int luaopen_nowplaying(lua_State *L) {
  luaL_newlib(L, nowplayinglib);
  return 1;
}
