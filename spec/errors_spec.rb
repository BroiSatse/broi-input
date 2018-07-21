RSpec.describe Broi::Errors do
  let(:error_hash) { { name: 'is blank', address: { postcode: 'is invalid', first_line: 'is blank' } } }
  subject(:errors) { described_class.new(error_hash) }

  describe '#[]' do
    it 'allows access to given fields through string' do
      expect(subject['name']).to eq 'is blank'
    end

    it 'allows access to given fields through symbol' do
      expect(subject[:name]).to eq 'is blank'
    end

    it 'returned nested error object for nesting keys' do
      expect(subject[:address]).to be_an_instance_of described_class
      expect(subject[:address]['postcode']).to eq 'is invalid'
    end

    it 'allows access through a joined key' do
      expect(subject['address.postcode']).to eq 'is invalid'
    end
  end

  describe '#to_nested_hash' do
    it 'returns all the errors in the form of nesting hashes' do
      expect(subject.to_nested_hash).to eq(
        name: 'is blank',
        address: {
          postcode: 'is invalid',
          first_line: 'is blank'
        }
      )
    end
  end

  describe '#to_flat_hash' do
    it 'returns all the errors with a flattened keys' do
      expect(subject.to_flat_hash).to eq(
        name: 'is blank',
        'address.postcode': 'is invalid',
        'address.first_line': 'is blank'
      )
    end
  end
end