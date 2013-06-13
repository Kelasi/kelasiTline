require 'spec_helper'

describe 'posts/index' do

  before do
    user = mock_model(User, id: 1, name: 'Saeed')
    post = mock_model(Post, user: user, created_at: Time.now)
    assign(:posts, 
           [mock_model(Post, 
                       created_at: Time.now,
                       user: user,
                       msg: "test message",
                       replies: [post])
    ])
    assign(:user, user)
  end

  it 'should contain a logout link' do
    render
    expect(rendered).to have_link 'logout', href: '/logout'
  end

  it 'should contain the name of logged in user' do
    render
    expect(rendered).to have_content 'Saeed'
  end

  it 'should contain the post.msg' do
    render
    expect(rendered).to have_content 'test message'
  end
end
