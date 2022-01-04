require "../../../SoftwaresLibrairies"

class Target < ISM::Software

    def initialize
        super(  "./Softwares/SystemBase-CrossToolchain/Gcc-Pass1/11.2.0/Information.json",
                "gcc-11.2.0")
    end
    
    def download
        super
        Process.run("wget", args: ["https://www.mpfr.org/mpfr-4.1.0/mpfr-4.1.0.tar.xz"],
                            output: :inherit,
                            chdir:  Ism.settings.sourcesPath + "/" + 
                                    @information.versionName)
        Process.run("wget", args: ["https://ftp.gnu.org/gnu/gmp/gmp-6.2.1.tar.xz"],
                            output: :inherit,
                            chdir:  Ism.settings.sourcesPath + "/" + 
                                    @information.versionName)
        Process.run("wget", args: ["https://ftp.gnu.org/gnu/mpc/mpc-1.2.1.tar.gz"],
                            output: :inherit,
                            chdir:  Ism.settings.sourcesPath + "/" + 
                                    @information.versionName)
    end

    def prepare
        super

        FileUtils.mv(   Ism.settings.sourcesPath + "/" + 
                        @information.versionName + "/" +
                        "mpfr-4.1.0.tar.xz",
                        Ism.settings.sourcesPath + "/" + 
                        @information.versionName + "/" +
                        @mainSourceDirectoryName + "/" + 
                        "mpfr-4.1.0.tar.xz")

        FileUtils.mv(   Ism.settings.sourcesPath + "/" + 
                        @information.versionName + "/" +
                        "gmp-6.2.1.tar.xz",    
                        Ism.settings.sourcesPath + "/" + 
                        @information.versionName + "/" +
                        @mainSourceDirectoryName + "/" +
                        "gmp-6.2.1.tar.xz")

        FileUtils.mv(   Ism.settings.sourcesPath + "/" + 
                        @information.versionName + "/" +
                        "mpc-1.2.1.tar.gz",
                        Ism.settings.sourcesPath + "/" + 
                        @information.versionName + "/" +
                        @mainSourceDirectoryName + "/" +
                        "mpc-1.2.1.tar.gz")

        Process.run("tar",  args: ["-xf", "mpfr-4.1.0.tar.xz"],
                            output: :inherit,
                            chdir:  Ism.settings.sourcesPath + "/" + 
                                    @information.versionName + "/" +
                                    @mainSourceDirectoryName)
        Process.run("tar",  args: ["-xf", "gmp-6.2.1.tar.xz"],
                            output: :inherit,
                            chdir:  Ism.settings.sourcesPath + "/" + 
                                    @information.versionName + "/" +
                                    @mainSourceDirectoryName)
        Process.run("tar",  args: ["-xf", "mpc-1.2.1.tar.gz"],
                            output: :inherit,
                            chdir:  Ism.settings.sourcesPath + "/" + 
                                    @information.versionName + "/" +
                                    @mainSourceDirectoryName)

        FileUtils.mv(   Ism.settings.sourcesPath + "/" + 
                        @information.versionName + "/" +
                        @mainSourceDirectoryName + "/" +
                        "mpfr-4.1.0",
                        Ism.settings.sourcesPath + "/" + 
                        @information.versionName + "/" +
                        @mainSourceDirectoryName + "/" + 
                        "mpfr")
            
        FileUtils.mv(   Ism.settings.sourcesPath + "/" + 
                        @information.versionName + "/" +
                        @mainSourceDirectoryName + "/" +
                        "gmp-6.2.1",    
                        Ism.settings.sourcesPath + "/" + 
                        @information.versionName + "/" +
                        @mainSourceDirectoryName + "/" +
                        "gmp")
            
        FileUtils.mv(   Ism.settings.sourcesPath + "/" + 
                        @information.versionName + "/" +
                        @mainSourceDirectoryName + "/" +
                        "mpc-1.2.1",
                        Ism.settings.sourcesPath + "/" + 
                        @information.versionName + "/" +
                        @mainSourceDirectoryName + "/" +
                        "mpc")

        `case $(uname -m) in
            x86_64)
              sed -e '/m64=/s/lib64/lib/' \
                  -i.orig gcc/config/i386/t-linux64
           ;;
        esac`

        Dir.mkdir(  Ism.settings.sourcesPath + "/" + 
                    @information.versionName + "/" +
                    @mainSourceDirectoryName + "/" +
                    "build")
    end
    
    def configure
        super
        Process.run("../configure", args: [ "--target=#{Ism.settings.target}", 
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
                                    output: :inherit,
                                    chdir:  Ism.settings.sourcesPath + "/" + 
                                            @information.versionName + "/" +
                                            @mainSourceDirectoryName + "/" +
                                            "build")
    end
    
    def build
        super
        Process.run("make", args:   [Ism.settings.makeOptions],
                            output: :inherit,
                            chdir:  Ism.settings.sourcesPath + "/" + 
                                    @information.versionName + "/" +
                                    @mainSourceDirectoryName + "/" +
                                    "build")
    end
    
    def install
        super
        Process.run("make", args:   [Ism.settings.makeOptions, "install"],
                            output: :inherit,
                            chdir:  Ism.settings.sourcesPath + "/" + 
                                    @information.versionName + "/" +
                                    @mainSourceDirectoryName + "/" +
                                    "build")

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