# encoding: utf-8
require 'csv'

module Dump
  class EmailResultDump
    attr_reader :filename, :error_messages

    ESCAPED_QUOTE = '"'
    DELIMITER = ";"

    def initialize()
      @error_messages = []

      set_headers
    end

    def perform!
      create_file!

      EmailResult.find_in_batches do |email_results|
        dump_to_file!(email_results)
      end
    end

    def dump_to_file!(email_results)
      begin
        File.open(@filename, 'a:utf-8') do |file|
          email_results.each do |eml|
            file.puts generate_row(eml).join(DELIMITER)
          end
        end
      rescue
        File.delete(@filename) if File.exists?(@filename)
        raise $!
      end
    end

    def generate_row(eml)
      return [] unless eml

      data = [
        eml.ID,
        escape_str(eml.syntax),
        escape_str(eml.handle),
        escape_str(eml.domain),
        escape_str(eml.address),
        eml.error,
        eml.responsecode,
        escape_str(eml.status),
        escape_str(eml.message),
        escape_str(eml.catch_all),
        escape_str(eml.duration),
        escape_str(eml.CreatedDate),
        eml.corrected,
        escape_str(eml.correctedaddress)
      ]
      data
    end

    def set_headers
      @headers = [
        "ID",
        "syntax",
        "handle",
        "domain",
        "address",
        "error",
        "responsecode",
        "status",
        "message",
        "catch_all",
        "duration",
        "CreatedDate",
        "corrected",
        "correctedaddress"
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
      @filename = @directory_name + "/email_template_dump.csv"
    end

    def escape_str(str)
      "#{ESCAPED_QUOTE}#{str.to_s.delete("\n").gsub(ESCAPED_QUOTE, '')}#{ESCAPED_QUOTE}"
    end
  end
end