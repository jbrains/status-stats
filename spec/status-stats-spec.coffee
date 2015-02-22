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

  xit "only enables the toggle command once the package is active", ->
    # ASSUME that the package is not activated by default
    expect(atom.packages.isPackageActive("status-stats")).toBe(false)

    spyOn(entryPoint, "toggle")

    atom.commands.dispatch(workspaceElement, "status-stats:toggle")
    expect(entryPoint.toggle).not.toHaveBeenCalled

    waitsForPromise ->
      atom.packages.activatePackage("status-stats")

    atom.commands.dispatch(workspaceElement, "status-stats:toggle")
    expect(entryPoint.toggle).toHaveBeenCalled
