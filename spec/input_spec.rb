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

  describe 'Non-strict input' do

    context 'with all the params' do
      let(:params) { { name: 'Some name', count: 5 } }

      it { is_expected.to be_success }

      it 'assigns all the values' do
        expect(input.name.value!).to eq params[:name]
        expect(input.count.value!).to eq params[:count]
      end
    end

    context 'with all the params except for the optional ones' do
      let(:params) { { name: 'Some name' } }

      it { is_expected.to be_success }

      it 'assigns all the values' do
        expect(input.name.value!).to eq params[:name]
        expect(input.count.value!).to eq default_count
      end
    end

    context 'with invalid params' do
      let(:params) { { name: 'hello', count: 'world' } }
      let(:errors) { result.errors }

      it { is_expected.to be_failure }
      it 'gives validation errors' do
        expect(errors).to eq(count: ['must be an integer'])
      end

      it 'returns input object with invalid values' do
        expect(input.name).to be_valid
        expect(input.count).to be_invalid
      end
    end
  end
end
