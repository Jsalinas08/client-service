require 'rails_helper'

RSpec.describe Client, type: :model do
  describe 'validations' do
    subject { build(:client) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:address) }
    it { is_expected.to validate_presence_of(:dni) }
    it { is_expected.to validate_presence_of(:email) }

    it { is_expected.to validate_uniqueness_of(:dni) }
    it { is_expected.to validate_uniqueness_of(:email) }

    it { is_expected.to allow_value('test@example.com').for(:email) }
    it { is_expected.not_to allow_value('invalid-email').for(:email) }
  end


  describe 'creation' do
    let(:valid_attributes) do
      {
        name: 'John Doe',
        address: '123 Main St',
        dni: '12345678',
        email: 'john@example.com'
      }
    end

    context 'with valid attributes' do
      it 'creates a client successfully' do
        client = described_class.create(valid_attributes)

        expect(client).to be_persisted
        expect(client).to have_attributes(valid_attributes)
      end
    end

    context 'with invalid attributes' do
      subject(:client) { described_class.new(attributes) }

      context 'when name is missing' do
        let(:attributes) { valid_attributes.except(:name) }

        it 'is invalid' do
          expect(client).not_to be_valid
          expect(client.errors[:name]).to include(I18n.t('errors.messages.blank'))
        end
      end

      context 'when address is missing' do
        let(:attributes) { valid_attributes.except(:address) }

        it 'is invalid' do
          expect(client).not_to be_valid
          expect(client.errors[:address]).to include(I18n.t('errors.messages.blank'))
        end
      end

      context 'when dni is missing' do
        let(:attributes) { valid_attributes.except(:dni) }

        it 'is invalid' do
          expect(client).not_to be_valid
          expect(client.errors[:dni]).to include(I18n.t('errors.messages.blank'))
        end
      end

      context 'when email is missing' do
        let(:attributes) { valid_attributes.except(:email) }

        it 'is invalid' do
          expect(client).not_to be_valid
          expect(client.errors[:email]).to include(I18n.t('errors.messages.blank'))
        end
      end

      context 'when dni is duplicated' do
        before { described_class.create!(valid_attributes) }

        let(:attributes) { valid_attributes.merge(name: 'Jane Doe', address: '456 Oak St', email: 'jane@example.com') }

        it 'is invalid' do
          expect(client).not_to be_valid
          expect(client.errors[:dni]).to include(I18n.t('errors.messages.taken'))
        end
      end

      context 'when email format is invalid' do
        let(:attributes) { valid_attributes.merge(email: 'invalid-email') }

        it 'is invalid' do
          expect(client).not_to be_valid
          expect(client.errors[:email]).to include(I18n.t('errors.messages.invalid'))
        end
      end
    end
  end
end
