# encoding: utf-8

require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))
require 'data_objects/spec/shared/command_spec'

describe DataObjects::Postgres::Command do
  it_should_behave_like 'a Command'
  it_should_behave_like 'a Command with async'

  describe 'query with RETURNING while not returning result' do
    before do
      @connection = DataObjects::Connection.new(CONFIG.uri)
      @select_command = @connection.create_command("SELECT name FROM users WHERE id = 900")
      @upsert_command = @connection.create_command("
          WITH upsert AS
            (UPDATE users SET name = ? WHERE id = 900 RETURNING id)
          INSERT INTO users (id, name)
          SELECT 900, 'dbussink' WHERE NOT EXISTS (SELECT 1 FROM upsert)")
    end

    after do
      @connection.close
    end

    it "should work with a writable CTE acting as an Upsert" do
      reader = @select_command.execute_reader
      expect(reader.to_a.size).to eq 0
      reader.close

      @upsert_command.execute_non_query('jwkoelewijn')

      reader = @select_command.execute_reader
      reader.next!
      expect(reader.values[0]).to eq 'dbussink'
      reader.close

      @upsert_command.execute_non_query('jwkoelewijn')

      reader = @select_command.execute_reader
      reader.next!
      expect(reader.values[0]).to eq 'jwkoelewijn'
      reader.close
    end
  end
end
