require 'rails_helper'

RSpec.describe Privilege, type: :model do

  let(:user) { create(:user, email: 'user@sanger.ac.uk') }
  let(:node) { create(:node, name: 'MyNode', owner: user) }

  describe '#create' do

    it 'is created as described' do
      pr = Privilege.create!(node: node, name: user.email, role: :editor)
      expect(pr.node).to eq(node)
      expect(pr.name).to eq(user.email)
      expect(pr.role).to eq('editor')
      expect(pr.editor?).to eq(true)
      expect(pr.spender?).to eq(false)
    end
  end

  describe 'validation' do
    it 'is not valid without a name' do
      expect(Privilege.new(node: node, role: :editor)).not_to be_valid
    end
    it 'is not valid without a node' do
      expect(Privilege.new(name: user.email, role: :editor)).not_to be_valid
    end
    it 'is not valid without a role' do
      expect(Privilege.new(name: user.email, node: node)).not_to be_valid
    end
    it 'is cannot have an invalid role' do
      expect { Privilege.new(name: user.email, node: node, role: :bananas) }.to raise_exception(ArgumentError)
    end
    it 'is valid with valid arguments' do
      expect(Privilege.new(name: user.email, node: node, role: :editor)).to be_valid
      expect(Privilege.new(name: 'pirates', node: node, role: :spender)).to be_valid
    end
  end
end
