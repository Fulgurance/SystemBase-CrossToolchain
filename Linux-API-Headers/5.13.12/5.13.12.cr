class Target < ISM::Software
    
    def download
        super
        downloadSource(@information.downloadLinks[0])
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
        makeSource([Ism.settings.makeOptions, "mrproper"])
    end
    
    def build
        super
        makeSource([Ism.settings.makeOptions, "headers"])
    end
    
    def install
        super
        deleteAllHiddenFilesRecursively("#{mainWorkingDirectory}usr/include")
        deleteFile("#{mainWorkingDirectory}usr/include/Makefile")
        FileUtils.cp_r("#{mainWorkingDirectory}usr/include", "#{Ism.settings.rootPath}")
    end

end
