supported_backend_plugins = [
  'bazqux',
  'feedbin',
  'feedhq',
  'fresh',
  'inoreader',
  'local',
  'owncloud',
  'ttrss'
]
backend_plugins = get_option('backend-plugins')

foreach backend_plugin: supported_backend_plugins
  if backend_plugins.contains(backend_plugin.to_lower())
    message('Backend Plugin: ' + backend_plugin + ' ON')
    subdir(backend_plugin)
  else
    message('Backend Plugin: ' + backend_plugin + ' OFF')
  endif
endforeach
