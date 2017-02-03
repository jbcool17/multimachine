require_relative '../../../lib/utilities/utilities'

describe 'Utilities Module' do
  # let(:dummy_class) { Class.new { include ModuleToBeTested } }
  before(:each) do
    @utility = Class.new
    @utility.extend(RelationshipOfCommand::Utilities)
  end

  context 'Message Output' do
    it 'Printing Message Format' do
      expect(@utility.message('test')).to eq "===> test"
    end
    it 'Printing Message Format to STDOUT' do
      expect { @utility.message('test') }.to output("===> test\n").to_stdout
    end
  end

  context 'SSH Connections' do
    it 'Connect to All' do
      output = @utility.connect_to_all('uname')
      expect(output.class).to eq Array
      expect(output.first[:master].strip).to eq 'Linux'
    end

    it 'Connect to Master' do
      output = @utility.connect_to('master', 'uname').to_s
      expect(output.class).to eq String
      expect(output.strip).to eq 'Linux'
    end

    it 'Upload to Master' do
      output = @utility.transfer_to('master', 'testsrc.mpg', '/home/vagrant/test')

      expect(output).to eq 100
    end

    it 'Download from Master' do
      output = @utility.transfer_to_output('master', 'test/testsrc.mpg')

      expect(output).to eq 100
    end

    it 'Run Command on Master - Continous Output' do
      output = @utility.run_command('master', 'uname')

      expect(output).to eq 'COMMAND: uname'
    end
  end
end
