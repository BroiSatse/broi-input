RSpec.describe Broi::Input do
  let(:input_class) do
    Class.new(described_class) do
      attribute :id
      attribute :attrs do
        attribute :name
        attribute :level, default: 0
      end

      validate do
        required(:id).filled(:int?)
        required(:attrs).schema do
          required(:name).filled(:str?)
          optional(:level).filled(:int?)
        end
      end
    end
  end

  let(:params) { {} }
  subject(:result) { input_class.(params) }
  let(:struct) { result.struct }
  let(:errors) { result.errors }

  context 'with all valid params' do
    let(:params) { { id: 3, attrs: { name: 'Hello', level: 2 } } }

    it { is_expected.to be_valid }

    it 'assigns all the valid values' do
      expect(struct.id).to eq params[:id]
      expect(struct.attrs.name).to eq params[:attrs][:name]
      expect(struct.attrs.level).to eq params[:attrs][:level]
    end

    it 'gives empty errors' do
      expect(errors).to be_empty
    end
  end

  context 'with all the params except for the optional ones' do
    let(:params) { { id: 3, attrs: { name: 'Hello' } } }

    it { is_expected.to be_valid }

    it 'uses the default value' do
      expect(struct.attrs.level).to eq 0
    end
  end

  describe 'invalid input' do
    context 'when required value key is missing' do
      let(:params) { { attrs: { name: 'Hello' } } }
    end

    it { is_expected.not_to be_valid }

    it 'sets validation message' do
      expect(errors[:id]).to eq ['is missing']
    end
  end
end
