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

  context 'with all the params' do
    let(:params) { { name: 'Some name', count: 5 } }
    let(:input) { result.value! }

    it { is_expected.to be_success }

    it 'assigns all the values' do
      expect(input.name).to eq params[:name]
      expect(input.count).to eq params[:count]
    end
  end

  context 'with all the params except for the optional ones' do
    let(:params) { { name: 'Some name' } }
    let(:input) { result.value! }

    it { is_expected.to be_success }

    it 'assigns all the values' do
      expect(input.name).to eq params[:name]
      expect(input.count).to eq default_count
    end
  end

  context 'with invalid params' do
    let(:params) { { name: '', count: 'hello' } }
    let(:errors) { result.failure }


    it { is_expected.to be_failure }
    it 'yields validation errors' do
      expect(errors).to eq(name: ['must be filled'], count: ['must be an integer'])
    end
  end
end
