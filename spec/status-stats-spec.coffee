entryPoint = require '../lib/status-stats'

describe "integrating this plugin with Atom", ->
  [workspaceElement] = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)

  describe "activating the package", ->
    it "does not handle commands when it has not yet been activated", ->
      spyOn(entryPoint, "toggle")

      # ASSUME that the package is not activated by default
      expect(atom.packages.isPackageActive("status-stats")).toBe(false)

      atom.commands.dispatch(workspaceElement, "status-stats:toggle")
      expect(entryPoint.toggle).not.toHaveBeenCalled()

    it "handles commands once activated", ->
      spyOn(entryPoint, "toggle")

      atom.packages.activatePackage("status-stats")

      atom.commands.dispatch(workspaceElement, "status-stats:toggle")
      expect(entryPoint.toggle).toHaveBeenCalled()

    it "Atom disables commands when the package is deactivated, even if the package doesn't disable them", ->
      spyOn(entryPoint, "toggle")

      runs -> atom.packages.activatePackage("status-stats")
      runs -> atom.packages.deactivatePackage("status-stats")

      atom.commands.dispatch(workspaceElement, "status-stats:toggle")
      expect(entryPoint.toggle).not.toHaveBeenCalled()
