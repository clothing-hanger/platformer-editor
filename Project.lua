local Project = {}

-- Game base resolution
Project.GameWidth = 1280
Project.GameHeight = 720

-- Window base resolution
Project.WindowWidth = 1280
Project.WindowHeight = 720

-- love.conf configurations
Project.Title = "BBT Level Editor"
Project.Company = "notagori"
Project.CodeName = "BBTLE"
Project.Identity = Project.Company .. "-" .. Project.CodeName

Project.WindowResizable = true
Project.VSync = 0 -- 0 = off, 1 = on

Project.Version = "11.4.0"

return Project