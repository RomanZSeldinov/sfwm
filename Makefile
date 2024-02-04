
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
	@rm -f stfwm ${OBJ} stfwm-${VERSION}.tar.gz

dist: clean
	@echo creating dist tarball
	@mkdir -p stfwm
	@mkdir -p stfwm-${VERSION}
	@cp -R LICENSE Makefile README config.def.h config.mk \
		stfwm.1 ${SRC} stfwm-${VERSION}
	@tar -cf stfwm-${VERSION}.tar stfwm-${VERSION}
	@gzip stfwm-${VERSION}.tar
	@rm -rf stfwm-${VERSION}

install: all
	@echo installing executable file to ${DESTDIR}${PREFIX}/bin
	@mkdir -p ${DESTDIR}${PREFIX}/bin
	@cp -f sfwm ${DESTDIR}${PREFIX}/bin
	@chmod 755 ${DESTDIR}${PREFIX}/bin/sfwm
	@echo installing manual page to ${DESTDIR}${MANPREFIX}/man1
	@mkdir -p ${DESTDIR}${MANPREFIX}/man1
	@sed "s/VERSION/${VERSION}/g" < stfwm.1 > ${DESTDIR}${MANPREFIX}/man1/stfwm.1
	@chmod 644 ${DESTDIR}${MANPREFIX}/man1/stfwm.1

uninstall:
	@echo removing executable file from ${DESTDIR}${PREFIX}/bin
	@rm -f ${DESTDIR}${PREFIX}/bin/stfwm
	@echo removing manual page from ${DESTDIR}${MANPREFIX}/man1
	@rm -f ${DESTDIR}${MANPREFIX}/man1/sfwm.1

.PHONY: all options clean dist install uninstall
