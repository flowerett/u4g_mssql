# encoding: utf-8
require 'csv'

module Dump
  class ApiLogDump
    attr_reader :filename, :error_messages

    ESCAPED_QUOTE = '"'
    DELIMITER = ";"

    def initialize()
      @error_messages = []

      set_headers
    end

    def perform!
      create_file!

      ApiLog.find_in_batches do |api_logs|
        dump_to_file!(api_logs)
      end
    end

    def dump_to_file!(api_logs)
      begin
        File.open(@filename, 'a:utf-8') do |file|
          api_logs.each do |log|
            file.puts generate_row(log).join(DELIMITER)
          end
        end
      rescue
        File.delete(@filename) if File.exists?(@filename)
        raise $!
      end
    end

    def generate_row(log)
      return [] unless log

      data = [
        log.ID,
        escape_str(log.TransactionID),
        escape_str(log.ApiKey),
        escape_str(log.RequestMethod),
        escape_str(log.RequestUrl),
        escape_str(log.RequestQueryString),
        escape_str(log.RequestBody),
        log.ResponseStatus,
        escape_str(log.ResponseDuration),
        escape_str(log.CreatedDate),
        escape_str(log.IpAddress)
      ]
      data
    end

    def set_headers
      @headers = [
        "ID",
        "TransactionID",
        "ApiKey",
        "RequestMethod",
        "RequestUrl",
        "RequestQueryString",
        "RequestBody",
        "ResponseStatus",
        "ResponseDuration",
        "CreatedDate",
        "IpAddress"
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
      @filename = @directory_name + "/api_logs.csv"
    end

    def escape_str(str)
      "#{ESCAPED_QUOTE}#{str.to_s.delete("\n").gsub(ESCAPED_QUOTE, '')}#{ESCAPED_QUOTE}"
    end
  end
end