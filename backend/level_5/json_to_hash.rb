require 'json'

class JsonToHash

  def self.read_file file
    begin
      file = File.read file
      JSON.parse file
    rescue => error
      puts error.message
    end
  end

  def self.write_output data
    File.open("output.json", "w") do | file |
      file.write JSON.pretty_generate(data)
    end
  end
end
