#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ([2.65])
AC_INIT([libplurk], [0.1], [david@wu-man.com])

AM_MAINTAINER_MODE([enable])
AM_INIT_AUTOMAKE([-Wall -Werror foreign])
AC_PROG_LIBTOOL
AC_CONFIG_MACRO_DIR([m4])

# Checks for programs.
AC_PROG_CC
AM_PROG_VALAC([0.8.0])

# Checks for libraries.
AM_PATH_GLIB_2_0([2.24.0], [
                   PLURK_CFLAGS="$PLURK_CFLAGS $GLIB_CFLAGS"
                   PLURK_LIBS="$PLURK_LIBS $GLIB_LIBS"
                  ], [AC_MSG_ERROR([$PACKAGE_NAME depends on glib-2.24.0])], [gobject])
PKG_CHECK_MODULES([SOUP], [libsoup-2.4], [
                   PLURK_CFLAGS="$PLURK_CFLAGS $SOUP_CFLAGS"
                   PLURK_LIBS="$PLURK_LIBS $SOUP_LIBS"
                   ], [AC_MSG_ERROR([$PACKAGE_NAME depends on libsoup-2.4])])
PKG_CHECK_MODULES([JSON], [json-glib-1.0], [
                   PLURK_CFLAGS="$PLURK_CFLAGS $JSON_CFLAGS"
                   PLURK_LIBS="$PLURK_LIBS $JSON_LIBS"
                   ], [AC_MSG_ERROR([$PACKAGE_NAME depends on json-glib-1.0])])
VALA_DEPS="libsoup-2.4 json-glib-1.0"
VALA_FLAGS="--pkg libsoup-2.4 --pkg json-glib-1.0"

# Checks for header files.

# Checks for typedefs, structures, and compiler characteristics.

# Checks for library functions.

AC_SUBST(PLURK_LIBS)
AC_SUBST(PLURK_CFLAGS)
AC_SUBST(VALA_FLAGS)
AC_SUBST(VALA_DEPS)

AC_CONFIG_FILES([
                 Makefile
                 plurk.pc
                 plurk.deps
                 ])
AC_OUTPUT
