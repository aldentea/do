shared_examples_for 'supporting Class' do

  before :all do
    setup_test_environment
  end

  before do
    @connection = DataObjects::Connection.new(CONFIG.uri)
  end

  after do
    @connection.close
  end

  describe 'reading a Class' do

    describe 'with manual typecasting' do

      before do
        @command = @connection.create_command("SELECT whitepaper_text FROM widgets WHERE ad_description = ?")
        @command.set_types(Class)
        @reader = @command.execute_reader('Buy this product now!')
        @reader.next!
        @values = @reader.values
      end

      after do
        @reader.close
      end

      it 'should return the correctly typed result' do
        expect(@values.first).to be_kind_of(Class)
      end

      it 'should return the correct result' do
        expect(@values.first).to eq String
      end

    end

  end

  describe 'writing a Class' do

    before do
      @reader = @connection.create_command("SELECT whitepaper_text FROM widgets WHERE whitepaper_text = ?").execute_reader(String)
      @reader.next!
      @values = @reader.values
    end

    after do
      @reader.close
    end

    it 'should return the correct entry' do
      expect(@values.first).to eq "String"
    end

  end

end
