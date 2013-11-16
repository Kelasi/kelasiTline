require 'spec_helper'

describe MilestonesController do

	before {session['user'] = User.first}

	context 'index' do

		it 'should call Octokit list_milestones method' do
			o = ['1','2','3']
			Octokit::Client.any_instance.should_receive(:list_milestones)
							.with('Kelasi/kelasi').and_return(o)
			get 'index', org: 'Kelasi', repo: 'kelasi'
			expect(assigns(:milestones)).to eq o
		end
	end

	context 'create' do

		let(:milestone) { ['1'] }
		let(:req_params) { {org: 'Kelasi', repo: 'kelasi', title: 'title', format: :json} }

		def ostub(obj = Hash.new)
			Octokit::Client.any_instance.should_receive(:create_milestone)
							.with('Kelasi/kelasi', 'title', obj).and_return(milestone)
		end

		it 'should call Octokit create_milestone' do
			ostub
			post 'create', req_params
			expect(assigns(:milestone)).to eq milestone
		end

		it 'should be able to get a hash of valid (state, description and due_on) optional argument' do
			due_on = { 'due_on' => Time.now }
			ostub due_on
			post 'create', req_params.merge(options: due_on)
			expect(assigns(:milestone)).to eq milestone
		end

		it 'should reject invalid optional parameter' do
			ostub
			post 'create', req_params.merge(options: {option: 'invalid'})
			expect(assigns(:milestone)).to eq milestone
		end
	end
end
