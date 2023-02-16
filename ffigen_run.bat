REM This script is used to run ffigen for all the bindings.
start /b flutter pub run ffigen --config plugin_bindings_ffigen.yaml
start /b flutter pub run ffigen --config magick_wand_bindings_ffigen.yaml