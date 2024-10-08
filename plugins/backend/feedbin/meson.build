feedbin_resources = gnome.compile_resources(
  'feedbin_res',
  'feedbin.gresource.xml'
)

static_lib = static_library(
  'feedbin_static',
  [
    'feedbinAPI.vala',
    'feedbinUtils.vala'
  ],
  c_args: c_args,
  vala_args: vala_args,
  dependencies: [
    libpeas,
    libgd,
    gtk,
    gee,
    libsecret,
    sqlite3,
    libsoup,
    libxml,
    json_glib,
    webkit2gtk,
    libhandy
  ],
  link_with: [
    communique_lib
  ],
  include_directories: include_directories('../../..')
)

plugin_lib = shared_library(
  'feedbin',
  [
    'feedbinInterface.vala',
  ],
  feedbin_resources,
  c_args: c_args,
  vala_args: vala_args,
  dependencies: [
    libpeas,
    libgd,
    gtk,
    gee,
    libsecret,
    sqlite3,
    libsoup,
    libxml,
    json_glib,
    webkit2gtk,
    libhandy
  ],
  link_with: [
    communique_lib,
    static_lib
  ],
  install: true,
  install_dir: BACKEND_PLUGINS_DIR,
  include_directories: include_directories('../../..')
)

install_data(
  [
    'com.github.suzie97.communique.feedbin.gschema.xml'
  ],
  install_dir: join_paths(SHARE_DIR, 'glib-2.0/schemas')
)

install_data(
  [
    'feedbin.plugin'
  ],
  install_dir: BACKEND_PLUGINS_DIR
)

plugin_test = executable(
  'test_feedbin',
  [
    'TestFeedbin.vala'
  ],
  c_args: c_args,
  # The tests intentionally don't catch exceptions
  vala_args: vala_args + ['--disable-warnings'],
  dependencies: [
    libpeas,
    libgd,
    gtk,
    gee,
    libsecret,
    sqlite3,
    libsoup,
    libxml,
    json_glib,
    webkit2gtk,
    libhandy
  ],
  link_with: [
    communique_lib,
    static_lib
  ],
  include_directories: include_directories('../../..')
)

if gtester.found()
    test('Feedbin plugin', gtester, args:['-k', '-o', meson.build_root() + '/feedbin.gtester.log', plugin_test])
else
    test('Feedbin plugin', plugin_test)
endif
