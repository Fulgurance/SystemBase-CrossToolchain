require "../../../SoftwaresLibrairies"

class Target < ISM::Software
    
    def download
        super
        downloadSource(@downloadLinks[0])
    end

    def extract
        super
        extractSource("glibc-2.34.tar.xz")
    end

    def prepare
        super
        @mainSourceDirectoryName = "glibc-2.34/"
        Process.run("case", args: [ "case",
                                    "$(uname -m)",
                                    "in",
                                    "i?86)",
                                    "ln",
                                    "-sfv",
                                    "ld-linux.so.2",
                                    "#{Ism.settings.rootPath}/lib/ld-lsb.so.3",
                                    ";;",
                                    "x86_64)",
                                    "ln",
                                    "-sfv",
                                    "../lib/ld-linux-x86-64.so.2",
                                    "#{Ism.settings.rootPath}/lib64",
                                    "ln",
                                    "-sfv",
                                    "../lib/ld-linux-x86-64.so.2",
                                    "#{Ism.settings.rootPath}/lib64/ld-lsb-x86-64.so.3",
                                    ";;",
                                    "esac"],
                            output: :inherit,
                            chdir:  Ism.settings.sourcesPath + "/" + 
                                    @information.versionName + "/" +
                                    @mainSourceDirectoryName)

        makeDirectory(@mainSourceDirectoryName+"build")
    end

    def configure
        super
        configureSource([   "--prefix=/usr",
                            "--host=#{Ism.settings.target}",
                            "--build=$(../scripts/config.guess)",
                            "--enable-kernel=3.2",
                            "--with-headers=#{Ism.settings.rootPath}/usr/include",
                            "libc_cv_slibdir=/usr/lib"])
    end
    
    def build
        super
        makeSource([Ism.settings.makeOptions],"build")
    end
    
    def install
        super
        makeSource([Ism.settings.makeOptions,"DESTDIR=#{Ism.settings.rootPath}","install"],"build")
                                    
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