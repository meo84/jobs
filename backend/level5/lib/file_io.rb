require 'json'

module FileIO

  def data_from_file(file_name)
    JSON.parse(File.read(file_name), { symbolize_names: true })
  end

  def save_to_file(data, file_name)
    json_data = JSON.pretty_generate(data)
    File.open(file_name, 'w') { |file| file.write(json_data) }
  end

   def get(data, type, id)
    objects = data[type].select { |object| object[:id] == id }
    objects.first
   end
end
