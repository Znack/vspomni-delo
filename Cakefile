fs = require 'fs'
{print} = require 'util'
{spawn, exec} = require 'child_process'

option "-b", '--browserified [BROWSERIED]', 'which file should be browserified'

try
  which = require('which').sync
catch err
  if process.platform.match(/^win/)?
    console.log 'WARNING: the which module is required for windows\ntry: npm install which'
  which = null

# ## *launch*
#
# **given** string as a cmd
# **and** optional array and option flags
# **and** optional callback
# **then** spawn cmd with options
# **and** pipe to process stdout and stderr respectively
# **and** on child process exit emit callback if set and status is 0
launch = (cmd, options=[], callback) ->
  cmd = which(cmd) if which
  app = spawn cmd, options
  app.stdout.pipe(process.stdout)
  app.stderr.pipe(process.stderr)
  app.on 'exit', (status) ->
    if status is 0
      callback() if callback
    else
      process.exit(status);


task "compileclient", "Compile coffee files in /client directiory", (options)->
  options = ['-c', '-o', 'public/js/', 'client/']
  launch 'coffee', options


task "browserify", "Browserify special js files", (options)->
  switch options.browserified
    when 'background'
      source = 'public/js/extension/background/background.js'
      target = 'extensions/chrome/js/background.js'
    when 'popup'
      source = 'public/js/extension/popup/popup.js'
      target = 'extensions/chrome/js/popup.js'
    when 'contentScript'
      source = 'public/js/extension/contentScripts/initExtension.js'
      target = 'extensions/chrome/js/todoExtension.js'
    else
      throw new Error('Try browserify invalid configured file')
  options = [source, '-o', target]
  launch 'browserify', options

task "packeverything", "Compily and Browserify all files", (options)->
  invoke 'compileclient'
  options.browserified = 'background'
  invoke 'browserify'
  options.browserified = 'popup'
  invoke 'browserify'
  options.browserified = 'contentScript'
  invoke 'browserify'

