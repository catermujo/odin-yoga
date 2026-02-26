# Odin bindings for Yoga

Bindings for [facebook/yoga](https://github.com/facebook/yoga).

Build scripts:

```bash
# Darwin/Linux shared
./build.sh

# Darwin/Linux static
./build_static.sh

# WebAssembly (Emscripten)
./build_wasm.sh

# Windows shared
./build.bat

# Windows static
./build_static.bat
```

Produced artifacts (shared):
- `libyoga.dylib` (Darwin)
- `libyoga.so` (Linux)
- `yoga.dll` + `yoga.lib` (Windows)

Produced artifacts (static):
- `libyoga.darwin.a`
- `libyoga.linux.a`
- `yoga_static.lib`
- `yoga.wasm.a`

`yoga.odin` link mode selection:
- Default: shared (`YOGA_LINK=shared`)
- Static: `-define:YOGA_LINK=static`

For wasm targets the binding uses `foreign _` declarations (same pattern as `vendor/ft`), so include `yoga.wasm.a` in your wasm link step.
