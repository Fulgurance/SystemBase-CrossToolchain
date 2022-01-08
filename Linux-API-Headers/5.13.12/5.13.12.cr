require "../../../SoftwaresLibrairies"

class Target < ISM::Software
    
    def download
        super
        downloadSource(@downloadLinks[0])
    end

    def extract
        super
        extractSource("linux-5.13.12.tar.xz")
    end

    def prepare
        super
        @mainSourceDirectoryName = "linux-5.13.12/"
    end

    def configure
        super
        configureSource([Ism.settings.makeOptions, "mrproper"])
    end
    
    def build
        super
        makeSource([Ism.settings.makeOptions, "headers"])
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