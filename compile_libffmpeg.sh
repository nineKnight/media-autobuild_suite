#!/bin/bash

[[ ! -e libavcodec.a \
|| ! -e libavdevice.a \
|| ! -e libavfilter.a \
|| ! -e libavformat.a \
|| ! -e libavutil.a \
|| ! -e libpostproc.a \
|| ! -e libswscale.a \
|| ! -e libswresample.a ]] \
&& echo Found no libavcodec.a or libavdevice.a or libavfilter.a or libavformat.a or libavutil.a or libpostproc.a or libswresample.a or libswscale.a \
&& exit 1

# Extract .a to get .o
ar -x libavcodec.a && ar -x libavdevice.a && ar -x libavfilter.a && ar -x libavformat.a && ar -x libavutil.a && ar -x libpostproc.a && ar -x libswscale.a && ar -x libswresample.a

# Compile a united ffmpeg library
CPPFLAGS='-D_FORTIFY_SOURCE=0 -D__USE_MINGW_ANSI_STDIO=1' \
CFLAGS='-mthreads -mtune=generic -O2 -pipe' \
CXXFLAGS='-mthreads -mtune=generic -O2 -pipe' \
LDFLAGS='-pipe -static-libgcc -static-libstdc++' \
gcc -shared -o libffmpeg.dll *.o `pkg-config --cflags --libs --static libavcodec libavdevice libavfilter libavformat libavutil libpostproc libswresample libswscale` -Wl,--export-all-symbols,--output-def,libffmpeg.def \
&& \rm -f ./*.o