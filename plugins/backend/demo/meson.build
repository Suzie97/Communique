demo_resources = gnome.compile_resources(
  'demo_res',
  'demo.gresource.xml'
)

shared_library(
  'demo',
  [
    'demoInterface.vala'
  ],
  demo_resources,
  c_args: c_args,
  vala_args: vala_args,
  dependencies: [
    libpeas,
    gtk,
    gee,
    libsecret,
    sqlite3,
    libsoup,
    libxml,
    json_glib,
    feedreader,
    libhandy
  ],
  install: true,
  install_dir: BACKEND_PLUGINS_DIR
)

install_data(
  [
    'com.github.suzie97.communique.demo.gschema.xml'
  ],
  install_dir: join_paths(SHARE_DIR, 'glib-2.0/schemas')
)

install_data(
  [
    'demo.plugin'
  ],
  install_dir: BACKEND_PLUGINS_DIR
)
