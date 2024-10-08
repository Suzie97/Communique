project('com.github.suzie97.communique', 'vala', 'c')

# Constants (paths)
VAPI_DIR               = join_paths(meson.current_source_dir(), 'vapi')
PO_DIR                 = join_paths(meson.current_source_dir(), 'po')
SHARE_DIR              = join_paths(get_option('prefix'),
                                    get_option('datadir'))
DATA_DIR               = join_paths(get_option('prefix'),
                                    get_option('datadir'),
                                    meson.project_name())
LOCALE_DIR             = join_paths(get_option('prefix'),
                                    get_option('localedir'))
PKGLIBDIR              = join_paths(get_option('prefix'),
                                    get_option('libdir'),
                                    meson.project_name())
SHARE_PLUGINS_DIR      = join_paths(PKGLIBDIR, 'pluginsShare')
BACKEND_PLUGINS_DIR    = join_paths(PKGLIBDIR, 'plugins')

# Define the vapi dir
add_project_arguments(['--vapidir=' + VAPI_DIR], language: 'vala')

# Modules
gnome = import('gnome')
i18n = import('i18n')

# Compilers
vala_compiler = meson.get_compiler('vala')
c_compiler = meson.get_compiler('c')

# Other tools
afl_fuzz = find_program('afl-fuzz', required:false) # american fuzzy lop
gtester = find_program('gtester', required:false)

# Dependencies
gdk_pixbuf          = dependency('gdk-pixbuf-2.0')
gee                 = dependency('gee-0.8')
glib                = dependency('glib-2.0')
goa                 = dependency('goa-1.0')
gstreamer           = dependency('gstreamer-1.0')
gstreamer_pbutils   = dependency('gstreamer-pbutils-1.0')
gtk                 = dependency('gtk+-3.0', version: '>=3.22')
gumbo               = dependency('gumbo')
json_glib           = dependency('json-glib-1.0')
libcurl             = c_compiler.find_library('curl')
libnotify           = dependency('libnotify')
libpeas             = dependency('libpeas-1.0')
libsecret           = dependency('libsecret-1')
libsoup             = dependency('libsoup-2.4')
libxml              = dependency('libxml-2.0')
linux               = vala_compiler.find_library('linux')
posix               = vala_compiler.find_library('posix')
rest                = dependency('rest-0.7')
sqlite3             = dependency('sqlite3')
webkit2gtk          = dependency('webkit2gtk-4.0')
webkitextension     = dependency('webkit2gtk-web-extension-4.0')
libunity            = dependency('unity', required: false)
libgranite          = dependency('granite')
libhandy            = dependency('libhandy-1')

# Configuration
conf = configuration_data()
conf.set('GETTEXT_PACKAGE', meson.project_name())
conf.set('PREFIX', get_option('prefix'))
conf.set('VERSION', meson.project_version())
conf.set('LOCALE_DIR', LOCALE_DIR)
conf.set('PKGDATADIR', DATA_DIR)
conf.set('PKGLIBDIR', PKGLIBDIR)

constants = vcs_tag(
	input : configure_file(
			input: 'src/Constants.vala.in',
			output: '@basename@',
			configuration: conf),
	output : 'Constants.vala',
	command : ['git', 'show-ref', '-s', 'refs/heads/master'],
	replace_string: '#GIT_SHA1#')



# Build libraries
subdir('libraries/libgd')
subdir('libraries/libgtkimageview')
subdir('libraries/libIvy')
subdir('libraries/htmlclean')
subdir('libraries/WebExtension')
subdir('libraries/libnxml')
subdir('libraries/libmrss')
subdir('libraries/rss-glib')
subdir('data')


# VAPI's
libgd_vapi          = vala_compiler.find_library('gd-1.0', dirs: VAPI_DIR)
gtkimageview_vapi   = vala_compiler.find_library('gtkimageview', dirs: VAPI_DIR)
htmlclean_vapi      = vala_compiler.find_library('htmlclean', dirs: VAPI_DIR)
rss_glib_vapi       = vala_compiler.find_library('rss-glib-1.0', dirs: VAPI_DIR)

