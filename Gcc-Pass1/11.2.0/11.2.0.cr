require "../../../SoftwaresLibrairies"

class Target < ISM::Software
    
    def download
        super
        downloadSource(@downloadLinks[0])
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

        moveFile("mpfr",@mainSourceDirectoryName)
        moveFile("gmp",@mainSourceDirectoryName)
        moveFile("mpc",@mainSourceDirectoryName)

        #A transformer
        Process.run("case", args: [ "$(uname -m)",
                                    "in",
                                    "x86_64)",
                                    "sed",
                                    "-e",
                                    "'/m64=/s/lib64/lib/'",
                                    "-i",
                                    ".orig",
                                    "gcc/config/i386/t-linux64",
                                    ";;",
                                    "esac"],
                            output: :inherit,
                            chdir:  Ism.settings.sourcesPath + "/" + 
                                    @information.versionName + "/" +
                                    @mainSourceDirectoryName)

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
                            "--enable-languages=c,c++"])
    end
    
    def build
        super
        makeSource([Ism.settings.makeOptions],"build")
    end
    
    def install
        super
        makeSource([Ism.settings.makeOptions, "install"],"build")

        #A transformer
        Process.run("cat",  args: [  "gcc/limitx.h", 
                                    "gcc/glimits.h",
                                    "gcc/limity.h",
                                    ">",
                                    "`dirname",
                                    "$(#{Ism.settings.target}-gcc",
                                    "-print-libgcc-file-name)`/install-tools/include/limits.h"],
                            output: :inherit,
                            chdir:  Ism.settings.sourcesPath + "/" + 
                                    @information.versionName + "/" +
                                    @mainSourceDirectoryName)
    end

end