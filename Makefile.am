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
