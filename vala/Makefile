TARGET := canary
SRCS   := src/*.vala

${TARGET}: ${SRCS}
	uncrustify -c uncrustify.vala.cfg --replace --no-backup ${SRCS}
	valac --pkg=gio-2.0 --pkg=libsoup-2.4 ${SRCS}

watch:
	while true; do inotifywait -r src -e MODIFY; make; done
