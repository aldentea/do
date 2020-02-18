require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))

describe DataObjects::Command do
  before do
    @connection = DataObjects::Connection.new('mock://localhost')
    @command = DataObjects::Command.new(@connection, 'SQL STRING')
  end

  after do
    @connection.close
  end

  %w{connection execute_non_query execute_reader set_types}.each do |meth|
    it "should respond to ##{meth}" do
      #@command.should respond_to(meth.intern)
	    expect(@command).to respond_to(meth.intern)
    end
  end

  %w{execute_non_query execute_reader set_types}.each do |meth|
    it "should raise NotImplementedError on ##{meth}" do
      #j\lambda { @command.send(meth.intern, nil) }.should raise_error(NotImplementedError)
	    expect(lambda { @command.send(meth.intern, nil) }).to raise_error(NotImplementedError)
    end
  end

end
