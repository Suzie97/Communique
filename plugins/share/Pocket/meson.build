pocket_resources = gnome.compile_resources(
  'pocket_res',
  'pocket.gresource.xml'
)

shared_library(
  'pocket',
  [
    'PocketAPI.vala',
    'PocketSetup.vala'
  ],
  pocket_resources,
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
    webkit2gtk,
    libxml,
    rest,
    json_glib,
    goa,
    libhandy
  ],
  link_with: [
    communique_lib
  ],
  install: true,
  install_dir: SHARE_PLUGINS_DIR,
  include_directories: include_directories('../../..')
)

install_data(
  [
    'com.github.suzie97.communique.share.pocket.gschema.xml'
  ],
  install_dir: join_paths(SHARE_DIR, 'glib-2.0/schemas')
)

install_data(
  [
    'pocket.plugin'
  ],
  install_dir: SHARE_PLUGINS_DIR
)
