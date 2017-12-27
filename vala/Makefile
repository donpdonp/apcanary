TARGET := canary
SRCS   := src/*.vala

${TARGET}: ${SRCS}
	uncrustify -c uncrustify.vala.cfg --replace --no-backup ${SRCS}
	valac --output ${TARGET} --pkg gio-2.0 --pkg libsoup-2.4 --pkg gtk+-3.0 --pkg librsvg-2.0 \
	      --pkg json-glib-1.0 \
	      --pkg lua -X '-I/usr/include/lua5.3' -X '-llua5.3' ${SRCS}

watch:
	while true; do inotifywait -r src -e MODIFY; make; done
