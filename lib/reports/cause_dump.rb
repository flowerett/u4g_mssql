# encoding: utf-8
require 'csv'

module Reports
  class CauseDump
    attr_reader :filename, :error_messages

    ESCAPED_QUOTE = '"'
    DELIMITER = ";"

    def initialize()
      @error_messages = []

      set_headers
    end

    def perform!
      create_file!

      Cause.find_in_batches do |causes|
        dump_to_file!(causes)
      end
    end

    def dump_to_file!(causes)
      begin
        File.open(@filename, 'a:utf-8') do |file|
          causes.each do |cause|
            file.puts generate_row(cause).join(DELIMITER)
          end
        end
      rescue
        File.delete(@filename) if File.exists?(@filename)
        raise $!
      end
    end

    def generate_row(cause)
      return [] unless cause

      data = [
        cause.ID,
        escape_str(cause.UrlName),
        escape_str(cause.Name),
        escape_str(cause.EIN),
        cause.NteeCommonCodeID,
        escape_str(cause.Address1),
        escape_str(cause.Address2),
        escape_str(cause.Address3),
        escape_str(cause.City),
        escape_str(cause.State),
        escape_str(cause.Zip),
        escape_str(cause.Url),
        escape_str(cause.Email),
        escape_str(cause.Phone),
        escape_str(cause.ContactFirstName),
        escape_str(cause.ContactLastName),
        escape_str(cause.ContactTitle),
        escape_str(cause.ContactEmail),
        escape_str(cause.ContactPhone),
        escape_str(cause.About),
        escape_str(cause.Mission),
        escape_str(cause.Description),
        escape_str(cause.VideoID),
        escape_str(cause.VideoProvider),
        cause.Status,
        escape_str(cause.CreatedDate),
        escape_str(cause.PhotoUrl),
        escape_str(cause.ThumbnailUrl),
        escape_str(cause.UpdatedDate)
      ]
      data
    end

    def set_headers
      @headers = [
        "ID",
        "UrlName",
        "Name",
        "EIN",
        "NteeCommonCodeID",
        "Address1",
        "Address2",
        "Address3",
        "City",
        "State",
        "Zip",
        "Url",
        "Email",
        "Phone",
        "ContactFirstName",
        "ContactLastName",
        "ContactTitle",
        "ContactEmail",
        "ContactPhone",
        "About",
        "Mission",
        "Description",
        "VideoID",
        "VideoProvider",
        "Status",
        "CreatedDate",
        "PhotoUrl",
        "ThumbnailUrl",
        "UpdatedDate",
      ]


    end

    def create_file!
      set_filename

      FileUtils.mkdir_p(@directory_name) unless File.exists?(@directory_name)

      File.open(@filename, 'w:utf-8') do |file|
        file.puts @headers.join(DELIMITER)
      end
    end

    def set_filename
      @directory_name = "tmp/causes"
      @filename = @directory_name + "/causes_dump.csv"
    end

    def escape_str(str)
      "#{ESCAPED_QUOTE}#{str.to_s.delete("\n").gsub(ESCAPED_QUOTE, '')}#{ESCAPED_QUOTE}"
    end
  end
end