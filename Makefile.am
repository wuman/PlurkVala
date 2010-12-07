ACLOCAL_AMFLAGS = -I m4

lib_LTLIBRARIES = libplurk.la

libplurk_la_SOURCES = \
                      plurk-api.vala \
                      plurk-client.vala \
                      plurk-error.vala \
                      plurk-plurk-list.vala \
                      plurk-plurk.vala \
                      plurk-profile.vala \
                      plurk-response-list.vala \
                      plurk-response.vala \
                      plurk-user-list.vala \
                      plurk-user.vala
libplurk_la_CPPFLAGS = @PLURK_CFLAGS@
libplurk_la_LIBADD = @PLURK_LIBS@
libplurk_la_VALAFLAGS = @VALA_FLAGS@

pkgconfig_DATA = plurk.pc
pkgconfigdir = @libdir@/pkgconfig

vapi_DATA = \
            plurk.deps \
            plurk.vapi
vapidir = @datadir@/vala/vapi

dist-hook: plurk.h

distcheck-hook: plurk.h

plurk.deps: $(libplurk_la_SOURCES)

plurk.vapi: $(libplurk_la_SOURCES) plurk.h

install-data-hook: plurk.h
	test -d $(DESTDIR)$(includedir) || mkdir -p $(DESTDIR)$(includedir)
	cp $(srcdir)/plurk.h $(DESTDIR)$(includedir)
	:> $(DESTDIR)$(vapidir)/plurk.deps
	for i in @VALA_DEPS@; do echo $$i >> $(DESTDIR)$(vapidir)/plurk.deps; done

uninstall-local:
	rm -f $(DESTDIR)$(includedir)/plurk.h

plurk.h: $(libplurk_la_SOURCES)
	valac $(VALA_FLAGS) $(srcdir)/*.vala -C -H $(srcdir)/plurk.h --library plurk

EXTRA_DIST = plurk.h plurk.deps.in plurk.pc.in $(vapi_DATA)
