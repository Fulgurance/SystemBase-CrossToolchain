require "../../../SoftwaresLibrairies"

class Target < ISM::Software

    def download
        super
        downloadSource(@information.downloadLinks[0])
    end

    def extract
        super
        extractSource("binutils-2.37.tar.xz")
    end

    def prepare
        super
        @mainSourceDirectoryName = "binutils-2.37/"
        makeDirectory(@mainSourceDirectoryName +"build")
    end
    
    def configure
        super
        configureSource([   "--prefix=#{Ism.settings.toolsPath}", 
                            "--with-sysroot=#{Ism.settings.rootPath}",
                            "--target=#{Ism.settings.target}",
                            "--disable-nls",
                            "--disable-werror"],
                            "build",
                            true)
    end
    
    def build
        super
        makeSource([Ism.settings.makeOptions],"build")
    end
    
    def install
        super
        makeSource(["-j1","install"],"build")
    end

end
