class Target < ISM::Software

    def download
        super
        downloadSource(@information.downloadLinks[0])
    end

    def extract
        super
        extractSource("gcc-11.2.0.tar.xz")
    end
    
    def prepare
        super
        @mainSourceDirectoryName = "gcc-11.2.0/"
        makeDirectory(@mainSourceDirectoryName+"build")
    end

    def configure
        super
        configureSource([   "--host=#{Ism.settings.target}", 
                            "--build=$(../config.guess)",
                            "--prefix=/usr",
                            "--disable-multilib",
                            "--disable-nls",
                            "--disable-libstdcxx-pch",
                            "--with-gxx-include-dir=/tools/#{Ism.settings.target}/include/c++/11.2.0"],
                            "build",
                            true,
                            "libstdc++-v3")
    end
    
    def build
        super
        makeSource([Ism.settings.makeOptions],"build")
    end
    
    def install
        super
        makeSource([Ism.settings.makeOptions,"DESTDIR=#{Ism.settings.rootPath}","install"],"build")
    end

end
