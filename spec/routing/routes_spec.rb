require 'spec_helper'

describe 'routes' do

	context 'issues' do
		it 'should reject invalid repos' do
			expect(:get => '/repo/org/repo/issues').not_to be_routable
		end

		it 'should accept valid repos' do
			expect(:get => '/repo/Kelasi/kelasi/issues').to be_routable
			expect(:get => '/repo/Kelasi/kelasiTline/milestones').to be_routable
		end
	end
end
