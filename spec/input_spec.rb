RSpec.describe Broi::Input do
  let(:input_class) do
    default_count = self.default_count

    Class.new(described_class) do
      attribute :name
      attribute :count, default: default_count

      validate do
        required(:name).filled
        optional(:count).maybe(:int?)
      end
    end
  end

  let(:default_count) { rand(1..10) }

  let(:params) { {} }
  subject(:result) { input_class.(params) }

  let(:input) { result.input }
  let(:errors) { result.errors }

  context 'with all the params' do
    let(:params) { { name: 'Some name', count: 5 } }

    it { is_expected.to be_success }

    it 'assigns all the valid values' do
      expect(input.name.value!).to eq params[:name]
      expect(input.count.value!).to eq params[:count]
    end

    it 'gives empty errors' do
      expect(errors).to be_empty
    end

    describe '#valid!' do
      let(:strict_input) { input.valid! }

      it 'returns values directly' do
        expect(strict_input.name).to eq params[:name]
        expect(strict_input.count).to eq params[:count]
      end
    end
  end

  context 'with all the params except for the optional ones' do
    let(:params) { { name: 'Some name' } }

    it { is_expected.to be_success }

    it 'assigns all the values' do
      expect(input.name.value!).to eq params[:name]
      expect(input.count.value!).to eq default_count
    end

    describe '#valid!' do
      let(:strict_input) { input.valid! }

      it 'returns values directly' do
        expect(strict_input.name).to eq params[:name]
        expect(strict_input.count).to eq default_count
      end
    end

  end

  context 'with invalid params' do
    let(:params) { { name: 'hello', count: 'world' } }

    it { is_expected.to be_failure }

    it 'gives validation errors' do
      expect(errors[:count]).to eq ['must be an integer']
    end

    it 'returns input object with invalid values' do
      expect(input.name).to be_valid
      expect(input.count).to be_invalid
    end

    describe '#valid!' do
      it 'raises an exception' do
        expect { input.valid! }.to raise_error Broi::Input::Invalid
      end
    end
  end
end
