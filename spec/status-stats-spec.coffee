# SMELL relative path in require; how to configure LOAD PATH for libraries?
entryPoint = require '../lib/status-stats'

describe "integrating this plugin with Atom", ->
  [workspaceElement] = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)

  # We need this because as of 2015-02-22, PackageManager.activatePackage(packageName)
  # does not always activate the named package. For example, when we configure
  # an activation command, then .activatePackage() will wait for that command
  # before activating the package.
  # See https://discuss.atom.io/t/can-you-force-the-activation-of-another-package/10885/18
  forceAtomToActivatePackage = (name) ->
    pack = atom.packages.loadPackage(name)
    expect(pack).toBeDefined()  # otherwise the package didn't load correctly
    pack.activationDeferred ?= resolve:(->), reject:(->)
    pack.activateNow()

  describe "activating the package", ->
    it "does not handle commands when it has not yet been activated", ->
      spyOn(entryPoint, "toggle")

      # ASSUME that the package is not activated by default
      expect(atom.packages.isPackageActive("status-stats")).toBe(false)

      atom.commands.dispatch(workspaceElement, "status-stats:toggle")
      expect(entryPoint.toggle).not.toHaveBeenCalled()

    it "handles commands once activated", ->
      spyOn(entryPoint, "toggle")

      # activate directly, rather than simulate the activation command
      forceAtomToActivatePackage("status-stats")

      atom.commands.dispatch(workspaceElement, "status-stats:toggle")
      expect(entryPoint.toggle).toHaveBeenCalled()

    # I'm not actually certain that this spec's expectation is correct.
    # Atom appears to behave this way, but I might have written the spec
    # incorrectly.
    it "Atom disables commands when the package is deactivated, even if the package doesn't disable them", ->
      spyOn(entryPoint, "toggle")

      # activate directly, rather than simulate the activation command
      forceAtomToActivatePackage("status-stats")
      atom.packages.deactivatePackage("status-stats")

      atom.commands.dispatch(workspaceElement, "status-stats:toggle")
      expect(entryPoint.toggle).not.toHaveBeenCalled()

    it "does not activate until someone tries to toggle the status", ->
      # ASSUME that the package is not activated by default
      expect(atom.packages.isPackageActive("status-stats")).toBe(false)

      # I've configured the corresponding activation command in package.json
      atom.commands.dispatch(workspaceElement, "status-stats:toggle")
      expect(atom.packages.isPackageActive("status-stats")).toBe(true)
