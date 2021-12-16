class FileReader
  def read(file_name)
    root_dir = File.expand_path("..", Dir.pwd)
    File.read("#{root_dir}/input/#{file_name}")
  end
end
