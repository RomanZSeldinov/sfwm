
include config.mk

SRC = sfwm.c
OBJ = ${SRC:.c=.o}

all: options sfwm

options:
	@echo sfwm build options:
	@echo "CFLAGS   = ${CFLAGS}"
	@echo "LDFLAGS  = ${LDFLAGS}"
	@echo "CC       = ${CC}"

.c.o:
	@echo CC $<
	@${CC} -c ${CFLAGS} $<

${OBJ}: config.h config.mk

config.h:
	@echo creating $@ from config.def.h
	@cp config.def.h $@

sfwm: ${OBJ}
	@echo CC -o $@
	@${CC} -o $@ ${OBJ} ${LDFLAGS}

clean:
	@echo cleaning
	@rm -f sfwm ${OBJ} sfwm-${VERSION}.tar.gz

dist: clean
	@echo creating dist tarball
	@mkdir -p sfwm
	@mkdir -p sfwm-${VERSION}
	@cp -R LICENSE Makefile README config.def.h config.mk \
		sfwm.1 ${SRC} sfwm-${VERSION}
	@tar -cf sfwm-${VERSION}.tar sfwm-${VERSION}
	@gzip sfwm-${VERSION}.tar
	@rm -rf sfwm-${VERSION}

install: all
	@echo installing executable file to ${DESTDIR}${PREFIX}/bin
	@mkdir -p ${DESTDIR}${PREFIX}/bin
	@cp -f sfwm ${DESTDIR}${PREFIX}/bin
	@chmod 755 ${DESTDIR}${PREFIX}/bin/sfwm
	@echo installing manual page to ${DESTDIR}${MANPREFIX}/man1
	@mkdir -p ${DESTDIR}${MANPREFIX}/man1
	@sed "s/VERSION/${VERSION}/g" < sfwm.1 > ${DESTDIR}${MANPREFIX}/man1/sfwm.1
	@chmod 644 ${DESTDIR}${MANPREFIX}/man1/sfwm.1

uninstall:
	@echo removing executable file from ${DESTDIR}${PREFIX}/bin
	@rm -f ${DESTDIR}${PREFIX}/bin/sfwm
	@echo removing manual page from ${DESTDIR}${MANPREFIX}/man1
	@rm -f ${DESTDIR}${MANPREFIX}/man1/sfwm.1

.PHONY: all options clean dist install uninstall
