# ============================================================
# 项目构建配置文件 / Project Build Configuration File
# ============================================================
# 此文件由构建脚本加载，用于定义项目的输出路径与依赖配置
# This file is loaded by the build script to define project output paths and dependency settings
# ============================================================

$object = Project.new do
  # ● 构建产物输出目录 / Build artifact output directory
  # CMake 安装步骤会将编译结果写入此目录
  # CMake install step will place compiled results into this directory
  self.output_directory = 'LibraryArti'

  # ● 静态库安装目录 / Static library installation directory
  # .lib 文件将被复制到此目录
  # .lib files will be copied to this directory
  self.library_install_directory = '../YukariYuyuko/Irai/Arti/lib'

  # ● 动态库安装目录 / Dynamic binary installation directory
  # .dll 文件将被复制到此目录
  # .dll files will be copied to this directory
  self.binary_install_directory = '../YukariYuyuko/Product'

  # ● 头文件安装目标目录 / Header installation destination directory
  # 公共头文件与 module.modulemap 将被复制到此目录
  # Public headers and module.modulemap will be copied to this directory
  self.header_destination = '../YukariYuyuko/Source/Arti'

  # ● 构建配置 / Build configuration
  # 可选值 / Available values: "Debug" | "Release"
  # 注意：此值会被命令行参数覆盖，仅作为未传参时的默认回退值
  # Note: This value will be overridden by command-line arguments; serves only as fallback when no argument is provided
  self.configuration = 'Release'
end