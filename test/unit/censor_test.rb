require 'test_helper'

class CensorTest < ActiveSupport::TestCase

  test "Should be initialized" do 
    censor = Censor.new
    assert censor.is_a? Censor
    censor = Censor.new(:forbidden_worlds => %w{gun})
    assert censor.forbidden_worlds == ['gun']
  end
  
  test "Filter must be change with forbidden_worlds" do
    censor = Censor.new
    forbidden_worlds = censor.forbidden_worlds
    filter = censor.filter
    censor.forbidden_worlds = %w{gun weapon drug}
    assert censor.forbidden_worlds != forbidden_worlds
    assert censor.filter != filter
  end

  test "Should replace forbidden worlds" do
    censor = Censor.new(:forbidden_worlds => %w{gun})
    unsafe_text = "I whave a gun"
    assert censor.sanitize(unsafe_text) != unsafe_text
  end

  test "Censor should replace with fullmatch" do
    censor = Censor.new(:forbidden_worlds => %w{gun})
    unsafe_text = "Fireworks has made with gunpowder"
    assert censor.sanitize(unsafe_text) == unsafe_text
  end
  
  test "Censored worlds must be same lenght" do
    censor = Censor.new(:forbidden_worlds => %w{weapon bullets})
    unsafe_text = 'i need bullets for my weapon'
    assert censor.sanitize(unsafe_text).length == unsafe_text.length
  end
  
  test "Should be work with objects" do
    post = OpenStruct.new(:content => 'Kill them all', :uncensored => "kill")
    censor = Censor.new(:forbidden_worlds => %w{kill})
    censor.before_save(post)
    assert post.content == 'xxxx them all'
    assert post.uncensored == 'kill'
  end
  
end
