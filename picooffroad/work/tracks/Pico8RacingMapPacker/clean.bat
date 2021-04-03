rem bin
del bin\*.pdb
del bin\*.iobj
del bin\*.ipdb
del bin\*.ilk
del bin\Pico8RacingMapPacker_d.exe
del bin\Pico8RacingMapPacker_x64_d.exe

rem vs2013
rmdir /S /Q project\vs2013\debug
rmdir /S /Q project\vs2013\release
rmdir /S /Q project\vs2013\ipch
rmdir /S /Q project\vs2013\x64
del project\vs2013\*.ncb
del project\vs2013\*.aps
del project\vs2013\*.sdf
attrib -H project\vs2013\Pico8RacingMapPacker.v12.suo
del project\vs2013\Pico8RacingMapPacker.v12.suo

rem vs2015
rmdir /S /Q project\vs2015\debug
rmdir /S /Q project\vs2015\release
rmdir /S /Q project\vs2015\ipch
rmdir /S /Q project\vs2015\x64
rmdir /S /Q project\vs2015\.vs
del project\vs2015\*.ncb
del project\vs2015\*.aps
del project\vs2015\*.sdf
del project\vs2015\*.db
attrib -H project\vs2015\Pico8RacingMapPacker.v12.suo
del project\vs2015\Pico8RacingMapPacker.v12.suo
