shared_examples_for 'a Reader' do

  before :all do
    setup_test_environment
  end

  before do
    @connection = DataObjects::Connection.new(CONFIG.uri)
    @reader     = @connection.create_command("SELECT code, name FROM widgets WHERE ad_description = ? order by id").execute_reader('Buy this product now!')
    @reader2    = @connection.create_command("SELECT code FROM widgets WHERE ad_description = ? order by id").execute_reader('Buy this product now!')
  end

  after do
    @reader.close
    @reader2.close
    @connection.close
  end

  it { expect(@reader).to respond_to(:fields) }

  describe 'fields' do

    it 'should return the correct fields in the reader' do
      # we downcase the field names as some drivers such as do_derby, do_h2,
      # do_hsqldb, do_oracle return the field names as uppercase
      expect(@reader.fields).to be_array_case_insensitively_equal_to(['code', 'name'])
    end

    it 'should return the field alias as the name, when the SQL AS keyword is specified' do
      reader = @connection.create_command("SELECT code AS codigo, name AS nombre FROM widgets WHERE ad_description = ? order by id").execute_reader('Buy this product now!')
      expect(reader.fields).not_to be_array_case_insensitively_equal_to(['code',   'name'])
      expect(reader.fields).to     be_array_case_insensitively_equal_to(['codigo', 'nombre'])
      reader.close
    end

  end

  it { expect(@reader).to respond_to(:values) }

  describe 'values' do

    describe 'when the reader is uninitialized' do

      it 'should raise an error' do
        expect { @reader.values }.to raise_error(DataObjects::DataError)
      end

    end

    describe 'when the reader is moved to the first result' do

      before do
        @reader.next!
      end

      it 'should return the correct first set of in the reader' do
        expect(@reader.values).to eq ["W0000001", "Widget 1"]
      end

    end

    describe 'when the reader is moved to the second result' do

      before do
        @reader.next!; @reader.next!
      end

      it 'should return the correct first set of in the reader' do
        expect(@reader.values).to eq ["W0000002", "Widget 2"]
      end

    end

    describe 'when the reader is moved to the end' do

      before do
        while @reader.next! ; end
      end

      it 'should raise an error again' do
        expect { @reader.values }.to raise_error(DataObjects::DataError)
      end
    end

  end

  it { expect(@reader).to respond_to(:close) }

  describe 'close' do

    describe 'on an open reader' do

      it 'should return true' do
        expect(@reader.close) be_truthy
      end

    end

    describe 'on an already closed reader' do

      before do
        @reader.close
      end

      it 'should return false' do
        expect(@reader.close) be_falsey
      end

    end

  end

  it { expect(@reader).to respond_to(:next!) }

  describe 'next!' do

    describe 'successfully moving the cursor initially' do

      it 'should return true' do
        expect(@reader.next!).to be_truthy
      end

    end

    describe 'moving the cursor' do

      before do
        @reader.next!
      end

      it 'should move the cursor to the next value' do
        expect(@reader.values).to eq ["W0000001", "Widget 1"]
        expect(lambda { @reader.next! }).to change { @reader.values }
        expect(@reader.values).to eq ["W0000002", "Widget 2"]
      end

    end

    describe 'arriving at the end of the reader' do

      before do
        while @reader.next!; end
      end

      it 'should return false when the end is reached' do
        expect(@reader.next!).to be_falsey
      end

    end

  end

  it { expect(@reader).to respond_to(:field_count) }

  describe 'field_count' do

    it 'should count the number of fields' do
      expect(@reader.field_count).to eq 2
    end

  end

  it { expect(@reader).to respond_to(:values) }

  describe 'each' do

    it 'should yield each row to the block for multiple columns' do
      rows_yielded = 0
      @reader.each do |row|
        expect(row).to respond_to(:[])

        expect(row.size).to eq 2

        # the field names need to be case insensitive as some drivers such as
        # do_derby, do_h2, do_hsqldb return the field names as uppercase
        expect(row['name'] || row['NAME']).to be_kind_of(String)
        expect(row['code'] || row['CODE']).to be_kind_of(String)

        rows_yielded += 1
      end
      expect(rows_yielded).to eq 15
    end

    it 'should yield each row to the block for a single column' do
      rows_yielded = 0
      @reader2.each do |row|
        expect(row).to respond_to(:[])

        expect(row.size).to eq 1

        # the field names need to be case insensitive as some drivers such as
        # do_derby, do_h2, do_hsqldb return the field names as uppercase
        expect(row['code'] || row['CODE']).to be_kind_of(String)

        rows_yielded += 1
      end
      expect(rows_yielded).to eq 15
    end

    it 'should return the reader' do
      expect(@reader.each { |row| }).to equal(@reader)
    end

  end

end
