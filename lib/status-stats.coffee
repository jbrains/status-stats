module.exports =
  activate: (state) ->
    # The command name needs to match status-stats.cson
    # atom.commands.add("atom-workspace", "status-stats:toggle", => @toggle())
    console.log("activating plugin with state #{state}")

  deactivate: ->
    console.log("deactivating plugin")

  toggle: ->
    console.log("toggle")
