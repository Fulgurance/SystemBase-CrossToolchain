require "../../../SoftwaresLibrairies"

class Target < ISM::Software

    def initialize
        super(  "./Softwares/SystemBase-CrossToolchain/Binutils-Pass1/2.37/Information.json",
                "binutils-2.37")
    end

    def prepare
        super
        Dir.mkdir(  Ism.settings.sourcesPath + "/" + 
                    @information.versionName + "/" +
                    @mainSourceDirectoryName + "/" +
                    "build")
    end
    
    def configure
        super
        Process.run("../configure", args: [  "--prefix=#{Ism.settings.toolsPath}", 
                                            "--with-sysroot=#{Ism.settings.rootPath}",
                                            "--target=#{Ism.settings.target}",
                                            "--disable-nls",
                                            "--disable-werror"],
                                    output: :inherit,
                                    chdir:  Ism.settings.sourcesPath + "/" + 
                                            @information.versionName + "/" +
                                            @mainSourceDirectoryName + "/" +
                                            "build")
    end
    
    def build
        super
        Process.run("make", args: [Ism.settings.makeOptions],
                            output: :inherit,
                            chdir:  Ism.settings.sourcesPath + "/" + 
                                    @information.versionName + "/" +
                                    @mainSourceDirectoryName + "/" +
                                    "build")
    end
    
    def install
        super
        Process.run("make", args: ["-j1","install"],
                            output: :inherit,
                            chdir:  Ism.settings.sourcesPath + "/" + 
                                    @information.versionName + "/" +
                                    @mainSourceDirectoryName + "/" +
                                    "build")
    end

end