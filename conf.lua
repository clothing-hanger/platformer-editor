local Project = require("Project")

function love.conf(t)
    t.window.title = "Love2D Template"
    t.console = true

    t.window.width = Project.WindowWidth
    t.window.height = Project.WindowHeight

    t.window.resizable = Project.WindowResizable
    t.window.vsync = Project.VSync

    t.version = Project.Version

    t.identity = Project.Identity
end
