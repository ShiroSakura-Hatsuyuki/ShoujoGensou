require 'fileutils'

# ============================================================
# 项目 DSL 定义 / Project DSL Definition
# ============================================================
class Project
  attr_accessor :output_directory,
                :library_install_directory,
                :binary_install_directory,
                :header_destination,
                :configuration

  # 初始化项目配置，支持通过代码块进行 DSL 配置
  # Initialize project configuration with optional DSL block
  def initialize(&block)
    @output_directory          = 'LibraryArti'
    @library_install_directory = 'ArtifactVault/lib'
    @binary_install_directory  = 'ArtifactVault/bin'
    @configuration             = 'Release'
    instance_eval(&block) if block_given?
  end
end

# ============================================================
# 构建脚本入口 / Build Script Entry Point
# ============================================================
if __FILE__ == $0
  # 配置参数映射表 / Configuration argument mapping table
  CONFIGURATION_MAP = {
    'D'       => 'Debug',
    'R'       => 'Release',
    'develop' => 'Debug',
    'debug'   => 'Debug',
    'release' => 'Release'
  }.freeze

  # CMake 生成器名称 / CMake generator name
  CMAKE_GENERATOR = 'Visual Studio 18 2026'.freeze

  # --- 辅助方法 / Helper Methods ----------------------------------------

  # 执行系统命令，失败时终止并输出错误信息
  # Execute system command; abort with error message on failure
  def execute_command!(command, error_message)
    puts "  ▶ #{command}"
    unless system(command)
      abort "✖ 错误 / Error: #{error_message}"
    end
  end

  # 清理目标目录、重建并复制匹配文件，返回已复制文件列表
  # Clean destination directory, recreate and copy matched files; return copied file list
  def install_artifacts(source_pattern, destination_directory, artifact_label)
    FileUtils.rm_rf(destination_directory)
    FileUtils.mkdir_p(destination_directory)

    matched_files = Dir.glob(source_pattern)
    if matched_files.empty?
      warn "  ○ 警告 / Warning: 未找到 #{artifact_label} 文件 / No #{artifact_label} files found (#{source_pattern})"
      return []
    end

    matched_files.each { |file_path| FileUtils.cp_r(file_path, destination_directory) }
    matched_files
  end

  # 打印带 Unicode 标记的步骤标题
  # Print step header with Unicode marker
  def print_step(step_number, description_chinese, description_english)
    puts "\n◆ 步骤 / Step #{step_number}: #{description_chinese} / #{description_english}"
    puts "─" * 50
  end

  # --- 主流程 / Main Flow ---------------------------------------------

  # 步骤 1：解析配置参数 / Step 1: Parse configuration argument
  print_step(1, '解析配置参数', 'Parse Configuration Argument')
  raw_argument = ARGV[0]
  configuration = CONFIGURATION_MAP.fetch(raw_argument, 'Release')
  if raw_argument && !CONFIGURATION_MAP.key?(raw_argument)
    warn "  ○ 警告 / Warning: 未知参数 '#{raw_argument}'，使用默认配置 Release / Unknown argument '#{raw_argument}', falling back to default configuration Release"
  end
  puts "  ● 当前配置 / Active configuration: #{configuration}"

  # 步骤 2：校验必需的项目文件 / Step 2: Validate required project files
  print_step(2, '校验必需的项目文件', 'Validate Required Project Files')
  required_files = %w[Project.rb CMakeLists.txt]
  required_files.each do |required_file|
    unless File.exist?(required_file)
      abort "✖ 错误 / Error: 未找到 #{required_file}，请确保在 Arti 项目根目录运行 / #{required_file} not found. Please run this script from the Arti project root directory."
    end
    puts "  ● 已找到 / Found: #{required_file}"
  end

  Dir.chdir(__dir__)
  load 'Project.rb'

  unless defined?($object) && $object.is_a?(Project)
    abort "✖ 错误 / Error: Project.rb 未正确定义 $object 实例 / Project.rb does not define a valid $object instance of Project"
  end

  $object.configuration = configuration

  output_directory          = $object.output_directory
  library_install_directory = $object.library_install_directory
  binary_install_directory  = $object.binary_install_directory
  header_destination        = $object.header_destination

  # 步骤 3：清理旧构建产物 / Step 3: Clean previous build artifacts
  print_step(3, '清理旧构建产物', 'Clean Previous Build Artifacts')
  FileUtils.rm_rf(output_directory)
  puts "  ● 已清理 / Removed: #{output_directory}"

  # 步骤 4：执行 CMake 构建流水线 / Step 4: Execute CMake build pipeline
  print_step(4, '执行 CMake 构建流水线', 'Execute CMake Build Pipeline')
  execute_command!(
    "cmake -B build_x64 -G \"#{CMAKE_GENERATOR}\" -A x64",
    'CMake 配置失败 / CMake configuration failed'
  )
  execute_command!(
    "cmake --build build_x64 --config #{configuration}",
    'CMake 构建失败 / CMake build failed'
  )
  execute_command!(
    "cmake --install build_x64 --config #{configuration}",
    'CMake 安装失败 / CMake installation failed'
  )

  # 步骤 5：收集并安装构建产物 / Step 5: Collect and install build artifacts
  print_step(5, '收集并安装构建产物', 'Collect and Install Build Artifacts')
  library_files = install_artifacts(
    "#{output_directory}/lib/*.lib",
    library_install_directory,
    '.lib'
  )
  binary_files = install_artifacts(
    "#{output_directory}/bin/*.dll",
    binary_install_directory,
    '.dll'
  )
  header_files = install_artifacts(
    "#{output_directory}/include/*",
    header_destination,
    '头文件 / header'
  )

  # 步骤 6：复制可选的模块映射文件 / Step 6: Copy optional module map file
  print_step(6, '复制可选的模块映射文件', 'Copy Optional Module Map File')
  modulemap_source_path = File.join(__dir__, 'module.modulemap')
  if File.exist?(modulemap_source_path)
    FileUtils.cp(modulemap_source_path, header_destination)
    expanded_modulemap_path = File.expand_path(File.join(header_destination, 'module.modulemap'))
    puts "  ● module.modulemap → #{expanded_modulemap_path}"
  else
    warn "  ○ 警告 / Warning: 未找到 module.modulemap 文件，已跳过 / module.modulemap file not found, skipping"
  end

  # 步骤 7：输出构建摘要 / Step 7: Print build summary
  print_step(7, '构建摘要', 'Build Summary')
  puts "  ■ lib/     #{library_files.map { |file_path| File.basename(file_path) }.join(', ')}"
  puts "  ■ bin/     #{binary_files.map { |file_path| File.basename(file_path) }.join(', ')}"
  puts "  ■ 头文件 / Headers → #{File.expand_path(header_destination)}"
  puts "\n✔ 构建成功完成 / Build completed successfully."
end