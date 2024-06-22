# The SaveData module is used to manipulate save data. It contains the {Value}s
# that make up the save data and {Conversion}s for resolving incompatibilities
# between Essentials and game versions.
# @see SaveData.register
# @see SaveData.register_conversion
module SaveData
  # Contains the file path of the save file.
  FILE_PATH = if File.directory?(System.data_directory)
                System.data_directory + '/Game.rxdata'
              else
                './Game.rxdata'
              end

  # @return [Boolean] whether the save file exists
  def self.exists?
    return File.file?(FILE_PATH)
  end

  # Fetches the save data from the given file.
  # Returns an Array in the case of a pre-v19 save file.
  # @param file_path [String] path of the file to load from
  # @return [Hash, Array] loaded save data
  # @raise [IOError, SystemCallError] if file opening fails
  def self.get_data_from_file(file_path)
    validate file_path => String
    save_data = nil
    File.open(file_path) do |file|
      data = Marshal.load(file)
      if data.is_a?(Hash)
        save_data = data
        next
      end
      save_data = [data]
      save_data << Marshal.load(file) until file.eof?
    end
    return save_data
  end

  # Fetches save data from the given file. If it needed converting, resaves it.
	# @param file_path [String] path of the file to read from
	# @return [Hash] save data in Hash format
	# @raise (see .get_data_from_file)
	def self.read_from_file(file_path,convert=false)
		validate file_path => String
		save_data = get_data_from_file(file_path)
		save_data = to_hash_format(save_data) if save_data.is_a?(Array)
		# Updating to a new version
		if convert && !save_data.empty? && PluginManager.compare_versions(save_data[:game_version], Settings::GAME_VERSION) < 0
			if run_conversions(save_data, file_path)
				File.open(file_path, 'wb') { |file| Marshal.dump(save_data, file) }
			end
			if removeIllegalElementsFromAllPokemon(save_data)
				File.open(file_path, 'wb') { |file| Marshal.dump(save_data, file) }
			end
		end
		return save_data
	end

  # Compiles the save data and saves a marshaled version of it into
  # the given file.
  # @param file_path [String] path of the file to save into
  # @raise [InvalidValueError] if an invalid value is being saved
  def self.save_to_file(file_path)
    validate file_path => String
    save_data = self.compile_save_hash
    File.open(file_path, 'wb') { |file| Marshal.dump(save_data, file) }
  end
  
  # Compiles the save data and saves a marshaled version of it into
	# the given file.
	# @param file_path [String] path of the file to save into
	# @raise [InvalidValueError] if an invalid value is being saved
	def self.save_backup(file_path)
		validate file_path => String
		save_data = self.compile_save_hash
		File.open(file_path + ".bak", 'wb') { |file| Marshal.dump(save_data, file) }
	end

  def self.delete_file(file = FILE_PATH)
		File.delete(file)
		File.delete(file + '.bak') if File.file?(file + '.bak')
  end

  # Converts the pre-v19 format data to the new format.
  # @param old_format [Array] pre-v19 format save data
  # @return [Hash] save data in new format
  def self.to_hash_format(old_format)
    validate old_format => Array
    hash = {}
    @values.each do |value|
      data = value.get_from_old_format(old_format)
      hash[value.id] = data unless data.nil?
    end
    return hash
  end

  def self.move_old_windows_save
		FileSave.dirv19
		FileSave.dirv18
	end
end
