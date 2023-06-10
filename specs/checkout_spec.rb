require './checkout'
require './products'
Dir.glob('./rules/**/*.rb') { |f| require f }

describe Checkout do
  let(:checkout) { described_class.new(rules) }

  before do
    product_codes.each do |code|
      checkout.scan(Products.by_code(code))
    end
  end

  describe '#total' do
    subject { checkout.total }

    context '[all rules enabled]' do
      let(:rules) { [Rules::Tea, Rules::Strawberry, Rules::Coffee] }

      context 'when empty basket' do
        let(:product_codes) { [] }
        it { expect(subject).to be_zero }
      end

      context 'when unknown product inside the basket' do
        let(:product_codes) { ['FOO'] }
        it { expect(subject).to be_zero }
      end

      context '[base test cases]' do
        context 'when basket is (GR1, SR1, GR1, GR1, CF1)' do
          let(:product_codes) { ['GR1', 'SR1', 'GR1', 'GR1', 'CF1'] }
          it { expect(subject).to eql 22.45 }
        end

        context 'when basket is (GR1, GR1)' do
          let(:product_codes) { ['GR1', 'GR1'] }
          it { expect(subject).to eql 3.11 }
        end

        context 'when basket is (SR1, SR1, GR1, SR1)' do
          let(:product_codes) { ['SR1', 'SR1', 'GR1', 'SR1'] }
          it { expect(subject).to eql 16.61 }
        end

        context 'when basket is (GR1, CF1, SR1, CF1, CF1)' do
          let(:product_codes) { ['GR1', 'CF1', 'SR1', 'CF1', 'CF1'] }
          it { expect(subject).to eql 30.57 }
        end
      end

      context '[additional test cases]' do
        context 'when just 1 coffee' do
          let(:product_codes) { ['CF1'] }
          it { expect(subject).to eql 11.23 }
        end

        context 'when enough tea and strawberry' do
          let(:product_codes) { ['SR1', 'GR1', 'SR1', 'SR1', 'CF1', 'GR1', 'CF1', 'SR1', 'SR1', 'SR1'] }
          it { expect(subject).to eql 52.57 } # Math: 3.11 + 6 * 4.5 + 2 * 11.23
        end

        context 'when enough strawberry and coffee' do
          let(:product_codes) { ['CF1', 'SR1', 'SR1', 'SR1', 'CF1', 'GR1', 'CF1'] }
          it { expect(subject).to eql 39.07 } # Math: 3.11 + 3 * 4.5 + 3 * 11.23 * 2/3
        end

        context 'when enough tea and coffee' do
          let(:product_codes) { ['GR1', 'GR1', 'CF1', 'CF1', 'SR1', 'SR1', 'CF1', 'GR1', 'CF1'] }
          it { expect(subject).to eql 46.17 } # Math: 2 * 3.11 + 2 * 5 + 4 * 11.23 * 2/3
        end
      end
    end

    context '[tea and coffe rules enabled only]' do
      let(:rules) { [Rules::Tea, Rules::Coffee] }
      let(:product_codes) { ['CF1', 'SR1', 'SR1', 'SR1', 'CF1', 'GR1', 'CF1'] }
      it { expect(subject).to eql 40.57 } # Math: 3.11 + 3 * 5 + 3 * 11.23 * 2/3
    end

    context '[strawberry rule enabled only]' do
      let(:rules) { [Rules::Strawberry] }
      let(:product_codes) { ['CF1', 'SR1', 'SR1', 'SR1', 'SR1', 'CF1', 'GR1', 'GR1', 'CF1'] }
      it { expect(subject).to eql 57.91 } # Math: 2 * 3.11 + 4 * 4.5 + 3 * 11.23
    end

    context '[no rules enabled]' do
      let(:rules) { [] }

      context 'when enough strawberry and coffee' do
        let(:product_codes) { ['CF1', 'SR1', 'SR1', 'SR1', 'SR1', 'CF1', 'GR1', 'GR1', 'CF1'] }
        it { expect(subject).to eql 59.91 } # Math: 2 * 3.11 + 4 * 5 + 3 * 11.23
      end

      context 'when enough tea' do
        let(:product_codes) { 10.times.map { 'GR1' } }
        it { expect(subject).to eql 31.1 } # Math: 10 * 3.11
      end
    end
  end

end
