require "../../../SoftwaresLibrairies"

class Target < ISM::Software

    def initialize
        super(  "./SystemBase-CrossToolchain/Softwares/Glibc-Pass1/2.34/Information.json",
                "glibc-2.34")
    end
    
    def prepare
        super
        `case $(uname -m) in
            i?86)   ln -sfv ld-linux.so.2 $LFS/lib/ld-lsb.so.3
            ;;
            x86_64) ln -sfv ../lib/ld-linux-x86-64.so.2 $LFS/lib64
                    ln -sfv ../lib/ld-linux-x86-64.so.2 $LFS/lib64/ld-lsb-x86-64.so.3
            ;;
        esac`

        Dir.mkdir(  Ism.settings.sourcesPath + "/" + 
                    @information.versionName + "/" +
                    @mainSourceDirectoryName + "/" +
                    "build")
    end

    def configure
        super
        Process.run("../configure", args: [ "--prefix=/usr",
                                            "--host=#{Ism.settings.target}",
                                            "--build=$(../scripts/config.guess)",
                                            "--enable-kernel=3.2",
                                            "--with-headers=#{Ism.settings.rootPath}/usr/include",
                                            "libc_cv_slibdir=/usr/lib"],
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
        Process.run("make", args: [Ism.settings.makeOptions,"DESTDIR=#{Ism.settings.rootPath}","install"],
                            output: :inherit,
                            chdir:  Ism.settings.sourcesPath + "/" + 
                                    @information.versionName + "/" +
                                    @mainSourceDirectoryName + "/" +
                                    "build")
                                    
        Process.run("sed",  args: ["'/RTLDLIST=/s@/usr@@g'","-i","#{Ism.settings.rootPath}/usr/bin/ldd"],
                            output: :inherit,
                            chdir:  Ism.settings.sourcesPath + "/" + 
                                    @information.versionName + "/" +
                                    @mainSourceDirectoryName + "/" +
                                    "build")

        Process.run("#{Ism.settings.rootPath}/tools/libexec/gcc/#{Ism.settings.target}/11.2.0/install-tools/mkheaders",
                            output: :inherit,
                            chdir:  Ism.settings.sourcesPath + "/" + 
                                    @information.versionName + "/" +
                                    @mainSourceDirectoryName + "/" +
                                    "build")
    end

end