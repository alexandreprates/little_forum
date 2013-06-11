require 'test_helper'

class PostTest < ActiveSupport::TestCase

  test "Post should have content" do
    post = Post.new
    assert !post.save
    post.content = "Post content"
    assert post.save
  end
  
  test "Post without parent_id should be topic" do
    post = Post.create :content => "I am a Topic!", :parent_id => ''
    assert post.topic
  end
  
  test "Post with parent_id should be a reply" do
    topic = Post.create :content => 'Another Topic'
    reply = Post.create :content => 'Another Topic is awesome', :parent_id => topic.id
    assert !reply.topic
    assert reply.path.match "^#{topic.path}"
  end
  
  test "Reply should be tree structure" do
    topic = Post.create :content => 'A Topic'
    first_reply = Post.create :content => 'First reply', :parent_id => topic.id
    second_reply = Post.create :content => 'Second reply', :parent_id => topic.id
    first_reply_reply = Post.create :content => 'First reply reply', :parent_id => first_reply.id
    assert topic.replies.collect(&:path) == [first_reply.path, first_reply_reply.path, second_reply.path]
  end

  test "Content should be censored" do
    censor = Censor.new
    unsafe_text = "Unsafe text with #{censor.forbidden_worlds.sample}"
    post = Post.create :content => unsafe_text
    assert post.content != unsafe_text
  end
  
end