# htmlclean
htmlclean  = declare_dependency(
  link_with: htmlclean_lib,
  include_directories: htmlclean_inc,
  dependencies: htmlclean_vapi
)

# libgd
libgd = declare_dependency(
  link_with: gd_lib,
  include_directories: gd_inc,
  dependencies: [libgd_vapi]
)

# GtkImageView
libgtkimageview = declare_dependency(
  link_with: gtkimageview_lib,
  include_directories: gtkimageview_inc,
  dependencies: [
    gtkimageview_vapi,
    c_compiler.find_library('m', required: false)
  ]
)

# libIvy
libivy = declare_dependency(
  link_with: ivy_lib,
  include_directories: ivy_inc
)

# lib_rss_glib
lib_rss_glib = declare_dependency(
  link_with: rss_glib_lib,
  include_directories: rss_glib_inc,
  dependencies: rss_glib_vapi
)

vala_sources = [
  constants,
  'src/FavIcon.vala',
  'src/FeedReader.vala',
  'src/Password.vala',
  'src/SQLite.vala',
  'src/Widgets/AddFeedDialog.vala',
  'src/Widgets/AddFolderDialog.vala',
  'src/Widgets/ArticleRow.vala',
  'src/Widgets/ArticleView.vala',
  'src/Widgets/ArticleViewLoadProgress.vala',
  'src/Widgets/ArticleViewUrlOverlay.vala',
  'src/Widgets/BackendInfoPopover.vala',
  'src/Widgets/CategorieRow.vala',
  'src/Widgets/ColorCircle.vala',
  'src/Widgets/ColorPopover.vala',
  'src/Widgets/ColumnView.vala',
  'src/Widgets/ColumnViewHeader.vala',
  'src/Widgets/FeedList.vala',
  'src/Widgets/FeedListFooter.vala',
  'src/Widgets/FeedRow.vala',
  'src/Widgets/FullscreenButton.vala',
  'src/Widgets/FullscreenHeader.vala',
  'src/Widgets/HoverButton.vala',
  'src/Widgets/ImagePopup.vala',
  'src/Widgets/InAppNotification.vala',
  'src/Widgets/InfoBar.vala',
  'src/Widgets/LoginPage.vala',
  'src/Widgets/LoginRow.vala',
  'src/Widgets/MainWindow.vala',
  'src/Widgets/MediaPlayer.vala',
  'src/Widgets/MediaRow.vala',
  'src/Widgets/ModeButton.vala',
  'src/Widgets/RemovePopover.vala',
  'src/Widgets/ResetPage.vala',
  'src/Widgets/ServiceSettingsPopover.vala',
  'src/Widgets/ShareRow.vala',
  'src/Widgets/Shortcuts.vala',
  'src/Widgets/ServiceInfo.vala',
  'src/Widgets/Setting.vala',
  'src/Widgets/SettingsDialog.vala',
  'src/Widgets/SharePopover.vala',
  'src/Widgets/SimpleHeader.vala',
  'src/Widgets/SpringCleanPage.vala',
  'src/Widgets/TagRow.vala',
  'src/Widgets/TagPopover.vala',
  'src/Widgets/TagPopoverRow.vala',
  'src/Widgets/UpdateButton.vala',
  'src/Widgets/WebLoginPage.vala',
  'src/Widgets/ArticleList/ArticleList.vala',
  'src/Widgets/ArticleList/ArticleListBox.vala',
  'src/Widgets/ArticleList/ArticleListEmptyLabel.vala',
  'src/Widgets/ArticleList/ArticleListScroll.vala',
  'src/Share/share.vala',
  'src/Share/ServiceSetup.vala',
  'src/Share/ShareAccountInterface.vala',
  'src/Logger.vala',
  'src/Enums.vala',
  'src/DataBaseReadOnly.vala',
  'src/ListUtils.vala',
  'src/Rfc822.vala',
  'src/Settings.vala',
  'src/StringUtils.vala',
  'src/Structs.vala',
  'src/Utils.vala',
  'src/QueryBuilder.vala',
  'src/ContentGrabber/grabberUtils.vala',
  'src/ContentGrabber/stringPair.vala',
  'src/Model/Feed.vala',
  'src/Model/Category.vala',
  'src/Model/Enclosure.vala',
  'src/Model/Article.vala',
  'src/Model/Tag.vala',
  'src/Model/CachedAction.vala',
  'src/Model/InterfaceState.vala',
  'src/Model/ShareAccount.vala',
  'src/ActionCache.vala',
  'src/Backend/Backend.vala',
  'src/DataBaseWriteAccess.vala',
  'src/Notification.vala',
  'src/CachedActionManager.vala',
  'src/Backend/FeedServer.vala',
  'src/Backend/FeedServerInterface.vala',
  'src/Backend/OPMLparser.vala',
  'src/ContentGrabber/grabberConfig.vala',
  'src/ContentGrabber/grabber.vala'
]


