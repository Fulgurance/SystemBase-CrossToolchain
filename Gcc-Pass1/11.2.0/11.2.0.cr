class Target < ISM::Software
    
    def download
        super
        downloadSource(@information.downloadLinks[0])
        downloadSource("https://www.mpfr.org/mpfr-4.1.0/mpfr-4.1.0.tar.xz")
        downloadSource("https://ftp.gnu.org/gnu/gmp/gmp-6.2.1.tar.xz")
        downloadSource("https://ftp.gnu.org/gnu/mpc/mpc-1.2.1.tar.gz")
    end

    def extract
        super
        extractSource("gcc-11.2.0.tar.xz")
        extractSource("mpfr-4.1.0.tar.xz")
        extractSource("gmp-6.2.1.tar.xz")
        extractSource("mpc-1.2.1.tar.gz")
    end


    def prepare
        super
        @mainSourceDirectoryName = "gcc-11.2.0/"

        moveFile("mpfr-4.1.0","mpfr")
        moveFile("gmp-6.2.1","gmp")
        moveFile("mpc-1.2.1","mpc")

        moveFile("mpfr",@mainSourceDirectoryName+"mpfr")
        moveFile("gmp",@mainSourceDirectoryName+"gmp")
        moveFile("mpc",@mainSourceDirectoryName+"mpc")

        if option?("Multilib")

        else

        end

        #if option?("x86_64")
            fileReplaceText(@mainSourceDirectoryName +
                            "gcc/config/i386/t-linux64",
                            "m64=../lib64",
                            "m64=../lib")
        #end

        makeDirectory(@mainSourceDirectoryName + "build")
    end
    
    def configure
        super
        configureSource([   "--target=#{Ism.settings.target}", 
                            "--prefix=#{Ism.settings.toolsPath}",
                            "--with-glibc-version=2.11",
                            "--with-sysroot=#{Ism.settings.rootPath}",
                            "--with-newlib",
                            "--without-headers",
                            "--enable-initfini-array",
                            "--disable-nls",
                            "--disable-shared",
                            "--disable-multilib",
                            "--disable-decimal-float",
                            "--disable-threads",
                            "--disable-libatomic",
                            "--disable-libgomp",
                            "--disable-libquadmath",
                            "--disable-libssp",
                            "--disable-libvtv",
                            "--disable-libstdcxx",
                            "--enable-languages=c,c++"],
                            "build",
                            true)
    end
    
    def build
        super
        makeSource([Ism.settings.makeOptions],"build")
    end
    
    def install
        super
        makeSource([Ism.settings.makeOptions, "install"],"build")

        fileAppendData( "#{Ism.settings.toolsPath}/lib/gcc/#{Ism.settings.target}/#{@information.version}/install-tools/include/limits.h",
                        getFileContent( Ism.settings.sourcesPath + "/" + 
                                        @information.versionName + "/" +
                                        @mainSourceDirectoryName + 
                                        "gcc/limitx.h"))
        fileAppendData( "#{Ism.settings.toolsPath}/lib/gcc/#{Ism.settings.target}/#{@information.version}/install-tools/include/limits.h",
                        getFileContent( Ism.settings.sourcesPath + "/" + 
                                        @information.versionName + "/" +
                                        @mainSourceDirectoryName + 
                                        "gcc/glimits.h"))
        fileAppendData( "#{Ism.settings.toolsPath}/lib/gcc/#{Ism.settings.target}/#{@information.version}/install-tools/include/limits.h",
                        getFileContent( Ism.settings.sourcesPath + "/" + 
                                        @information.versionName + "/" +
                                        @mainSourceDirectoryName + 
                                        "gcc/limity.h"))
    end

end
