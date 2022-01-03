require "../../../SoftwaresLibrairies"

class Target < ISM::Software

    def initialize
        super(  "./Softwares/Linux-API-Headers/5.13.12/Information.json",
                "linux-5.13.12")
    end
    
    def configure
        super
        Process.run("make", args: [Ism.settings.makeOptions, "mrproper"],
                            output: :inherit,
                            chdir:  Ism.settings.sourcesPath + "/" + 
                                    @information.versionName + "/" +
                                    @mainSourceDirectoryName)
    end
    
    def build
        super
        Process.run("make", args: [Ism.settings.makeOptions, "headers"],
                            output: :inherit,
                            chdir:  Ism.settings.sourcesPath + "/" + 
                                    @information.versionName + "/" +
                                    @mainSourceDirectoryName)
    end
    
    def install
        super
        Process.run("find", args: ["usr/include","-name", "'.*'", "-delete"],
                            output: :inherit,
                            chdir:  Ism.settings.sourcesPath + "/" + 
                                    @information.versionName + "/" +
                                    @mainSourceDirectoryName)

        Process.run("rm",   args: ["usr/include/Makefile"],
                            output: :inherit,
                            chdir:  Ism.settings.sourcesPath + "/" + 
                                    @information.versionName + "/" +
                                    @mainSourceDirectoryName)
                                    
        Process.run("cp",   args: ["-rv","usr/include", "#{Ism.settings.rootPath}"],
                            output: :inherit,
                            chdir:  Ism.settings.sourcesPath + "/" + 
                                    @information.versionName + "/" +
                                    @mainSourceDirectoryName)
    end

end