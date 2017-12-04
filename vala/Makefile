.PHONY := uncrustify
TARGET := canary
SRCS   := canary.vala


${TARGET}: ${SRCS}
	uncrustify -c uncrustify.vala.cfg --replace --no-backup ${SRCS}
	valac --pkg=gio-2.0 --pkg=libsoup-2.4 ${SRCS}

