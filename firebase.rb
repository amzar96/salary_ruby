require "firebase"
require "json"

class FirebaseAuth
  attr_accessor :firebase

  def initialize()
    firebase_url = "https://ruby-fave.firebaseio.com/"
    firebase_secret = "ZTNQrx29tQMYQjWvkv0fxj4qsxvz5xHy8Ao2AgVp"
    @firebase = Firebase::Client.new(firebase_url, firebase_secret)
    @firebase.request.connect_timeout = 30
  end

  def get(path)
    @firebase.get(path)
  end

  def get_all()
    @firebase.get("staff")
  end

  def set(path, data)
    @firebase.set(path, data)
  end

  def delete(path)
    @firebase.delete(path)
  end

  def push(path, data)
    @firebase.push(path, data)
  end

  def update(path, data)
    @firebase.update(path, data)
  end
end

fb = FirebaseAuth.new()
# response = fb.set(path = "staff/user", data = { :name => "Amzar", :salary => 1321 })
# response = fb.set(data)
# response = fb.get(322)
# response = fb.update(path = 232, data = { :name => "Ali", :salary => 1321, :monthly_tax => 92818 })
# response.raw_body
# a = response.raw_body
# parsed = JSON.parse(a)
# puts parsed["name"]
# response = fb.get_all()
# puts response.raw_body
