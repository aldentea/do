require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))

describe DataObjects::URI do
  subject { described_class.parse(uri) }

  context 'parsing parts' do
    let(:uri) { 'mock://username:password@localhost:12345/path?encoding=utf8#fragment'  }

    it { expect(subject.scheme).to eq('mock') }
    it { expect(subject.user).to eq('username') }
    it { expect(subject.password).to eq('password') }
    it { expect(subject.host).to eq('localhost') }
    it { expect(subject.port).to eq(12345) }
    it { expect(subject.path).to eq('/path') }
    it { expect(subject.query).to eq({'encoding' => 'utf8'}) }
    it { expect(subject.fragment).to eq('fragment') }

    it 'should provide a correct string representation' do
      expect(subject.to_s).to eq('mock://username@localhost:12345/path?encoding=utf8#fragment')
    end
  end

  context 'parsing JDBC URL parts' do
    let(:uri) { 'jdbc:mock://username:password@localhost:12345/path?encoding=utf8#fragment'  }

    it { expect(subject.scheme).to eq('jdbc') }
    it { expect(subject.subscheme).to eq('mock') }
    it { expect(subject.user).to eq('username') }
    it { expect(subject.password).to eq('password') }
    it { expect(subject.host).to eq('localhost') }
    it { expect(subject.port).to eq(12345) }
    it { expect(subject.path).to eq('/path') }
    it { expect(subject.query).to eq({'encoding' => 'utf8'}) }
    it { expect(subject.fragment).to eq('fragment') }

    it 'should provide a correct string representation' do
      expect(subject.to_s).to eq('jdbc:mock://username@localhost:12345/path?encoding=utf8#fragment')
    end
  end

  context 'parsing parts' do
    let(:uri) { 'java:comp/env/jdbc/TestDataSource'  }

    it { expect(subject.scheme).to eq('java') }
    it { expect(subject.path).to eq('comp/env/jdbc/TestDataSource') }

    it 'should provide a correct string representation' do
      expect(subject.to_s).to eq('java:comp/env/jdbc/TestDataSource')
    end
  end

end
