shared_examples_for 'supporting Range' do

  before :all do
    setup_test_environment
  end

  before do
    @connection = DataObjects::Connection.new(CONFIG.uri)
  end

  after do
    @connection.close
  end

  describe 'passing a Range as a parameter in execute_reader' do

    before do
      @reader = @connection.create_command("SELECT * FROM widgets WHERE id between ?").execute_reader(2..5)
    end

    after do
      @reader.close
    end

    it 'should return correct number of rows' do
      counter  = 0
      while(@reader.next!) do
        counter += 1
      end
      expect(counter).to eq 4
    end

  end
end
