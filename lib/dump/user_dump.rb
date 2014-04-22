# encoding: utf-8
require 'csv'

module Dump
  class UserDump
    attr_reader :filename, :error_messages

    ESCAPED_QUOTE = '"'
    DELIMITER = ";"

    def initialize()
      @error_messages = []

      set_headers
    end

    def perform!
      create_file!

      User.find_in_batches do |users|
        dump_to_file!(users)
      end
    end

    def dump_to_file!(users)
      begin
        File.open(@filename, 'a:utf-8') do |file|
          users.each do |user|
            file.puts generate_row(user).join(DELIMITER)
          end
        end
      rescue
        File.delete(@filename) if File.exists?(@filename)
        raise $!
      end
    end

    def generate_row(user)
      return [] unless user

      data = [
        user.ID,
        escape_str(user.UID),
        escape_str(user.FirstName),
        escape_str(user.LastName),
        escape_str(user.Email),
        user.BirthDay,
        user.BirthMonth,
        user.BirthYear,
        escape_str(user.Zip),
        escape_str(user.PhotoUrl),
        escape_str(user.ThumbnailUrl),
        escape_str(user.Permission),
        escape_str(user.ModifiedDate),
        escape_str(user.CreatedDate),
        escape_str(user.Password),
        escape_str(user.UrlName),
        user.Role,
        user.OptIn,
        escape_str(user.LastLogin)
      ]
      data
    end

    def set_headers
      @headers = [
                  "ID",
                  "UID",
                  "FirstName",
                  "LastName",
                  "Email",
                  "BirthDay",
                  "BirthMonth",
                  "BirthYear",
                  "Zip",
                  "PhotoUrl",
                  "ThumbnailUrl",
                  "Permission",
                  "ModifiedDate",
                  "CreatedDate",
                  "Password",
                  "UrlName",
                  "Role",
                  "OptIn",
                  "LastLogin"
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
      @directory_name = "tmp/dump"
      @filename = @directory_name + "/users_dump.csv"
    end

    def escape_str(str)
      "#{ESCAPED_QUOTE}#{str.to_s.delete("\n").gsub(ESCAPED_QUOTE, '')}#{ESCAPED_QUOTE}"
    end
  end
end