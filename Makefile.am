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
libplurk_la_VALAFLAGS = @VALA_PACKAGES@

dist-hook: plurk.h

distcheck-hook: plurk.h

install-data-hook: plurk.h
	test -d $(DESTDIR)$(includedir) || mkdir -p $(DESTDIR)$(includedir)
	cp $(srcdir)/plurk.h $(DESTDIR)$(includedir)

uninstall-local:
	rm -f $(DESTDIR)$(includedir)/plurk.h

plurk.h:
	valac $(VALA_PACKAGES) $(srcdir)/*.vala -C -H $(srcdir)/plurk.h

EXTRA_DIST = plurk.h