c_args = [
  '-g',
  '-w',
  '-rdynamic',
  '-Wno-deprecated-declarations',
  '-DVERSION="' + meson.project_version() + '"',
  '-DGETTEXT_PACKAGE="'+ meson.project_name() +'"',
  '-DGNOMELOCALEDIR="' + LOCALE_DIR + '"',
  '-DGOA_API_IS_SUBJECT_TO_CHANGE'
]

vala_args = [
  '--enable-experimental',
  '--target-glib','2.52',
  '--enable-deprecated'
]

communique_deps = [
    glib,
    gtk,
    json_glib,
    libsoup,
    sqlite3,
    gee,
    libsecret,
    rest,
    webkit2gtk,
    gstreamer,
    gstreamer_pbutils,
    libpeas,
    libxml,
    goa,
    posix,
    libivy,
    libgtkimageview,
    htmlclean,
    libgd,
    libgranite,
    libhandy
  ]


if libunity.found()
	message('libUnity support ON')
	communique_deps  += [ libunity ]
	vala_args += ['-D', 'LIBUNITY']
else
	message('libUnity support OFF')
endif

# The shared lib for plugins
communique_lib = shared_library(
  'FeedReader',
  vala_sources,
  c_args: c_args,
  vala_args: vala_args,
  vala_header: 'FeedReader.h',
  vala_vapi: 'FeedReader.vapi',
  dependencies: communique_deps,
  install: true
)

c_args = c_args + ['-include','FeedReader.h',]

# Build plugins and data files
subdir('plugins')
subdir('schemas')
subdir('po')

# Create an executable file
executable(
  'com.github.suzie97.communique',
  UI_RESOURCES + ['src/FeedReaderMain.vala'],
  c_args: c_args,
  vala_args: vala_args,
  link_with: [
    communique_lib
  ],
  dependencies: communique_deps,
  install: true
)

# Post install script
meson.add_install_script('build-aux/meson_post_install.py')

# tests
tests = [
  'QueryBuilder',
  'StringUtils'
]

foreach test_name : tests
  test_target = executable(
    'test_' + test_name.to_lower(),
    [
      'src/Test' + test_name + '.vala'
    ],
    c_args: c_args,
    # The tests intentionally don't catch exceptions
    vala_args: vala_args + ['--disable-warnings'],
    dependencies: communique_deps,
    link_with: [
      communique_lib
    ]
  )

  if gtester.found()
      test(test_name, gtester, args:['-k', '-o', meson.build_root() + '/' + test_name.to_lower() + '.gtester.log', test_target])
  else
      test(test_name, test_target)
  endif
endforeach
