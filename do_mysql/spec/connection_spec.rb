# encoding: utf-8

require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))
require 'data_objects/spec/shared/connection_spec'
require 'cgi'

describe DataObjects::Mysql::Connection do

  before :all do
    @driver = CONFIG.scheme
    @user   = CONFIG.user
    @password = CONFIG.pass
    @host   = CONFIG.host
    @port   = CONFIG.port
    @database = CONFIG.database
    @ssl    = CONFIG.ssl
  end

  it_should_behave_like 'a Connection'
  it_should_behave_like 'a Connection with authentication support'
  it_should_behave_like 'a Connection allowing default database'
  it_should_behave_like 'a Connection with JDBC URL support' if JRUBY
  it_should_behave_like 'a Connection with SSL support' unless JRUBY
  it_should_behave_like 'a Connection via JDNI' if JRUBY

  if DataObjectsSpecHelpers.test_environment_supports_ssl?

    describe 'connecting with SSL' do

      it 'should raise an error when passed ssl=true' do
        expect { DataObjects::Connection.new("#{CONFIG.uri}?ssl=true") }.to raise_error(ArgumentError)
      end

      it 'should raise an error when passed a nonexistent client certificate' do
        expect { DataObjects::Connection.new("#{CONFIG.uri}?ssl[client_cert]=nonexistent") }.to raise_error(ArgumentError)
      end

      it 'should raise an error when passed a nonexistent client key' do
        expect { DataObjects::Connection.new("#{CONFIG.uri}?ssl[client_key]=nonexistent") }.to raise_error(ArgumentError)
      end

      it 'should raise an error when passed a nonexistent ca certificate' do
        expect { DataObjects::Connection.new("#{CONFIG.uri}?ssl[ca_cert]=nonexistent") }.to raise_error(ArgumentError)
      end

      it 'should connect with a specified SSL cipher' do
        expect(DataObjects::Connection.new("#{CONFIG.uri}?#{CONFIG.ssl}&ssl[cipher]=#{SSLHelpers::CONFIG.cipher}").ssl_cipher).to eq SSLHelpers::CONFIG.cipher
      end

      it 'should raise an error with an invalid SSL cipher' do
        expect { DataObjects::Connection.new("#{CONFIG.uri}?#{CONFIG.ssl}&ssl[cipher]=invalid") }.to raise_error
      end

    end

  end

end
