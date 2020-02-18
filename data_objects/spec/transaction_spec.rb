require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))

describe DataObjects::Transaction do

  before :each do
    @connection = double("connection")
    expect(DataObjects::Connection).to receive(:new).with("mock://mock/mock").once.and_return(@connection)
    #DataObjects::Connection.should_receive(:new).with("mock://mock/mock").once.and_return(@connection)
    @transaction = DataObjects::Transaction.new("mock://mock/mock")
  end

  it "should have a HOST constant" do
    DataObjects::Transaction::HOST.should_not == nil?
  end

  describe "#initialize" do
    it "should provide a connection" do
      expect(@transaction.connection).to eq(@connection)
    end
    it "should provide an id" do
      expect(@transaction.id).not_to eq(nil)
    end
    it "should provide a unique id" do
	    expect(DataObjects::Connection).to receive(:new).with("mock://mock/mock2").once.and_return(@connection)
      expect(@transaction.id).not_to eq(DataObjects::Transaction.new("mock://mock/mock2").id)
    end
  end
  describe "#close" do
    it "should close its connection" do
      expect(@connection).to receive(:close).once
      expect(lambda { @transaction.close }).not_to raise_error(DataObjects::TransactionError)
    end
  end
  [:prepare, :commit_prepared, :rollback_prepared].each do |meth|
    it "should raise NotImplementedError on #{meth}" do
	    expect(lambda { @transaction.send(meth) }).to raise_error(NotImplementedError)
    end
  end

end
